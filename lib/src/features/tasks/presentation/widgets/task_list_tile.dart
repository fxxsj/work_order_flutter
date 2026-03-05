import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.task,
    this.onTap,
  });

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = <String>[];
    if (task.workOrderNumber != null) subtitle.add('施工单 ${task.workOrderNumber}');
    if (task.processName != null) subtitle.add(task.processName!);
    if (task.statusDisplay != null) subtitle.add(task.statusDisplay!);

    return ListTile(
      onTap: onTap,
      title: Text(task.workContent?.trim().isNotEmpty == true ? task.workContent! : '任务 #${task.id}'),
      subtitle: subtitle.isEmpty ? null : Text(subtitle.join(' · ')),
      trailing: _buildTrailing(context),
    );
  }

  Widget? _buildTrailing(BuildContext context) {
    if (task.productionQuantity == null && task.quantityCompleted == null) {
      return null;
    }
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    final text = '${completed.toStringAsFixed(0)}/${total.toStringAsFixed(0)}';
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }
}
