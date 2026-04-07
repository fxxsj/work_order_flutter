import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_ui_helper.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';

/// 操作员任务中心入口。
class TaskOperatorCenterEntry extends StatelessWidget {
  const TaskOperatorCenterEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<TaskApiService>(
      create: (context) => TaskApiService(context.read<ApiClient>()),
      child: const TaskOperatorCenterPage(),
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
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无任务数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';

  bool _loading = false;
  String? _errorMessage;
  List<Task> _myTasks = [];
  List<Task> _claimableTasks = [];
  int? _claimingTaskId;
  String? _quickFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final api = context.read<TaskApiService>();
      final payload = await api.fetchOperatorCenterData();
      final myTasksPayload = payload['my_tasks'];
      final claimablePayload = payload['claimable_tasks'];
      setState(() {
        _myTasks = _mapTasks(myTasksPayload);
        _claimableTasks = _mapTasks(claimablePayload);
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

  List<Task> _mapTasks(dynamic payload) {
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) => Task.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }

  Future<void> _claimTask(Task task) async {
    setState(() => _claimingTaskId = task.id);
    try {
      final api = context.read<TaskApiService>();
      await api.claimTask(task.id);
      ToastUtil.showSuccess('任务已认领');
      await _loadData();
    } catch (err) {
      ToastUtil.showError(
          '认领失败: ${err.toString().replaceFirst('Exception: ', '')}');
    } finally {
      if (mounted) {
        setState(() => _claimingTaskId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final overdueCount =
        [..._myTasks, ..._claimableTasks].where(TaskUiHelper.isOverdue).length;
    final dueSoonCount =
        [..._myTasks, ..._claimableTasks].where(TaskUiHelper.isDueSoon).length;
    final filteredMyTasks = _filterTasks(_myTasks);
    final filteredClaimableTasks = _filterTasks(_claimableTasks);
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
            if (_claimableTasks.isNotEmpty)
              StatusHintChip(
                label: '待认领',
                count: _claimableTasks.length,
                icon: Icons.assignment_turned_in_outlined,
                selected: _quickFilter == 'claimable',
                onTap: () => _toggleQuickFilter('claimable'),
              ),
            if (overdueCount > 0)
              StatusHintChip(
                label: '已逾期',
                count: overdueCount,
                icon: Icons.warning_amber_rounded,
                selected: _quickFilter == 'overdue',
                onTap: () => _toggleQuickFilter('overdue'),
              ),
            if (dueSoonCount > 0)
              StatusHintChip(
                label: '临近交付',
                count: dueSoonCount,
                icon: Icons.event_busy_outlined,
                selected: _quickFilter == 'due_soon',
                onTap: () => _toggleQuickFilter('due_soon'),
              ),
            if (_quickFilter != null)
              OutlinedButton.icon(
                onPressed: () => setState(() => _quickFilter = null),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: const Text('清除筛选'),
              ),
            PageActionButton.outlined(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
          ],
        ),
      ),
      body: _buildBody(
        context,
        isMobile,
        filteredMyTasks: filteredMyTasks,
        filteredClaimableTasks: filteredClaimableTasks,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool isMobile, {
    required List<Task> filteredMyTasks,
    required List<Task> filteredClaimableTasks,
  }) {
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

    final hasData =
        filteredMyTasks.isNotEmpty || filteredClaimableTasks.isNotEmpty;
    if (!hasData && !_loading) {
      return EmptyStateCard(
        icon: Icons.assignment_turned_in_outlined,
        text: _quickFilter == null ? _emptyText : '当前筛选下暂无任务',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = isMobile || constraints.maxWidth < 960;
        final children = [
          _buildMyTasksSection(isNarrow, filteredMyTasks),
          SizedBox(height: LayoutTokens.gapLg, width: LayoutTokens.gapLg),
          _buildClaimableSection(isNarrow, filteredClaimableTasks),
        ];
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    children[0],
                    SizedBox(height: LayoutTokens.gapLg),
                    children[2]
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: children[0]),
                    SizedBox(width: LayoutTokens.gapLg),
                    Expanded(child: children[2]),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildMyTasksSection(bool isNarrow, List<Task> tasks) {
    final tabs = [
      _TaskTab(label: '全部', filter: null),
      _TaskTab(label: '待开始', filter: 'pending'),
      _TaskTab(label: '进行中', filter: 'in_progress'),
      _TaskTab(label: '已完成', filter: 'completed'),
    ];

    return DetailSectionCard(
      title: '我的任务',
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: LayoutTokens.gapMd),
              tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
            ),
            SizedBox(height: LayoutTokens.gapMd),
            SizedBox(
              height: 420,
              child: TabBarView(
                children: tabs.map((tab) {
                  final list = tab.filter == null
                      ? tasks
                      : tasks
                          .where((task) => task.status == tab.filter)
                          .toList();
                  return _buildTaskList(
                    list,
                    isNarrow: isNarrow,
                    emptyText: '暂无${tab.label}任务',
                    showUpdateActions: true,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimableSection(bool isNarrow, List<Task> tasks) {
    return DetailSectionCard(
      title: '可认领任务',
      child: SizedBox(
        height: 420,
        child: _buildTaskList(
          tasks,
          isNarrow: isNarrow,
          emptyText: '暂无可认领任务',
          trailingBuilder: (task) {
            final claiming = _claimingTaskId == task.id;
            if (claiming) {
              return const SizedBox(
                width: 32,
                height: 32,
                child: Center(
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
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
          },
        ),
      ),
    );
  }

  Widget _buildTaskList(
    List<Task> tasks, {
    required bool isNarrow,
    required String emptyText,
    Widget Function(Task task)? trailingBuilder,
    bool showUpdateActions = false,
  }) {
    if (tasks.isEmpty) {
      final colors = Theme.of(context).extension<AppColors>();
      return Center(
        child: Text(
          emptyText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors?.subtleText ??
                    Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    if (!isNarrow) {
      return _buildTaskTable(
        tasks,
        trailingBuilder: trailingBuilder,
        showUpdateActions: showUpdateActions,
      );
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => SizedBox(height: LayoutTokens.gapSm),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _TaskCard(
          task: task,
          trailing: trailingBuilder?.call(task),
          onTap: () => _openTaskDetail(context, task),
          onUpdate: () => _openUpdateDialog(context, task, completeMode: false),
          onComplete: () =>
              _openUpdateDialog(context, task, completeMode: true),
        );
      },
    );
  }

  Widget _buildTaskTable(
    List<Task> tasks, {
    Widget Function(Task task)? trailingBuilder,
    bool showUpdateActions = false,
  }) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('任务')),
        DataColumn(label: Text('来源')),
        DataColumn(label: Text('工序')),
        DataColumn(label: Text('数量')),
        DataColumn(label: Text('进度')),
        DataColumn(label: Text('交期')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('待办')),
        DataColumn(label: Text('操作')),
      ],
      rows: tasks
          .map(
            (task) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(TaskUiHelper.title(task)),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(
                  _displayText(TaskUiHelper.sourceSummary(task)),
                  style: textStyle,
                )),
                DataCell(
                    Text(_displayText(task.processName), style: textStyle)),
                DataCell(
                    Text(TaskUiHelper.quantitySummary(task), style: textStyle)),
                DataCell(
                    Text(TaskUiHelper.progressText(task), style: textStyle)),
                DataCell(Text(
                  TaskUiHelper.deadlineRiskText(task) == null
                      ? _formatDate(task.deliveryDate)
                      : '${_formatDate(task.deliveryDate)} · ${TaskUiHelper.deadlineRiskText(task)!}',
                  style: textStyle,
                )),
                DataCell(Text(
                  task.statusDisplay ?? task.status ?? '-',
                  style: textStyle,
                )),
                DataCell(
                    Text(TaskUiHelper.followUpText(task), style: textStyle)),
                DataCell(Wrap(
                  spacing: LayoutTokens.gapSm,
                  runSpacing: LayoutTokens.gapXs,
                  children: [
                    RowActionGroup(
                      actions: [
                        RowAction(
                          label: '查看',
                          onPressed: () => _openTaskDetail(context, task),
                        ),
                        if (showUpdateActions)
                          RowAction(
                            label: '更新进度',
                            onPressed: () => _openUpdateDialog(
                              context,
                              task,
                              completeMode: false,
                            ),
                          ),
                        if (showUpdateActions)
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
                    if (trailingBuilder != null) trailingBuilder(task),
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

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  List<Task> _filterTasks(List<Task> source) {
    switch (_quickFilter) {
      case 'claimable':
        return identical(source, _claimableTasks) ? source : const [];
      case 'overdue':
        return source.where(TaskUiHelper.isOverdue).toList();
      case 'due_soon':
        return source.where(TaskUiHelper.isDueSoon).toList();
      default:
        return source;
    }
  }

  void _toggleQuickFilter(String key) {
    setState(() {
      _quickFilter = _quickFilter == key ? null : key;
    });
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

class _TaskTab {
  const _TaskTab({required this.label, required this.filter});

  final String label;
  final String? filter;
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onUpdate,
    required this.onComplete,
    this.trailing,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onUpdate;
  final VoidCallback onComplete;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isCompleted = task.status == 'completed';
    return Container(
      padding: LayoutTokens.cardPadding(context),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TaskListTile(
                  task: task,
                  onTap: onTap,
                  showDivider: false,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: LayoutTokens.gapSm),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
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
            ],
          ),
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
    final remaining = ((widget.task.productionQuantity ?? 0) -
            (widget.task.quantityCompleted ?? 0))
        .clamp(0, double.infinity)
        .toInt();
    _quantityIncrement =
        remaining == 0 ? 1 : remaining.clamp(1, remaining).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    final progress = total > 0 ? (completed / total * 100).round() : 0;

    return FormDialog(
      title: _completeMode ? '完成任务' : '更新进度',
      formKey: _formKey,
      submitText: _completeMode ? '确认完成' : '确认更新',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.workContent ?? '任务 #${task.id}'),
          SizedBox(height: LayoutTokens.gapSm),
          LinearProgressIndicator(value: total > 0 ? completed / total : 0),
          SizedBox(height: LayoutTokens.gapSm),
          Text('$completed / $total · $progress%'),
          SizedBox(height: LayoutTokens.gapLg),
          ToggleButtons(
            isSelected: [_completeMode == false, _completeMode == true],
            onPressed: (index) {
              setState(() => _completeMode = index == 1);
            },
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: LayoutTokens.gapMd),
                child: Text('增量更新'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: LayoutTokens.gapMd),
                child: Text('直接完成'),
              ),
            ],
          ),
          SizedBox(height: LayoutTokens.gapMd),
          if (!_completeMode) ...[
            CrudFormField.number(
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
            SizedBox(height: LayoutTokens.gapMd),
          ],
          CrudFormField.number(
            label: '不良品数量',
            initialValue: _quantityDefective.toString(),
            onChanged: (value) {
              _quantityDefective = int.tryParse(value) ?? 0;
            },
          ).build(context),
          if (_completeMode) ...[
            SizedBox(height: LayoutTokens.gapMd),
            CrudFormField.text(
              label: '完成理由（可选）',
              onChanged: (value) => _completionReason = value,
            ).build(context),
          ],
          SizedBox(height: LayoutTokens.gapMd),
          CrudFormField.text(
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
      final api = context.read<TaskApiService>();
      if (_completeMode) {
        await api.complete(widget.task.id, {
          'quantity_defective': _quantityDefective,
          'completion_reason': _completionReason,
          'notes': _notes,
        });
      } else {
        await api.updateQuantity(widget.task.id, {
          'quantity_increment': _quantityIncrement,
          'quantity_defective': _quantityDefective,
          'notes': _notes,
        });
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
