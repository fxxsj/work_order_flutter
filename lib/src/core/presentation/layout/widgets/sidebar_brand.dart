import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Brand header used in [AppSidebarDrawer] and [AppSidebarRail].
class SidebarBrand extends StatelessWidget {
  const SidebarBrand({
    super.key,
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
        height: LayoutTokens.navItemHeight,
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        ),
        child: Icon(Icons.grid_view_rounded,
            color: Theme.of(context).colorScheme.onPrimary, size: 18),
      );
    }

    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: LayoutTokens.gapXs,
        vertical: LayoutTokens.gapXxxs,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: onPrimary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
            ),
            child: Icon(Icons.grid_view_rounded, color: onPrimary, size: 18),
          ),
          SizedBox(width: LayoutTokens.cardPaddingSm),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: onPrimary,
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
