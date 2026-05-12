import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_loading_indicator.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_mode_toggle.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/tasks/application/task_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_board_support_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_action_dialogs.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_board_sections.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';

enum _TaskBoardViewMode {
  board,
  list,
  timeline,
}

/// 部门任务看板入口。
class TaskBoardEntry extends StatelessWidget {
  const TaskBoardEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<TaskApiService, TaskRepository, TaskViewModel>(
      createService: (context) => TaskApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          TaskRepositoryImpl(context.read<TaskApiService>()),
      createViewModel: (context) =>
          TaskViewModel(context.read<TaskRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const TaskBoardPage(),
    );
  }
}

/// 部门任务看板页面。
class TaskBoardPage extends StatelessWidget {
  const TaskBoardPage({super.key});

  @override
  Widget build(BuildContext context) => const _TaskBoardView();
}

class _TaskBoardView extends StatefulWidget {
  const _TaskBoardView();

  @override
  State<_TaskBoardView> createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<_TaskBoardView> {
  static const _searchDebounceDuration = AnimationTokens.slower;
  static const double _searchWidth = LayoutTokens.searchWidth;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const double _columnMinWidth = 260;

  static const String _searchHintText = '搜索任务内容/施工单号';
  static const String _refreshButtonText = '刷新';
  static const String _resetButtonText = '重置筛选';
  static const String _emptyText = '暂无任务数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  _TaskBoardViewMode _viewMode = _TaskBoardViewMode.board;
  bool _hideEmptyColumns = false;
  bool _sortByDeliveryDate = false;
  int? _draggingTaskId;
  int? _updatingTaskId;
  String? _statusFilter;
  int? _departmentFilterId;

  bool _loadingDepartments = false;
  List<TaskDepartmentOption> _departments = [];
  TaskBoardSupportService? _supportService;
  bool _departmentsRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= TaskBoardSupportService(context.read<ApiClient>());
    if (_departmentsRequested) return;
    _departmentsRequested = true;
    _loadDepartments();
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
      ..setDepartmentFilterId(_departmentFilterId);
    viewModel.loadTasks(resetPage: true);
  }

  void _resetFilters(TaskViewModel viewModel) {
    _searchController.clear();
    _statusFilter = null;
    _departmentFilterId = null;
    viewModel.setSearchText('');
    _applyFilters(viewModel);
  }

  Future<void> _loadDepartments() async {
    setState(() => _loadingDepartments = true);
    try {
      final result = await _supportService!.fetchDepartments();
      if (!mounted) return;
      setState(() => _departments = result);
    } catch (_) {
      // 忽略部门加载失败，避免影响列表主体
    } finally {
      if (mounted) setState(() => _loadingDepartments = false);
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
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<TaskViewModel>(
      builder: (context, viewModel, _) {
        final tasks = viewModel.tasks;
        _statusFilter = viewModel.statusFilter;
        _departmentFilterId = viewModel.departmentFilterId;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildBody(context, viewModel, tasks, isMobile),
          footer: viewModel.total > 0
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

  Widget _buildBody(
    BuildContext context,
    TaskViewModel viewModel,
    List<Task> tasks,
    bool isMobile,
  ) {
    if (viewModel.loading && tasks.isEmpty) {
      return const AppLoadingIndicator();
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadTasks(resetPage: true),
      );
    }
    if (!viewModel.loading && tasks.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmptyStateCard(
            icon: Icons.view_kanban_outlined,
            text: _emptyText,
          ),
          if (_hasFilters()) ...[
            SizedBox(height: LayoutTokens.gapMd),
            PageActionButton.outlined(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt, size: 16),
              label: _resetButtonText,
            ),
          ],
        ],
      );
    }

    if (_viewMode == _TaskBoardViewMode.list) {
      return _buildListView(context, tasks);
    }
    if (_viewMode == _TaskBoardViewMode.timeline) {
      return _buildTimelineView(context, tasks);
    }
    return _buildBoardView(context, viewModel, tasks, isMobile);
  }

