import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/features/notification/domain/notification_model.dart';

/// List item for the notification popup menu in [AppHeader].
class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    super.key,
    required this.item,
    required this.accent,
    required this.subtleText,
    required this.primary,
    required this.showDivider,
    required this.timeLabel,
    required this.onAction,
  });

  final NotificationModel item;
  final Color accent;
  final Color subtleText;
  final Color primary;
  final bool showDivider;
  final String timeLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    final levelColor = _levelColorFor(item.level, primary, semantic);
    final actionIcon = item.isRead ? Icons.delete_outline : Icons.done_all;
    final actionTooltip = item.isRead ? '删除通知' : '标为已读';
    final actionColor = item.isRead ? subtleText : primary;

    // Main content style is more prominent
    final contentStyle = theme.textTheme.bodyMedium?.copyWith(
      color: accent,
      fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
    );
    // Time style is more subtle
    final timeStyle = theme.textTheme.labelSmall?.copyWith(color: subtleText);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: LayoutTokens.gapMd,
            vertical: LayoutTokens.gapSm,
          ),
          decoration: BoxDecoration(
            color:
                item.isRead ? Colors.transparent : semantic?.unreadBackground,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 8,
                height: 8,
                child: item.isRead
                    ? null
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          color: levelColor,
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
              SizedBox(width: LayoutTokens.gapMd),

              // Content and Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.content,
                      style: contentStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: LayoutTokens.gapXs),
                    Text(
                      timeLabel,
                      style: timeStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(width: LayoutTokens.gapSm),

              // Mark as read button
              IconButton(
                tooltip: actionTooltip,
                icon: Icon(actionIcon, size: 16),
                color: actionColor,
                onPressed: onAction,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: subtleText.withValues(alpha: OpacityTokens.distinct),
          ),
      ],
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
      return semantic?.warning ?? ColorTokens.warning;
    case NotificationLevel.urgent:
      return semantic?.danger ?? ColorTokens.danger;
    case NotificationLevel.info:
      return primary;
  }
}
