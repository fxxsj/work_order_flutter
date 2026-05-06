import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';

/// Navigation tile used in the drawer variant of the sidebar.
class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
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
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: isSelected ? primary : sidebarText,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
    );
    final badgeStyle = theme.textTheme.labelSmall?.copyWith(
      color: primary,
      fontWeight: FontWeight.w600,
    );
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 18 : LayoutTokens.gapMd,
        vertical: dense ? 1 : 3,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: LayoutTokens.gapMd,
            vertical: dense ? 7 : 9,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
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
              SizedBox(width: LayoutTokens.cardPaddingSm),
              Expanded(
                child: Text(
                  item.label,
                  style: labelStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: LayoutTokens.gapSm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(LayoutTokens.radiusPill),
                  ),
                  child: Text(
                    badgeText!,
                    style: badgeStyle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
