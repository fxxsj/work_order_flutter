import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Badge chip shown in [AppHeader] for the "今日待办" count.
class AppBarChip extends StatelessWidget {
  const AppBarChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      margin: const EdgeInsets.only(left: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: OpacityTokens.subtle),
        borderRadius: BorderRadius.circular(RadiusTokens.pill),
        border: Border.all(color: color.withValues(alpha: OpacityTokens.mild)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
