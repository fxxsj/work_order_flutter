import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';

class ApprovalRejectionNoticeCard extends StatelessWidget {
  const ApprovalRejectionNoticeCard({
    super.key,
    required this.reason,
    required this.nextStep,
    this.comment,
    this.title = '审批已退回',
    this.icon = Icons.warning_amber_rounded,
    this.reasonLabel = '驳回原因',
    this.commentLabel = '审批说明',
    this.nextStepLabel = '下一步',
    this.primaryAction,
    this.secondaryAction,
  });

  final String title;
  final String reason;
  final String nextStep;
  final String? comment;
  final IconData icon;
  final String reasonLabel;
  final String commentLabel;
  final String nextStepLabel;
  final Widget? primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    final colors = theme.extension<AppColors>();
    final warning = semantic?.warning ?? theme.colorScheme.error;

    return DetailSurfaceCard(
      padding: LayoutTokens.cardPadding(context),
      backgroundColor: warning.withValues(alpha: OpacityTokens.subtle),
      borderColor: warning.withValues(alpha: OpacityTokens.strong),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: warning, size: 22),
              SizedBox(width: LayoutTokens.cardPaddingSm),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors?.sidebarText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: LayoutTokens.gapLg),
          _NoticeBlock(label: reasonLabel, value: reason),
          if ((comment ?? '').trim().isNotEmpty) ...[
            SizedBox(height: LayoutTokens.gapMd),
            _NoticeBlock(label: commentLabel, value: comment!.trim()),
          ],
          SizedBox(height: LayoutTokens.gapMd),
          _NoticeBlock(label: nextStepLabel, value: nextStep),
          if (primaryAction != null || secondaryAction != null) ...[
            SizedBox(height: LayoutTokens.gapLg),
            Wrap(
              spacing: LayoutTokens.gapSm,
              runSpacing: LayoutTokens.gapSm,
              children: [
                if (primaryAction != null) primaryAction!,
                if (secondaryAction != null) secondaryAction!,
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NoticeBlock extends StatelessWidget {
  const _NoticeBlock({
    required this.label,
    required this.value,
  });

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
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors?.subtleText,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: LayoutTokens.gapXs),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
