import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/controllers/app_badge_controller.dart';
import 'package:work_order_app/src/features/notification/application/notification_controller.dart';
import 'package:work_order_app/src/features/notification/domain/notification_model.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.isMobile,
    required this.showSidebarToggle,
    required this.isSidebarCollapsed,
    required this.onSidebarToggle,
    required this.title,
    required this.onMenuTap,
    required this.onSettingTap,
    required this.onNotificationViewAll,
    required this.onProfileTap,
    required this.onLogoutTap,
    required this.primary,
    required this.surface,
    required this.accent,
    required this.subtleText,
    required this.height,
    required this.isCompactActions,
  });

  final bool isMobile;
  final bool showSidebarToggle;
  final bool isSidebarCollapsed;
  final VoidCallback onSidebarToggle;
  final String title;
  final VoidCallback onMenuTap;
  final VoidCallback onSettingTap;
  final VoidCallback onNotificationViewAll;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;
  final Color primary;
  final Color surface;
  final Color accent;
  final Color subtleText;
  final double height;
  final bool isCompactActions;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: surface,
      elevation: 0,
      iconTheme: IconThemeData(color: subtleText),
      titleSpacing: isMobile ? 0 : 16,
      leading: isMobile
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
            )
          : null,
      title: Row(
        children: [
          if (!isMobile)
            Container(
              width: 8,
              height: 28,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          if (!isMobile) const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 15 : 17,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        if (showSidebarToggle)
          IconButton(
            tooltip: isSidebarCollapsed ? '展开侧边栏' : '收起侧边栏',
            icon: Icon(isSidebarCollapsed ? Icons.chevron_right : Icons.chevron_left),
            onPressed: onSidebarToggle,
          ),
        if (!isCompactActions) ...[
          Consumer<AppBadgeController>(
            builder: (context, badgeCtrl, _) {
              if (badgeCtrl.isLoading) {
                return const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
              return _AppBarChip(
                label: '今日待办 ${badgeCtrl.todoCount}',
                color: primary,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        Consumer<NotificationController>(
          builder: (context, notifyCtrl, _) {
            final unread = notifyCtrl.unreadCount;
            final label = unread > 99 ? '99+' : '$unread';
            return PopupMenuButton<String>(
              tooltip: '通知',
              offset: const Offset(0, 46),
              constraints: const BoxConstraints(minWidth: 280, maxWidth: 320),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onSelected: (value) {
                notifyCtrl.markRead(value);
              },
              itemBuilder: (context) => _buildNotificationMenuItems(
                context,
                notifyCtrl,
                accent,
                subtleText,
                primary,
                onNotificationViewAll,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Badge(
                  isLabelVisible: unread > 0,
                  label: Text(label),
                  backgroundColor: Colors.redAccent,
                  offset: const Offset(6, -6),
                  child: const Icon(Icons.notifications_none_outlined),
                ),
              ),
            );
          },
        ),
        if (!isCompactActions)
          IconButton(
            tooltip: '外观设置',
            icon: const Icon(Icons.tune_outlined),
            onPressed: onSettingTap,
          ),
        if (isCompactActions)
          PopupMenuButton<String>(
            tooltip: '更多操作',
            onSelected: (value) {
              if (value == 'settings') {
                onSettingTap();
              } else if (value == 'search') {
                // TODO: wire up search entry point.
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'search', child: Text('搜索')),
              const PopupMenuItem(value: 'settings', child: Text('外观设置')),
              PopupMenuItem(
                value: 'todo',
                child: Consumer<AppBadgeController>(
                  builder: (context, badgeCtrl, _) {
                    final label = badgeCtrl.isLoading
                        ? '今日待办加载中'
                        : '今日待办 ${badgeCtrl.todoCount}';
                    return Text(label);
                  },
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.more_vert),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _AvatarMenu(
            primary: primary,
            onProfileTap: onProfileTap,
            onLogoutTap: onLogoutTap,
          ),
        ),
      ],
    );
  }
}

List<PopupMenuEntry<String>> _buildNotificationMenuItems(
  BuildContext context,
  NotificationController controller,
  Color accent,
  Color subtleText,
  Color primary,
  VoidCallback onNotificationViewAll,
) {
  final items = <PopupMenuEntry<String>>[];
  items.add(
    PopupMenuItem<String>(
      enabled: false,
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 4),
      child: Row(
        children: [
          Text(
            '通知',
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              controller.markAllRead();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('全部已读', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    ),
  );
  items.add(const PopupMenuDivider(height: 1));
  if (controller.recentList.isEmpty) {
    items.add(
      PopupMenuItem<String>(
        enabled: false,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Text(
          '暂无通知',
          style: TextStyle(color: subtleText, fontSize: 12),
        ),
      ),
    );
    return items;
  }

  final sortedList = controller.recentList.toList()
    ..sort((a, b) {
      if (a.isRead == b.isRead) {
        return b.createdAt.compareTo(a.createdAt);
      }
      return a.isRead ? 1 : -1;
    });

  for (int i = 0; i < sortedList.length; i += 1) {
    final item = sortedList[i];
    final showDivider = i != sortedList.length - 1;
    items.add(
      PopupMenuItem<String>(
        value: item.id,
        padding: EdgeInsets.zero,
        child: _NotificationListItem(
          item: item,
          accent: accent,
          subtleText: subtleText,
          primary: primary,
          showDivider: showDivider,
          timeLabel: _formatRelativeTime(item.createdAt),
          onMarkRead: () {
            controller.markRead(item.id);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
  items.add(const PopupMenuDivider(height: 1));
  items.add(
    PopupMenuItem<String>(
      enabled: false,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
            onNotificationViewAll();
          },
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('查看全部', style: TextStyle(fontSize: 12)),
        ),
      ),
    ),
  );
  return items;
}

class _NotificationListItem extends StatelessWidget {
  const _NotificationListItem({
    required this.item,
    required this.accent,
    required this.subtleText,
    required this.primary,
    required this.showDivider,
    required this.timeLabel,
    required this.onMarkRead,
  });

  final NotificationModel item;
  final Color accent;
  final Color subtleText;
  final Color primary;
  final bool showDivider;
  final String timeLabel;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColorFor(item.level, primary);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.transparent : primary.withOpacity(0.14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: levelColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: accent,
                    fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                timeLabel,
                style: TextStyle(color: subtleText, fontSize: 11),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: '标为已读',
                icon: const Icon(Icons.done_all, size: 16),
                color: item.isRead ? subtleText : primary,
                onPressed: onMarkRead,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.content,
            style: TextStyle(color: subtleText, fontSize: 12, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Divider(height: 1, color: subtleText.withOpacity(0.2)),
            ),
        ],
      ),
    );
  }
}

class _AppBarChip extends StatelessWidget {
  const _AppBarChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11.5,
        ),
      ),
    );
  }
}

class _AvatarMenu extends StatelessWidget {
  const _AvatarMenu({
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        radius: 16,
        backgroundColor: primary.withOpacity(0.15),
        child: const Icon(Icons.person, size: 18, color: Colors.white),
      ),
    );
  }
}

String _formatRelativeTime(DateTime createdAt) {
  final diff = DateTime.now().difference(createdAt);
  if (diff.inMinutes < 1) {
    return '刚刚';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}分钟前';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours}小时前';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays}天前';
  }
  final hour = createdAt.hour.toString().padLeft(2, '0');
  final minute = createdAt.minute.toString().padLeft(2, '0');
  return '${createdAt.month}月${createdAt.day}日 $hour:$minute';
}

Color _levelColorFor(NotificationLevel level, Color primary) {
  switch (level) {
    case NotificationLevel.warning:
      return const Color(0xFFF59E0B);
    case NotificationLevel.urgent:
      return const Color(0xFFEF4444);
    case NotificationLevel.info:
    default:
      return primary;
  }
}
