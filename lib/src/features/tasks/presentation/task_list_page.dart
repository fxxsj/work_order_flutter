import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/file_download.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/application/task_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_list_support_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_ui_helper.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_action_dialogs.dart';

/// 任务列表入口。
class TaskListEntry extends StatelessWidget {
  const TaskListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<TaskApiService, TaskRepository, TaskViewModel>(
      createService: (context) => TaskApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          TaskRepositoryImpl(context.read<TaskApiService>()),
      createViewModel: (context) =>
          TaskViewModel(context.read<TaskRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const TaskListPage(),
    );
  }
}

/// 任务列表页视图，只负责渲染。
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) => const _TaskListView();
}

class _TaskListView extends StatefulWidget {
  const _TaskListView();

  @override
  State<_TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<_TaskListView> {
  static const _searchDebounceDuration = AnimationTokens.slower;
  static const double _searchWidth = LayoutTokens.searchWidth;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索任务内容/施工单号';
  static const String _refreshButtonText = '刷新';
  static const String _resetButtonText = '重置筛选';
  static const String _emptyText = '暂无任务数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';
  static const String _assignButtonText = '分派操作员';
  static const String _updateButtonText = '更新进度';
  static const String _completeButtonText = '完成任务';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _statusFilter;
  String? _priorityFilter;
  int? _departmentFilterId;
  int? _processFilterId;

  bool _loadingOptions = false;
  List<TaskDepartmentOption> _departments = [];
  List<Process> _processes = [];
  bool _exporting = false;
  TaskListSupportService? _supportService;
  bool _optionsRequested = false;
  String? _routeSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= TaskListSupportService(context.read<ApiClient>());
    if (!_optionsRequested) {
      _optionsRequested = true;
      _loadFilterOptions();
    }

    final uri = GoRouterState.of(context).uri;
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeStatus = uri.queryParameters['status']?.trim() ?? '';
    final routePriority = uri.queryParameters['priority']?.trim() ?? '';
    final routeTodo = uri.queryParameters['todo']?.trim() ?? '';
    final routeDepartmentId =
        int.tryParse(uri.queryParameters['assigned_department'] ?? '');
    final routeProcessId =
        int.tryParse(uri.queryParameters['work_order_process'] ?? '');
    final signature = [
      routeSearch,
      routeStatus,
      routePriority,
      routeTodo,
      routeDepartmentId?.toString() ?? '',
      routeProcessId?.toString() ?? '',
    ].join('|');
    final hadRouteState = _routeSignature != null;
    if (_routeSignature == signature) return;
    _routeSignature = signature;
    _searchController.text = routeSearch;
    final hasRouteFilter = routeSearch.isNotEmpty ||
        routeStatus.isNotEmpty ||
        routePriority.isNotEmpty ||
        routeTodo.isNotEmpty ||
        (routeDepartmentId != null && routeDepartmentId > 0) ||
        (routeProcessId != null && routeProcessId > 0);
    if (!hasRouteFilter && !hadRouteState) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TaskViewModel>().applyRoutePrefill(
            search: routeSearch,
            status: routeStatus,
            priority: routePriority,
            departmentId: routeDepartmentId,
            processId: routeProcessId,
            todo: routeTodo,
          );
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(TaskViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadTasks(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadTasks(resetPage: true);
    });
  }

  void _applyFilters(TaskViewModel viewModel) {
    viewModel
      ..setStatusFilter(_statusFilter)
      ..setPriorityFilter(_priorityFilter)
      ..setDepartmentFilterId(_departmentFilterId)
      ..setProcessFilterId(_processFilterId);
    viewModel.loadTasks(resetPage: true);
  }

  void _resetFilters(TaskViewModel viewModel) {
    _searchController.clear();
    setState(() {
      _statusFilter = null;
      _priorityFilter = null;
      _departmentFilterId = null;
      _processFilterId = null;
    });
    viewModel
      ..setStatusFilter(null)
      ..setPriorityFilter(null)
      ..setDepartmentFilterId(null)
      ..setProcessFilterId(null);
    viewModel.loadTasks(resetPage: true);
  }

