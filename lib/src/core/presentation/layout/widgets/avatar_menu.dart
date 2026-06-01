import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Avatar + popup menu shown at the right edge of [AppHeader].
class AvatarMenu extends StatelessWidget {
  const AvatarMenu({
    super.key,
    required this.primary,
    required this.onProfileTap,
    required this.onLogoutTap,
  });

  final Color primary;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '账户',
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          onProfileTap();
        } else if (value == 'logout') {
          onLogoutTap();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'profile', child: Text('个人信息')),
        PopupMenuItem(value: 'logout', child: Text('退出登录')),
      ],
      child: CircleAvatar(
        radius: 15,
        backgroundColor: primary.withValues(alpha: OpacityTokens.mild),
        child: Icon(Icons.person, size: 17, color: primary),
      ),
    );
  }
}
