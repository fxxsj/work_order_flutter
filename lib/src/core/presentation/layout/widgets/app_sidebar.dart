import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/drawer_tile.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/rail_badge.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/sidebar_brand.dart';

class AppSidebarDrawer extends StatelessWidget {
  const AppSidebarDrawer({
    super.key,
    required this.appTitle,
    required this.navItems,
    required this.expandedIds,
    required this.currentId,
    required this.onToggleExpand,
    required this.onSelectId,
    required this.primary,
    required this.sidebarText,
    required this.badgeTextForItem,
    required this.headerHeight,
  });

  final String appTitle;
  final List<NavItem> navItems;
  final Set<String> expandedIds;
  final String currentId;
  final void Function(String id, bool expanded) onToggleExpand;
  final ValueChanged<String> onSelectId;
  final Color primary;
  final Color sidebarText;
  final String? Function(NavItem) badgeTextForItem;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parentStyle = theme.textTheme.bodySmall?.copyWith(
      color: sidebarText,
      fontWeight: FontWeight.w700,
    );
    final tiles = <Widget>[];

    for (final item in navItems) {
      if (item.children.isEmpty) {
        tiles.add(
          DrawerTile(
            item: item,
            badgeText: badgeTextForItem(item),
            isSelected: currentId == item.id,
            primary: primary,
            sidebarText: sidebarText,
            onTap: () => onSelectId(item.id),
          ),
        );
      } else {
        final isExpanded =
            expandedIds.contains(item.id) ||
            item.children.any((c) => c.id == currentId);
        tiles.add(
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: PageStorageKey(item.id),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (value) => onToggleExpand(item.id, value),
              tilePadding: EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
                vertical: SpacingTokens.xxxs,
              ),
              childrenPadding: EdgeInsets.zero,
              leading: Icon(item.icon, color: sidebarText, size: 18),
              title: Text(item.label, style: parentStyle),
              children: [
                for (final child in item.children)
                  DrawerTile(
                    item: child,
                    badgeText: badgeTextForItem(child),
                    isSelected: currentId == child.id,
                    primary: primary,
                    sidebarText: sidebarText,
                    onTap: () => onSelectId(child.id),
                    dense: true,
                  ),
              ],
            ),
          ),
        );
      }
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: headerHeight,
          color: primary,
          padding: EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
          alignment: Alignment.centerLeft,
          child: SidebarBrand(
            compact: false,
            title: appTitle,
            primary: primary,
            sidebarText: sidebarText,
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: ListView(padding: EdgeInsets.zero, children: tiles),
          ),
        ),
      ],
    );
  }
}

class AppSidebarRail extends StatelessWidget {
  const AppSidebarRail({
    super.key,
    required this.appTitle,
    required this.navItems,
    required this.expandedIds,
    required this.currentId,
    required this.onToggleExpand,
    required this.onSelectId,
    required this.primary,
    required this.sidebarText,
    required this.railExtended,
    required this.badgeTextForItem,
    required this.controller,
    required this.headerHeight,
  });

  final String appTitle;
  final List<NavItem> navItems;
  final Set<String> expandedIds;
  final String currentId;
  final void Function(String id, bool expanded) onToggleExpand;
  final ValueChanged<String> onSelectId;
  final Color primary;
  final Color sidebarText;
  final bool railExtended;
  final String? Function(NavItem) badgeTextForItem;
  final ScrollController controller;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: headerHeight,
          color: primary,
          padding: EdgeInsets.symmetric(horizontal: LayoutTokens.cardPaddingSm),
          alignment: Alignment.centerLeft,
          child: SidebarBrand(
            compact: !railExtended,
            title: appTitle,
            primary: primary,
            sidebarText: sidebarText,
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: ListView(
              controller: controller,
              padding: EdgeInsets.fromLTRB(
                LayoutTokens.cardPaddingSm,
                SpacingTokens.xxs,
                LayoutTokens.cardPaddingSm,
                SpacingTokens.lg,
              ),
              children: _buildRailItems(context),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRailItems(BuildContext context) {
    final items = <Widget>[];
    for (final item in navItems) {
      if (item.children.isEmpty) {
        items.add(
          _buildRailTile(
            context,
            item,
            isSelected: currentId == item.id,
            onTap: () => onSelectId(item.id),
          ),
        );
      } else {
        final isExpanded =
            expandedIds.contains(item.id) ||
            item.children.any((c) => c.id == currentId);
        items.add(
          _buildRailTile(
            context,
            item,
            isSelected: false,
            isParent: true,
            isExpanded: isExpanded,
            onTap: () => onToggleExpand(item.id, !isExpanded),
          ),
        );
        if (isExpanded) {
          for (final child in item.children) {
            items.add(
              _buildRailTile(
                context,
                child,
                isSelected: currentId == child.id,
                indent: railExtended ? 16 : 0,
                onTap: () => onSelectId(child.id),
              ),
            );
          }
        }
      }
    }
    return items;
  }

  Widget _buildRailTile(
    BuildContext context,
    NavItem item, {
    required bool isSelected,
    required VoidCallback onTap,
    bool isParent = false,
    bool isExpanded = false,
    double indent = 0,
  }) {
    final theme = Theme.of(context);
    final background = isSelected
        ? primary.withValues(alpha: OpacityTokens.subtle)
        : Colors.transparent;
    final iconColor = isSelected ? primary : sidebarText;
    final textColor = isSelected ? primary : sidebarText;
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: textColor,
      fontWeight: isParent ? FontWeight.w600 : FontWeight.w500,
    );

    final tile = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusTokens.sm),
      child: Container(
        height: LayoutTokens.navItemHeight,
        padding: EdgeInsets.symmetric(
          horizontal: railExtended ? LayoutTokens.cardPaddingSm : 0,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
          border: Border.all(
            color: isSelected
                ? primary.withValues(alpha: OpacityTokens.mild)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: railExtended
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (railExtended && indent > 0) SizedBox(width: indent),
            Icon(item.icon, color: iconColor, size: 20),
            if (railExtended) SizedBox(width: SpacingTokens.md),
            if (railExtended)
              Expanded(
                child: Text(
                  item.label,
                  style: labelStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (railExtended && isParent)
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: textColor.withValues(alpha: OpacityTokens.intense),
                size: 18,
              ),
            if (railExtended && !isParent)
              RailBadge(badgeText: badgeTextForItem(item), primary: primary),
          ],
        ),
      ),
    );
    final content = railExtended
        ? tile
        : Tooltip(message: item.label, child: tile);
    return Padding(
      padding: EdgeInsets.only(bottom: SpacingTokens.xs),
      child: content,
    );
  }
}
