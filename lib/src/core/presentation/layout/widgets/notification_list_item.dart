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
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    final levelColor = _levelColorFor(item.level, primary, semantic);
    final titleStyle = theme.textTheme.bodySmall?.copyWith(
      color: accent,
      fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
    );
    final timeStyle = theme.textTheme.labelSmall?.copyWith(color: subtleText);
    final contentStyle = theme.textTheme.bodySmall?.copyWith(
      color: subtleText,
      height: 1.4,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        LayoutTokens.gapMd,
        LayoutTokens.gapSm,
        LayoutTokens.gapMd,
        LayoutTokens.gapSm,
      ),
      decoration: BoxDecoration(
        color:
            item.isRead ? Colors.transparent : primary.withValues(alpha: 0.14),
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
              SizedBox(width: LayoutTokens.gapSm),
              Expanded(
                child: Text(
                  item.title,
                  style: titleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: LayoutTokens.gapSm),
              Text(
                timeLabel,
                style: timeStyle,
              ),
              SizedBox(width: LayoutTokens.gapSm),
              IconButton(
                tooltip: '标为已读',
                icon: const Icon(Icons.done_all, size: 16),
                color: item.isRead ? subtleText : primary,
                onPressed: onMarkRead,
              ),
            ],
          ),
          SizedBox(height: LayoutTokens.gapSm),
          Text(
            item.content,
            style: contentStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(top: LayoutTokens.gapSm),
              child:
                  Divider(height: 1, color: subtleText.withValues(alpha: 0.2)),
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
      return semantic?.warning ?? ColorTokens.warning;
    case NotificationLevel.urgent:
      return semantic?.danger ?? ColorTokens.danger;
    case NotificationLevel.info:
      return primary;
  }
}
