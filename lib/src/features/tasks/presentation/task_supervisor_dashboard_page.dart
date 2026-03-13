import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';

class TaskSupervisorDashboardEntry extends StatefulWidget {
  const TaskSupervisorDashboardEntry({super.key});

  @override
  State<TaskSupervisorDashboardEntry> createState() =>
      _TaskSupervisorDashboardEntryState();
}

class _TaskSupervisorDashboardEntryState
    extends State<TaskSupervisorDashboardEntry> {
  TaskApiService? _taskApi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_taskApi != null) return;
    final apiClient = context.read<ApiClient>();
    _taskApi = TaskApiService(apiClient);
  }

  @override
  Widget build(BuildContext context) {
    final api = _taskApi;
    if (api == null) return const SizedBox.shrink();
    return Provider<TaskApiService>.value(
      value: api,
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
  List<_OperatorOption> _operators = [];
  String _viewMode = 'dashboard';
  int? _assigningTaskId;
  String _taskStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() => _loading = true);
    try {
      final apiClient = context.read<ApiClient>();
      final deptApi = DepartmentApiService(apiClient);
      final page = await deptApi.fetchDepartments(page: 1, pageSize: 200);
      if (!mounted) return;
      setState(() {
        _departments = page.items.map((dto) => dto.toEntity()).toList();
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
      final api = context.read<TaskApiService>();
      final payload = await api.fetchDepartmentWorkload(params: {
        'department_id': _departmentId,
      });
      final tasksPage = await api.fetchTasks(
        departmentId: _departmentId,
        page: 1,
        pageSize: 50,
        ordering: '-created_at',
      );
      final operators = await api.fetchDepartmentOperators(_departmentId!);
      setState(() {
        _workload = payload;
        _departmentTasks =
            tasksPage.items.map((dto) => dto.toEntity()).toList();
        _operators = operators
            .map((item) => _OperatorOption.fromJson(item))
            .where((item) => item.id > 0)
            .toList();
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
                return _FilterDrawerContent(
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
                      child: _FilterDrawerContent(
                        title: '筛选',
                        child:
                            _buildFilterPanel(dialogContext, deptItems: deptItems),
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
                position: animation.drive(
                  CurveTween(curve: Curves.easeOutCubic),
                ).drive(offsetTween),
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
              constraints: BoxConstraints(minHeight: _controlHeight, minWidth: 88),
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        DropdownButtonFormField<int?>(
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
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('完成'),
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
                        return _SupervisorTaskCard(
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
                DataCell(Text(_displayText(task.workOrderNumber),
                    style: textStyle)),
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
                DataCell(Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (task.workOrderId != null) {
                          context.go('/workorders/${task.workOrderId}');
                        } else {
                          ToastUtil.showError('该任务暂无施工单详情');
                        }
                      },
                      child: const Text('查看施工单'),
                    ),
                    TextButton(
                      onPressed: () => _openAssignDialog(task),
                      child: const Text('分派操作员'),
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
                _PriorityChip(
                    label: '紧急',
                    value: _toInt(priority['urgent']),
                    color: Colors.redAccent),
                _PriorityChip(
                    label: '高',
                    value: _toInt(priority['high']),
                    color: Colors.orangeAccent),
                _PriorityChip(
                    label: '普通',
                    value: _toInt(priority['normal']),
                    color: Colors.blueAccent),
                _PriorityChip(
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
                        .map((item) => _OperatorCard(
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
              _DragColumn(
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
                _DragColumn(
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
      builder: (context) => _AssignDialog(
        task: task,
        operators: _operators,
        onSubmit: (operatorId, notes) async {
          try {
            final api = context.read<TaskApiService>();
            await api.assign(task.id, {
              'operator_id': operatorId,
              'notes': notes,
            });
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

  Future<void> _assignToOperator(Task task, _OperatorOption operator) async {
    if (task.assignedOperatorId == operator.id) return;
    setState(() => _assigningTaskId = task.id);
    try {
      final api = context.read<TaskApiService>();
      await api.assign(task.id, {
        'operator_id': operator.id,
        'notes': '',
      });
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
      _StatusFilterItem(key: 'all', label: '全部', count: tasks.length),
      _StatusFilterItem(
          key: 'pending', label: '待处理', count: counts['pending'] ?? 0),
      _StatusFilterItem(
          key: 'in_progress', label: '进行中', count: counts['in_progress'] ?? 0),
      _StatusFilterItem(
          key: 'completed', label: '已完成', count: counts['completed'] ?? 0),
      if ((counts['other'] ?? 0) > 0)
        _StatusFilterItem(
            key: 'other', label: '其他', count: counts['other'] ?? 0),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final selected = _taskStatusFilter == item.key;
        return ChoiceChip(
          label: Text('${item.label} ${item.count}'),
          selected: selected,
          onSelected: (_) => setState(() => _taskStatusFilter = item.key),
        );
      }).toList(),
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

class _OperatorOption {
  const _OperatorOption({required this.id, required this.name});

  final int id;
  final String name;

  factory _OperatorOption.fromJson(Map<String, dynamic> json) {
    final id = _toInt(json['id']);
    final first = json['first_name']?.toString() ?? '';
    final last = json['last_name']?.toString() ?? '';
    final username = json['username']?.toString() ?? '';
    final fullName = '$first$last'.trim();
    final name = fullName.isNotEmpty
        ? fullName
        : (username.isNotEmpty ? username : '操作员 $id');
    return _OperatorOption(id: id, name: name);
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class _StatusFilterItem {
  const _StatusFilterItem({
    required this.key,
    required this.label,
    required this.count,
  });

  final String key;
  final String label;
  final int count;
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label $value'),
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: color),
    );
  }
}

class _OperatorCard extends StatelessWidget {
  const _OperatorCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final name = item['operator_name']?.toString() ?? '-';
    final total = _toInt(item['total_count']);
    final pending = _toInt(item['pending_count']);
    final inProgress = _toInt(item['in_progress_count']);
    final completed = _toInt(item['completed_count']);
    final completionRate = _toNum(item['completion_rate']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.15),
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    Text('共 $total 个任务',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colors.subtleText)),
                  ],
                ),
              ),
              Text('${completionRate.toStringAsFixed(1)}%',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _StatusBadge(label: '待处理', value: pending),
              _StatusBadge(label: '进行中', value: inProgress),
              _StatusBadge(label: '已完成', value: completed),
            ],
          ),
        ],
      ),
    );
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label $value'));
  }
}

class _DragColumn extends StatelessWidget {
  const _DragColumn({
    required this.title,
    required this.subtitle,
    required this.height,
    required this.tasks,
    required this.operatorId,
    required this.onDrop,
    required this.assigningTaskId,
  });

  final String title;
  final String subtitle;
  final double height;
  final List<Task> tasks;
  final int? operatorId;
  final ValueChanged<Task>? onDrop;
  final int? assigningTaskId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final canAccept = onDrop != null;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.sidebarText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    '暂无任务',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.subtleText,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _DraggableTaskCard(
                      task: task,
                      isBusy: assigningTaskId == task.id,
                    );
                  },
                ),
        ),
      ],
    );

    if (canAccept) {
      return DragTarget<_TaskDragData>(
        onWillAcceptWithDetails: (details) =>
            operatorId != null &&
            details.data.task.assignedOperatorId != operatorId,
        onAcceptWithDetails: (details) => onDrop?.call(details.data.task),
        builder: (context, candidates, rejected) {
          final highlight = candidates.isNotEmpty;
          return _columnShell(context, colors, highlight, content);
        },
      );
    }
    return _columnShell(context, colors, false, content);
  }

  Widget _columnShell(
    BuildContext context,
    AppColors colors,
    bool highlight,
    Widget child,
  ) {
    return Container(
      width: 280,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
        border: Border.all(
          color: highlight
              ? Theme.of(context).colorScheme.primary
              : colors.borderColor,
          width: highlight ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }
}

class _TaskDragData {
  const _TaskDragData({
    required this.task,
  });

  final Task task;
}

class _DraggableTaskCard extends StatelessWidget {
  const _DraggableTaskCard({
    required this.task,
    required this.isBusy,
  });

  final Task task;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    final card = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: colors.borderColor),
      ),
      child: TaskListTile(
        task: task,
        onTap: null,
        showDivider: false,
      ),
    );

    return LongPressDraggable<_TaskDragData>(
      data: _TaskDragData(
        task: task,
      ),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 260, child: card),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: Stack(
        children: [
          card,
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
      ),
    );
  }
}

class _SupervisorTaskCard extends StatelessWidget {
  const _SupervisorTaskCard({
    required this.task,
    required this.onTap,
    required this.onAssign,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskListTile(
            task: task,
            onTap: onTap,
            showDivider: false,
            showAssignee: true,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onAssign,
                icon: const Icon(Icons.person_add_alt_1, size: 16),
                label: const Text('分派操作员'),
              ),
            ],
          ),
        ],
      ),
    );
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

class _AssignDialog extends StatefulWidget {
  const _AssignDialog({
    required this.task,
    required this.operators,
    required this.onSubmit,
  });

  final Task task;
  final List<_OperatorOption> operators;
  final Future<void> Function(int operatorId, String notes) onSubmit;

  @override
  State<_AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends State<_AssignDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _operatorId;
  String _notes = '';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _operatorId = widget.operators.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('分派任务'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                key: ValueKey<int>(_operatorId),
                initialValue: _operatorId,
                decoration: const InputDecoration(labelText: '操作员'),
                items: widget.operators
                    .map((op) =>
                        DropdownMenuItem(value: op.id, child: Text(op.name)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _operatorId = value ?? _operatorId),
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
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('确认分派'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(_operatorId, _notes);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // keep dialog open on failure
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
