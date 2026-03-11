import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
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

/// 任务列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class TaskListEntry extends StatefulWidget {
  const TaskListEntry({super.key});

  @override
  State<TaskListEntry> createState() => _TaskListEntryState();
}

class _TaskListEntryState extends State<TaskListEntry> {
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
  static const double _spacingSm = 8;
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

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _filtersExpanded = false;
  String? _statusFilter;
  String? _priorityFilter;
  int? _departmentFilterId;
  int? _processFilterId;

  bool _loadingOptions = false;
  List<Department> _departments = [];
  List<Process> _processes = [];

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
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<TaskViewModel>(
      builder: (context, viewModel, _) {
        final tasks = viewModel.tasks;
        _statusFilter = viewModel.statusFilter;
        _priorityFilter = viewModel.priorityFilter;
        _departmentFilterId = viewModel.departmentFilterId;
        _processFilterId = viewModel.processFilterId;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, tasks, isMobile),
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

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildSummaryCard(context, task, isMobile);
      },
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    TaskViewModel viewModel,
    List<String> breadcrumb,
    bool isMobile,
  ) {
    final summaryItems = [
      WorkbenchStatItem(label: '总任务', value: '${viewModel.total}'),
    ];
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

    return WorkbenchHeaderBar(
      breadcrumb: null,
      title: '任务列表',
      subtitle: '',
      stats: summaryItems,
      titleMaxWidth: isMobile ? double.infinity : 420,
      hideSubtitleOnMobile: true,
      mobileStatCount: 1,
      hideTitleOnMobile: true,
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
            onPressed: () =>
                setState(() => _filtersExpanded = !filtersExpanded),
            icon: filtersExpanded
                ? Icons.filter_alt_off
                : Icons.filter_alt_outlined,
            label: filtersExpanded
                ? '收起筛选'
                : activeFilters > 0
                    ? '筛选 $activeFilters'
                    : '筛选',
            height: _controlHeight,
            compact: isMobile,
          );

          final mobileFilters = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_loadingOptions) const LinearProgressIndicator(minHeight: 2),
              DropdownButtonFormField<String>(
                initialValue: _statusFilter,
                isExpanded: true,
                decoration: const InputDecoration(
                    labelText: '状态', border: OutlineInputBorder()),
                items: statusItems,
                onChanged: (value) {
                  setState(() => _statusFilter = value);
                  _applyFilters(viewModel);
                },
              ),
              const SizedBox(height: _spacingSm),
              DropdownButtonFormField<String>(
                initialValue: _priorityFilter,
                isExpanded: true,
                decoration: const InputDecoration(
                    labelText: '优先级', border: OutlineInputBorder()),
                items: priorityItems,
                onChanged: (value) {
                  setState(() => _priorityFilter = value);
                  _applyFilters(viewModel);
                },
              ),
              const SizedBox(height: _spacingSm),
              DropdownButtonFormField<int?>(
                initialValue: _departmentFilterId,
                isExpanded: true,
                decoration: const InputDecoration(
                    labelText: '部门', border: OutlineInputBorder()),
                items: departmentItems,
                onChanged: (value) {
                  setState(() => _departmentFilterId = value);
                  _applyFilters(viewModel);
                },
              ),
              const SizedBox(height: _spacingSm),
              DropdownButtonFormField<int?>(
                initialValue: _processFilterId,
                isExpanded: true,
                decoration: const InputDecoration(
                    labelText: '工序', border: OutlineInputBorder()),
                items: processItems,
                onChanged: (value) {
                  setState(() => _processFilterId = value);
                  _applyFilters(viewModel);
                },
              ),
            ],
          );

          final desktopFilters = Wrap(
            spacing: _spacingSm,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (_loadingOptions)
                const SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  initialValue: _statusFilter,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: '状态', border: OutlineInputBorder()),
                  items: statusItems,
                  onChanged: (value) {
                    setState(() => _statusFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  initialValue: _priorityFilter,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: '优先级', border: OutlineInputBorder()),
                  items: priorityItems,
                  onChanged: (value) {
                    setState(() => _priorityFilter = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<int?>(
                  initialValue: _departmentFilterId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: '部门', border: OutlineInputBorder()),
                  items: departmentItems,
                  onChanged: (value) {
                    setState(() => _departmentFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<int?>(
                  initialValue: _processFilterId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: '工序', border: OutlineInputBorder()),
                  items: processItems,
                  onChanged: (value) {
                    setState(() => _processFilterId = value);
                    _applyFilters(viewModel);
                  },
                ),
              ),
            ],
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
          ];

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
                  child: mobileFilters,
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
                child: desktopFilters,
              ),
            ],
          );
        },
      ),
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

  Widget _buildSummaryCard(BuildContext context, Task task, bool isMobile) {
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
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
