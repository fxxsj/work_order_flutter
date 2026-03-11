import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';

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

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
        child: _SidebarBrand(
          compact: false,
          title: appTitle,
          primary: primary,
          sidebarText: sidebarText,
        ),
      ),
    ];

    for (final item in navItems) {
      if (item.children.isEmpty) {
        children.add(
          _buildDrawerTile(
            item,
            primary: primary,
            sidebarText: sidebarText,
            isSelected: currentId == item.id,
            onTap: () => onSelectId(item.id),
            badgeTextForItem: badgeTextForItem,
          ),
        );
      } else {
        final isExpanded = expandedIds.contains(item.id) ||
            item.children.any((c) => c.id == currentId);
        children.add(
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: PageStorageKey(item.id),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (value) => onToggleExpand(item.id, value),
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              childrenPadding: EdgeInsets.zero,
              leading: Icon(item.icon, color: sidebarText, size: 18),
              title: Text(
                item.label,
                style: TextStyle(
                  color: sidebarText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [
                for (final child in item.children)
                  _buildDrawerTile(
                    child,
                    primary: primary,
                    sidebarText: sidebarText,
                    isSelected: currentId == child.id,
                    onTap: () => onSelectId(child.id),
                    badgeTextForItem: badgeTextForItem,
                    dense: true,
                  ),
              ],
            ),
          ),
        );
      }
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: children,
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

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: false,
      controller: controller,
      child: ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SidebarBrand(
              compact: !railExtended,
              title: appTitle,
              primary: primary,
              sidebarText: sidebarText,
            ),
          ),
          ..._buildRailItems(),
        ],
      ),
    );
  }

  List<Widget> _buildRailItems() {
    final items = <Widget>[];
    for (final item in navItems) {
      if (item.children.isEmpty) {
        items.add(
          _buildRailTile(
            item,
            isSelected: currentId == item.id,
            onTap: () => onSelectId(item.id),
          ),
        );
      } else {
        final isExpanded = expandedIds.contains(item.id) ||
            item.children.any((c) => c.id == currentId);
        items.add(
          _buildRailTile(
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
    NavItem item, {
    required bool isSelected,
    required VoidCallback onTap,
    bool isParent = false,
    bool isExpanded = false,
    double indent = 0,
  }) {
    final background =
        isSelected ? primary.withValues(alpha: 0.08) : Colors.transparent;
    final iconColor = isSelected ? primary : sidebarText;
    final textColor = isSelected ? primary : sidebarText;

    final tile = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: railExtended ? 10 : 0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? primary.withValues(alpha: 0.12)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment:
              railExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            if (railExtended && indent > 0) SizedBox(width: indent),
            Icon(item.icon, color: iconColor, size: 20),
            if (railExtended) const SizedBox(width: 12),
            if (railExtended)
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isParent ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (railExtended && isParent)
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: textColor.withValues(alpha: 0.8),
                size: 18,
              ),
            if (railExtended && !isParent)
              _RailBadge(
                badgeText: badgeTextForItem(item),
                primary: primary,
              ),
          ],
        ),
      ),
    );
    final content =
        railExtended ? tile : Tooltip(message: item.label, child: tile);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: content,
    );
  }
}

Widget _buildDrawerTile(
  NavItem item, {
  required Color primary,
  required Color sidebarText,
  required bool isSelected,
  required VoidCallback onTap,
  required String? Function(NavItem) badgeTextForItem,
  bool dense = false,
}) {
  return _DrawerTile(
    item: item,
    badgeText: badgeTextForItem(item),
    isSelected: isSelected,
    primary: primary,
    sidebarText: sidebarText,
    onTap: onTap,
    dense: dense,
  );
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.item,
    required this.badgeText,
    required this.isSelected,
    required this.primary,
    required this.sidebarText,
    required this.onTap,
    this.dense = false,
  });

  final NavItem item;
  final String? badgeText;
  final bool isSelected;
  final Color primary;
  final Color sidebarText;
  final VoidCallback onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final background =
        isSelected ? primary.withValues(alpha: 0.08) : Colors.transparent;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: dense ? 18 : 12, vertical: dense ? 1 : 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 7 : 9),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? primary.withValues(alpha: 0.12)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(item.icon,
                  color: isSelected ? primary : sidebarText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? primary : sidebarText,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeText != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      color: primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailBadge extends StatelessWidget {
  const _RailBadge({
    required this.badgeText,
    required this.primary,
  });

  final String? badgeText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    if (badgeText == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        badgeText!,
        style: TextStyle(
          color: primary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  const _SidebarBrand({
    required this.compact,
    required this.title,
    required this.primary,
    required this.sidebarText,
  });

  final bool compact;
  final String title;
  final Color primary;
  final Color sidebarText;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.grid_view_rounded, color: primary, size: 18),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.grid_view_rounded, color: primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: sidebarText,
                    fontWeight: FontWeight.w700,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
