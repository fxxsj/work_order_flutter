import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';

class ResponsivePaginationBar extends StatelessWidget {
  const ResponsivePaginationBar({
    super.key,
    required this.infoText,
    required this.page,
    required this.pageSize,
    required this.pageSizeOptions,
    required this.onPageSizeChanged,
    required this.onPrev,
    required this.onNext,
    required this.hasPrev,
    required this.hasNext,
    this.pageSizeLabelBuilder,
  });

  final String infoText;
  final int page;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int> onPageSizeChanged;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final bool hasPrev;
  final bool hasNext;
  final String Function(int size)? pageSizeLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.sm;
    final resolvedPadding = LayoutTokens.cardPadding(context);

    return SizedBox(
      width: double.infinity,
      child: AppCard(
        padding: resolvedPadding,
        radius: compact ? LayoutTokens.radiusMd : LayoutTokens.radiusLg,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < Breakpoints.sm;
            final infoStyle =
                theme.textTheme.bodySmall?.copyWith(color: colors.subtleText);
            final effectivePageSize = pageSizeOptions.contains(pageSize)
                ? pageSize
                : (pageSizeOptions.isNotEmpty ? pageSizeOptions.first : null);
            final pagerControls = Wrap(
              spacing: LayoutTokens.gapXs,
              runSpacing: LayoutTokens.gapXs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (effectivePageSize != null)
                  DropdownMenu<int>(
                    key: ValueKey<int>(effectivePageSize),
                    initialSelection: effectivePageSize,
                    width: compact ? 88 : 96,
                    textStyle: infoStyle,
                    menuStyle: const MenuStyle(
                      visualDensity: VisualDensity.compact,
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    dropdownMenuEntries: pageSizeOptions
                        .map(
                          (size) => DropdownMenuEntry<int>(
                            value: size,
                            label: pageSizeLabelBuilder?.call(size) ?? '$size',
                          ),
                        )
                        .toList(),
                    onSelected: (value) {
                      if (value == null) return;
                      onPageSizeChanged(value);
                    },
                  ),
                IconButton(
                  onPressed: hasPrev ? onPrev : null,
                  icon: const Icon(Icons.chevron_left, size: 18),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
                Text('$page', style: infoStyle),
                IconButton(
                  onPressed: hasNext ? onNext : null,
                  icon: const Icon(Icons.chevron_right, size: 18),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            );

            if (compact) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      infoText,
                      style: infoStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconTheme(
                    data: IconThemeData(
                      size: 18,
                      color: colors.subtleText,
                    ),
                    child: DefaultTextStyle.merge(
                      style: infoStyle,
                      child: pagerControls,
                    ),
                  ),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    infoText,
                    style: infoStyle,
                  ),
                ),
                const SizedBox(width: 12),
                IconTheme(
                  data: IconThemeData(
                    size: 18,
                    color: colors.subtleText,
                  ),
                  child: DefaultTextStyle.merge(
                    style: infoStyle,
                    child: pagerControls,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.text,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String text;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    final background =
        (semantic?.info ?? theme.colorScheme.primary).withValues(alpha: 0.05);
    final border =
        (semantic?.info ?? theme.colorScheme.primary).withValues(alpha: 0.15);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.maxHeight.isFinite;
        final card = AppCard(
          padding: const EdgeInsets.symmetric(vertical: 32),
          radius: LayoutTokens.radiusMd,
          background: background,
          borderColor: border,
          borderAlpha: 1,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: semantic?.info ?? theme.colorScheme.primary,
                    size: LayoutTokens.iconXxxl),
                const SizedBox(height: LayoutTokens.gapSm),
                Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: LayoutTokens.gapXs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: LayoutTokens.gapMd),
                  OutlinedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.add, size: LayoutTokens.iconSm),
                    label: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        );

        return SizedBox(
          width: double.infinity,
          height: hasBoundedHeight ? constraints.maxHeight : null,
          child: card,
        );
      },
    );
  }
}

class ErrorStateCard extends StatelessWidget {
  const ErrorStateCard({
    super.key,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.subtitle,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    final danger = semantic?.danger ?? theme.colorScheme.error;
    final background = danger.withValues(alpha: 0.06);
    final border = danger.withValues(alpha: 0.2);

    return SizedBox(
      width: double.infinity,
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 32),
        radius: LayoutTokens.radiusMd,
        background: background,
        borderColor: border,
        borderAlpha: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                color: danger, size: LayoutTokens.iconXxl),
            const SizedBox(height: LayoutTokens.gapSm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: LayoutTokens.gapXs),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: LayoutTokens.gapSm),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: LayoutTokens.iconSm),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSearchField extends StatelessWidget {
  const ListSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.height,
    required this.width,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hintText;
  final double height;
  final double width;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: SizedBox(
        height: height,
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            return TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                constraints: BoxConstraints.tightFor(height: height),
                hintText: hintText,
                prefixIcon: const Icon(Icons.search, size: LayoutTokens.iconMd),
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: '清空',
                        icon:
                            const Icon(Icons.close, size: LayoutTokens.iconMd),
                        onPressed: onClear,
                      ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ListDensityToggle extends StatelessWidget {
  const ListDensityToggle({
    super.key,
    required this.isDense,
    required this.onChanged,
    required this.height,
    this.minWidth = 52,
    this.radius = LayoutTokens.radiusSm,
    this.comfortLabel = '舒适',
    this.compactLabel = '紧凑',
  });

  final bool isDense;
  final ValueChanged<bool> onChanged;
  final double height;
  final double minWidth;
  final double radius;
  final String comfortLabel;
  final String compactLabel;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [isDense == false, isDense == true],
      onPressed: (index) => onChanged(index == 1),
      borderRadius: BorderRadius.circular(radius),
      constraints: BoxConstraints(minHeight: height, minWidth: minWidth),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(comfortLabel),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(compactLabel),
        ),
      ],
    );
  }
}

class ListToolbarButton extends StatelessWidget {
  const ListToolbarButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.height,
    this.compact = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: LayoutTokens.iconSm),
        label: Text(label),
        style: compact
            ? OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                visualDensity: VisualDensity.compact,
              )
            : null,
      ),
    );
  }
}

class ExpandableFilters extends StatelessWidget {
  const ExpandableFilters({
    super.key,
    required this.expanded,
    required this.maxHeight,
    required this.child,
    this.topPadding = 0,
  });

  final bool expanded;
  final double maxHeight;
  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AnimationTokens.expandDuration,
      curve: Curves.easeOut,
      child: expanded
          ? Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: child,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
