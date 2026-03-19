import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_supervisor_support_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_supervisor_sections.dart';

class TaskSupervisorDashboardEntry extends StatelessWidget {
  const TaskSupervisorDashboardEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<TaskApiService>(
      create: (context) => TaskApiService(context.read<ApiClient>()),
      child: const TaskSupervisorDashboardPage(),
    );
  }
}

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
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';

  bool _loading = false;
  String? _errorMessage;
  List<Department> _departments = [];
  int? _departmentId;
  Map<String, dynamic>? _workload;
  List<Task> _departmentTasks = [];
  List<TaskSupervisorOperatorOption> _operators = [];
  String _viewMode = 'dashboard';
  int? _assigningTaskId;
  String _taskStatusFilter = 'all';
  TaskSupervisorSupportService? _supportService;
  bool _departmentsRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= TaskSupervisorSupportService(context.read<ApiClient>());
    if (_departmentsRequested) return;
    _departmentsRequested = true;
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() => _loading = true);
    try {
      final departments = await _supportService!.fetchDepartments();
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
      final data = await _supportService!.loadDepartmentDashboard(
        _departmentId!,
      );
      if (!mounted) return;
      setState(() {
        _workload = data.workload;
        _departmentTasks = data.tasks;
        _operators = data.operators;
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
    final isMobile = BreakpointsUtil.isMobile(context);

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
        .map((dept) =>
            DropdownMenuItem<int?>(value: dept.id, child: Text(dept.name)))
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
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                    width: 320,
                    height: double.infinity,
                    child: SafeArea(
                      child: TaskSupervisorFilterDrawerContent(
                        title: '筛选',
                        child: _buildFilterPanel(dialogContext,
                            deptItems: deptItems),
                      ),
                    ),
                  ),
                ),
              );
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
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

        return ListToolbar(
          isMobile: isMobile,
          actions: [
            PageActionButton.outlined(
              onPressed: _loadWorkload,
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            ToggleButtons(
              isSelected: [
                _viewMode == 'dashboard',
                _viewMode == 'tasks',
                _viewMode == 'dragdrop',
              ],
              onPressed: (index) {
                setState(() {
                  if (index == 0) _viewMode = 'dashboard';
                  if (index == 1) _viewMode = 'tasks';
                  if (index == 2) _viewMode = 'dragdrop';
                });
              },
              constraints:
                  BoxConstraints(minHeight: _controlHeight, minWidth: 88),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('统计视图'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('任务列表'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('拖拽分派'),
                ),
              ],
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
    required List<DropdownMenuItem<int?>> deptItems,
  }) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        SearchableDropdownFormField<int?>(
          key: ValueKey<int?>(_departmentId),
          initialValue: _departmentId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: '部门'),
          items: deptItems,
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
    final isMobile = BreakpointsUtil.isMobile(context);
    final filteredTasks = _filterTasks(_departmentTasks);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTaskStatusFilters(_departmentTasks),
        const SizedBox(height: 12),
        Expanded(
          child: filteredTasks.isEmpty
              ? const EmptyStateCard(
                  icon: Icons.filter_alt_off_outlined,
                  text: '暂无符合条件的任务',
                )
              : isMobile
                  ? ListView.separated(
                      itemCount: filteredTasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
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
                DataCell(
                    Text(_displayText(task.processName), style: textStyle)),
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
                  task.statusDisplay ?? task.status ?? '-',
                  style: textStyle,
                )),
                DataCell(RowActionGroup(
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
                )),
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
    final percentage =
        (completed / total * 100).clamp(0, 100).toStringAsFixed(0);
    return '$percentage%';
  }

  Widget _buildDashboardView() {
    final summary = _workload?['summary'] as Map<String, dynamic>? ?? const {};
    final priority =
        _workload?['priority_distribution'] as Map<String, dynamic>? ??
            const {};
    final operators = _workload?['operators'] as List? ?? const [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailSectionCard(
            title: '部门汇总',
            child: SummaryFieldWrap(
              isMobile: BreakpointsUtil.isMobile(context),
              children: [
                SummaryField(
                    label: '总任务', value: '${_toInt(summary['total_tasks'])}'),
                SummaryField(
                    label: '待处理', value: '${_toInt(summary['pending_tasks'])}'),
                SummaryField(
                    label: '进行中',
                    value: '${_toInt(summary['in_progress_tasks'])}'),
                SummaryField(
                    label: '已完成',
                    value: '${_toInt(summary['completed_tasks'])}'),
                SummaryField(
                    label: '已取消',
                    value: '${_toInt(summary['cancelled_tasks'])}'),
                SummaryField(
                  label: '完成率',
                  value:
                      '${_toNum(summary['completion_rate']).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          DetailSectionCard(
            title: '优先级分布',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TaskSupervisorPriorityChip(
                    label: '紧急',
                    value: _toInt(priority['urgent']),
                    color: Colors.redAccent),
                TaskSupervisorPriorityChip(
                    label: '高',
                    value: _toInt(priority['high']),
                    color: Colors.orangeAccent),
                TaskSupervisorPriorityChip(
                    label: '普通',
                    value: _toInt(priority['normal']),
                    color: Colors.blueAccent),
                TaskSupervisorPriorityChip(
                    label: '低',
                    value: _toInt(priority['low']),
                    color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 12),
          DetailSectionCard(
            title: '操作员工作负载',
            child: operators.isEmpty
                ? const Text('暂无操作员数据')
                : Column(
                    children: operators
                        .whereType<Map>()
                        .map((item) => TaskSupervisorOperatorCard(
                            item: Map<String, dynamic>.from(item)))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragDropView() {
    if (_operators.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.groups_outlined,
        text: '暂无可用操作员',
      );
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
              const SizedBox(width: 16),
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
                const SizedBox(width: 16),
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
            await _supportService!.assignTask(
              task.id,
              operatorId: operatorId,
              notes: notes,
            );
            ToastUtil.showSuccess('任务已分派');
            await _loadWorkload();
          } catch (err) {
            ToastUtil.showError(
                '分派失败: ${err.toString().replaceFirst('Exception: ', '')}');
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
      await _supportService!.assignTask(
        task.id,
        operatorId: operator.id,
        notes: '',
      );
      ToastUtil.showSuccess('已分派给 ${operator.name}');
      await _loadWorkload();
    } catch (err) {
      ToastUtil.showError(
          '分派失败: ${err.toString().replaceFirst('Exception: ', '')}');
    } finally {
      if (mounted) setState(() => _assigningTaskId = null);
    }
  }

  Widget _buildTaskStatusFilters(List<Task> tasks) {
    final counts = _buildStatusCounts(tasks);
    final items = [
      TaskSupervisorStatusFilterItem(
          key: 'all', label: '全部', count: tasks.length),
      TaskSupervisorStatusFilterItem(
          key: 'pending', label: '待处理', count: counts['pending'] ?? 0),
      TaskSupervisorStatusFilterItem(
          key: 'in_progress', label: '进行中', count: counts['in_progress'] ?? 0),
      TaskSupervisorStatusFilterItem(
          key: 'completed', label: '已完成', count: counts['completed'] ?? 0),
      if ((counts['other'] ?? 0) > 0)
        TaskSupervisorStatusFilterItem(
            key: 'other', label: '其他', count: counts['other'] ?? 0),
    ];

    return TaskSupervisorStatusFilters(
      items: items,
      selectedKey: _taskStatusFilter,
      onSelected: (key) => setState(() => _taskStatusFilter = key),
    );
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (_taskStatusFilter == 'all') return tasks;
    if (_taskStatusFilter == 'other') {
      return tasks
          .where((task) =>
              task.status != 'pending' &&
              task.status != 'in_progress' &&
              task.status != 'completed')
          .toList();
    }
    return tasks.where((task) => task.status == _taskStatusFilter).toList();
  }

  Map<String, int> _buildStatusCounts(List<Task> tasks) {
    final counts = <String, int>{
      'pending': 0,
      'in_progress': 0,
      'completed': 0,
      'other': 0,
    };
    for (final task in tasks) {
      final status = task.status ?? '';
      if (counts.containsKey(status)) {
        counts[status] = (counts[status] ?? 0) + 1;
      } else {
        counts['other'] = (counts['other'] ?? 0) + 1;
      }
    }
    return counts;
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
