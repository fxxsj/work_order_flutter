import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_loading_indicator.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/notification_time_utils.dart';
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

        final theme = Theme.of(context);
        return Container(
          padding: LayoutTokens.cardPadding(context),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
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
              SizedBox(height: LayoutTokens.gapMd),
              if (controller.isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: LayoutTokens.gapXl),
                    child: AppLoadingIndicator(color: primary),
                  ),
                )
              else if (items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: LayoutTokens.gapXl),
                  decoration: BoxDecoration(
                    color: primary.withAlpha(10),
                    borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                  ),
                  child: Center(
                    child: Text(
                      '暂无通知',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: subtleText),
                    ),
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
                      onPressed:
                          controller.isLoadingMore ? null : controller.loadMore,
                      child: controller.isLoadingMore
                          ? const AppLoadingIndicator(
                              centered: false,
                              size: LayoutTokens.iconXl,
                            )
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
    final theme = Theme.of(context);
    return Wrap(
      spacing: LayoutTokens.gapMd,
      runSpacing: LayoutTokens.gapMd,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '通知中心',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        ),
        Text(
          '未读 $unreadCount / 总数 $totalCount',
          style: theme.textTheme.bodySmall?.copyWith(color: subtleText),
        ),
        FilterChip(
          label: const Text('仅看未读'),
          selected: showUnreadOnly,
          onSelected: onFilterChange,
        ),
        TextButton.icon(
          onPressed: onMarkAllRead,
          style: TextButton.styleFrom(
            foregroundColor: primary,
          ),
          icon: Icon(Icons.done_all, size: 18, color: primary),
          label: Text('全部已读', style: TextStyle(color: primary)),
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
    final semantic = Theme.of(context).extension<AppSemanticColors>();
    final theme = Theme.of(context);
    final levelColor = _levelColorFor(item.level, primary, semantic);
    return Container(
      margin: EdgeInsets.only(bottom: LayoutTokens.gapMd),
      padding: LayoutTokens.cardPadding(context),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        border: Border.all(
          color: item.isRead
              ? levelColor.withValues(alpha: OpacityTokens.invisible)
              : levelColor.withValues(alpha: OpacityTokens.scrim),
        ),
        boxShadow: [
          BoxShadow(
            color: (semantic?.shadowStrong ?? theme.shadowColor).withValues(
              alpha: OpacityTokens.faint,
            ),
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
            margin: EdgeInsets.only(top: LayoutTokens.gapSm),
            decoration: BoxDecoration(
              color: item.isRead
                  ? levelColor.withValues(alpha: OpacityTokens.invisible)
                  : levelColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: LayoutTokens.gapMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
                SizedBox(height: LayoutTokens.gapSm),
                Text(
                  item.content,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subtleText,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                Text(
                  formatRelativeTime(item.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: subtleText,
                  ),
                ),
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

Color _levelColorFor(
  NotificationLevel level,
  Color primary,
  AppSemanticColors? semantic,
) {
  switch (level) {
    case NotificationLevel.warning:
      return semantic?.warning ?? const Color(0xFF8a8f98); // inkSubtle
    case NotificationLevel.urgent:
      return semantic?.danger ?? const Color(0xFFef4444); // danger
    case NotificationLevel.info:
      return primary;
  }
}
