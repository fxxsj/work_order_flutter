import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';

class PageHeaderBar extends StatelessWidget {
  const PageHeaderBar({
    super.key,
    required this.actions,
    this.breadcrumb,
    this.padding,
    this.useSurface = true,
    this.showDivider = true,
    this.breadcrumbBottomSpacing = 4,
    this.breadcrumbStyle,
  });

  final String? breadcrumb;
  final Widget actions;
  final EdgeInsetsGeometry? padding;
  final bool useSurface;
  final bool showDivider;
  final double breadcrumbBottomSpacing;
  final TextStyle? breadcrumbStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final resolvedPadding = padding ?? LayoutTokens.pageHeaderPadding(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumb != null && breadcrumb!.trim().isNotEmpty) ...[
          Text(
            breadcrumb!,
            style: breadcrumbStyle ??
                theme.textTheme.bodySmall
                    ?.copyWith(color: colors?.subtleText ?? theme.hintColor),
          ),
          SizedBox(height: breadcrumbBottomSpacing),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = BreakpointsUtil.isMobile(context);
            final actionContent = isMobile
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: actions,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: actions,
                  );
            return Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: actionContent,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );

    if (!useSurface && !showDivider && padding == EdgeInsets.zero) {
      return content;
    }

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: useSurface ? theme.colorScheme.surface : null,
        border: showDivider
            ? Border(
                bottom: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.6)),
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
  static const double radius = LayoutTokens.radiusSm;
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
        EdgeInsets.symmetric(
            horizontal:
                hasLabel ? (variant == PageActionVariant.filled ? 12 : 10) : 0);

    final style = variant == PageActionVariant.filled
        ? FilledButton.styleFrom(
            minimumSize: Size(
                isSquare ? PageActionStyle.iconButtonSize : (minWidth ?? 0),
                PageActionStyle.height),
            fixedSize: isSquare
                ? const Size(
                    PageActionStyle.iconButtonSize, PageActionStyle.height)
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
              isSquare
                  ? PageActionStyle.iconButtonSize
                  : (minWidth ?? PageActionStyle.minWidth),
              PageActionStyle.height,
            ),
            fixedSize: isSquare
                ? const Size(
                    PageActionStyle.iconButtonSize, PageActionStyle.height)
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

class WorkbenchStatItem {
  const WorkbenchStatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class WorkbenchHeaderBar extends StatelessWidget {
  const WorkbenchHeaderBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actions,
    this.breadcrumb,
    this.stats = const [],
    this.titleMaxWidth = 480,
    this.hideSubtitleOnMobile = false,
    this.mobileStatCount,
    this.hideTitleOnMobile = false,
    this.hideBreadcrumbOnMobile = false,
  });

  final String? breadcrumb;
  final String title;
  final String subtitle;
  final List<WorkbenchStatItem> stats;
  final Widget actions;
  final double titleMaxWidth;
  final bool hideSubtitleOnMobile;
  final int? mobileStatCount;
  final bool hideTitleOnMobile;
  final bool hideBreadcrumbOnMobile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isXs = BreakpointsUtil.isXs(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final cardPadding = isXs ? 14.0 : 16.0;
    final titleSpacing = isXs ? 10.0 : 14.0;
    final sectionSpacing = isXs ? 12.0 : 14.0;
    final breadcrumbSpacing = isXs ? 4.0 : 6.0;
    final visibleStats = isMobile && mobileStatCount != null
        ? stats.take(mobileStatCount!).toList()
        : stats;
    final shouldShowBreadcrumb = !(isMobile && hideBreadcrumbOnMobile);
    final shouldShowTitleBlock = !(isMobile && hideTitleOnMobile);

    return AppCard(
      padding: EdgeInsets.all(cardPadding),
      radius: isXs ? LayoutTokens.radiusLg : LayoutTokens.radiusXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shouldShowBreadcrumb &&
              breadcrumb != null &&
              breadcrumb!.trim().isNotEmpty) ...[
            Text(
              breadcrumb!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
            ),
            SizedBox(height: breadcrumbSpacing),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = isMobile || constraints.maxWidth < 720;
              final titleBlock = shouldShowTitleBlock
                  ? ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isNarrow ? double.infinity : titleMaxWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: (isXs
                                    ? theme.textTheme.titleMedium
                                    : theme.textTheme.titleLarge)
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.sidebarText,
                            ),
                          ),
                          if (subtitle.trim().isNotEmpty &&
                              !(isMobile && hideSubtitleOnMobile)) ...[
                            SizedBox(height: isXs ? 3 : 4),
                            Text(
                              subtitle,
                              maxLines: isXs ? 2 : null,
                              overflow: isXs ? TextOverflow.ellipsis : null,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.subtleText,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : const SizedBox.shrink();

              final statsRow = visibleStats.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                      spacing: titleSpacing,
                      runSpacing: titleSpacing,
                      children: [
                        for (final item in visibleStats)
                          WorkbenchStatChip(item: item),
                      ],
                    );

              final actionBlock = DefaultTextStyle.merge(
                style: theme.textTheme.bodyMedium,
                child: actions,
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (shouldShowTitleBlock) titleBlock,
                    if (visibleStats.isNotEmpty) ...[
                      SizedBox(height: titleSpacing),
                      statsRow,
                    ],
                    SizedBox(height: sectionSpacing),
                    actionBlock,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (shouldShowTitleBlock) titleBlock,
                        if (visibleStats.isNotEmpty) ...[
                          SizedBox(height: titleSpacing),
                          statsRow,
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: sectionSpacing),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: actionBlock,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class WorkbenchStatChip extends StatelessWidget {
  const WorkbenchStatChip({
    super.key,
    required this.item,
  });

  final WorkbenchStatItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isXs = BreakpointsUtil.isXs(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isXs ? 10 : 12,
        vertical: isXs ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius:
            BorderRadius.circular(isXs ? LayoutTokens.radiusMd : LayoutTokens.radiusLg),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.label,
            style:
                theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            style:
                (isXs ? theme.textTheme.titleSmall : theme.textTheme.titleSmall)
                    ?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.sidebarText,
            ),
          ),
        ],
      ),
    );
  }
}
