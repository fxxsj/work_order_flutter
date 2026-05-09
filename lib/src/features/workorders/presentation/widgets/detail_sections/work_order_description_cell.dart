import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Description cell for detail grids.
class DescriptionCell extends StatelessWidget {
  const DescriptionCell({
    required this.label,
    required this.value,
    this.isStatus = false,
    this.statusType,
    this.statusValue,
    this.isProgress = false,
    this.progressValue,
  });

  final String label;
  final String value;
  final bool isStatus;
  final String? statusType;
  final String? statusValue;
  final bool isProgress;
  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final dividerColor =
        colors?.borderColor.withValues(alpha: OpacityTokens.strong);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor ?? Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors?.subtleText,
            ),
          ),
          SpacingTokens.vXs,
          if (isProgress && progressValue != null)
            ClipRRect(
              borderRadius: RadiusTokens.bXs,
              child: LinearProgressIndicator(
                value: progressValue! / 100,
                backgroundColor:
                    colors?.borderColor.withValues(alpha: OpacityTokens.medium),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressValue! >= 100
                      ? Colors.green
                      : theme.colorScheme.primary,
                ),
              ),
            )
          else if (isStatus && statusValue != null)
            StatusBadge(
              text: value,
              type: statusType ?? '',
              statusValue: statusValue!,
            )
          else
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

/// Status badge widget.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.text,
    required this.type,
    required this.statusValue,
  });

  final String text;
  final String type;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: OpacityTokens.mild),
        borderRadius: RadiusTokens.bXs,
        border:
            Border.all(color: color.withValues(alpha: OpacityTokens.strong)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Color get _badgeColor {
    switch (type) {
      case 'status':
        switch (statusValue) {
          case 'pending':
            return Colors.grey;
          case 'in_progress':
            return Colors.blue;
          case 'paused':
            return Colors.orange;
          case 'completed':
            return Colors.green;
          case 'cancelled':
            return Colors.red;
          default:
            return Colors.grey;
        }
      case 'approval':
        switch (statusValue) {
          case 'draft':
            return Colors.grey;
          case 'submitted':
          case 'pending':
            return Colors.orange;
          case 'approved':
            return Colors.green;
          case 'rejected':
            return Colors.red;
          default:
            return Colors.grey;
        }
      case 'priority':
        switch (statusValue) {
          case 'low':
            return Colors.grey;
          case 'normal':
            return Colors.blue;
          case 'high':
            return Colors.orange;
          case 'urgent':
            return Colors.red;
          default:
            return Colors.grey;
        }
      default:
        return Colors.grey;
    }
  }
}
