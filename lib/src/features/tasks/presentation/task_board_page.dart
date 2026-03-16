import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/application/task_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';

enum _TaskBoardViewMode {
  board,
  list,
  timeline,
}

/// 部门任务看板入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class TaskBoardEntry extends StatefulWidget {
  const TaskBoardEntry({super.key});

  @override
  State<TaskBoardEntry> createState() => _TaskBoardEntryState();
}

class _TaskBoardEntryState extends State<TaskBoardEntry> {
  TaskApiService? _apiService;
  TaskRepositoryImpl? _repository;
  TaskViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = TaskApiService(apiClient);
    _repository = TaskRepositoryImpl(_apiService!);
    _viewModel = TaskViewModel(_repository!);
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _viewModel?.initialize();
      });
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = _apiService;
    final repository = _repository;
    final viewModel = _viewModel;
    if (apiService == null || repository == null || viewModel == null) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: [
        Provider<TaskApiService>.value(value: apiService),
        Provider<TaskRepository>.value(value: repository),
        ChangeNotifierProvider<TaskViewModel>.value(value: viewModel),
      ],
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
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
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
  List<Department> _departments = [];

  @override
  void initState() {
    super.initState();
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
      final apiClient = context.read<ApiClient>();
      final departmentApi = DepartmentApiService(apiClient);
      final result =
          await departmentApi.fetchDepartments(page: 1, pageSize: 200);
      if (!mounted) return;
      setState(() {
        _departments = result.items.map((item) => item.toEntity()).toList();
      });
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
    final isMobile = BreakpointsUtil.isMobile(context);

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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmptyStateCard(
            icon: Icons.view_kanban_outlined,
            text: _emptyText,
          ),
          if (_hasFilters()) ...[
            const SizedBox(height: 12),
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
      const DropdownMenuItem<int?>(
        value: null,
        child: Text('全部部门', overflow: TextOverflow.ellipsis),
      ),
      ..._departments.map(
        (item) => DropdownMenuItem<int?>(
          value: item.id,
          child: Text(item.name, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    final statusItems = const [
      DropdownMenuItem<String?>(value: null, child: Text('全部状态')),
      DropdownMenuItem(value: 'pending', child: Text('待开始')),
      DropdownMenuItem(value: 'in_progress', child: Text('进行中')),
      DropdownMenuItem(value: 'completed', child: Text('已完成')),
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
            ToggleButtons(
              isSelected: [
                _viewMode == _TaskBoardViewMode.board,
                _viewMode == _TaskBoardViewMode.list,
                _viewMode == _TaskBoardViewMode.timeline,
              ],
              onPressed: (index) {
                setState(() {
                  if (index == 0) _viewMode = _TaskBoardViewMode.board;
                  if (index == 1) _viewMode = _TaskBoardViewMode.list;
                  if (index == 2) _viewMode = _TaskBoardViewMode.timeline;
                });
              },
              constraints: BoxConstraints(
                minHeight: _controlHeight,
                minWidth: isMobile ? 72 : 88,
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('看板'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('列表'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('时间轴'),
                ),
              ],
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
    required List<DropdownMenuItem<int?>> departmentItems,
    required List<DropdownMenuItem<String?>> statusItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        if (_loadingDepartments) const LinearProgressIndicator(minHeight: 2),
        SearchableDropdownFormField<int?>(
          key: ValueKey<int?>(_departmentFilterId),
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
        SearchableDropdownFormField<String?>(
          key: ValueKey<String?>(_statusFilter),
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
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final groups = _groupTasksByDate(tasks);
    final listPadding = EdgeInsets.only(bottom: sectionSpacing);

    return ListView.separated(
      padding: listPadding,
      itemCount: groups.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final group = groups[index];
        final overdue = group.date != null && _isOverdue(group.date!) &&
            group.tasks.any((task) => task.status != 'completed');

        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.borderColor),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  border: Border(
                    bottom: BorderSide(color: colors.borderColor),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.sidebarText,
                        ),
                      ),
                    ),
                    if (overdue)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                              LayoutTokens.radiusPill),
                          border: Border.all(
                            color: theme.colorScheme.error
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '已逾期',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      '${group.tasks.length} 项',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.subtleText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < group.tasks.length; i++)
                TaskListTile(
                  task: group.tasks[i],
                  onTap: () => _openTaskDetail(context, group.tasks[i]),
                  showDivider: i != group.tasks.length - 1,
                  showAssignee: true,
                ),
            ],
          ),
        );
      },
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
      _BoardColumnData(
        key: 'pending',
        title: '待开始',
        icon: Icons.pause_circle_outline,
        tasks: grouped['pending'] ?? const [],
        totalCount: tasks.length,
      ),
      _BoardColumnData(
        key: 'in_progress',
        title: '进行中',
        icon: Icons.play_circle_outline,
        tasks: grouped['in_progress'] ?? const [],
        totalCount: tasks.length,
      ),
      _BoardColumnData(
        key: 'completed',
        title: '已完成',
        icon: Icons.check_circle_outline,
        tasks: grouped['completed'] ?? const [],
        totalCount: tasks.length,
      ),
      _BoardColumnData(
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
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final column = columns[index];
          return _BoardColumn(
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
          const gap = 16.0;
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
                    child: _BoardColumn(
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
        const SizedBox(height: 12),
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

  List<_TimelineGroup> _groupTasksByDate(List<Task> tasks) {
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
    final groups = <_TimelineGroup>[
      for (final key in keys)
        _TimelineGroup(
          date: DateTime.fromMillisecondsSinceEpoch(key),
          label: _formatTimelineLabel(
              DateTime.fromMillisecondsSinceEpoch(key)),
          tasks: dated[key] ?? const [],
        ),
    ];

    if (noDate.isNotEmpty) {
      groups.add(_TimelineGroup(
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('该任务暂无施工单详情可查看。')),
    );
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
    await showDialog<void>(
      context: context,
      builder: (_) => _TaskQuantityDialog(
        task: task,
        onSubmit: (payload) => _submitQuantityUpdate(viewModel, task, payload),
      ),
    );
  }

  Future<void> _openCompleteDialog(
    BuildContext context,
    TaskViewModel viewModel,
    Task task,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _TaskCompleteDialog(
        task: task,
        onSubmit: (payload) => _submitComplete(viewModel, task, payload),
      ),
    );
  }

  Future<void> _submitQuantityUpdate(
    TaskViewModel viewModel,
    Task task,
    Map<String, dynamic> payload,
  ) async {
    setState(() => _updatingTaskId = task.id);
    try {
      final api = context.read<TaskApiService>();
      await api.updateQuantity(task.id, payload);
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
      final api = context.read<TaskApiService>();
      await api.complete(task.id, payload);
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
      _QuickFilterItem(label: '全部', value: null, count: tasks.length),
      _QuickFilterItem(
          label: '待开始', value: 'pending', count: statusCounts['pending'] ?? 0),
      _QuickFilterItem(
        label: '进行中',
        value: 'in_progress',
        count: statusCounts['in_progress'] ?? 0,
      ),
      _QuickFilterItem(
          label: '已完成',
          value: 'completed',
          count: statusCounts['completed'] ?? 0),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final filter in filters)
          ChoiceChip(
            label: Text('${filter.label} ${filter.count}'),
            selected: _statusFilter == filter.value,
            onSelected: (_) {
              setState(() => _statusFilter = filter.value);
              _applyFilters(viewModel);
            },
          ),
        FilterChip(
          label: const Text('隐藏空列'),
          selected: _hideEmptyColumns,
          onSelected: (value) => setState(() => _hideEmptyColumns = value),
        ),
        FilterChip(
          label: const Text('按交期排序'),
          selected: _sortByDeliveryDate,
          onSelected: (value) => setState(() => _sortByDeliveryDate = value),
        ),
      ],
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

class _TimelineGroup {
  const _TimelineGroup({
    required this.date,
    required this.label,
    required this.tasks,
  });

  final DateTime? date;
  final String label;
  final List<Task> tasks;
}

class _QuickFilterItem {
  const _QuickFilterItem({
    required this.label,
    required this.value,
    required this.count,
  });

  final String label;
  final String? value;
  final int count;
}

class _BoardColumnData {
  const _BoardColumnData({
    required this.key,
    required this.title,
    required this.icon,
    required this.tasks,
    required this.totalCount,
  });

  final String key;
  final String title;
  final IconData icon;
  final List<Task> tasks;
  final int totalCount;
}

class _BoardColumn extends StatelessWidget {
  const _BoardColumn({
    required this.data,
    required this.onTapTask,
    this.onDrop,
    this.canAccept,
    this.onDragStart,
    this.onDragEnd,
    this.updatingTaskId,
    this.draggingTaskId,
    this.useLongPress = false,
    this.width,
    this.fullWidth = false,
  });

  final _BoardColumnData data;
  final ValueChanged<Task> onTapTask;
  final ValueChanged<_TaskDragData>? onDrop;
  final bool Function(_TaskDragData data)? canAccept;
  final ValueChanged<Task>? onDragStart;
  final VoidCallback? onDragEnd;
  final int? updatingTaskId;
  final int? draggingTaskId;
  final bool useLongPress;
  final double? width;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final resolvedWidth = fullWidth ? double.infinity : (width ?? 320);
    double? resolvedFeedbackWidth;
    if (resolvedWidth.isFinite) {
      final value = (resolvedWidth - 24).clamp(220.0, 520.0);
      resolvedFeedbackWidth = value.toDouble();
    }
    final share = data.totalCount == 0
        ? 0
        : (data.tasks.length / data.totalCount * 100).round();
    final dragTarget = DragTarget<_TaskDragData>(
      onWillAcceptWithDetails: (details) =>
          canAccept?.call(details.data) ?? false,
      onAcceptWithDetails: (details) => onDrop?.call(details.data),
      builder: (context, candidates, rejected) {
        final highlight = candidates.isNotEmpty;
        return _buildColumnShell(
          context,
          colors,
          resolvedWidth,
          resolvedFeedbackWidth,
          highlight,
          share,
        );
      },
    );

    return dragTarget;
  }

  Widget _buildColumnShell(
    BuildContext context,
    AppColors colors,
    double resolvedWidth,
    double? resolvedFeedbackWidth,
    bool highlight,
    int share,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: resolvedWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
        border: Border.all(
          color: highlight ? theme.colorScheme.primary : colors.borderColor,
          width: highlight ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 18, color: colors.subtleText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.sidebarText,
                  ),
                ),
              ),
              Text(
                '${data.tasks.length} · $share%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.subtleText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (data.tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '暂无任务',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.subtleText,
                ),
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < data.tasks.length; i++) ...[
                  _DraggableTaskCard(
                    task: data.tasks[i],
                    onTap: () => onTapTask(data.tasks[i]),
                    onDragStart: onDragStart,
                    onDragEnd: onDragEnd,
                    isBusy: updatingTaskId == data.tasks[i].id,
                    isDragging: draggingTaskId == data.tasks[i].id,
                    useLongPress: useLongPress,
                    feedbackWidth: resolvedFeedbackWidth,
                  ),
                  if (i != data.tasks.length - 1) const SizedBox(height: 8),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _TaskDragData {
  const _TaskDragData({
    required this.task,
    required this.fromStatus,
  });

  final Task task;
  final String fromStatus;
}

class _DraggableTaskCard extends StatelessWidget {
  const _DraggableTaskCard({
    required this.task,
    required this.onTap,
    required this.onDragStart,
    required this.onDragEnd,
    required this.isBusy,
    required this.isDragging,
    required this.useLongPress,
    this.feedbackWidth,
  });

  final Task task;
  final VoidCallback onTap;
  final ValueChanged<Task>? onDragStart;
  final VoidCallback? onDragEnd;
  final bool isBusy;
  final bool isDragging;
  final bool useLongPress;
  final double? feedbackWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    final card = Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: colors.borderColor),
      ),
      child: TaskListTile(
        task: task,
        onTap: onTap,
        showDivider: false,
      ),
    );

    final draggable = useLongPress
        ? LongPressDraggable<_TaskDragData>(
            data: _TaskDragData(task: task, fromStatus: task.status ?? ''),
            onDragStarted: () => onDragStart?.call(task),
            onDragEnd: (_) => onDragEnd?.call(),
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(width: feedbackWidth ?? 280, child: card),
            ),
            childWhenDragging: Opacity(opacity: 0.4, child: card),
            child: _buildContent(colors, card),
          )
        : Draggable<_TaskDragData>(
            data: _TaskDragData(task: task, fromStatus: task.status ?? ''),
            onDragStarted: () => onDragStart?.call(task),
            onDragEnd: (_) => onDragEnd?.call(),
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(width: feedbackWidth ?? 280, child: card),
            ),
            childWhenDragging: Opacity(opacity: 0.4, child: card),
            child: _buildContent(colors, card),
          );

    return draggable;
  }

  Widget _buildContent(AppColors colors, Widget card) {
    return Stack(
      children: [
        card,
        if (isDragging)
          Positioned.fill(
            child: Container(
              color: colors.surface.withValues(alpha: 0.6),
              child: const Center(
                child: Icon(Icons.open_with, size: 18),
              ),
            ),
          ),
        if (isBusy)
          Positioned.fill(
            child: Container(
              color: colors.surface.withValues(alpha: 0.7),
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TaskQuantityDialog extends StatefulWidget {
  const _TaskQuantityDialog({
    required this.task,
    required this.onSubmit,
  });

  final Task task;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<_TaskQuantityDialog> createState() => _TaskQuantityDialogState();
}

class _TaskQuantityDialogState extends State<_TaskQuantityDialog> {
  final _formKey = GlobalKey<FormState>();
  int _quantityIncrement = 1;
  int _quantityDefective = 0;
  String _notes = '';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _quantityIncrement = 1;
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    final remaining = (total - completed).clamp(0, double.infinity).toInt();

    return AlertDialog(
      title: const Text('更新进度'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.workContent ?? '任务 #${task.id}'),
                const SizedBox(height: 8),
                Text('已完成 $completed / $total · 剩余 $remaining'),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _quantityIncrement.toString(),
                  decoration: const InputDecoration(labelText: '本次完成数量'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return '请输入大于 0 的数量';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _quantityIncrement = int.tryParse(value) ?? 0;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _quantityDefective.toString(),
                  decoration: const InputDecoration(labelText: '不良品数量'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _quantityDefective = int.tryParse(value) ?? 0;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: '备注（可选）'),
                  onChanged: (value) => _notes = value,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('确认更新'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _submitting = true);
    try {
      await widget.onSubmit({
        'quantity_increment': _quantityIncrement,
        'quantity_defective': _quantityDefective,
        'notes': _notes,
      });
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _TaskCompleteDialog extends StatefulWidget {
  const _TaskCompleteDialog({
    required this.task,
    required this.onSubmit,
  });

  final Task task;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<_TaskCompleteDialog> createState() => _TaskCompleteDialogState();
}

class _TaskCompleteDialogState extends State<_TaskCompleteDialog> {
  int _quantityDefective = 0;
  String _completionReason = '';
  String _notes = '';
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return AlertDialog(
      title: const Text('完成任务'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.workContent ?? '任务 #${task.id}'),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _quantityDefective.toString(),
                decoration: const InputDecoration(labelText: '不良品数量'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _quantityDefective = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: '完成理由（可选）'),
                onChanged: (value) => _completionReason = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: '备注（可选）'),
                onChanged: (value) => _notes = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('确认完成'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await widget.onSubmit({
        'quantity_defective': _quantityDefective,
        'completion_reason': _completionReason,
        'notes': _notes,
      });
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
