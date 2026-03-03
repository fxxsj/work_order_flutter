import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/features/notification/application/notification_view_model.dart';
import 'package:work_order_app/src/features/notification/domain/notification_model.dart';

class NotificationCenterView extends StatelessWidget {
  const NotificationCenterView({
    super.key,
    required this.primary,
    required this.surface,
    required this.accent,
    required this.subtleText,
    required this.borderColor,
  });

  final Color primary;
  final Color surface;
  final Color accent;
  final Color subtleText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationViewModel>(
      builder: (context, controller, _) {
        final showUnreadOnly = controller.showUnreadOnly;
        final allItems = controller.notifications.toList();
        final items = showUnreadOnly
            ? allItems.where((item) => !item.isRead).toList()
            : allItems;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationToolbar(
                primary: primary,
                accent: accent,
                subtleText: subtleText,
                unreadCount: controller.unreadCount,
                totalCount: controller.totalCount,
                showUnreadOnly: showUnreadOnly,
                onFilterChange: controller.setShowUnreadOnly,
                onMarkAllRead: controller.markAllRead,
                onRefresh: controller.refreshAll,
              ),
              const SizedBox(height: 12),
              if (controller.isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(color: primary),
                  ),
                )
              else if (items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('暂无通知', style: TextStyle(color: subtleText)),
                  ),
                )
              else ...[
                ...items.map(
                  (item) => _NotificationListItem(
                    item: item,
                    primary: primary,
                    surface: surface,
                    subtleText: subtleText,
                    accent: accent,
                    onMarkRead: controller.markRead,
                  ),
                ),
                if (controller.hasMore)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: controller.isLoadingMore ? null : controller.loadMore,
                      child: controller.isLoadingMore
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('加载更多'),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _NotificationToolbar extends StatelessWidget {
  const _NotificationToolbar({
    required this.primary,
    required this.accent,
    required this.subtleText,
    required this.unreadCount,
    required this.totalCount,
    required this.showUnreadOnly,
    required this.onFilterChange,
    required this.onMarkAllRead,
    required this.onRefresh,
  });

  final Color primary;
  final Color accent;
  final Color subtleText;
  final int unreadCount;
  final int totalCount;
  final bool showUnreadOnly;
  final ValueChanged<bool> onFilterChange;
  final VoidCallback onMarkAllRead;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '通知中心',
          style: TextStyle(fontWeight: FontWeight.w700, color: accent, fontSize: 16),
        ),
        Text('未读 $unreadCount / 总数 $totalCount', style: TextStyle(color: subtleText)),
        FilterChip(
          label: const Text('仅看未读'),
          selected: showUnreadOnly,
          onSelected: onFilterChange,
        ),
        TextButton.icon(
          onPressed: onMarkAllRead,
          icon: const Icon(Icons.done_all, size: 18),
          label: const Text('全部已读'),
        ),
        OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('刷新'),
        ),
      ],
    );
  }
}

class _NotificationListItem extends StatelessWidget {
  const _NotificationListItem({
    required this.item,
    required this.primary,
    required this.surface,
    required this.subtleText,
    required this.accent,
    required this.onMarkRead,
  });

  final NotificationModel item;
  final Color primary;
  final Color surface;
  final Color subtleText;
  final Color accent;
  final ValueChanged<String> onMarkRead;

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColorFor(item.level, primary);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.isRead ? Colors.transparent : levelColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: item.isRead ? Colors.transparent : levelColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(fontWeight: FontWeight.w700, color: accent),
                ),
                const SizedBox(height: 6),
                Text(item.content, style: TextStyle(color: subtleText, height: 1.4)),
                const SizedBox(height: 8),
                Text(_formatRelativeTime(item.createdAt), style: TextStyle(color: subtleText, fontSize: 12)),
              ],
            ),
          ),
          if (!item.isRead)
            TextButton(
              onPressed: () => onMarkRead(item.id),
              child: const Text('标记已读'),
            ),
        ],
      ),
    );
  }
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
