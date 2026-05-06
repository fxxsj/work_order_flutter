import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/controllers/app_badge_controller.dart';
import 'package:work_order_app/src/features/notification/application/notification_view_model.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_bar_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/avatar_menu.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/notification_list_item.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/notification_time_utils.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.isMobile,
    required this.showSidebarToggle,
    required this.isSidebarCollapsed,
    required this.onSidebarToggle,
    required this.appTitle,
    required this.sectionTitle,
    required this.onMenuTap,
    required this.onSettingTap,
    required this.onNotificationViewAll,
    required this.onProfileTap,
    required this.onLogoutTap,
    required this.primary,
    required this.surface,
    required this.accent,
    required this.subtleText,
    required this.borderColor,
    required this.height,
    required this.isCompactActions,
    required this.showAppTitle,
  });

  final bool isMobile;
  final bool showSidebarToggle;
  final bool isSidebarCollapsed;
  final VoidCallback onSidebarToggle;
  final String appTitle;
  final String sectionTitle;
  final VoidCallback onMenuTap;
  final VoidCallback onSettingTap;
  final VoidCallback onNotificationViewAll;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;
  final Color primary;
  final Color surface;
  final Color accent;
  final Color subtleText;
  final Color borderColor;
  final double height;
  final bool isCompactActions;
  final bool showAppTitle;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    final appTitleStyle = theme.textTheme.labelSmall?.copyWith(
      color: subtleText,
      fontWeight: FontWeight.w600,
    );
    final sectionStyle =
        (isMobile ? theme.textTheme.titleSmall : theme.textTheme.titleMedium)
            ?.copyWith(
      color: accent,
      fontWeight: FontWeight.w700,
    );
    return AppBar(
      primary: isMobile,
      backgroundColor: surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: Border(
        bottom: BorderSide(color: borderColor.withValues(alpha: 0.75)),
      ),
      toolbarHeight: height,
      iconTheme: IconThemeData(color: subtleText),
      titleSpacing: isMobile ? 0 : 8,
      leading: isMobile
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
            )
          : null,
      title: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile && showAppTitle)
                  Text(
                    appTitle,
                    style: appTitleStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  sectionTitle,
                  style: sectionStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (showSidebarToggle)
          IconButton(
            tooltip: isSidebarCollapsed ? '展开侧边栏' : '收起侧边栏',
            visualDensity: VisualDensity.compact,
            icon: Icon(
              isSidebarCollapsed ? Icons.chevron_right : Icons.chevron_left,
            ),
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
              return AppBarChip(
                label: '今日待办 ${badgeCtrl.todoCount}',
                color: primary,
              );
            },
          ),
          const SizedBox(width: 4),
        ],
        Consumer<NotificationViewModel>(
          builder: (context, notifyCtrl, _) {
            final unread = notifyCtrl.unreadCount;
            final label = unread > 99 ? '99+' : '$unread';
            return PopupMenuButton<String>(
              tooltip: '通知',
              offset: const Offset(0, 46),
              constraints: const BoxConstraints(minWidth: 280, maxWidth: 320),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusMd)),
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
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Badge(
                  isLabelVisible: unread > 0,
                  label: Text(label),
                  backgroundColor: semantic?.danger ?? ColorTokens.danger,
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
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.tune_outlined),
            onPressed: onSettingTap,
          ),
        if (isCompactActions)
          PopupMenuButton<String>(
            tooltip: '更多操作',
            onSelected: (value) {
              if (value == 'settings') {
                onSettingTap();
              }
            },
            itemBuilder: (context) => [
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: LayoutTokens.gapSm),
              child: Icon(Icons.more_vert),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            right: LayoutTokens.gapMd,
            left: LayoutTokens.gapXs,
          ),
          child: AvatarMenu(
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
  NotificationViewModel controller,
  Color accent,
  Color subtleText,
  Color primary,
  VoidCallback onNotificationViewAll,
) {
  final theme = Theme.of(context);
  final headerStyle = theme.textTheme.titleSmall?.copyWith(
    color: accent,
    fontWeight: FontWeight.w600,
  );
  final actionStyle = theme.textTheme.labelSmall ?? theme.textTheme.bodySmall;
  final emptyStyle = theme.textTheme.bodySmall?.copyWith(color: subtleText);
  final items = <PopupMenuEntry<String>>[];
  items.add(
    PopupMenuItem<String>(
      enabled: false,
      padding: EdgeInsets.fromLTRB(
        LayoutTokens.gapMd,
        LayoutTokens.gapSm,
        LayoutTokens.gapSm,
        LayoutTokens.gapXs,
      ),
      child: Row(
        children: [
          Text(
            '通知',
            style: headerStyle,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              controller.markAllRead();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.symmetric(
                horizontal: LayoutTokens.gapSm,
                vertical: LayoutTokens.gapXs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('全部已读', style: actionStyle),
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
        padding: EdgeInsets.all(LayoutTokens.gapMd),
        child: Text(
          '暂无通知',
          style: emptyStyle,
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
        child: NotificationListItem(
          item: item,
          accent: accent,
          subtleText: subtleText,
          primary: primary,
          showDivider: showDivider,
          timeLabel: formatRelativeTime(item.createdAt),
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
      padding: EdgeInsets.fromLTRB(
        LayoutTokens.gapMd,
        LayoutTokens.gapSm,
        LayoutTokens.gapMd,
        LayoutTokens.gapSm,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
            onNotificationViewAll();
          },
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(
              horizontal: LayoutTokens.gapSm,
              vertical: LayoutTokens.gapXs,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('查看全部', style: actionStyle),
        ),
      ),
    ),
  );
  return items;
}
