import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_data_sections.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/detail_sections/work_order_detail_sections.dart';

/// 审批流程视图：ApprovalSection + ApprovalLogs + RejectionNotice
class WorkOrderDetailApprovalView extends StatelessWidget {
  const WorkOrderDetailApprovalView({
    super.key,
    required this.detail,
    required this.actionLoading,
    required this.onSubmitApproval,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onMarkUrgent,
    required this.buildSection,
    required this.emptyText,
    required this.formatDate,
    required this.rejectionReason,
    required this.rejectionComment,
    required this.onEditPressed,
  });

  final WorkOrderDetail detail;
  final bool actionLoading;
  final VoidCallback onSubmitApproval;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onResubmit;
  final Future<void> Function() onMarkUrgent;
  final Widget Function(String title, Widget child) buildSection;
  final String emptyText;
  final String Function(DateTime? value) formatDate;
  final String? rejectionReason;
  final String? rejectionComment;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(LayoutTokens.sectionSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 驳回通知（条件显示）
          if ((detail.approvalStatus ?? '') == 'rejected' &&
              ((rejectionReason ?? '').isNotEmpty ||
                  (rejectionComment ?? '').isNotEmpty)) ...[
            ApprovalRejectionNoticeCard(
              reason: rejectionReason ?? '请先查看审批说明',
              comment: rejectionComment,
              nextStep: '根据退回原因补充资料或修改内容后，直接点击"重新提交审核"。',
              primaryAction: FilledButton.icon(
                onPressed: onResubmit,
                icon: const Icon(Icons.send_outlined, size: 18),
                label: const Text('重新提交审核'),
              ),
              secondaryAction: OutlinedButton.icon(
                onPressed: onEditPressed,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('先去修改'),
              ),
            ),
            SizedBox(height: LayoutTokens.sectionSpacing(context)),
          ],

          // 审批流程
          buildSection(
            '审批流程',
            WorkOrderApprovalSection(
              detail: detail,
              actionLoading: actionLoading,
              onSubmitApproval: onSubmitApproval,
              onApprove: onApprove,
              onReject: onReject,
              onResubmit: onResubmit,
              onMarkUrgent: onMarkUrgent,
              emptyText: emptyText,
            ),
          ),
          SizedBox(height: LayoutTokens.sectionSpacing(context)),

          // 审批记录
          buildSection(
            '审批记录',
            WorkOrderApprovalLogsSection(
              logs: detail.approvalLogs,
              emptyText: emptyText,
              formatDate: formatDate,
            ),
          ),
        ],
      ),
    );
  }
}
