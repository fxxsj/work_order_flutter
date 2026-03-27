import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

enum StatusChipVariant {
  warning,
  info,
  success,
  danger,
  primary,
}

class StatusHintChip extends StatelessWidget {
  const StatusHintChip({
    super.key,
    required this.label,
    required this.count,
    this.icon = Icons.warning_amber_rounded,
    this.onTap,
    this.selected = false,
    this.variant = StatusChipVariant.warning,
  });

  final String label;
  final int count;
  final IconData icon;
  final VoidCallback? onTap;
  final bool selected;
  final StatusChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();

    final baseColor = switch (variant) {
      StatusChipVariant.warning => semantic?.warning ?? theme.colorScheme.primary,
      StatusChipVariant.info => semantic?.info ?? theme.colorScheme.primary,
      StatusChipVariant.success => semantic?.success ?? theme.colorScheme.primary,
      StatusChipVariant.danger => semantic?.danger ?? theme.colorScheme.error,
      StatusChipVariant.primary => theme.colorScheme.primary,
    };

    final iconData = switch (variant) {
      StatusChipVariant.warning => Icons.warning_amber_rounded,
      StatusChipVariant.info => Icons.info_outline_rounded,
      StatusChipVariant.success => Icons.check_circle_outline_rounded,
      StatusChipVariant.danger => Icons.error_outline_rounded,
      StatusChipVariant.primary => Icons.notification_important_outlined,
    };

    final chip = Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: selected ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        border: Border.all(
            color: baseColor.withValues(alpha: selected ? 0.45 : 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? iconData, size: 16, color: baseColor),
          const SizedBox(width: 6),
          Text(
            '$label $count',
            style: theme.textTheme.bodySmall?.copyWith(
              color: baseColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return chip;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        onTap: onTap,
        child: chip,
      ),
    );
  }
}
