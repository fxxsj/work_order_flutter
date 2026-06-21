import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_mode_toggle.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/domain/task_supervisor_dashboard_data.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_ui_helper.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_supervisor_sections.dart';

class TaskSupervisorDashboardPage extends StatelessWidget {
  const TaskSupervisorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => const _TaskSupervisorDashboardView();
}

class _TaskSupervisorDashboardView extends StatefulWidget {
  const _TaskSupervisorDashboardView();

  @override
  State<_TaskSupervisorDashboardView> createState() =>
      _TaskSupervisorDashboardViewState();
}

class _TaskSupervisorDashboardViewState
    extends State<_TaskSupervisorDashboardView> {
  static const double _spacingSm = SpacingTokens.sm;
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';

  bool _loading = false;
  String? _errorMessage;
  List<TaskDepartmentOption> _departments = [];
  int? _departmentId;
  Map<String, dynamic>? _workload;
  List<Task> _departmentTasks = [];
  List<TaskSupervisorOperatorOption> _operators = [];
  TaskSupervisorFlowSummary _flowSummary = const TaskSupervisorFlowSummary();
  String _viewMode = 'dashboard';
  int? _assigningTaskId;
  String _taskStatusFilter = 'all';
  bool _departmentsRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_departmentsRequested) return;
    _departmentsRequested = true;
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() => _loading = true);
    try {
      final repository = context.read<TaskRepository>();
      final departments = await repository.loadDepartments();
      if (!mounted) return;
      setState(() {
        _departments = departments;
        if (_departments.isNotEmpty) {
          _departmentId = _departments.first.id;
        }
      });
      await _loadWorkload();
    } catch (err) {
      setState(() {
        _errorMessage = err.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadWorkload() async {
    if (_departmentId == null) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final repository = context.read<TaskRepository>();
      final data = await repository.loadDepartmentDashboard(_departmentId!);
      if (!mounted) return;
      setState(() {
        _workload = data.workload;
        _departmentTasks = data.tasks;
        _operators = data.operators;
        _flowSummary = data.flowSummary;
      });
    } catch (err) {
      setState(() {
        _errorMessage = err.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
        actions: _buildActions(isMobile),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildActions(bool isMobile) {
    final deptItems = _departments
        .map(
          (dept) => AppDropdownOption<int?>(value: dept.id, label: dept.name),
        )
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        void openFilterDrawer() {
          if (isMobile) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              builder: (sheetContext) {
                return TaskSupervisorFilterDrawerContent(
                  title: '筛选',
                  child: _buildFilterPanel(sheetContext, deptItems: deptItems),
                );
              },
            );
            return;
          }

          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: '筛选',
            barrierColor: Theme.of(
              context,
            ).shadowColor.withValues(alpha: LayoutTokens.barrierOpacity),
            transitionDuration: AnimationTokens.slide,
            pageBuilder: (dialogContext, animation, secondaryAnimation) {
              return Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Theme.of(dialogContext).colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: SizedBox(
                    width: LayoutTokens.searchWidth,
                    height: double.infinity,
                    child: SafeArea(
                      child: TaskSupervisorFilterDrawerContent(
                        title: '筛选',
                        child: _buildFilterPanel(
                          dialogContext,
                          deptItems: deptItems,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              final offsetTween = Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              );
              return SlideTransition(
                position: animation
                    .drive(CurveTween(curve: Curves.easeOutCubic))
                    .drive(offsetTween),
                child: child,
              );
            },
          );
        }

        return ListToolbar(
          isMobile: isMobile,
          actions: [
            PageActionButton.outlined(
              onPressed: _loadWorkload,
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageModeToggle<String>(
              value: _viewMode,
              options: const [
                PageModeOption(value: 'dashboard', label: '统计视图'),
                PageModeOption(value: 'tasks', label: '任务列表'),
                PageModeOption(value: 'dragdrop', label: '拖拽分派'),
              ],
              onChanged: (value) => setState(() => _viewMode = value),
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: '筛选',
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterPanel(
    BuildContext context, {
    required List<AppDropdownOption<int?>> deptItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: LayoutTokens.pagePadding(context),
      children: [
        AppSelect<int?>(
          key: ValueKey<int?>(_departmentId),
          value: _departmentId,
          decoration: const InputDecoration(labelText: '部门'),
          options: deptItems,
          onChanged: (value) {
            setState(() => _departmentId = value);
            _loadWorkload();
          },
        ),
        SizedBox(height: spacing),
        PageActionButton.filled(
          onPressed: () => Navigator.of(context).maybePop(),
          label: '完成',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading && _workload == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null && !_loading) {
      return ErrorStateCard(
        message: _errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: _loadWorkload,
      );
    }
    if (_workload == null && !_loading) {
      return const EmptyStateCard(
        icon: Icons.dashboard_customize_outlined,
        text: _emptyText,
      );
    }

    if (_viewMode == 'tasks') {
      return _buildTaskListView();
    }
    if (_viewMode == 'dragdrop') {
      return _buildDragDropView();
    }
    return _buildDashboardView();
  }

  Widget _buildTaskListView() {
    if (_departmentTasks.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.view_list_outlined,
        text: '暂无部门任务',
      );
    }
    final isMobile = ResponsiveLayout.isMobile(context);
    final filteredTasks = _filterTasks(_departmentTasks);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTaskStatusFilters(_departmentTasks),
        SizedBox(height: SpacingTokens.md),
        Expanded(
          child: filteredTasks.isEmpty
              ? const EmptyStateCard(
                  icon: Icons.filter_alt_off_outlined,
                  text: '暂无符合条件的任务',
                )
              : isMobile
              ? ListView.separated(
                  itemCount: filteredTasks.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: SpacingTokens.sm),
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TaskSupervisorTaskCard(
                      task: task,
                      onTap: () {
                        if (task.workOrderId != null) {
                          context.go('/workorders/${task.workOrderId}');
                        } else {
                          ToastUtil.showError('该任务暂无施工单详情');
                        }
                      },
                      onAssign: () => _openAssignDialog(task),
                    );
                  },
                )
              : _buildTaskTable(filteredTasks),
        ),
      ],
    );
  }

  Widget _buildTaskTable(List<Task> tasks) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('任务')),
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('工序')),
        DataColumn(label: Text('部门')),
        DataColumn(label: Text('操作员')),
        DataColumn(label: Text('生产数量')),
        DataColumn(label: Text('完成数量')),
        DataColumn(label: Text('进度')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('操作')),
      ],
      rows: tasks
          .map(
            (task) => DataRow(
              cells: [
                DataCell(
                  Text(
                    _displayText(
                      task.workContent?.trim().isNotEmpty == true
                          ? task.workContent
                          : (task.processName ?? '任务 #${task.id}'),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(_displayText(task.workOrderNumber), style: textStyle),
                ),
                DataCell(
                  Text(_displayText(task.processName), style: textStyle),
                ),
                DataCell(
                  Text(
                    _displayText(task.assignedDepartmentName),
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    _displayText(task.assignedOperatorName),
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    _formatNumber(task.productionQuantity),
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(_formatNumber(task.quantityCompleted), style: textStyle),
                ),
                DataCell(Text(_formatProgress(task), style: textStyle)),
                DataCell(
                  Text(
                    task.statusDisplay ?? task.status ?? '-',
                    style: textStyle,
                  ),
                ),
                DataCell(
                  RowActionGroup(
                    actions: [
                      RowAction(
                        label: '查看施工单',
                        onPressed: () {
                          if (task.workOrderId != null) {
                            context.go('/workorders/${task.workOrderId}');
                          } else {
                            ToastUtil.showError('该任务暂无施工单详情');
                          }
                        },
                      ),
                      RowAction(
                        label: '分派操作员',
                        onPressed: () => _openAssignDialog(task),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '-' : text;
  }

  String _formatNumber(double? value) {
    if (value == null) return '-';
    return value.toStringAsFixed(0);
  }

  String _formatProgress(Task task) {
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    if (total <= 0) return '-';
    final percentage = (completed / total * 100)
        .clamp(0, 100)
        .toStringAsFixed(0);
    return '$percentage%';
  }

  Widget _buildDashboardView() {
    final theme = Theme.of(context);
    final summary = _workload?['summary'] as Map<String, dynamic>? ?? const {};
    final priority =
        _workload?['priority_distribution'] as Map<String, dynamic>? ??
        const {};
    final operators = _workload?['operators'] as List? ?? const [];
    final overdueCount = _toInt(summary['overdue_tasks']);
    final dueSoonCount = _toInt(summary['due_soon_tasks']);
    final unassignedCount = _toInt(summary['unassigned_tasks']);
    final handoffCount = _toInt(summary['handoff_tasks']);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailSectionCard(
            title: '部门汇总',
            child: SummaryFieldWrap(
              isMobile: ResponsiveLayout.isMobile(context),
              children: [
                SummaryField(
                  label: '总任务',
                  value: '${_toInt(summary['total_tasks'])}',
                ),
                SummaryField(
                  label: '待处理',
                  value: '${_toInt(summary['pending_tasks'])}',
                ),
                SummaryField(
                  label: '进行中',
                  value: '${_toInt(summary['in_progress_tasks'])}',
                ),
                SummaryField(
                  label: '已完成',
                  value: '${_toInt(summary['completed_tasks'])}',
                ),
                SummaryField(
                  label: '已取消',
                  value: '${_toInt(summary['cancelled_tasks'])}',
                ),
                SummaryField(
                  label: '完成率',
                  value:
                      '${_toNum(summary['completion_rate']).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingTokens.md),
          DetailSectionCard(
            title: '主管待办',
            child: Wrap(
              spacing: SpacingTokens.md,
              runSpacing: SpacingTokens.md,
              children: [
                TaskSupervisorFocusCard(
                  label: '逾期任务',
                  value: overdueCount,
                  hint: overdueCount > 0 ? '优先排查超期工序与堵点' : '当前部门暂无逾期任务',
                  icon: Icons.warning_amber_rounded,
                  color:
                      theme.extension<AppSemanticColors>()?.danger ??
                      theme.colorScheme.error,
                  actionLabel: '查看任务',
                  onPressed: () => _openTaskFocus('overdue'),
                ),
                TaskSupervisorFocusCard(
                  label: '临近交期',
                  value: dueSoonCount,
                  hint: dueSoonCount > 0 ? '2 天内到期，建议主管提前协调' : '当前没有临近交期任务',
                  icon: Icons.schedule_outlined,
                  color:
                      theme.extension<AppSemanticColors>()?.warning ??
                      theme.colorScheme.secondary,
                  actionLabel: '查看任务',
                  onPressed: () => _openTaskFocus('due_soon'),
                ),
                TaskSupervisorFocusCard(
                  label: '待分派',
                  value: unassignedCount,
                  hint: unassignedCount > 0 ? '仍未落到操作员的生产任务' : '当前部门没有待分派任务',
                  icon: Icons.person_add_alt_1_outlined,
                  color: theme.colorScheme.primary,
                  actionLabel: '进入分派',
                  onPressed: () => _openTaskFocus('unassigned'),
                ),
                TaskSupervisorFocusCard(
                  label: '待交接下游',
                  value: handoffCount,
                  hint: handoffCount > 0 ? '已完工，建议尽快推进质检或入库' : '暂无待交接下游任务',
                  icon: Icons.compare_arrows_outlined,
                  color:
                      theme.extension<AppSemanticColors>()?.success ??
                      const Color(0xFF27a644),
                  actionLabel: '看已完工',
                  onPressed: () => _openTaskFocus('completed'),
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingTokens.md),
          DetailSectionCard(
            title: '跨环节提醒',
            child: Wrap(
              spacing: SpacingTokens.md,
              runSpacing: SpacingTokens.md,
              children: [
                TaskSupervisorFocusCard(
                  label: '待完成检验',
                  value: _flowSummary.pendingInspections,
                  hint: _flowSummary.pendingInspections > 0
                      ? '质检未收口时，下游仓库与交付会继续等待'
                      : '当前没有待完成检验单',
                  icon: Icons.fact_check_outlined,
                  color: theme.colorScheme.primary,
                  actionLabel: '查看质检',
                  onPressed: () => context.go(
                    '/inventory/quality?result=pending&department_id=${_departmentId ?? 0}',
                  ),
                ),
                TaskSupervisorFocusCard(
                  label: '待跟进质检异常',
                  value: _flowSummary.exceptionInspections,
                  hint: _flowSummary.exceptionInspections > 0
                      ? '包含不合格与条件接收，需尽快决定返工或放行'
                      : '当前没有质检异常待跟进',
                  icon: Icons.report_problem_outlined,
                  color:
                      theme.extension<AppSemanticColors>()?.warning ??
                      theme.colorScheme.secondary,
                  actionLabel: '查看质检',
                  onPressed: () => context.go(
                    '/inventory/quality?department_id=${_departmentId ?? 0}',
                  ),
                ),
                TaskSupervisorFocusCard(
                  label: '待签收交付',
                  value: _flowSummary.pendingReceipts,
                  hint: _flowSummary.pendingReceipts > 0
                      ? '已发货但尚未签收，建议同步交付风险'
                      : '当前没有待签收交付',
                  icon: Icons.local_shipping_outlined,
                  color: theme.colorScheme.primary,
                  actionLabel: '查看发货',
                  onPressed: () => context.go(
                    '/inventory/delivery?department_id=${_departmentId ?? 0}',
                  ),
                ),
                TaskSupervisorFocusCard(
                  label: '拒收待处理',
                  value: _flowSummary.rejectedDeliveries,
                  hint: _flowSummary.rejectedDeliveries > 0
                      ? '已发生拒收，建议尽快确认补发或终止交付'
                      : '当前没有拒收单待处理',
                  icon: Icons.assignment_late_outlined,
                  color:
                      theme.extension<AppSemanticColors>()?.danger ??
                      theme.colorScheme.error,
                  actionLabel: '查看拒收',
                  onPressed: () => context.go(
                    '/inventory/delivery?status=rejected&department_id=${_departmentId ?? 0}',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingTokens.md),
          DetailSectionCard(
            title: '优先级分布',
            child: Wrap(
              spacing: SpacingTokens.sm,
              runSpacing: SpacingTokens.sm,
              children: [
                TaskSupervisorPriorityChip(
                  label: '紧急',
                  value: _toInt(priority['urgent']),
                  color:
                      theme.extension<AppSemanticColors>()?.danger ??
                      theme.colorScheme.error,
                ),
                TaskSupervisorPriorityChip(
                  label: '高',
                  value: _toInt(priority['high']),
                  color:
                      theme.extension<AppSemanticColors>()?.warning ??
                      theme.colorScheme.secondary,
                ),
                TaskSupervisorPriorityChip(
                  label: '普通',
                  value: _toInt(priority['normal']),
                  color: theme.colorScheme.primary,
                ),
                TaskSupervisorPriorityChip(
                  label: '低',
                  value: _toInt(priority['low']),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingTokens.md),
          DetailSectionCard(
            title: '操作员工作负载',
            child: operators.isEmpty
                ? const Text('暂无操作员数据')
                : Column(
                    children: operators
                        .whereType<Map>()
                        .map(
                          (item) => TaskSupervisorOperatorCard(
                            item: Map<String, dynamic>.from(item),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragDropView() {
    if (_operators.isEmpty) {
      return const EmptyStateCard(icon: Icons.groups_outlined, text: '暂无可用操作员');
    }
    if (_departmentTasks.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.view_kanban_outlined,
        text: '暂无任务数据',
      );
    }

    final unassigned = _departmentTasks
        .where((task) => task.assignedOperatorId == null)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskSupervisorDragColumn(
                title: '待分派',
                subtitle: '未分配操作员',
                height: height,
                tasks: unassigned,
                operatorId: null,
                onDrop: null,
                assigningTaskId: _assigningTaskId,
              ),
              SizedBox(width: SpacingTokens.lg),
              for (final operator in _operators) ...[
                TaskSupervisorDragColumn(
                  title: operator.name,
                  subtitle: '操作员任务',
                  height: height,
                  tasks: _departmentTasks
                      .where((task) => task.assignedOperatorId == operator.id)
                      .toList(),
                  operatorId: operator.id,
                  onDrop: (task) => _assignToOperator(task, operator),
                  assigningTaskId: _assigningTaskId,
                ),
                SizedBox(width: SpacingTokens.lg),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAssignDialog(Task task) async {
    if (_operators.isEmpty) {
      ToastUtil.showError('当前部门暂无可分派操作员');
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) => TaskSupervisorAssignDialog(
        task: task,
        operators: _operators,
        onSubmit: (operatorId, notes) async {
          try {
            final repository = context.read<TaskRepository>();
            await repository.assignTask(
              task.id,
              operatorId: operatorId,
              notes: notes,
            );
            ToastUtil.showSuccess('任务已分派');
            await _loadWorkload();
          } catch (err) {
            ToastUtil.showError(
              '分派失败: ${err.toString().replaceFirst('Exception: ', '')}',
            );
            rethrow;
          }
        },
      ),
    );
  }

  Future<void> _assignToOperator(
    Task task,
    TaskSupervisorOperatorOption operator,
  ) async {
    if (task.assignedOperatorId == operator.id) return;
    setState(() => _assigningTaskId = task.id);
    try {
      final repository = context.read<TaskRepository>();
      await repository.assignTask(
        task.id,
        operatorId: operator.id,
        notes: '',
      );
      ToastUtil.showSuccess('已分派给 ${operator.name}');
      await _loadWorkload();
    } catch (err) {
      ToastUtil.showError(
        '分派失败: ${err.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      if (mounted) setState(() => _assigningTaskId = null);
    }
  }

  Widget _buildTaskStatusFilters(List<Task> tasks) {
    final counts = _buildStatusCounts(tasks);
    final items = [
      TaskSupervisorStatusFilterItem(
        key: 'all',
        label: '全部',
        count: tasks.length,
      ),
      if ((counts['overdue'] ?? 0) > 0)
        TaskSupervisorStatusFilterItem(
          key: 'overdue',
          label: '已逾期',
          count: counts['overdue'] ?? 0,
        ),
      if ((counts['due_soon'] ?? 0) > 0)
        TaskSupervisorStatusFilterItem(
          key: 'due_soon',
          label: '临近交期',
          count: counts['due_soon'] ?? 0,
        ),
      if ((counts['unassigned'] ?? 0) > 0)
        TaskSupervisorStatusFilterItem(
          key: 'unassigned',
          label: '待分派',
          count: counts['unassigned'] ?? 0,
        ),
      TaskSupervisorStatusFilterItem(
        key: 'pending',
        label: '待处理',
        count: counts['pending'] ?? 0,
      ),
      TaskSupervisorStatusFilterItem(
        key: 'in_progress',
        label: '进行中',
        count: counts['in_progress'] ?? 0,
      ),
      TaskSupervisorStatusFilterItem(
        key: 'completed',
        label: '已完成',
        count: counts['completed'] ?? 0,
      ),
      if ((counts['other'] ?? 0) > 0)
        TaskSupervisorStatusFilterItem(
          key: 'other',
          label: '其他',
          count: counts['other'] ?? 0,
        ),
    ];

    return TaskSupervisorStatusFilters(
      items: items,
      selectedKey: _taskStatusFilter,
      onSelected: (key) => setState(() => _taskStatusFilter = key),
    );
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (_taskStatusFilter == 'all') return tasks;
    if (_taskStatusFilter == 'overdue') {
      return tasks.where(TaskUiHelper.isOverdue).toList();
    }
    if (_taskStatusFilter == 'due_soon') {
      return tasks.where(TaskUiHelper.isDueSoon).toList();
    }
    if (_taskStatusFilter == 'unassigned') {
      return tasks.where(TaskUiHelper.needsAssignment).toList();
    }
    if (_taskStatusFilter == 'other') {
      return tasks
          .where(
            (task) =>
                task.status != 'pending' &&
                task.status != 'in_progress' &&
                task.status != 'completed',
          )
          .toList();
    }
    return tasks.where((task) => task.status == _taskStatusFilter).toList();
  }

  Map<String, int> _buildStatusCounts(List<Task> tasks) {
    final counts = <String, int>{
      'overdue': 0,
      'due_soon': 0,
      'unassigned': 0,
      'pending': 0,
      'in_progress': 0,
      'completed': 0,
      'other': 0,
    };
    for (final task in tasks) {
      if (TaskUiHelper.isOverdue(task)) {
        counts['overdue'] = (counts['overdue'] ?? 0) + 1;
      } else if (TaskUiHelper.isDueSoon(task)) {
        counts['due_soon'] = (counts['due_soon'] ?? 0) + 1;
      }
      if (TaskUiHelper.needsAssignment(task)) {
        counts['unassigned'] = (counts['unassigned'] ?? 0) + 1;
      }
      final status = task.status ?? '';
      if (counts.containsKey(status)) {
        counts[status] = (counts[status] ?? 0) + 1;
      } else {
        counts['other'] = (counts['other'] ?? 0) + 1;
      }
    }
    return counts;
  }

  void _openTaskFocus(String filterKey) {
    setState(() {
      _viewMode = 'tasks';
      _taskStatusFilter = filterKey;
    });
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toNum(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
