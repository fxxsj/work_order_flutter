import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';

class SummaryField extends StatelessWidget {
  const SummaryField({super.key, required this.label, required this.value});

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
            color: colors?.subtleText ?? theme.hintColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors?.sidebarText,
          ),
        ),
      ],
    );
  }
}

class SummaryChip extends StatelessWidget {
  const SummaryChip({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors?.borderColor ?? theme.dividerColor),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors?.subtleText ?? theme.hintColor,
          ),
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors?.sidebarText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryFieldWrap extends StatelessWidget {
  const SummaryFieldWrap({
    super.key,
    required this.isMobile,
    required this.children,
    this.desktopWidth = 220,
    this.spacing = 24,
    this.runSpacing = 12,
  });

  final bool isMobile;
  final double desktopWidth;
  final double spacing;
  final double runSpacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children
          .map(
            (child) => SizedBox(
              width: isMobile ? double.infinity : desktopWidth,
              child: child,
            ),
          )
          .toList(),
    );
  }
}
