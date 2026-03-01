import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_order_app/pages/layout/nav_config.dart';

class AppSidebarDrawer extends StatelessWidget {
  const AppSidebarDrawer({
    super.key,
    required this.navItems,
    required this.expandedIds,
    required this.currentId,
    required this.onToggleExpand,
    required this.onSelectId,
    required this.primary,
    required this.sidebarText,
    required this.badgeTextForItem,
  });

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
    final children = <Widget>[];
    for (final item in navItems) {
      if (item.children.isEmpty) {
        children.add(_buildDrawerTile(
          item,
          primary: primary,
          sidebarText: sidebarText,
          isSelected: currentId == item.id,
          onTap: () => onSelectId(item.id),
          badgeTextForItem: badgeTextForItem,
        ));
      } else {
        final isExpanded = expandedIds.contains(item.id) || item.children.any((c) => c.id == currentId);
        children.add(
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: PageStorageKey(item.id),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (value) => onToggleExpand(item.id, value),
              leading: Icon(item.icon, color: sidebarText, size: 18),
              title: Text(
                item.label,
                style: TextStyle(color: sidebarText, fontSize: 13, fontWeight: FontWeight.w600),
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
    final items = _buildRailItems();
    return Scrollbar(
      thumbVisibility: true,
      controller: controller,
      child: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      ),
    );
  }

  List<Widget> _buildRailItems() {
    final items = <Widget>[];
    for (final item in navItems) {
      if (item.children.isEmpty) {
        items.add(_buildRailTile(
          item,
          isSelected: currentId == item.id,
          onTap: () => onSelectId(item.id),
        ));
      } else {
        final isExpanded = expandedIds.contains(item.id) || item.children.any((c) => c.id == currentId);
        items.add(_buildRailTile(
          item,
          isSelected: false,
          isParent: true,
          isExpanded: isExpanded,
          onTap: () => onToggleExpand(item.id, !isExpanded),
        ));
        if (isExpanded) {
          for (final child in item.children) {
            items.add(_buildRailTile(
              child,
              isSelected: currentId == child.id,
              indent: railExtended ? 16 : 0,
              onTap: () => onSelectId(child.id),
            ));
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
    final background = isSelected ? primary.withOpacity(0.12) : Colors.transparent;
    final iconColor = isSelected ? primary : sidebarText;
    final textColor = isSelected ? primary : sidebarText;
    final tile = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: railExtended ? 12 : 0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: railExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
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
                    fontWeight: isParent ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (railExtended && isParent)
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: textColor.withOpacity(0.8),
                size: 18,
              ),
            if (railExtended && !isParent)
              _RailBadge(
                item: item,
                primary: primary,
                badgeTextForItem: badgeTextForItem,
              ),
          ],
        ),
      ),
    );
    final content = railExtended ? tile : Tooltip(message: item.label, child: tile);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
  if (item.id == 'notifications') {
    return Obx(() {
      final badgeText = badgeTextForItem(item);
      return _DrawerTile(
        item: item,
        badgeText: badgeText,
        isSelected: isSelected,
        primary: primary,
        sidebarText: sidebarText,
        onTap: onTap,
        dense: dense,
      );
    });
  }
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
    final background = isSelected ? primary.withOpacity(0.2) : Colors.transparent;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dense ? 18 : 12, vertical: dense ? 2 : 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 8 : 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? primary.withOpacity(0.35) : Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: isSelected ? primary : sidebarText, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? primary : sidebarText,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
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
    required this.item,
    required this.primary,
    required this.badgeTextForItem,
  });

  final NavItem item;
  final Color primary;
  final String? Function(NavItem) badgeTextForItem;

  @override
  Widget build(BuildContext context) {
    if (item.id == 'notifications') {
      return Obx(() => _buildBadge(badgeTextForItem(item)));
    }
    return _buildBadge(badgeTextForItem(item));
  }

  Widget _buildBadge(String? text) {
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10.5),
      ),
    );
  }
}
