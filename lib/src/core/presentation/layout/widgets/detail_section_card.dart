import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class DetailSurfaceCard extends StatelessWidget {
  const DetailSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final resolvedRadius = radius ?? RadiusTokens.lg;
    final resolvedBackground =
        backgroundColor ?? (colors?.surface ?? theme.colorScheme.surface);
    final resolvedBorderColor =
        borderColor ??
        (colors?.borderColor ??
            theme.dividerColor.withValues(alpha: OpacityTokens.intense));
    final content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    return Container(
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(resolvedRadius),
        border: Border.all(color: resolvedBorderColor),
      ),
      child: content,
    );
  }
}

class DetailSectionCard extends StatelessWidget {
  const DetailSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.spacing,
    this.titleStyle,
    this.trailing,
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final TextStyle? titleStyle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final resolvedPadding = padding ?? LayoutTokens.cardPadding(context);
    final resolvedSpacing = spacing ?? LayoutTokens.sectionSpacing(context);
    final resolvedTitleStyle =
        titleStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: colors?.sidebarText ?? theme.textTheme.titleMedium?.color,
        );

    return DetailSurfaceCard(
      padding: resolvedPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(title, style: resolvedTitleStyle)),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: resolvedSpacing),
          child,
        ],
      ),
    );
  }
}
