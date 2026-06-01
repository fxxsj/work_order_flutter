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
    final background = isSelected
        ? primary.withValues(alpha: OpacityTokens.subtle)
        : Colors.transparent;
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
        horizontal: dense ? 18 : SpacingTokens.md,
        vertical: dense ? 1 : 3,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SpacingTokens.md,
            vertical: dense ? 7 : 9,
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
            children: [
              Icon(
                item.icon,
                color: isSelected ? primary : sidebarText,
                size: 18,
              ),
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
                    horizontal: SpacingTokens.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: OpacityTokens.splash),
                    borderRadius: BorderRadius.circular(RadiusTokens.pill),
                  ),
                  child: Text(badgeText!, style: badgeStyle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
