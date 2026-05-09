import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/meta_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/extensions/datetime_extensions.dart';
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
    final isXs = ResponsiveLayout.isXs(context);
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
          padding: EdgeInsets.fromLTRB(
            LayoutTokens.gapLg,
            isXs ? LayoutTokens.gapMd : LayoutTokens.gapSm + LayoutTokens.gapXs,
            LayoutTokens.gapLg,
            isXs ? LayoutTokens.gapMd : LayoutTokens.gapSm + LayoutTokens.gapXs,
          ),
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
                    SizedBox(
                      width: isXs ? LayoutTokens.gapSm : LayoutTokens.gapMd,
                    ),
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
              SizedBox(
                height: isXs
                    ? LayoutTokens.gapSm
                    : LayoutTokens.gapSm + LayoutTokens.gapXs,
              ),
              Wrap(
                spacing: isXs ? LayoutTokens.gapSm : LayoutTokens.gapSm,
                runSpacing: isXs ? LayoutTokens.gapSm : LayoutTokens.gapSm,
                children: [
                  if (task.customerName?.isNotEmpty == true)
                    MetaChip(label: '客户', value: task.customerName!),
                  if (task.workOrderNumber?.isNotEmpty == true)
                    MetaChip(label: '施工单', value: task.workOrderNumber!),
                  if (task.processName?.isNotEmpty == true)
                    MetaChip(label: '工序', value: task.processName!),
                  if (task.statusDisplay?.isNotEmpty == true)
                    MetaChip(label: '状态', value: task.statusDisplay!),
                  if (task.priorityDisplay?.isNotEmpty == true)
                    MetaChip(label: '优先级', value: task.priorityDisplay!),
                  if (deliveryDate != null)
                    MetaChip(label: '交付', value: deliveryDate.toYMD),
                  if (deadlineRisk != null)
                    MetaChip(label: '风险', value: deadlineRisk),
                  if (followUp.isNotEmpty && followUp != '-')
                    MetaChip(label: '下一步', value: followUp),
                  if (showAssignee &&
                      task.assignedOperatorName?.isNotEmpty == true)
                    MetaChip(label: '执行人', value: task.assignedOperatorName!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
