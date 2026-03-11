import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
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
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isXs = BreakpointsUtil.isXs(context);
    final title = task.workContent?.trim().isNotEmpty == true
        ? task.workContent!
        : '任务 #${task.id}';
    final progressText = _buildProgressText();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(16, isXs ? 12 : 14, 16, isXs ? 12 : 14),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(
              bottom: BorderSide(color: colors.borderColor),
            ),
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
    return '${completed.toStringAsFixed(0)}/${total.toStringAsFixed(0)}';
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

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: BreakpointsUtil.isXs(context) ? 8 : 10,
        vertical: BreakpointsUtil.isXs(context) ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.borderColor),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.subtleText,
          ),
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.sidebarText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
