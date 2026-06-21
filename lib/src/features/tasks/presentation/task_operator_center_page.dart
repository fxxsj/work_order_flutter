import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';

import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_mode_toggle.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_operator_center_result.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_ui_helper.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';


/// 任务关联对象一行展示（产品/稿图/刀模/材料）。
class _TaskContextRow extends StatelessWidget {
  const _TaskContextRow({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <String, String>{
      if (task.productName != null) '产品': task.productName!,
      if (task.artworkName != null) '稿图': task.artworkName!,
      if (task.dieName != null) '刀模': task.dieName!,
      if (task.materialName != null) '材料': task.materialName!,
    };
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: SpacingTokens.xs,
      runSpacing: SpacingTokens.xs,
      children: items.entries.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${e.key}: ${e.value}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 操作记录展开行。
class _TaskLogRow extends StatelessWidget {
  const _TaskLogRow({required this.logs});

  final List<Map<String, dynamic>> logs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    if (logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          '暂无操作记录',
          style: theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '操作记录',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          ...logs.map((log) {
            final actor = log['actor_name'] ?? log['actor'] ?? '-';
            final action = log['action'] ?? log['event'] ?? '-';
            final note = log['note'] ?? '';
            final createdAt = log['created_at'] ?? log['timestamp'] ?? '';
            String timeStr = createdAt;
            if (createdAt is String && createdAt.length >= 16) {
              timeStr = createdAt.substring(5, 16).replaceAll('T', ' ');
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$actor ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      note.isNotEmpty ? '$action · $note' : action,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    timeStr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.subtleText,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class TaskOperatorCenterPage extends StatelessWidget {
  const TaskOperatorCenterPage({super.key});

  @override
  Widget build(BuildContext context) => const _TaskOperatorCenterView();
}

class _TaskOperatorCenterView extends StatefulWidget {
  const _TaskOperatorCenterView();

  @override
  State<_TaskOperatorCenterView> createState() =>
      _TaskOperatorCenterViewState();
}

class _TaskOperatorCenterViewState extends State<_TaskOperatorCenterView> {
  static const double _spacingSm = SpacingTokens.sm;
  static const double _searchWidth = LayoutTokens.searchWidth;
  static const double _controlHeight = PageActionStyle.height;
  static const String _refreshButtonText = '刷新';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';

  final TextEditingController _searchController = TextEditingController();
  final _debounce = DebounceController();

  bool _loading = false;
  String? _errorMessage;
  List<Task> _myTasks = [];
  List<Task> _claimableTasks = [];
  // 原始 JSON，用于取 taskLogs 等未建模字段
  final List<Map<String, dynamic>> _myTasksRaw = [];
  final List<Map<String, dynamic>> _claimableTasksRaw = [];
  OperatorSummary _summary = const OperatorSummary();
  PaginationMeta _meta = const PaginationMeta();
  int? _claimingTaskId;

  // 分页
  static const int _defaultLimit = 50;
  bool _loadingMoreMy = false;
  bool _loadingMoreClaimable = false;

  // 展开日志的 task id
  int? _expandedLogTaskId;

  // 筛选状态
  String? _statusFilter;
  String? _taskTypeFilter;
  String? _priorityFilter;
  String _activeTab = 'mine';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildParams() {
    final params = <String, dynamic>{};
    final search = _searchController.text.trim();
    if (search.isNotEmpty) params['search'] = search;
    if (_statusFilter != null && _statusFilter!.isNotEmpty) {
      params['status'] = _statusFilter;
    }
    if (_taskTypeFilter != null && _taskTypeFilter!.isNotEmpty) {
      params['task_type'] = _taskTypeFilter;
    }
    if (_priorityFilter != null && _priorityFilter!.isNotEmpty) {
      params['priority'] = _priorityFilter;
    }
    return params;
  }

  Future<void> _loadData({bool resetPagination = true}) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final repository = context.read<TaskRepository>();
      final params = _buildParams();
      final result = await repository.fetchOperatorCenterData(
        params: params,
        myLimit: _defaultLimit,
        myOffset: 0,
        claimableLimit: _defaultLimit,
        claimableOffset: 0,
      );
      setState(() {
        _myTasks = result.myTasks;
        _claimableTasks = result.claimableTasks;
        _myTasksRaw
          ..clear()
          ..addAll(result.myTasksRaw);
        _claimableTasksRaw
          ..clear()
          ..addAll(result.claimableTasksRaw);
        _summary = result.summary;
        _meta = result.meta;
      });
    } catch (err) {
      setState(() {
        _errorMessage = err.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadMoreMyTasks() async {
    if (_loadingMoreMy || !_meta.myHasMore) return;
    setState(() => _loadingMoreMy = true);
    try {
      final repository = context.read<TaskRepository>();
      final params = _buildParams();
      final currentOffset = _myTasks.length;
      final result = await repository.fetchOperatorCenterData(
        params: params,
        myLimit: _defaultLimit,
        myOffset: currentOffset,
        claimableLimit: 0,
        claimableOffset: 0,
      );
      setState(() {
        _myTasks = [..._myTasks, ...result.myTasks];
        _myTasksRaw.addAll(result.myTasksRaw);
        _meta = result.meta;
      });
    } catch (err) {
      ToastUtil.showError(
        '加载更多失败: ${err.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      if (mounted) setState(() => _loadingMoreMy = false);
    }
  }

  Future<void> _loadMoreClaimableTasks() async {
    if (_loadingMoreClaimable || !_meta.claimableHasMore) return;
    setState(() => _loadingMoreClaimable = true);
    try {
      final repository = context.read<TaskRepository>();
      final params = _buildParams();
      final currentOffset = _claimableTasks.length;
      final result = await repository.fetchOperatorCenterData(
        params: params,
        myLimit: 0,
        myOffset: 0,
        claimableLimit: _defaultLimit,
        claimableOffset: currentOffset,
      );
      setState(() {
        _claimableTasks = [..._claimableTasks, ...result.claimableTasks];
        _claimableTasksRaw.addAll(result.claimableTasksRaw);
        _meta = result.meta;
      });
    } catch (err) {
      ToastUtil.showError(
        '加载更多失败: ${err.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      if (mounted) setState(() => _loadingMoreClaimable = false);
    }
  }

  Future<void> _claimTask(Task task) async {
    setState(() => _claimingTaskId = task.id);
    try {
      final repository = context.read<TaskRepository>();
      await repository.claimTask(task.id);
      ToastUtil.showSuccess('任务已认领');
      await _loadData();
    } catch (err) {
      ToastUtil.showError(_claimErrorMessage(err));
    } finally {
      if (mounted) {
        setState(() => _claimingTaskId = null);
      }
    }
  }

  String _claimErrorMessage(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isEmpty) {
      return '认领失败，请刷新后重试';
    }
    if (message.contains('已认领') ||
        message.toLowerCase().contains('already') ||
        message.toLowerCase().contains('claimed')) {
      return '任务已被认领，请刷新列表';
    }
    if (message.contains('部门') ||
        message.toLowerCase().contains('department') ||
        message.toLowerCase().contains('permission') ||
        message.contains('权限')) {
      return '当前账号不属于该任务部门，无法认领';
    }
    return '认领失败: $message';
  }

  void _onSearchChanged() {
    _debounce.run(() => _loadData());
  }

  void _onFilterChanged() {
    _loadData();
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _statusFilter = null;
      _taskTypeFilter = null;
      _priorityFilter = null;
    });
    _loadData();
  }

  bool get _hasActiveFilters {
    return _searchController.text.trim().isNotEmpty ||
        (_statusFilter != null && _statusFilter!.isNotEmpty) ||
        (_taskTypeFilter != null && _taskTypeFilter!.isNotEmpty) ||
        (_priorityFilter != null && _priorityFilter!.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return ListPageScaffold(
      spacing: _spacingSm,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: ListToolbar(
          isMobile: isMobile,
          actions: [
            PageActionButton.outlined(
              onPressed: _loading ? null : _loadData,
              icon: Icon(
                Icons.refresh,
                size: 16,
                color: _loading ? Theme.of(context).disabledColor : null,
              ),
              label: _refreshButtonText,
            ),
          ],
        ),
      ),
      body: _buildBody(context, isMobile),
    );
  }

  Widget _buildBody(BuildContext context, bool isMobile) {
    if (_loading && _myTasks.isEmpty && _claimableTasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null && !_loading) {
      return ErrorStateCard(
        message: _errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: _loadData,
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCards(context),
          SizedBox(height: SpacingTokens.md),
          _buildFilterBar(context, isMobile),
          SizedBox(height: SpacingTokens.md),
          _buildTabAndList(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildStatCards(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final cards = [
      (
        label: '可认领',
        value: _summary.claimableCount,
        icon: Icons.assignment_turned_in_outlined,
        color: theme.colorScheme.primary,
      ),
      (
        label: '我的待开始',
        value: _summary.myPending,
        icon: Icons.schedule_outlined,
        color: Colors.orange,
      ),
      (
        label: '进行中',
        value: _summary.myInProgress,
        icon: Icons.pending_outlined,
        color: Colors.blue,
      ),
      (
        label: '我的任务',
        value: _summary.myTotal,
        icon: Icons.task_alt_outlined,
        color: Colors.green,
      ),
    ];

    return Wrap(
      spacing: SpacingTokens.sm,
      runSpacing: SpacingTokens.sm,
      children: cards.map((card) {
        return Container(
          width: 140,
          padding: LayoutTokens.cardPadding(context),
          decoration: BoxDecoration(
            color: colors?.surface ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            border: Border.all(
              color: colors?.borderColor ?? theme.dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(card.icon, size: 16, color: card.color),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      card.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            colors?.subtleText ??
                            theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                card.value.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterBar(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final statusItems = const [
      AppDropdownOption(value: null, label: '全部状态'),
      AppDropdownOption(value: 'pending', label: '待开始'),
      AppDropdownOption(value: 'in_progress', label: '进行中'),
      AppDropdownOption(value: 'completed', label: '已完成'),
    ];
    final taskTypeItems = const [
      AppDropdownOption(value: null, label: '全部类型'),
      AppDropdownOption(value: 'auto_calculate', label: '自动计算'),
      AppDropdownOption(value: 'production', label: '生产'),
      AppDropdownOption(value: 'purchasing', label: '采购'),
    ];
    final priorityItems = const [
      AppDropdownOption(value: null, label: '全部优先级'),
      AppDropdownOption(value: 'low', label: '低'),
      AppDropdownOption(value: 'normal', label: '普通'),
      AppDropdownOption(value: 'high', label: '高'),
      AppDropdownOption(value: 'urgent', label: '紧急'),
    ];

    final filterWidth = isMobile ? double.infinity : 160.0;

    return Container(
      padding: LayoutTokens.cardPadding(context),
      decoration: BoxDecoration(
        color: colors?.surface ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(
          color: colors?.borderColor ?? Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: SpacingTokens.sm,
            runSpacing: SpacingTokens.sm,
            children: [
              SizedBox(
                width: isMobile ? double.infinity : _searchWidth,
                height: _controlHeight,
                child: ListSearchField(
                  controller: _searchController,
                  hintText: '搜索施工单/客户/任务内容',
                  height: _controlHeight,
                  width: isMobile ? double.infinity : _searchWidth,
                  onChanged: (_) => _onSearchChanged(),
                  onSubmitted: (_) => _onSearchChanged(),
                  onClear: () {
                    _searchController.clear();
                    _onSearchChanged();
                  },
                ),
              ),
              SizedBox(
                width: filterWidth,
                height: _controlHeight,
                child: AppSelect<String?>(
                  value: _statusFilter,
                  options: statusItems,
                  onChanged: (value) {
                    setState(() => _statusFilter = value);
                    _onFilterChanged();
                  },
                  decoration: const InputDecoration(
                    hintText: '任务状态',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(
                width: filterWidth,
                height: _controlHeight,
                child: AppSelect<String?>(
                  value: _taskTypeFilter,
                  options: taskTypeItems,
                  onChanged: (value) {
                    setState(() => _taskTypeFilter = value);
                    _onFilterChanged();
                  },
                  decoration: const InputDecoration(
                    hintText: '任务类型',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(
                width: filterWidth,
                height: _controlHeight,
                child: AppSelect<String?>(
                  value: _priorityFilter,
                  options: priorityItems,
                  onChanged: (value) {
                    setState(() => _priorityFilter = value);
                    _onFilterChanged();
                  },
                  decoration: const InputDecoration(
                    hintText: '优先级',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          if (_hasActiveFilters) ...[
            SizedBox(height: SpacingTokens.sm),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _resetFilters,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 14),
                label: const Text('重置筛选'),
                style: OutlinedButton.styleFrom(
                  textStyle: theme.textTheme.labelSmall,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabAndList(BuildContext context, bool isMobile) {
    final tasks = _activeTab == 'mine' ? _myTasks : _claimableTasks;
    final hasMore = _activeTab == 'mine'
        ? _meta.myHasMore
        : _meta.claimableHasMore;
    final total = _activeTab == 'mine' ? _meta.myTotal : _meta.claimableTotal;
    final loadingMore = _activeTab == 'mine'
        ? _loadingMoreMy
        : _loadingMoreClaimable;
    final onLoadMore = _activeTab == 'mine'
        ? _loadMoreMyTasks
        : _loadMoreClaimableTasks;

    final filteredTasks = _filterTasksByStatus(tasks);

    if (filteredTasks.isEmpty && !_loading) {
      return EmptyStateCard(
        icon: Icons.assignment_turned_in_outlined,
        text: _activeTab == 'mine' ? '暂无我的任务' : '暂无可认领任务',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab bar
        Wrap(
          spacing: SpacingTokens.sm,
          children: [
            _TabChip(
              label: '我的任务',
              count: _myTasks.length,
              active: _activeTab == 'mine',
              onTap: () => setState(() => _activeTab = 'mine'),
            ),
            _TabChip(
              label: '可认领',
              count: _claimableTasks.length,
              active: _activeTab == 'claimable',
              onTap: () => setState(() => _activeTab = 'claimable'),
            ),
          ],
        ),
        SizedBox(height: SpacingTokens.md),
        // Task list
        if (!isMobile)
          _buildTaskTable(
            context,
            filteredTasks,
            hasMore: hasMore,
            total: total,
            loadingMore: loadingMore,
            onLoadMore: onLoadMore,
          )
        else
          _buildTaskListMobile(
            context,
            filteredTasks,
            hasMore: hasMore,
            total: total,
            loadingMore: loadingMore,
            onLoadMore: onLoadMore,
          ),
      ],
    );
  }

  List<Task> _filterTasksByStatus(List<Task> tasks) {
    // Status filter is already applied via API params, no client-side filter needed.
    // But we keep the tab-based separation (mine / claimable).
    return tasks;
  }

  Widget _buildTaskTable(
    BuildContext context,
    List<Task> tasks, {
    required bool hasMore,
    required int total,
    required bool loadingMore,
    required VoidCallback onLoadMore,
  }) {
    final theme = Theme.of(context);
    final isClaimable = _activeTab == 'claimable';
    return Column(
      children: [
        if (total > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '已显示 ${tasks.length} / 共 $total 条',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        Expanded(
          child: AppDataTable(
            columns: const [
              DataColumn(label: Text('任务')),
              DataColumn(label: Text('来源')),
              DataColumn(label: Text('工序')),
              DataColumn(label: Text('数量')),
              DataColumn(label: Text('进度')),
              DataColumn(label: Text('交期')),
              DataColumn(label: Text('状态')),
              DataColumn(label: Text('操作')),
            ],
            rows: tasks
                .map(
                  (task) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          _displayText(TaskUiHelper.title(task)),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      DataCell(
                        Text(
                          _displayText(TaskUiHelper.sourceSummary(task)),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          _displayText(task.processName),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          TaskUiHelper.quantitySummary(task),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          TaskUiHelper.progressText(task),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          TaskUiHelper.deadlineRiskText(task) == null
                              ? _formatDate(task.deliveryDate)
                              : '${_formatDate(task.deliveryDate)} · ${TaskUiHelper.deadlineRiskText(task)!}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          task.statusDisplay ?? task.status ?? '-',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Wrap(
                          spacing: SpacingTokens.sm,
                          runSpacing: SpacingTokens.xs,
                          children: [
                            if (!isClaimable) ...[
                              RowActionGroup(
                                actions: [
                                  RowAction(
                                    label: '更新进度',
                                    onPressed: () => _openUpdateDialog(
                                      context,
                                      task,
                                      completeMode: false,
                                    ),
                                  ),
                                  RowAction(
                                    label: '完成任务',
                                    onPressed: () => _openUpdateDialog(
                                      context,
                                      task,
                                      completeMode: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (isClaimable) _buildClaimButton(task),
                            RowActionGroup(
                              actions: [
                                RowAction(
                                  label: '查看施工单',
                                  onPressed: () =>
                                      _openTaskDetail(context, task),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: loadingMore
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : OutlinedButton(
                      onPressed: onLoadMore,
                      child: const Text('加载更多'),
                    ),
            ),
          ),
      ],
    );
  }

  Widget _buildTaskListMobile(
    BuildContext context,
    List<Task> tasks, {
    required bool hasMore,
    required int total,
    required bool loadingMore,
    required VoidCallback onLoadMore,
  }) {
    final isClaimable = _activeTab == 'claimable';
    final theme = Theme.of(context);
    return Column(
      children: [
        if (total > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '已显示 ${tasks.length} / 共 $total 条',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => SizedBox(height: SpacingTokens.sm),
            itemBuilder: (context, index) {
              final task = tasks[index];
              final rawTasks = _activeTab == 'mine'
                  ? _myTasksRaw
                  : _claimableTasksRaw;
              return _TaskCard(
                task: task,
                rawTaskData: index < rawTasks.length ? rawTasks[index] : {},
                isClaimable: isClaimable,
                claimingTaskId: _claimingTaskId,
                expandedLogTaskId: _expandedLogTaskId,
                onClaim: () => _claimTask(task),
                onTap: () => _openTaskDetail(context, task),
                onUpdate: () =>
                    _openUpdateDialog(context, task, completeMode: false),
                onComplete: () =>
                    _openUpdateDialog(context, task, completeMode: true),
                onToggleLogs: () {
                  setState(() {
                    _expandedLogTaskId = _expandedLogTaskId == task.id
                        ? null
                        : task.id;
                  });
                },
              );
            },
          ),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: loadingMore
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : OutlinedButton(
                      onPressed: onLoadMore,
                      child: const Text('加载更多'),
                    ),
            ),
          ),
      ],
    );
  }

  Widget _buildClaimButton(Task task) {
    final claiming = _claimingTaskId == task.id;
    if (claiming) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return RowActionGroup(
      actions: [
        RowAction(
          label: '认领',
          icon: Icons.assignment_turned_in_outlined,
          onPressed: () => _claimTask(task),
        ),
      ],
    );
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '-' : text;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
    final local = value.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }

  void _openTaskDetail(BuildContext context, Task task) {
    if (task.workOrderId != null) {
      context.go('/workorders/${task.workOrderId}');
      return;
    }
    ToastUtil.showError('该任务暂无施工单可查看');
  }

  Future<void> _openUpdateDialog(
    BuildContext context,
    Task task, {
    required bool completeMode,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _TaskUpdateDialog(
        task: task,
        completeMode: completeMode,
        onSuccess: _loadData,
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.extension<AppColors>();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusTokens.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? colorScheme.primaryContainer
              : colors?.surface ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          border: Border.all(
            color: active
                ? colorScheme.primary
                : colors?.borderColor ?? theme.dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: active
                    ? colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: active
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: active
                      ? colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.rawTaskData,
    required this.isClaimable,
    required this.claimingTaskId,
    required this.expandedLogTaskId,
    required this.onClaim,
    required this.onTap,
    required this.onUpdate,
    required this.onComplete,
    required this.onToggleLogs,
  });

  final Task task;
  final Map<String, dynamic> rawTaskData;
  final bool isClaimable;
  final int? claimingTaskId;
  final int? expandedLogTaskId;
  final VoidCallback onClaim;
  final VoidCallback onTap;
  final VoidCallback onUpdate;
  final VoidCallback onComplete;
  final VoidCallback onToggleLogs;

  List<Map<String, dynamic>> get _logs {
    final logs = rawTaskData['task_logs'];
    if (logs is List) {
      return logs.whereType<Map>().cast<Map<String, dynamic>>().toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;
    final isCompleted = task.status == 'completed';
    final deadlineRisk = TaskUiHelper.deadlineRiskText(task);
    final isOverdue = deadlineRisk == '已逾期';
    final isDueSoon = deadlineRisk != null && !isOverdue;
    final claiming = claimingTaskId == task.id;

    String formatDate(DateTime? date) {
      if (date == null) return '-';
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    return Container(
      padding: LayoutTokens.cardPadding(context),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(
          color: isOverdue
              ? colorScheme.error
              : isDueSoon
              ? Colors.orange
              : colors.borderColor,
          width: isOverdue || isDueSoon ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部：施工单号 + 客户名
          if (task.workOrderNumber != null || task.customerName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
              child: Row(
                children: [
                  if (task.workOrderNumber != null) ...[
                    InkWell(
                      onTap: onTap,
                      child: Text(
                        task.workOrderNumber!,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  if (task.workOrderNumber != null && task.customerName != null)
                    const Text(' · '),
                  if (task.customerName != null)
                    Text(
                      task.customerName!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.subtleText,
                      ),
                    ),
                  const Spacer(),
                  if (deadlineRisk != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.sm,
                        vertical: SpacingTokens.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? colorScheme.error.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                      ),
                      child: Text(
                        deadlineRisk,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isOverdue ? colorScheme.error : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else if (task.deliveryDate != null)
                    Text(
                      '交付 ${formatDate(task.deliveryDate)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.subtleText,
                      ),
                    ),
                ],
              ),
            ),
          // 任务内容
          TaskListTile(task: task, onTap: onTap, showDivider: false),
          SizedBox(height: SpacingTokens.sm),
          // 关联对象
          _TaskContextRow(task: task),
          SizedBox(height: SpacingTokens.sm),
          // 操作按钮
          if (isClaimable)
            claiming
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: onClaim,
                    icon: const Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 16,
                    ),
                    label: const Text('认领'),
                  )
          else
            Wrap(
              spacing: SpacingTokens.sm,
              runSpacing: SpacingTokens.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: isCompleted ? null : onUpdate,
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(isCompleted ? '已完成' : '更新进度'),
                ),
                OutlinedButton.icon(
                  onPressed: isCompleted ? null : onComplete,
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: Text(isCompleted ? '已完成' : '完成任务'),
                ),
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('查看施工单'),
                ),
              ],
            ),
          if (!isClaimable)
            TextButton(
              onPressed: onToggleLogs,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    expandedLogTaskId == task.id
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 16,
                  ),
                  Text(
                    '操作记录${_logs.isNotEmpty ? ' (${_logs.length})' : ''}',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          if (expandedLogTaskId == task.id) _TaskLogRow(logs: _logs),
        ],
      ),
    );
  }
}

class _TaskUpdateDialog extends StatefulWidget {
  const _TaskUpdateDialog({
    required this.task,
    required this.completeMode,
    required this.onSuccess,
  });

  final Task task;
  final bool completeMode;
  final VoidCallback onSuccess;

  @override
  State<_TaskUpdateDialog> createState() => _TaskUpdateDialogState();
}

class _TaskUpdateDialogState extends State<_TaskUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  late bool _completeMode;
  int _quantityIncrement = 1;
  int _quantityDefective = 0;
  String _completionReason = '';
  String _notes = '';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _completeMode = widget.completeMode;
    final remaining =
        ((widget.task.productionQuantity ?? 0) -
                (widget.task.quantityCompleted ?? 0))
            .clamp(0, double.infinity)
            .toInt();
    _quantityIncrement = remaining == 0
        ? 1
        : remaining.clamp(1, remaining).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    final progress = total > 0 ? (completed / total * 100).round() : 0;

    return AppActionFormDialog(
      title: _completeMode ? '完成任务' : '更新进度',
      formKey: _formKey,
      submitText: _completeMode ? '确认完成' : '确认更新',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      summary: _completeMode
          ? '确认将该任务标记为完成，并记录本次完成结果。'
          : '记录本次生产进度，系统会累加完成数量并保留不良品信息。',
      impacts: _completeMode
          ? const ['任务完成后会进入后续质检、入库或交接流程', '不良品数量和完成说明会影响后续质量追踪']
          : const ['完成数量会计入任务进度', '不良品数量会用于后续质量统计'],
      auditHint: _completeMode ? '完成理由和备注会进入任务流转记录。' : null,
      onSubmit: _submit,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.workContent ?? '任务 #${task.id}'),
          SizedBox(height: SpacingTokens.sm),
          LinearProgressIndicator(value: total > 0 ? completed / total : 0),
          SizedBox(height: SpacingTokens.sm),
          Text('$completed / $total · $progress%'),
          SizedBox(height: SpacingTokens.lg),
          PageModeToggle<bool>(
            value: _completeMode,
            options: const [
              PageModeOption(value: false, label: '增量更新'),
              PageModeOption(value: true, label: '直接完成'),
            ],
            onChanged: (value) => setState(() => _completeMode = value),
          ),
          SizedBox(height: SpacingTokens.md),
          if (!_completeMode) ...[
            CrudFieldConfig.number(
              label: '本次完成数量',
              initialValue: _quantityIncrement.toString(),
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
            ).build(context),
            SizedBox(height: SpacingTokens.md),
          ],
          CrudFieldConfig.number(
            label: '不良品数量',
            initialValue: _quantityDefective.toString(),
            onChanged: (value) {
              _quantityDefective = int.tryParse(value) ?? 0;
            },
          ).build(context),
          if (_completeMode) ...[
            SizedBox(height: SpacingTokens.md),
            CrudFieldConfig.text(
              label: '完成理由（可选）',
              onChanged: (value) => _completionReason = value,
            ).build(context),
          ],
          SizedBox(height: SpacingTokens.md),
          CrudFieldConfig.text(
            label: '备注（可选）',
            onChanged: (value) => _notes = value,
          ).build(context),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_completeMode && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _submitting = true);
    try {
      final repository = context.read<TaskRepository>();
      // 传递 version 实现乐观锁
      final payload = <String, dynamic>{
        'quantity_defective': _quantityDefective,
        'notes': _notes,
        if (_completeMode) 'completion_reason': _completionReason,
        if (!_completeMode) 'quantity_increment': _quantityIncrement,
        if (widget.task.version != null) 'version': widget.task.version,
      };
      if (_completeMode) {
        await repository.completeTask(widget.task.id, payload);
      } else {
        await repository.updateQuantity(widget.task.id, payload);
      }
      ToastUtil.showSuccess(_completeMode ? '任务已完成' : '进度已更新');
      widget.onSuccess();
      if (mounted) Navigator.of(context).pop();
    } catch (err) {
      ToastUtil.showError(err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
