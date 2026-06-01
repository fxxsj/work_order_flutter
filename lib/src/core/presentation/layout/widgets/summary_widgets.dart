import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class SummaryField extends StatelessWidget {
  const SummaryField({super.key, required this.label, required this.value});

  static const double _mobileRowBreakpoint = 240;
  static const double _mobileLabelWidth = 88;

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors?.subtleText ?? theme.hintColor,
    );
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: colors?.sidebarText,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _mobileRowBreakpoint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _mobileLabelWidth,
                child: Text(label, style: labelStyle),
              ),
              const SizedBox(width: SpacingTokens.md),
              Expanded(child: Text(value, style: valueStyle)),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: labelStyle),
            const SizedBox(height: SpacingTokens.xs),
            Text(value, style: valueStyle),
          ],
        );
      },
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
        color: theme.colorScheme.primary.withValues(alpha: OpacityTokens.faint),
        borderRadius: BorderRadius.circular(RadiusTokens.pill),
        border: Border.all(color: colors?.borderColor ?? theme.dividerColor),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors?.subtleText ?? theme.hintColor,
          ),
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: theme.textTheme.labelSmall?.copyWith(
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
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            SizedBox(width: double.infinity, child: children[i]),
            if (i < children.length - 1) SizedBox(height: runSpacing),
          ],
        ],
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children
          .map((child) => SizedBox(width: desktopWidth, child: child))
          .toList(),
    );
  }
}
