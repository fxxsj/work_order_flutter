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
    this.shadowLevel = ShadowLevel.md,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? background;
  final Color? borderColor;
  final double? borderAlpha;
  final double? radius;
  final bool showBorder;
  final bool showShadow;
  final ShadowLevel shadowLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final resolvedPadding = padding ?? LayoutTokens.cardPadding(context);
    final resolvedRadius = radius ?? RadiusTokens.md;
    final resolvedBackground =
        background ?? colors?.surface ?? theme.colorScheme.surface;
    final resolvedBorder =
        borderColor ?? colors?.borderColor ?? theme.dividerColor;
    final resolvedBorderAlpha = borderAlpha ?? OpacityTokens.border;

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(resolvedRadius),
        border: showBorder
            ? Border.all(
                color: resolvedBorder.withValues(alpha: resolvedBorderAlpha),
              )
            : null,
        boxShadow: showShadow ? _getShadow(context, shadowLevel) : null,
      ),
      child: child,
    );
  }

  List<BoxShadow> _getShadow(BuildContext context, ShadowLevel level) {
    switch (level) {
      case ShadowLevel.xs:
        return ShadowTokens.xs;
      case ShadowLevel.sm:
        return ShadowTokens.sm;
      case ShadowLevel.md:
        return ShadowTokens.card;
      case ShadowLevel.lg:
        return ShadowTokens.lg;
      case ShadowLevel.xl:
        return ShadowTokens.xl;
    }
  }
}

/// 阴影等级
enum ShadowLevel { xs, sm, md, lg, xl }
