import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/file_download.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/data/department_dto.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_dto.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/application/task_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
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
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
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
  List<Department> _departments = [];
  List<Process> _processes = [];
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
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
    _statusFilter = null;
    _priorityFilter = null;
    _departmentFilterId = null;
    _processFilterId = null;
    viewModel.setSearchText('');
    _applyFilters(viewModel);
  }

  Future<void> _exportTasks(TaskViewModel viewModel) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final apiService = context.read<TaskApiService>();
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
      };
      final response = await apiService.export(params: params);
      final data = response.data;
      if (data == null) {
        ToastUtil.showError('导出失败: 返回内容为空');
        return;
      }
      final bytes = data is Uint8List
          ? data
          : data is List<int>
              ? Uint8List.fromList(data)
              : null;
      if (bytes == null) {
        ToastUtil.showError('导出失败: 返回格式不支持');
        return;
      }
      final filename = _resolveExportFilename(response, fallback: '任务列表');
      final savedPath = await saveBytes(bytes, filename,
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

  String _resolveExportFilename(
    dynamic response, {
    required String fallback,
  }) {
    final timestamp =
        DateTime.now().toIso8601String().replaceAll(':', '').split('.').first;
    try {
      final headers = response.headers;
      final contentDisposition = headers.value('content-disposition') ??
          headers.value('Content-Disposition');
      if (contentDisposition != null) {
        final match =
            RegExp('filename=\"?([^\";]+)\"?').firstMatch(contentDisposition);
        if (match != null) {
          return match.group(1) ?? '${fallback}_$timestamp.xlsx';
        }
      }
    } catch (_) {
      // ignore header parsing errors
    }
    return '${fallback}_$timestamp.xlsx';
  }

  Future<void> _loadFilterOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final apiClient = context.read<ApiClient>();
      final departmentApi = DepartmentApiService(apiClient);
      final processApi = ProcessApiService(apiClient);
      final results = await Future.wait([
        departmentApi.fetchDepartments(page: 1, pageSize: 200),
        processApi.fetchProcesses(page: 1, pageSize: 200),
      ]);
      final departmentPage = results[0] as DepartmentPageDto;
      final processPage = results[1] as ProcessPageDto;
      if (!mounted) return;
      setState(() {
        _departments = departmentPage.items
            .map<Department>((item) => item.toEntity())
            .toList();
        _processes =
            processPage.items.map<Process>((item) => item.toEntity()).toList();
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
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('工序')),
        DataColumn(label: Text('分派部门')),
        DataColumn(label: Text('分派操作员')),
        DataColumn(label: Text('生产数量')),
        DataColumn(label: Text('完成数量')),
        DataColumn(label: Text('进度')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('操作')),
      ],
      rows: tasks.map(
        (task) {
          final isCompleted = task.status == 'completed';
          final isCancelled = task.status == 'cancelled';
          final isDraft = task.status == 'draft';
          final canUpdate = !(isCompleted || isCancelled || isDraft);
          final canComplete = !(isCompleted || isCancelled || isDraft);

          return DataRow(
            cells: [
              DataCell(Text(
                _displayText(
                  task.workContent?.trim().isNotEmpty == true
                      ? task.workContent
                      : (task.processName ?? '任务 #${task.id}'),
                ),
                style: theme.textTheme.bodyMedium,
              )),
              DataCell(
                  Text(_displayText(task.workOrderNumber), style: textStyle)),
              DataCell(Text(_displayText(task.processName), style: textStyle)),
              DataCell(Text(_displayText(task.assignedDepartmentName),
                  style: textStyle)),
              DataCell(Text(_displayText(task.assignedOperatorName),
                  style: textStyle)),
              DataCell(Text(_formatNumber(task.productionQuantity),
                  style: textStyle)),
              DataCell(Text(_formatNumber(task.quantityCompleted),
                  style: textStyle)),
              DataCell(Text(_formatProgress(task), style: textStyle)),
              DataCell(Text(
                task.statusDisplay ?? task.status ?? _emptyCellText,
                style: textStyle,
              )),
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
      DropdownMenuItem(value: 'draft', child: Text('草稿')),
      DropdownMenuItem(value: 'pending', child: Text('待开始')),
      DropdownMenuItem(value: 'in_progress', child: Text('进行中')),
      DropdownMenuItem(value: 'completed', child: Text('已完成')),
      DropdownMenuItem(value: 'cancelled', child: Text('已取消')),
    ];
    final priorityItems = const [
      DropdownMenuItem(value: 'low', child: Text('低')),
      DropdownMenuItem(value: 'normal', child: Text('普通')),
      DropdownMenuItem(value: 'high', child: Text('高')),
      DropdownMenuItem(value: 'urgent', child: Text('紧急')),
    ];
    final departmentItems = [
      const DropdownMenuItem<int?>(
          value: null, child: Text('全部部门', overflow: TextOverflow.ellipsis)),
      ..._departments.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.name, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    final processItems = [
      const DropdownMenuItem<int?>(
          value: null, child: Text('全部工序', overflow: TextOverflow.ellipsis)),
      ..._processes.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.name, overflow: TextOverflow.ellipsis),
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
            if (isMobile) {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                showDragHandle: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                builder: (sheetContext) {
                  return _FilterDrawerContent(
                    title: activeFilters > 0 ? '筛选 ($activeFilters)' : '筛选',
                    child: _buildFilterPanel(
                      sheetContext,
                      viewModel,
                      statusItems: statusItems,
                      priorityItems: priorityItems,
                      departmentItems: departmentItems,
                      processItems: processItems,
                    ),
                  );
                },
              );
              return;
            }

            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: '筛选',
              barrierColor: Colors.black.withValues(alpha: 0.3),
              transitionDuration: const Duration(milliseconds: 220),
              pageBuilder: (dialogContext, animation, secondaryAnimation) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Theme.of(dialogContext).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    child: SizedBox(
                      width: 360,
                      height: double.infinity,
                      child: SafeArea(
                        child: _FilterDrawerContent(
                          title:
                              activeFilters > 0 ? '筛选 ($activeFilters)' : '筛选',
                          child: _buildFilterPanel(
                            dialogContext,
                            viewModel,
                            statusItems: statusItems,
                            priorityItems: priorityItems,
                            departmentItems: departmentItems,
                            processItems: processItems,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                final offsetTween =
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
                return SlideTransition(
                  position: animation
                      .drive(
                        CurveTween(curve: Curves.easeOutCubic),
                      )
                      .drive(offsetTween),
                  child: child,
                );
              },
            );
          }

          final actions = <Widget>[
            PageActionButton.outlined(
              onPressed: () => viewModel.loadTasks(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
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
    required List<DropdownMenuItem<String>> statusItems,
    required List<DropdownMenuItem<String>> priorityItems,
    required List<DropdownMenuItem<int?>> departmentItems,
    required List<DropdownMenuItem<int?>> processItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        if (_loadingOptions) const LinearProgressIndicator(minHeight: 2),
        SearchableDropdownFormField<String>(
          initialValue: _statusFilter,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '状态'),
          items: statusItems,
          onChanged: (value) {
            setState(() => _statusFilter = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<String>(
          initialValue: _priorityFilter,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '优先级'),
          items: priorityItems,
          onChanged: (value) {
            setState(() => _priorityFilter = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          initialValue: _departmentFilterId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '部门'),
          items: departmentItems,
          onChanged: (value) {
            setState(() => _departmentFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        SearchableDropdownFormField<int?>(
          initialValue: _processFilterId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '工序'),
          items: processItems,
          onChanged: (value) {
            setState(() => _processFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            PageActionButton.outlined(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt, size: 16),
              label: _resetButtonText,
            ),
            SizedBox(width: spacing),
            PageActionButton.filled(
              onPressed: () => Navigator.of(context).maybePop(),
              label: '完成',
            ),
          ],
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
    return count;
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatNumber(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(0);
  }

  String _formatProgress(Task task) {
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    if (total <= 0) return _emptyCellText;
    final percentage =
        (completed / total * 100).clamp(0, 100).toStringAsFixed(0);
    return '$percentage%';
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
    final title = _displayText(
      task.workContent?.trim().isNotEmpty == true
          ? task.workContent
          : (task.processName ?? '任务 #${task.id}'),
    );
    final workOrder = _displayText(task.workOrderNumber);
    final process = _displayText(task.processName);
    final department = _displayText(task.assignedDepartmentName);
    final operator = _displayText(task.assignedOperatorName);
    final production = _formatNumber(task.productionQuantity);
    final completed = _formatNumber(task.quantityCompleted);
    final progress = _formatProgress(task);
    final status = task.statusDisplay ?? task.status ?? _emptyCellText;
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
                    '$workOrder · $process',
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
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
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '施工单号', value: workOrder),
              _SummaryField(label: '工序', value: process),
              _SummaryField(label: '任务内容', value: title),
              _SummaryField(label: '分派部门', value: department),
              _SummaryField(label: '分派操作员', value: operator),
              _SummaryField(label: '生产数量', value: production),
              _SummaryField(label: '完成数量', value: completed),
              _SummaryField(label: '进度', value: progress),
              _SummaryField(label: '状态', value: status),
            ],
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
      loadOperators: (departmentId) {
        final api = context.read<TaskApiService>();
        return api.fetchDepartmentOperators(departmentId);
      },
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
      final api = context.read<TaskApiService>();
      await api.updateQuantity(task.id, payload);
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
      final api = context.read<TaskApiService>();
      await api.complete(task.id, payload);
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
      final api = context.read<TaskApiService>();
      await api.assign(task.id, {
        'operator_id': operatorId,
        'notes': notes,
      });
      ToastUtil.showSuccess('任务已分派');
      await viewModel.loadTasks(resetPage: false);
    } catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Exception: ', ''));
    }
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;

class _FilterDrawerContent extends StatelessWidget {
  const _FilterDrawerContent({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}
