import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.background,
    this.borderColor,
    this.borderAlpha,
    this.radius,
    this.showBorder = true,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? background;
  final Color? borderColor;
  final double? borderAlpha;
  final double? radius;
  final bool showBorder;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final semantic = theme.extension<AppSemanticColors>();
    final resolvedPadding = padding ?? LayoutTokens.cardPadding(context);
    final resolvedRadius = radius ?? LayoutTokens.radiusMd;
    final resolvedBackground =
        background ?? colors?.surface ?? theme.colorScheme.surface;
    final resolvedBorder = borderColor ?? colors?.borderColor ?? theme.dividerColor;
    final resolvedBorderAlpha = borderAlpha ?? 0.55;
    final shadowBase = semantic?.shadowStrong ?? theme.shadowColor;

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(resolvedRadius),
        border: showBorder
            ? Border.all(color: resolvedBorder.withValues(alpha: resolvedBorderAlpha))
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: shadowBase.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: shadowBase.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