  Future<void> _exportTasks(TaskViewModel viewModel) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final params = <String, dynamic>{
        if (_searchController.text.trim().isNotEmpty)
          'search': _searchController.text.trim(),
        if (viewModel.statusFilter != null &&
            viewModel.statusFilter!.isNotEmpty)
          'status': viewModel.statusFilter,
        if (viewModel.priorityFilter != null &&
            viewModel.priorityFilter!.isNotEmpty)
          'priority': viewModel.priorityFilter,
        if ((viewModel.departmentFilterId ?? 0) > 0)
          'assigned_department': viewModel.departmentFilterId,
        if ((viewModel.processFilterId ?? 0) > 0)
          'work_order_process': viewModel.processFilterId,
        if ((viewModel.todoFilter ?? '').isNotEmpty)
          'todo': viewModel.todoFilter,
      };
      final result = await _supportService!.export(params);
      final savedPath = await saveBytes(result.bytes, result.filename,
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      if (savedPath == null) {
        ToastUtil.showSuccess('导出已开始');
      } else {
        ToastUtil.showSuccess('已导出到 $savedPath');
      }
    } catch (err) {
      ToastUtil.showError('导出失败: $err');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _loadFilterOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final options = await _supportService!.loadFilterOptions();
      if (!mounted) return;
      setState(() {
        _departments = options.departments;
        _processes = options.processes;
      });
    } catch (err) {
      // 忽略筛选加载失败，避免影响列表主体
    } finally {
      if (mounted) setState(() => _loadingOptions = false);
    }
  }

  static String _pageInfoText(TaskViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<TaskViewModel>(
      builder: (context, viewModel, _) {
        final tasks = viewModel.tasks;
        _statusFilter = viewModel.statusFilter;
        _priorityFilter = viewModel.priorityFilter;
        _departmentFilterId = viewModel.departmentFilterId;
        _processFilterId = viewModel.processFilterId;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, tasks, isMobile),
          footer: viewModel.totalPages > 1
              ? ResponsivePaginationBar(
                  infoText: _pageInfoText(viewModel),
                  page: viewModel.page,
                  pageSize: viewModel.pageSize,
                  pageSizeOptions: viewModel.pageSizeOptions,
                  onPageSizeChanged: viewModel.setPageSize,
                  onPrev: () => viewModel.setPage(viewModel.page - 1),
                  onNext: () => viewModel.setPage(viewModel.page + 1),
                  hasPrev: viewModel.hasPrev,
                  hasNext: viewModel.hasNext,
                  pageSizeLabelBuilder: (size) =>
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    TaskViewModel viewModel,
    List<Task> tasks,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadTasks(resetPage: true),
      );
    }
    if (!viewModel.loading && tasks.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.task_alt_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, tasks);
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildSummaryCard(context, viewModel, task, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    TaskViewModel viewModel,
    List<Task> tasks,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('任务')),
        DataColumn(label: Text('来源')),
        DataColumn(label: Text('工序')),
        DataColumn(label: Text('分派部门')),
        DataColumn(label: Text('分派操作员')),
        DataColumn(label: Text('数量')),
        DataColumn(label: Text('进度')),
        DataColumn(label: Text('交期')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('待办')),
        DataColumn(label: Text('操作')),
      ],
      rows: tasks.map(
        (task) {
          final isCompleted = task.status == 'completed';
          final isCancelled = task.status == 'cancelled';
          final isDraft = task.status == 'draft';
          final canUpdate = !(isCompleted || isCancelled || isDraft);
          final canComplete = !(isCompleted || isCancelled || isDraft);
          final source = TaskUiHelper.sourceSummary(task);
          final quantity = TaskUiHelper.quantitySummary(task);
          final deliveryDate = _formatDate(task.deliveryDate);
          final deadlineRisk = TaskUiHelper.deadlineRiskText(task);
          final followUp = TaskUiHelper.followUpText(task);

          return DataRow(
            cells: [
              DataCell(Text(
                _displayText(TaskUiHelper.title(task)),
                style: theme.textTheme.bodyMedium,
              )),
              DataCell(Text(_displayText(source), style: textStyle)),
              DataCell(Text(_displayText(task.processName), style: textStyle)),
              DataCell(Text(_displayText(task.assignedDepartmentName),
                  style: textStyle)),
              DataCell(Text(_displayText(task.assignedOperatorName),
                  style: textStyle)),
              DataCell(Text(quantity, style: textStyle)),
              DataCell(Text(TaskUiHelper.progressText(task), style: textStyle)),
              DataCell(Text(
                deadlineRisk == null
                    ? deliveryDate
                    : '$deliveryDate · $deadlineRisk',
                style: textStyle,
              )),
              DataCell(Text(
                task.statusDisplay ?? task.status ?? _emptyCellText,
                style: textStyle,
              )),
              DataCell(Text(followUp, style: textStyle)),
              DataCell(RowActionGroup(
                actions: [
                  if (task.workOrderId != null)
                    RowAction(
                      label: '查看施工单',
                      onPressed: () =>
                          context.go('/workorders/${task.workOrderId}'),
                    ),
                  if (canUpdate)
                    RowAction(
                      label: _updateButtonText,
                      onPressed: () =>
                          _openUpdateDialog(context, viewModel, task),
                    ),
                  if (canComplete)
                    RowAction(
                      label: _completeButtonText,
                      onPressed: () =>
                          _openCompleteDialog(context, viewModel, task),
                    ),
                  RowAction(
                    label: _assignButtonText,
                    onPressed: () =>
                        _openAssignDialog(context, viewModel, task),
                  ),
                ],
              )),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    TaskViewModel viewModel,
    bool isMobile,
  ) {
    final statusItems = const [
      AppDropdownOption(value: 'draft', label: '草稿'),
      AppDropdownOption(value: 'pending', label: '待开始'),
      AppDropdownOption(value: 'in_progress', label: '进行中'),
      AppDropdownOption(value: 'completed', label: '已完成'),
      AppDropdownOption(value: 'cancelled', label: '已取消'),
    ];
    final priorityItems = const [
      AppDropdownOption(value: 'low', label: '低'),
      AppDropdownOption(value: 'normal', label: '普通'),
      AppDropdownOption(value: 'high', label: '高'),
      AppDropdownOption(value: 'urgent', label: '紧急'),
    ];
    final departmentItems = [
      const AppDropdownOption<int?>(
          value: null, label: '全部部门'),
      ..._departments.map(
        (item) => AppDropdownOption<int?>(
          value: item.id,
          label: item.name,
        ),
      ),
    ];
    final processItems = [
      const AppDropdownOption<int?>(
          value: null, label: '全部工序'),
      ..._processes.map(
        (item) => AppDropdownOption<int?>(
          value: item.id,
          label: item.name,
        ),
      ),
    ];

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeFilters = _activeFilterCount();
          final overdueCount =
              _summaryCount(viewModel.summary, 'overdue_count');
          final dueSoonCount =
              _summaryCount(viewModel.summary, 'due_soon_count');
          final unassignedCount =
              _summaryCount(viewModel.summary, 'unassigned_count');
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: _controlHeight,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          void openFilterDrawer() {
            showAdaptiveFilterDrawer(
              context,
              isMobile: isMobile,
              title: activeFilters > 0 ? '筛选 ($activeFilters)' : '筛选',
              child: _buildFilterPanel(
                context,
                viewModel,
                statusItems: statusItems,
                priorityItems: priorityItems,
                departmentItems: departmentItems,
                processItems: processItems,
              ),
            );
          }

          final actions = <Widget>[
            if (overdueCount > 0)
              StatusHintChip(
                label: '已逾期任务',
                count: overdueCount,
                icon: Icons.warning_amber_rounded,
                selected: viewModel.todoFilter == 'overdue',
                onTap: () => _openQuickFilter(viewModel, todo: 'overdue'),
              ),
            if (dueSoonCount > 0)
              StatusHintChip(
                label: '临近交付',
                count: dueSoonCount,
                icon: Icons.event_busy_outlined,
                selected: viewModel.todoFilter == 'due_soon',
                onTap: () => _openQuickFilter(viewModel, todo: 'due_soon'),
              ),
            if (unassignedCount > 0)
              StatusHintChip(
                label: '待分派任务',
                count: unassignedCount,
                icon: Icons.person_search_outlined,
                selected: viewModel.todoFilter == 'unassigned',
                onTap: () => _openQuickFilter(viewModel, todo: 'unassigned'),
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadTasks(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            if ((viewModel.todoFilter ?? '').isNotEmpty)
              PageActionButton.outlined(
                onPressed: () => _clearQuickFilter(viewModel),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除待办',
              ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
            ),
            PageActionButton.outlined(
              onPressed: _exporting ? null : () => _exportTasks(viewModel),
              icon: const Icon(Icons.download_outlined, size: 16),
              label: _exporting ? '导出中' : '导出',
            ),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _spacingSm,
          );
        },
      ),
    );
  }

  Widget _buildFilterPanel(
    BuildContext context,
    TaskViewModel viewModel, {
    required List<AppDropdownOption<String>> statusItems,
    required List<AppDropdownOption<String>> priorityItems,
    required List<AppDropdownOption<int?>> departmentItems,
    required List<AppDropdownOption<int?>> processItems,
  }) {
    return FilterPanelBody(
      bottomSpacing: LayoutTokens.formSectionSpacing(context),
      resetLabel: _resetButtonText,
      onReset: () => _resetFilters(viewModel),
      fields: [
        if (_loadingOptions) const LinearProgressIndicator(minHeight: 2),
        AppSelect<String>(
          value: _statusFilter,
          decoration: const InputDecoration(labelText: '状态'),
          options: statusItems,
          onChanged: (value) {
            setState(() => _statusFilter = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<String>(
          value: _priorityFilter,
          decoration: const InputDecoration(labelText: '优先级'),
          options: priorityItems,
          onChanged: (value) {
            setState(() => _priorityFilter = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<int?>(
          value: _departmentFilterId,
          decoration: const InputDecoration(labelText: '部门'),
          options: departmentItems,
          onChanged: (value) {
            setState(() => _departmentFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        AppSelect<int?>(
          value: _processFilterId,
          decoration: const InputDecoration(labelText: '工序'),
          options: processItems,
          onChanged: (value) {
            setState(() => _processFilterId = value);
            _applyFilters(viewModel);
          },
        ),
      ],
    );
  }

  int _activeFilterCount() {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (_statusFilter != null && _statusFilter!.isNotEmpty) count += 1;
    if (_priorityFilter != null && _priorityFilter!.isNotEmpty) count += 1;
    if (_departmentFilterId != null) count += 1;
    if (_processFilterId != null) count += 1;
    final todo = context.read<TaskViewModel>().todoFilter;
    if (todo != null && todo.isNotEmpty) count += 1;
    return count;
  }

  void _clearQuickFilter(TaskViewModel viewModel) {
    _openQuickFilter(
      viewModel,
      status: viewModel.statusFilter,
      priority: viewModel.priorityFilter,
      departmentId: viewModel.departmentFilterId,
      processId: viewModel.processFilterId,
    );
  }

  void _openQuickFilter(
    TaskViewModel viewModel, {
    String? status,
    String? priority,
    int? departmentId,
    int? processId,
    String? todo,
  }) {
    final query = <String, String>{};
    final search = _searchController.text.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    final statusValue = status ?? viewModel.statusFilter;
    if ((statusValue ?? '').trim().isNotEmpty) {
      query['status'] = statusValue!.trim();
    }
    final priorityValue = priority ?? viewModel.priorityFilter;
    if ((priorityValue ?? '').trim().isNotEmpty) {
      query['priority'] = priorityValue!.trim();
    }
    final departmentValue = departmentId ?? viewModel.departmentFilterId;
    if ((departmentValue ?? 0) > 0) {
      query['assigned_department'] = departmentValue!.toString();
    }
    final processValue = processId ?? viewModel.processFilterId;
    if ((processValue ?? 0) > 0) {
      query['work_order_process'] = processValue!.toString();
    }
    if ((todo ?? '').trim().isNotEmpty) {
      query['todo'] = todo!.trim();
    }
    context.go(Uri(path: '/tasks', queryParameters: query).toString());
  }

  int _summaryCount(Map<String, dynamic> payload, String key) {
    final summary = payload['summary'];
    if (summary is Map<String, dynamic>) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    if (summary is Map) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }
    return 0;
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Widget _mobileRow(BuildContext context, TextStyle? labelStyle, String label,
      String value,
      {bool last = false}) {
    final theme = Theme.of(context);
    final spacing = LayoutTokens.sectionSpacing(context) * 0.6;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: Text(label, style: labelStyle)),
          Expanded(
              child: Text(value.isEmpty ? _emptyCellText : value,
                  style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildMobileFields(
    BuildContext context,
    TextStyle? labelStyle, {
    required String customer,
    required String workOrder,
    required String process,
    required String title,
    required String department,
    required String operator,
    required String quantity,
    required String progress,
    required String deliveryDate,
    required String deadlineRisk,
    required String status,
    required String followUp,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileRow(context, labelStyle, '客户', customer),
        _mobileRow(context, labelStyle, '施工单号', workOrder),
        _mobileRow(context, labelStyle, '工序', process),
        _mobileRow(context, labelStyle, '任务内容', title),
        _mobileRow(context, labelStyle, '分派部门', department),
        _mobileRow(context, labelStyle, '分派操作员', operator),
        _mobileRow(context, labelStyle, '数量', quantity),
        _mobileRow(context, labelStyle, '进度', progress),
        _mobileRow(context, labelStyle, '交付日期', deliveryDate),
        _mobileRow(context, labelStyle, '交期风险', deadlineRisk),
        _mobileRow(context, labelStyle, '状态', status),
        _mobileRow(context, labelStyle, '下一步', followUp, last: true),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    TaskViewModel viewModel,
    Task task,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final title = _displayText(TaskUiHelper.title(task));
    final customer = _displayText(task.customerName);
    final workOrder = _displayText(task.workOrderNumber);
    final process = _displayText(task.processName);
    final department = _displayText(task.assignedDepartmentName);
    final operator = _displayText(task.assignedOperatorName);
    final quantity = TaskUiHelper.quantitySummary(task);
    final progress = TaskUiHelper.progressText(task);
    final status = task.statusDisplay ?? task.status ?? _emptyCellText;
    final followUp = TaskUiHelper.followUpText(task);
    final deadlineRisk = TaskUiHelper.deadlineRiskText(task) ?? _emptyCellText;
    final deliveryDate = _formatDate(task.deliveryDate);
    final isCompleted = task.status == 'completed';
    final isCancelled = task.status == 'cancelled';
    final isDraft = task.status == 'draft';
    final canUpdate = !(isCompleted || isCancelled || isDraft);
    final canComplete = !(isCompleted || isCancelled || isDraft);

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    [customer, workOrder, process]
                        .where((item) => item != _emptyCellText)
                        .join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '状态', value: status),
                      _SummaryChip(label: '进度', value: progress),
                      _SummaryChip(label: '待办', value: followUp),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0.0,
              duration: AnimationTokens.expandDuration,
              child: Icon(
                Icons.expand_more,
                size: 20,
                color: colors?.subtleText ?? theme.hintColor,
              ),
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileFields(
            context,
            theme.textTheme.labelSmall?.copyWith(
              color: colors?.subtleText ?? theme.hintColor,
            ),
            customer: customer,
            workOrder: workOrder,
            process: process,
            title: title,
            department: department,
            operator: operator,
            quantity: quantity,
            progress: progress,
            deliveryDate: deliveryDate,
            deadlineRisk: deadlineRisk,
            status: status,
            followUp: followUp,
          ),
          if (task.workOrderId != null) ...[
            SizedBox(height: sectionSpacing),
            OutlinedButton.icon(
              onPressed: () => context.go('/workorders/${task.workOrderId}'),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('查看施工单'),
            ),
          ],
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: canUpdate
                    ? () => _openUpdateDialog(context, viewModel, task)
                    : null,
                icon: const Icon(Icons.edit, size: 16),
                label: Text(canUpdate ? _updateButtonText : '不可更新'),
              ),
              OutlinedButton.icon(
                onPressed: canComplete
                    ? () => _openCompleteDialog(context, viewModel, task)
                    : null,
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: Text(canComplete ? _completeButtonText : '不可完成'),
              ),
              OutlinedButton.icon(
                onPressed: () => _openAssignDialog(context, viewModel, task),
                icon: const Icon(Icons.person_add_alt_1, size: 16),
                label: const Text(_assignButtonText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openUpdateDialog(
    BuildContext context,
    TaskViewModel viewModel,
    Task task,
  ) async {
    await showTaskQuantityDialog(
      context,
      task: task,
      onSubmit: (payload) => _submitQuantityUpdate(viewModel, task, payload),
    );
  }

  Future<void> _openCompleteDialog(
    BuildContext context,
    TaskViewModel viewModel,
    Task task,
  ) async {
    await showTaskCompleteDialog(
      context,
      task: task,
      onSubmit: (payload) => _submitComplete(viewModel, task, payload),
    );
  }

  Future<void> _openAssignDialog(
    BuildContext context,
    TaskViewModel viewModel,
    Task task,
  ) async {
    await showTaskAssignDialog(
      context,
      task: task,
      departments: _departments,
      loadOperators: (departmentId) =>
          _supportService!.loadOperators(departmentId),
      onSubmit: (operatorId, notes) =>
          _submitAssign(viewModel, task, operatorId, notes),
    );
  }

  Future<void> _submitQuantityUpdate(
    TaskViewModel viewModel,
    Task task,
    Map<String, dynamic> payload,
  ) async {
    try {
      await _supportService!.updateQuantity(task.id, payload);
      ToastUtil.showSuccess('已更新任务进度');
      await viewModel.loadTasks(resetPage: false);
    } catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _submitComplete(
    TaskViewModel viewModel,
    Task task,
    Map<String, dynamic> payload,
  ) async {
    try {
      await _supportService!.completeTask(task.id, payload);
      ToastUtil.showSuccess('任务已完成');
      await viewModel.loadTasks(resetPage: false);
    } catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _submitAssign(
    TaskViewModel viewModel,
    Task task,
    int operatorId,
    String notes,
  ) async {
    try {
      await _supportService!.assignTask(
        task.id,
        operatorId: operatorId,
        notes: notes,
      );
      ToastUtil.showSuccess('任务已分派');
      await viewModel.loadTasks(resetPage: false);
    } catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Exception: ', ''));
    }
  }
}

typedef _SummaryChip = SummaryChip;
