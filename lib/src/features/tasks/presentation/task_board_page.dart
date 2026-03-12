import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/application/task_view_model.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_repository_impl.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';

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
  static const double _columnWidth = 320;

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
  bool _filtersExpanded = false;
  bool _showListView = false;
  bool _hideEmptyColumns = false;
  bool _sortByDeliveryDate = false;
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
      final result = await departmentApi.fetchDepartments(page: 1, pageSize: 200);
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
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<TaskViewModel>(
      builder: (context, viewModel, _) {
        final tasks = viewModel.tasks;
        _statusFilter = viewModel.statusFilter;
        _departmentFilterId = viewModel.departmentFilterId;
        final stats = _buildStats(tasks, viewModel.total);
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile, stats),
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

    if (_showListView) {
      return _buildListView(context, tasks);
    }
    return _buildBoardView(context, viewModel, tasks, isMobile);
  }

  Widget _buildPageHeader(
    BuildContext context,
    TaskViewModel viewModel,
    List<String> breadcrumb,
    bool isMobile,
    _TaskBoardStats stats,
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

    return WorkbenchHeaderBar(
      breadcrumb: breadcrumb.isEmpty ? null : breadcrumb.join(' / '),
      title: '部门任务看板',
      subtitle: '支持看板与列表视图切换，按部门/状态快速筛选任务。',
      stats: [
        WorkbenchStatItem(label: '总任务', value: '${stats.total}'),
        WorkbenchStatItem(label: '待开始', value: '${stats.pending}'),
        WorkbenchStatItem(label: '进行中', value: '${stats.inProgress}'),
        WorkbenchStatItem(label: '已完成', value: '${stats.completed}'),
      ],
      titleMaxWidth: isMobile ? double.infinity : 420,
      hideSubtitleOnMobile: true,
      mobileStatCount: 2,
      hideTitleOnMobile: false,
      hideBreadcrumbOnMobile: true,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final filtersExpanded = _filtersExpanded;
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

          final filterToggle = ListToolbarButton(
            onPressed: () => setState(() => _filtersExpanded = !filtersExpanded),
            icon: filtersExpanded ? Icons.filter_alt_off : Icons.filter_alt_outlined,
            label: filtersExpanded
                ? '收起筛选'
                : activeFilters > 0
                    ? '筛选 $activeFilters'
                    : '筛选',
            height: _controlHeight,
            compact: isMobile,
          );

          final viewToggle = ListToolbarButton(
            onPressed: () => setState(() => _showListView = !_showListView),
            icon: _showListView ? Icons.view_kanban_outlined : Icons.view_list_outlined,
            label: _showListView ? '看板视图' : '列表视图',
            height: _controlHeight,
            compact: isMobile,
          );

          final actions = <Widget>[
            filterToggle,
            if (activeFilters > 0)
              ListToolbarButton(
                onPressed: () => _resetFilters(viewModel),
                icon: Icons.restart_alt,
                label: _resetButtonText,
                height: _controlHeight,
                compact: isMobile,
              ),
            ListToolbarButton(
              onPressed: () => viewModel.loadTasks(resetPage: true),
              icon: Icons.refresh,
              label: _refreshButtonText,
              height: _controlHeight,
              compact: isMobile,
            ),
            viewToggle,
          ];

          final filterWidgets = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_loadingDepartments)
                const LinearProgressIndicator(minHeight: 2),
              DropdownButtonFormField<int?>(
                value: _departmentFilterId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: '部门'),
                items: departmentItems,
                onChanged: (value) {
                  setState(() => _departmentFilterId = value);
                  _applyFilters(viewModel);
                },
              ),
              const SizedBox(height: _spacingSm),
              DropdownButtonFormField<String?>(
                value: _statusFilter,
                isExpanded: true,
                decoration: const InputDecoration(labelText: '状态'),
                items: statusItems,
                onChanged: (value) {
                  setState(() => _statusFilter = value);
                  _applyFilters(viewModel);
                },
              ),
            ],
          );

          if (isMobile) {
            final maxFilterHeight = MediaQuery.of(context).size.height * 0.45;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListToolbar(
                  isMobile: true,
                  searchField: searchField,
                  actions: actions,
                  spacing: _spacingSm,
                  mobileActionAlignment: WrapAlignment.start,
                ),
                const SizedBox(height: _spacingSm),
                ExpandableFilters(
                  expanded: filtersExpanded,
                  maxHeight: maxFilterHeight,
                  child: filterWidgets,
                ),
              ],
            );
          }

          final maxFilterHeight = MediaQuery.of(context).size.height * 0.35;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListToolbar(
                isMobile: false,
                searchField: searchField,
                actions: actions,
                spacing: _spacingSm,
              ),
              ExpandableFilters(
                expanded: filtersExpanded,
                maxHeight: maxFilterHeight,
                topPadding: _spacingSm,
                child: filterWidgets,
              ),
            ],
          );
        },
      ),
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
            fullWidth: true,
          );
        },
      );
    } else {
      boardContent = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < columns.length; i++) ...[
                      _BoardColumn(
                        data: columns[i],
                        onTapTask: (task) => _openTaskDetail(context, task),
                        width: _columnWidth,
                      ),
                      if (i != columns.length - 1) const SizedBox(width: 16),
                    ],
                  ],
                ),
              ),
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

  _TaskBoardStats _buildStats(List<Task> tasks, int total) {
    var pending = 0;
    var inProgress = 0;
    var completed = 0;
    for (final task in tasks) {
      switch (task.status) {
        case 'pending':
          pending += 1;
          break;
        case 'in_progress':
          inProgress += 1;
          break;
        case 'completed':
          completed += 1;
          break;
      }
    }
    return _TaskBoardStats(
      total: total,
      pending: pending,
      inProgress: inProgress,
      completed: completed,
    );
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

  Widget _buildBoardQuickFilters(TaskViewModel viewModel, List<Task> tasks) {
    final statusCounts = _buildStatusCounts(tasks);
    final filters = [
      _QuickFilterItem(label: '全部', value: null, count: tasks.length),
      _QuickFilterItem(label: '待开始', value: 'pending', count: statusCounts['pending'] ?? 0),
      _QuickFilterItem(
        label: '进行中',
        value: 'in_progress',
        count: statusCounts['in_progress'] ?? 0,
      ),
      _QuickFilterItem(label: '已完成', value: 'completed', count: statusCounts['completed'] ?? 0),
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

class _TaskBoardStats {
  const _TaskBoardStats({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
  });

  final int total;
  final int pending;
  final int inProgress;
  final int completed;
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
    this.width,
    this.fullWidth = false,
  });

  final _BoardColumnData data;
  final ValueChanged<Task> onTapTask;
  final double? width;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final resolvedWidth = fullWidth ? double.infinity : (width ?? 320);
    final share = data.totalCount == 0
        ? 0
        : (data.tasks.length / data.totalCount * 100).round();

    return Container(
      width: resolvedWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
        border: Border.all(color: colors.borderColor),
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
                  TaskListTile(
                    task: data.tasks[i],
                    onTap: () => onTapTask(data.tasks[i]),
                    showDivider: false,
                  ),
                  if (i != data.tasks.length - 1)
                    const SizedBox(height: 8),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
