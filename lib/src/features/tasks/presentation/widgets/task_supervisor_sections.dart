import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/opacity_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/tasks/data/task_supervisor_support_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_list_tile.dart';

class TaskSupervisorFilterDrawerContent extends StatelessWidget {
  const TaskSupervisorFilterDrawerContent({
    super.key,
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
          padding: EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            LayoutTokens.gapMd,
            LayoutTokens.gapSm,
            LayoutTokens.gapSm,
          ),
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

class TaskSupervisorStatusFilterItem {
  const TaskSupervisorStatusFilterItem({
    required this.key,
    required this.label,
    required this.count,
  });

  final String key;
  final String label;
  final int count;
}

class TaskSupervisorPriorityChip extends StatelessWidget {
  const TaskSupervisorPriorityChip({
    super.key,
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
      backgroundColor: color.withValues(alpha: OpacityTokens.mild),
      labelStyle: TextStyle(color: color),
    );
  }
}

class TaskSupervisorStatusBadge extends StatelessWidget {
  const TaskSupervisorStatusBadge({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label $value'));
  }
}

class TaskSupervisorFocusCard extends StatelessWidget {
  const TaskSupervisorFocusCard({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
    required this.color,
    this.actionLabel,
    this.onPressed,
  });

  final String label;
  final int value;
  final String hint;
  final IconData icon;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Container(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
      padding: LayoutTokens.cardPadding(context),
      decoration: BoxDecoration(
        color: color.withValues(alpha: OpacityTokens.subtle),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: color.withValues(alpha: OpacityTokens.medium)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: OpacityTokens.mild),
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              SizedBox(width: LayoutTokens.gapMd),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$value',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: LayoutTokens.gapMd),
          Text(
            hint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.subtleText,
            ),
          ),
          if (onPressed != null && actionLabel != null) ...[
            SizedBox(height: LayoutTokens.gapMd),
            OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.arrow_forward_outlined, size: 16),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class TaskSupervisorOperatorCard extends StatelessWidget {
  const TaskSupervisorOperatorCard({
    super.key,
    required this.item,
  });

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
      margin: EdgeInsets.only(bottom: LayoutTokens.gapMd),
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
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: OpacityTokens.mild),
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
              SizedBox(width: LayoutTokens.gapMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '共 $total 个任务',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.subtleText,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${completionRate.toStringAsFixed(1)}%',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              TaskSupervisorStatusBadge(label: '待处理', value: pending),
              TaskSupervisorStatusBadge(label: '进行中', value: inProgress),
              TaskSupervisorStatusBadge(label: '已完成', value: completed),
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

class TaskSupervisorTaskCard extends StatelessWidget {
  const TaskSupervisorTaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onAssign,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
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
          TaskListTile(
            task: task,
            onTap: onTap,
            showDivider: false,
            showAssignee: true,
          ),
          SizedBox(height: LayoutTokens.gapSm),
          OutlinedButton.icon(
            onPressed: onAssign,
            icon: const Icon(Icons.person_add_alt_1, size: 16),
            label: const Text('分派操作员'),
          ),
        ],
      ),
    );
  }
}

class TaskSupervisorDragData {
  const TaskSupervisorDragData({
    required this.task,
  });

  final Task task;
}

class TaskSupervisorDraggableTaskCard extends StatelessWidget {
  const TaskSupervisorDraggableTaskCard({
    super.key,
    required this.task,
    required this.isBusy,
  });

  final Task task;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final card = Container(
      padding: LayoutTokens.cardPadding(context),
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

    return LongPressDraggable<TaskSupervisorDragData>(
      data: TaskSupervisorDragData(task: task),
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
                color: colors.surface.withValues(alpha: OpacityTokens.intense),
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

class TaskSupervisorDragColumn extends StatelessWidget {
  const TaskSupervisorDragColumn({
    super.key,
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

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.sidebarText,
          ),
        ),
        const SizedBox(height: LayoutTokens.gapXs),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
        ),
        SizedBox(height: LayoutTokens.gapMd),
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
                  separatorBuilder: (_, __) =>
                      SizedBox(height: LayoutTokens.gapSm),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskSupervisorDraggableTaskCard(
                      task: task,
                      isBusy: assigningTaskId == task.id,
                    );
                  },
                ),
        ),
      ],
    );

    if (!canAccept) {
      return _TaskSupervisorColumnShell(
        height: height,
        colors: colors,
        highlight: false,
        child: content,
      );
    }

    return DragTarget<TaskSupervisorDragData>(
      onWillAcceptWithDetails: (details) =>
          operatorId != null &&
          details.data.task.assignedOperatorId != operatorId,
      onAcceptWithDetails: (details) => onDrop?.call(details.data.task),
      builder: (context, candidates, rejected) {
        return _TaskSupervisorColumnShell(
          height: height,
          colors: colors,
          highlight: candidates.isNotEmpty,
          child: content,
        );
      },
    );
  }
}

class _TaskSupervisorColumnShell extends StatelessWidget {
  const _TaskSupervisorColumnShell({
    required this.height,
    required this.colors,
    required this.highlight,
    required this.child,
  });

  final double height;
  final AppColors colors;
  final bool highlight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: height,
      padding: LayoutTokens.cardPadding(context),
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

class TaskSupervisorStatusFilters extends StatelessWidget {
  const TaskSupervisorStatusFilters({
    super.key,
    required this.items,
    required this.selectedKey,
    required this.onSelected,
  });

  final List<TaskSupervisorStatusFilterItem> items;
  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => ChoiceChip(
              label: Text('${item.label} ${item.count}'),
              selected: selectedKey == item.key,
              onSelected: (_) => onSelected(item.key),
            ),
          )
          .toList(),
    );
  }
}

class TaskSupervisorAssignDialog extends StatefulWidget {
  const TaskSupervisorAssignDialog({
    super.key,
    required this.task,
    required this.operators,
    required this.onSubmit,
  });

  final Task task;
  final List<TaskSupervisorOperatorOption> operators;
  final Future<void> Function(int operatorId, String notes) onSubmit;

  @override
  State<TaskSupervisorAssignDialog> createState() =>
      _TaskSupervisorAssignDialogState();
}

class _TaskSupervisorAssignDialogState
    extends State<TaskSupervisorAssignDialog> {
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
    return AppFormDialog(
      title: '分派任务',
      formKey: _formKey,
      submitText: '确认分派',
      submitting: _submitting,
      maxWidth: LayoutTokens.dialogWidthSm,
      onSubmit: _submit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSelect<int>(
            key: ValueKey<int>(_operatorId),
            value: _operatorId,
            decoration: const InputDecoration(labelText: '操作员'),
            options: widget.operators
                .map(
                  (op) => AppDropdownOption(value: op.id, label: op.name),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _operatorId = value ?? _operatorId),
          ),
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
