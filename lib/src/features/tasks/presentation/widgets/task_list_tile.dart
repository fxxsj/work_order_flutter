import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_ui_helper.dart';

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
    final title = TaskUiHelper.title(task);
    final progressText = TaskUiHelper.quantitySummary(task);
    final deliveryDate = task.deliveryDate;
    final deadlineRisk = TaskUiHelper.deadlineRiskText(task);
    final followUp = TaskUiHelper.followUpText(task);

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
                  if (progressText != '-') ...[
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
                  if (task.customerName?.isNotEmpty == true)
                    _MetaChip(label: '客户', value: task.customerName!),
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
                  if (deadlineRisk != null)
                    _MetaChip(label: '风险', value: deadlineRisk),
                  if (followUp.isNotEmpty && followUp != '-')
                    _MetaChip(label: '下一步', value: followUp),
                  if (showAssignee &&
                      task.assignedOperatorName?.isNotEmpty == true)
                    _MetaChip(label: '执行人', value: task.assignedOperatorName!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
