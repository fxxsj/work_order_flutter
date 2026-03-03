import 'package:flutter/material.dart';

class PageHeaderBar extends StatelessWidget {
  const PageHeaderBar({
    super.key,
    required this.actions,
    this.breadcrumb,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 12),
    this.useSurface = true,
    this.showDivider = true,
    this.breadcrumbBottomSpacing = 4,
    this.breadcrumbStyle,
  });

  final String? breadcrumb;
  final Widget actions;
  final EdgeInsetsGeometry padding;
  final bool useSurface;
  final bool showDivider;
  final double breadcrumbBottomSpacing;
  final TextStyle? breadcrumbStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumb != null && breadcrumb!.trim().isNotEmpty) ...[
          Text(
            breadcrumb!,
            style: breadcrumbStyle ?? theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          SizedBox(height: breadcrumbBottomSpacing),
        ],
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: actions,
              ),
            ),
          ],
        ),
      ],
    );

    if (!useSurface && !showDivider && padding == EdgeInsets.zero) {
      return content;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: useSurface ? theme.colorScheme.surface : null,
        border: showDivider
            ? Border(
                bottom: BorderSide(color: theme.dividerColor.withOpacity(0.6)),
              )
            : null,
      ),
      child: content,
    );
  }
}

class PageActionStyle {
  const PageActionStyle._();

  static const double height = 36;
  static const double radius = 4;
  static const double minWidth = 88;
  static const double iconButtonSize = 36;
}

enum PageActionVariant { filled, outlined }

class PageActionButton extends StatelessWidget {
  const PageActionButton.filled({
    super.key,
    required this.onPressed,
    this.icon,
    this.label,
    this.minWidth,
    this.square = false,
    this.padding,
  }) : variant = PageActionVariant.filled;

  const PageActionButton.outlined({
    super.key,
    required this.onPressed,
    this.icon,
    this.label,
    this.minWidth,
    this.square = false,
    this.padding,
  }) : variant = PageActionVariant.outlined;

  final PageActionVariant variant;
  final VoidCallback? onPressed;
  final Widget? icon;
  final String? label;
  final double? minWidth;
  final bool square;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final hasLabel = label != null && label!.trim().isNotEmpty;
    final isSquare = square || (!hasLabel && icon != null);
    final effectivePadding = padding ??
        EdgeInsets.symmetric(horizontal: hasLabel ? (variant == PageActionVariant.filled ? 12 : 10) : 0);

    final style = variant == PageActionVariant.filled
        ? FilledButton.styleFrom(
            minimumSize: Size(isSquare ? PageActionStyle.iconButtonSize : (minWidth ?? 0), PageActionStyle.height),
            fixedSize: isSquare
                ? const Size(PageActionStyle.iconButtonSize, PageActionStyle.height)
                : null,
            padding: effectivePadding,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PageActionStyle.radius),
            ),
          )
        : OutlinedButton.styleFrom(
            minimumSize: Size(
              isSquare ? PageActionStyle.iconButtonSize : (minWidth ?? PageActionStyle.minWidth),
              PageActionStyle.height,
            ),
            fixedSize: isSquare
                ? const Size(PageActionStyle.iconButtonSize, PageActionStyle.height)
                : null,
            padding: effectivePadding,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PageActionStyle.radius),
            ),
          );

    Widget button;
    if (variant == PageActionVariant.filled) {
      if (icon != null && hasLabel) {
        button = FilledButton.icon(
          style: style,
          onPressed: onPressed,
          icon: icon!,
          label: Text(label!),
        );
      } else {
        button = FilledButton(
          style: style,
          onPressed: onPressed,
          child: icon ?? Text(label ?? ''),
        );
      }
    } else if (icon != null && hasLabel) {
      button = OutlinedButton.icon(
        style: style,
        onPressed: onPressed,
        icon: icon!,
        label: Text(label!),
      );
    } else {
      button = OutlinedButton(
        style: style,
        onPressed: onPressed,
        child: icon ?? Text(label ?? ''),
      );
    }

    return SizedBox(
      height: PageActionStyle.height,
      width: isSquare ? PageActionStyle.iconButtonSize : null,
      child: button,
    );
  }
}
