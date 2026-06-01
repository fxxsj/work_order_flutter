import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class ExpandableSummaryCard extends StatefulWidget {
  const ExpandableSummaryCard({
    super.key,
    required this.headerBuilder,
    this.expandedChild,
    this.initiallyExpanded = false,
    this.onHeaderTap,
    this.headerPadding,
    this.expandedPadding,
    this.radius,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget Function(BuildContext context, bool expanded) headerBuilder;
  final Widget? expandedChild;
  final bool initiallyExpanded;
  final VoidCallback? onHeaderTap;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? expandedPadding;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  State<ExpandableSummaryCard> createState() => _ExpandableSummaryCardState();
}

class _ExpandableSummaryCardState extends State<ExpandableSummaryCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;

  void _handleTap() {
    if (widget.expandedChild == null) {
      widget.onHeaderTap?.call();
      return;
    }
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final resolvedRadius = widget.radius ?? RadiusTokens.lg;
    final resolvedBorderColor =
        widget.borderColor ??
        (colors?.borderColor ??
            theme.dividerColor.withValues(alpha: OpacityTokens.intense));
    final resolvedBackground =
        widget.backgroundColor ??
        (colors?.surface ?? theme.colorScheme.surface);
    final resolvedHeaderPadding =
        (widget.headerPadding ?? LayoutTokens.cardPadding(context)).resolve(
          Directionality.of(context),
        );
    final expandedSpacing = LayoutTokens.sectionSpacing(context);
    final resolvedExpandedPadding =
        widget.expandedPadding ??
        EdgeInsets.fromLTRB(
          resolvedHeaderPadding.left,
          expandedSpacing,
          resolvedHeaderPadding.right,
          resolvedHeaderPadding.bottom,
        );

    return AnimatedSize(
      duration: AnimationTokens.slide,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: resolvedBackground,
          borderRadius: BorderRadius.circular(resolvedRadius),
          border: Border.all(color: resolvedBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _handleTap,
              borderRadius: BorderRadius.circular(resolvedRadius),
              child: Padding(
                padding: resolvedHeaderPadding,
                child: widget.headerBuilder(context, _expanded),
              ),
            ),
            if (widget.expandedChild != null)
              ClipRect(
                child: Align(
                  heightFactor: _expanded ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(height: 1, color: resolvedBorderColor),
                      Padding(
                        padding: resolvedExpandedPadding,
                        child: widget.expandedChild,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
