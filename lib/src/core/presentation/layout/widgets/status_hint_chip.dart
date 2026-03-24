import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';

class StatusHintChip extends StatelessWidget {
  const StatusHintChip({
    super.key,
    required this.label,
    required this.count,
    this.icon = Icons.warning_amber_rounded,
  });

  final String label;
  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    final warning = semantic?.warning ?? theme.colorScheme.primary;

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: warning.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: warning),
          const SizedBox(width: 6),
          Text(
            '$label $count',
            style: theme.textTheme.bodySmall?.copyWith(
              color: warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