  Widget _buildPageHeader(
    BuildContext context,
    TaskViewModel viewModel,
    bool isMobile,
  ) {
    final departmentItems = [
      const AppDropdownOption<int?>(
        value: null,
        label: '全部部门',
      ),
      ..._departments.map(
        (item) => AppDropdownOption<int?>(
          value: item.id,
          label: item.name,
        ),
      ),
    ];
    final statusItems = const [
      AppDropdownOption<String?>(value: null, label: '全部状态'),
      AppDropdownOption(value: 'pending', label: '待开始'),
      AppDropdownOption(value: 'in_progress', label: '进行中'),
      AppDropdownOption(value: 'completed', label: '已完成'),
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
                  return TaskBoardFilterDrawerContent(
                    title: activeFilters > 0 ? '筛选 ($activeFilters)' : '筛选',
                    child: _buildFilterPanel(
                      sheetContext,
                      viewModel,
                      departmentItems: departmentItems,
                      statusItems: statusItems,
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
              barrierColor: Theme.of(context)
                  .shadowColor
                  .withValues(alpha: OpacityTokens.scrim),
              transitionDuration: AnimationTokens.slide,
              pageBuilder: (dialogContext, animation, secondaryAnimation) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Theme.of(dialogContext).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    child: SizedBox(
                      width: LayoutTokens.dialogWidthXs,
                      height: double.infinity,
                      child: SafeArea(
                        child: TaskBoardFilterDrawerContent(
                          title:
                              activeFilters > 0 ? '筛选 ($activeFilters)' : '筛选',
                          child: _buildFilterPanel(
                            dialogContext,
                            viewModel,
                            departmentItems: departmentItems,
                            statusItems: statusItems,
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
              onPressed: () => context.go('/tasks/supervisor'),
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 16),
              label: '待分派',
            ),
            PageModeToggle<_TaskBoardViewMode>(
              value: _viewMode,
              minWidth: isMobile ? 72 : 88,
              options: const [
                PageModeOption(value: _TaskBoardViewMode.board, label: '看板'),
                PageModeOption(value: _TaskBoardViewMode.list, label: '列表'),
                PageModeOption(
                  value: _TaskBoardViewMode.timeline,
                  label: '时间轴',
                ),
              ],
              onChanged: (value) => setState(() => _viewMode = value),
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
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
    required List<AppDropdownOption<int?>> departmentItems,
    required List<AppDropdownOption<String?>> statusItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: LayoutTokens.pagePadding(context),
      children: [
        if (_loadingDepartments) const LinearProgressIndicator(minHeight: 2),
        AppSelect<int?>(
          key: ValueKey<int?>(_departmentFilterId),
          value: _departmentFilterId,
          decoration: const InputDecoration(labelText: '部门'),
          options: departmentItems,
          onChanged: (value) {
            setState(() => _departmentFilterId = value);
            _applyFilters(viewModel);
          },
        ),
        SizedBox(height: spacing),
        AppSelect<String?>(
          key: ValueKey<String?>(_statusFilter),
          value: _statusFilter,
          decoration: const InputDecoration(labelText: '状态'),
          options: statusItems,
          onChanged: (value) {
            setState(() => _statusFilter = value);
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

  Widget _buildListView(BuildContext context, List<Task> tasks) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListTile(
          task: task,
          onTap: () => _openTaskDetail(context, task),
          showDivider: false,
        );
      },
    );
  }

  Widget _buildTimelineView(BuildContext context, List<Task> tasks) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    return TaskTimelineList(
      groups: _groupTasksByDate(tasks),
      sectionSpacing: sectionSpacing,
      isOverdue: _isOverdue,
      onTapTask: (task) => _openTaskDetail(context, task),
    );
  }

  Widget _buildBoardView(
    BuildContext context,
    TaskViewModel viewModel,
    List<Task> tasks,
    bool isMobile,
  ) {
    final grouped = _groupTasks(tasks, sortByDeliveryDate: _sortByDeliveryDate);
    var columns = [
      TaskBoardColumnData(
        key: 'pending',
        title: '待开始',
        icon: Icons.pause_circle_outline,
        tasks: grouped['pending'] ?? const [],
        totalCount: tasks.length,
      ),
      TaskBoardColumnData(
        key: 'in_progress',
        title: '进行中',
        icon: Icons.play_circle_outline,
        tasks: grouped['in_progress'] ?? const [],
        totalCount: tasks.length,
      ),
      TaskBoardColumnData(
        key: 'completed',
        title: '已完成',
        icon: Icons.check_circle_outline,
        tasks: grouped['completed'] ?? const [],
        totalCount: tasks.length,
      ),
      TaskBoardColumnData(
        key: 'other',
        title: '其他',
        icon: Icons.more_horiz,
        tasks: grouped['other'] ?? const [],
        totalCount: tasks.length,
      ),
    ];

    if (_hideEmptyColumns) {
      columns = columns.where((column) => column.tasks.isNotEmpty).toList();
    }

    Widget boardContent;
    if (isMobile) {
      boardContent = ListView.separated(
        itemCount: columns.length,
        separatorBuilder: (_, __) => SizedBox(height: LayoutTokens.gapMd),
        itemBuilder: (context, index) {
          final column = columns[index];
          return TaskBoardColumn(
            data: column,
            onTapTask: (task) => _openTaskDetail(context, task),
            onDrop: (data) =>
                _handleStatusDrop(context, viewModel, data.task, column.key),
            canAccept: (data) => _canAcceptDrop(data.task, column.key),
            onDragStart: _handleDragStart,
            onDragEnd: _handleDragEnd,
            updatingTaskId: _updatingTaskId,
            draggingTaskId: _draggingTaskId,
            useLongPress: true,
            fullWidth: true,
          );
        },
      );
    } else {
      boardContent = LayoutBuilder(
        builder: (context, constraints) {
          const gap = LayoutTokens.gapLg;
          final maxWidth = constraints.maxWidth;
          var columnsPerRow =
              ((maxWidth + gap) / (_columnMinWidth + gap)).floor();
          if (columnsPerRow < 1) columnsPerRow = 1;
          if (columnsPerRow > columns.length) {
            columnsPerRow = columns.length;
          }
          final columnWidth =
              (maxWidth - gap * (columnsPerRow - 1)) / columnsPerRow;

          return SingleChildScrollView(
            child: Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final column in columns)
                  SizedBox(
                    width: columnWidth,
                    child: TaskBoardColumn(
                      data: column,
                      onTapTask: (task) => _openTaskDetail(context, task),
                      onDrop: (data) => _handleStatusDrop(
                          context, viewModel, data.task, column.key),
                      canAccept: (data) =>
                          _canAcceptDrop(data.task, column.key),
                      onDragStart: _handleDragStart,
                      onDragEnd: _handleDragEnd,
                      updatingTaskId: _updatingTaskId,
                      draggingTaskId: _draggingTaskId,
                      useLongPress: false,
                      width: columnWidth,
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoardQuickFilters(viewModel, tasks),
        SizedBox(height: LayoutTokens.gapMd),
        Expanded(child: boardContent),
      ],
    );
  }

  Map<String, List<Task>> _groupTasks(
    List<Task> tasks, {
    required bool sortByDeliveryDate,
  }) {
    final grouped = <String, List<Task>>{
      'pending': [],
      'in_progress': [],
      'completed': [],
      'other': [],
    };
    for (final task in tasks) {
      final status = task.status ?? '';
      if (grouped.containsKey(status)) {
        grouped[status]!.add(task);
      } else {
        grouped['other']!.add(task);
      }
    }
    if (sortByDeliveryDate) {
      for (final entry in grouped.entries) {
        entry.value.sort((a, b) {
          final aDate = a.deliveryDate;
          final bDate = b.deliveryDate;
          if (aDate == null && bDate == null) return a.id.compareTo(b.id);
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          final compare = aDate.compareTo(bDate);
          return compare != 0 ? compare : a.id.compareTo(b.id);
        });
      }
    }
    return grouped;
  }

  List<TimelineGroup> _groupTasksByDate(List<Task> tasks) {
    final dated = <int, List<Task>>{};
    final noDate = <Task>[];

    for (final task in tasks) {
      final date = task.deliveryDate;
      if (date == null) {
        noDate.add(task);
        continue;
      }
      final normalized = DateTime(date.year, date.month, date.day);
      final key = normalized.millisecondsSinceEpoch;
      dated.putIfAbsent(key, () => []).add(task);
    }

    for (final entry in dated.entries) {
      _sortTasksByStatus(entry.value);
    }
    if (noDate.isNotEmpty) {
      _sortTasksByStatus(noDate);
    }

    final keys = dated.keys.toList()..sort();
    final groups = <TimelineGroup>[
      for (final key in keys)
        TimelineGroup(
          date: DateTime.fromMillisecondsSinceEpoch(key),
          label: _formatTimelineLabel(DateTime.fromMillisecondsSinceEpoch(key)),
          tasks: dated[key] ?? const [],
        ),
    ];

    if (noDate.isNotEmpty) {
      groups.add(TimelineGroup(
        date: null,
        label: '未设置交期',
        tasks: noDate,
      ));
    }
    return groups;
  }

  void _sortTasksByStatus(List<Task> items) {
    items.sort((a, b) {
      final aRank = _statusRank(a.status);
      final bRank = _statusRank(b.status);
      if (aRank != bRank) return aRank.compareTo(bRank);
      return a.id.compareTo(b.id);
    });
  }

  int _statusRank(String? status) {
    switch (status) {
      case 'in_progress':
        return 0;
      case 'pending':
        return 1;
      case 'completed':
        return 2;
      case 'cancelled':
        return 3;
      default:
        return 4;
    }
  }

  String _formatTimelineLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalized = DateTime(date.year, date.month, date.day);
    final diffDays = normalized.difference(today).inDays;
    final weekday = _weekdayLabel(normalized.weekday);
    final label = '${normalized.month}月${normalized.day}日 $weekday';
    if (diffDays == 0) {
      return '$label · 今天';
    }
    if (diffDays == 1) {
      return '$label · 明天';
    }
    if (diffDays < 0) {
      return '$label · 已逾期';
    }
    return label;
  }

  String _weekdayLabel(int weekday) {
    const labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    if (weekday < 1 || weekday > 7) return '';
    return labels[weekday - 1];
  }

  bool _isOverdue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.isBefore(today);
  }

  int _activeFilterCount() {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (_statusFilter != null && _statusFilter!.trim().isNotEmpty) count += 1;
    if (_departmentFilterId != null) count += 1;
    return count;
  }

  bool _hasFilters() => _activeFilterCount() > 0;

  void _openTaskDetail(BuildContext context, Task task) {
    if (task.workOrderId != null) {
      context.go('/workorders/${task.workOrderId}');
      return;
    }
    ToastUtil.showError('该任务暂无施工单详情可查看。');
  }

  void _handleDragStart(Task task) {
    setState(() => _draggingTaskId = task.id);
  }

  void _handleDragEnd() {
    if (_draggingTaskId != null) {
      setState(() => _draggingTaskId = null);
    }
  }

  bool _canAcceptDrop(Task task, String targetStatus) {
    if (_updatingTaskId != null) return false;
    if (targetStatus == 'other') return false;
    final current = task.status ?? '';
    if (current == targetStatus) return false;
    if (current == 'completed') return false;
    if (targetStatus == 'pending') return false;
    if (targetStatus == 'in_progress') {
      return current == 'pending';
    }
    if (targetStatus == 'completed') {
      return current == 'pending' || current == 'in_progress';
    }
    return false;
  }

  Future<void> _handleStatusDrop(
    BuildContext context,
    TaskViewModel viewModel,
    Task task,
    String targetStatus,
  ) async {
    if (!_canAcceptDrop(task, targetStatus)) return;
    if (targetStatus == 'in_progress') {
      await _openQuantityDialog(context, viewModel, task);
      return;
    }
    if (targetStatus == 'completed') {
      await _openCompleteDialog(context, viewModel, task);
    }
  }

  Future<void> _openQuantityDialog(
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

  Future<void> _submitQuantityUpdate(
    TaskViewModel viewModel,
    Task task,
    Map<String, dynamic> payload,
  ) async {
    setState(() => _updatingTaskId = task.id);
    try {
      await _supportService!.updateQuantity(task.id, payload);
      ToastUtil.showSuccess('已更新任务进度');
      await viewModel.loadTasks(resetPage: false);
    } catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _updatingTaskId = null);
    }
  }

  Future<void> _submitComplete(
    TaskViewModel viewModel,
    Task task,
    Map<String, dynamic> payload,
  ) async {
    setState(() => _updatingTaskId = task.id);
    try {
      await _supportService!.completeTask(task.id, payload);
      ToastUtil.showSuccess('任务已完成');
      await viewModel.loadTasks(resetPage: false);
    } catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _updatingTaskId = null);
    }
  }

  Widget _buildBoardQuickFilters(TaskViewModel viewModel, List<Task> tasks) {
    final statusCounts = _buildStatusCounts(tasks);
    final filters = [
      TaskBoardQuickFilterItem(label: '全部', value: null, count: tasks.length),
      TaskBoardQuickFilterItem(
          label: '待开始', value: 'pending', count: statusCounts['pending'] ?? 0),
      TaskBoardQuickFilterItem(
        label: '进行中',
        value: 'in_progress',
        count: statusCounts['in_progress'] ?? 0,
      ),
      TaskBoardQuickFilterItem(
          label: '已完成',
          value: 'completed',
          count: statusCounts['completed'] ?? 0),
    ];

    return TaskBoardQuickFilters(
      filters: filters,
      selectedStatus: _statusFilter,
      hideEmptyColumns: _hideEmptyColumns,
      sortByDeliveryDate: _sortByDeliveryDate,
      onSelectStatus: (value) {
        setState(() => _statusFilter = value);
        _applyFilters(viewModel);
      },
      onToggleHideEmptyColumns: (value) =>
          setState(() => _hideEmptyColumns = value),
      onToggleSortByDeliveryDate: (value) =>
          setState(() => _sortByDeliveryDate = value),
    );
  }

  Map<String, int> _buildStatusCounts(List<Task> tasks) {
    final counts = <String, int>{
      'pending': 0,
      'in_progress': 0,
      'completed': 0,
    };
    for (final task in tasks) {
      final status = task.status ?? '';
      if (counts.containsKey(status)) {
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }
    return counts;
  }
}
