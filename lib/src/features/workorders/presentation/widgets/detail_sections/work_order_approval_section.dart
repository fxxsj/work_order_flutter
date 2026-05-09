import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

/// Approval section for work order details.
class WorkOrderApprovalSection extends StatelessWidget {
  const WorkOrderApprovalSection({
    super.key,
    required this.detail,
    required this.actionLoading,
    required this.onSubmitApproval,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onMarkUrgent,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final bool actionLoading;
  final VoidCallback onSubmitApproval;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onResubmit;
  final VoidCallback onMarkUrgent;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return SingleApprovalContent(
      detail: detail,
      actionLoading: actionLoading,
      onApprove: onApprove,
      onReject: onReject,
      onSubmitApproval: onSubmitApproval,
      onResubmit: onResubmit,
      onMarkUrgent: onMarkUrgent,
      emptyText: emptyText,
    );
  }
}

/// Single approval content widget.
class SingleApprovalContent extends StatelessWidget {
  const SingleApprovalContent({
    required this.detail,
    required this.actionLoading,
    required this.onApprove,
    required this.onReject,
    required this.onSubmitApproval,
    required this.onResubmit,
    required this.onMarkUrgent,
    required this.emptyText,
  });

  final WorkOrderDetail detail;
  final bool actionLoading;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback onSubmitApproval;
  final VoidCallback? onResubmit;
  final VoidCallback onMarkUrgent;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText =
        detail.approvalStatusDisplay ?? detail.approvalStatus ?? emptyText;
    final comment = (detail.approvalComment ?? '').trim();
    final status = detail.approvalStatus ?? '';
    final spacing = LayoutTokens.gapSm;
    final useColumnButtons = ResponsiveLayout.isMobile(context);

    final actions = <Widget>[];
    if (status == 'draft') {
      actions.add(
        FilledButton.icon(
          onPressed: actionLoading ? null : onSubmitApproval,
          icon: const Icon(Icons.fact_check_outlined, size: 18),
          label: Text(actionLoading ? '提交中' : '提交审核'),
        ),
      );
    }
    if ((status == 'submitted' || status == 'pending') &&
        onApprove != null &&
        onReject != null) {
      if (useColumnButtons) {
        actions.addAll([
          FilledButton(
            onPressed: actionLoading ? null : onApprove,
            child: const Text('审核通过'),
          ),
          SizedBox(height: spacing),
          OutlinedButton(
            onPressed: actionLoading ? null : onReject,
            child: const Text('审核拒绝'),
          ),
        ]);
      } else {
        actions.add(
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: actionLoading ? null : onApprove,
                  child: const Text('审核通过'),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: OutlinedButton(
                  onPressed: actionLoading ? null : onReject,
                  child: const Text('审核拒绝'),
                ),
              ),
            ],
          ),
        );
      }
    }
    if (status == 'rejected' && onResubmit != null) {
      actions.add(
        FilledButton.icon(
          onPressed: actionLoading ? null : onResubmit,
          icon: const Icon(Icons.send_outlined, size: 18),
          label: const Text('重新提交审核'),
        ),
      );
    }
    if (detail.priority != 'urgent') {
      actions.add(
        OutlinedButton.icon(
          onPressed: actionLoading ? null : onMarkUrgent,
          icon: const Icon(Icons.priority_high, size: 18),
          label: const Text('标记紧急'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: LayoutTokens.gapLg,
          runSpacing: LayoutTokens.gapSm,
          children: [
            InfoRow(label: '审批状态', value: statusText),
            InfoRow(
              label: '审核人',
              value: detail.approvedByName?.trim().isNotEmpty == true
                  ? detail.approvedByName!
                  : emptyText,
            ),
          ],
        ),
        if (comment.isNotEmpty) ...[
          SizedBox(height: LayoutTokens.gapMd),
          Text(
            comment,
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (actions.isNotEmpty) ...[
          SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: actions,
          ),
        ],
      ],
    );
  }
}

/// Info row widget.
class InfoRow extends StatelessWidget {
  const InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: colors?.subtleText),
        ),
        SpacingTokens.vXs,
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
