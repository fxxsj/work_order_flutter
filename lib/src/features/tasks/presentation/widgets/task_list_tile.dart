import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.task,
    this.onTap,
    this.showDivider = true,
    this.showAssignee = false,
  });

  final Task task;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool showAssignee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isXs = BreakpointsUtil.isXs(context);
    final title = task.workContent?.trim().isNotEmpty == true
        ? task.workContent!
        : '任务 #${task.id}';
    final progressText = _buildProgressText();
    final deliveryDate = task.deliveryDate;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(16, isXs ? 12 : 14, 16, isXs ? 12 : 14),
          decoration: BoxDecoration(
            color: colors.surface,
            border: showDivider
                ? Border(
                    bottom: BorderSide(color: colors.borderColor),
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.sidebarText,
                      ),
                    ),
                  ),
                  if (progressText != null) ...[
                    SizedBox(width: isXs ? 8 : 12),
                    Flexible(
                      child: Text(
                        progressText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.subtleText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: isXs ? 8 : 10),
              Wrap(
                spacing: isXs ? 6 : 8,
                runSpacing: isXs ? 6 : 8,
                children: [
                  if (task.workOrderNumber?.isNotEmpty == true)
                    _MetaChip(label: '施工单', value: task.workOrderNumber!),
                  if (task.processName?.isNotEmpty == true)
                    _MetaChip(label: '工序', value: task.processName!),
                  if (task.statusDisplay?.isNotEmpty == true)
                    _MetaChip(label: '状态', value: task.statusDisplay!),
                  if (task.priorityDisplay?.isNotEmpty == true)
                    _MetaChip(label: '优先级', value: task.priorityDisplay!),
                  if (deliveryDate != null)
                    _MetaChip(label: '交付', value: _formatDate(deliveryDate)),
                  if (showAssignee && task.assignedOperatorName?.isNotEmpty == true)
                    _MetaChip(label: '执行人', value: task.assignedOperatorName!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _buildProgressText() {
    if (task.productionQuantity == null && task.quantityCompleted == null) {
      return null;
    }
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    if (total <= 0) return null;
    return '${completed.toStringAsFixed(0)}/${total.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors.subtleText,
    );
    final valueStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors.sidebarText,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: BreakpointsUtil.isXs(context) ? 8 : 10,
        vertical: BreakpointsUtil.isXs(context) ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
        border: Border.all(color: colors.borderColor),
      ),
      child: RichText(
        text: TextSpan(
          style: labelStyle,
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: valueStyle,
            ),
          ],
        ),
      ),
    );
  }
}
