import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Badge pill for the rail sidebar.
class RailBadge extends StatelessWidget {
  const RailBadge({
    super.key,
    required this.badgeText,
    required this.primary,
  });

  final String? badgeText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    if (badgeText == null) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: LayoutTokens.gapSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
      ),
      child: Text(
        badgeText!,
        style: theme.textTheme.labelSmall?.copyWith(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
