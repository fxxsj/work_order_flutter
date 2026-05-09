import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = LayoutTokens.maxContentWidth,
    this.scrollable = true,
  });

  final Widget child;
  final double maxWidth;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final semantic = theme.extension<AppSemanticColors>();
    final padding = LayoutTokens.pagePadding(context);
    final innerPadding = LayoutTokens.cardPadding(context);
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    double resolvedMaxWidth = maxWidth;
    if (maxWidth == LayoutTokens.maxContentWidth) {
      if (ResponsiveLayout.is2xl(context)) {
        resolvedMaxWidth = LayoutTokens.maxContentWidthWide;
      } else if (ResponsiveLayout.isDesktop(context)) {
        resolvedMaxWidth = LayoutTokens.maxContentWidth;
      } else {
        resolvedMaxWidth = double.infinity;
      }
    }

    final useSurfaceCanvas = !isMobile;
    final borderColor = colors?.borderColor ?? theme.dividerColor;
    final canvasRadius = BorderRadius.zero;
    final canvas = Container(
      decoration: BoxDecoration(
        color: colors?.surface ?? theme.colorScheme.surface,
        borderRadius: canvasRadius,
        border: Border.all(color: borderColor.withValues(alpha: OpacityTokens.intense)),
        boxShadow: [
          if (semantic != null)
            BoxShadow(
              color: semantic.shadowStrong.withValues(alpha: isTablet ? OpacityTokens.weak : OpacityTokens.subtle),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: canvasRadius,
        child: Padding(
          padding: innerPadding,
          child: child,
        ),
      ),
    );

    final container = Container(
      color: colors?.background ?? theme.scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
          child: Padding(
            padding: padding,
            child: useSurfaceCanvas ? canvas : child,
          ),
        ),
      ),
    );

    if (!scrollable) {
      return container;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: container,
          ),
        );
      },
    );
  }
}
