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
            borderRadius: BorderRadius.circular(RadiusTokens.sm),
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
                notificationTypeFilter: controller.notificationTypeFilter,
                priorityFilter: controller.priorityFilter,
                ordering: controller.ordering,
                searchQuery: controller.searchQuery,
                onFilterChange: controller.setShowUnreadOnly,
                onTypeFilterChange: controller.setNotificationTypeFilter,
                onPriorityFilterChange: controller.setPriorityFilter,
                onOrderingChange: controller.setOrdering,
                onSearchChange: controller.setSearchQuery,
                onClearFilters: controller.clearFilters,
                onMarkAllRead: controller.markAllRead,
                onRefresh: controller.refreshAll,
              ),
              SizedBox(height: SpacingTokens.md),
              if (controller.isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: SpacingTokens.xl),
                    child: AppLoadingIndicator(color: primary),
                  ),
                )
              else if (items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: SpacingTokens.xl),
                  decoration: BoxDecoration(
                    color: primary.withAlpha(10),
                    borderRadius: BorderRadius.circular(RadiusTokens.sm),
                  ),
                  child: Center(
                    child: Text(
                      '暂无通知',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: subtleText,
                      ),
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
                      onPressed: controller.isLoadingMore
                          ? null
                          : controller.loadMore,
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
    required this.notificationTypeFilter,
    required this.priorityFilter,
    required this.ordering,
    required this.searchQuery,
    required this.onFilterChange,
    required this.onTypeFilterChange,
    required this.onPriorityFilterChange,
    required this.onOrderingChange,
    required this.onSearchChange,
    required this.onClearFilters,
    required this.onMarkAllRead,
    required this.onRefresh,
  });

  final Color primary;
  final Color accent;
  final Color subtleText;
  final int unreadCount;
  final int totalCount;
  final bool showUnreadOnly;
  final String? notificationTypeFilter;
  final String? priorityFilter;
  final String ordering;
  final String searchQuery;
  final ValueChanged<bool> onFilterChange;
  final ValueChanged<String?> onTypeFilterChange;
  final ValueChanged<String?> onPriorityFilterChange;
  final ValueChanged<String> onOrderingChange;
  final ValueChanged<String> onSearchChange;
  final VoidCallback onClearFilters;
  final VoidCallback onMarkAllRead;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: SpacingTokens.md,
      runSpacing: SpacingTokens.md,
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
        SizedBox(
          width: 220,
          child: _SearchField(value: searchQuery, onSubmitted: onSearchChange),
        ),
        _ToolbarDropdown(
          value: notificationTypeFilter ?? '',
          options: _notificationTypeOptions,
          onChanged: onTypeFilterChange,
        ),
        _ToolbarDropdown(
          value: priorityFilter ?? '',
          options: _priorityOptions,
          onChanged: onPriorityFilterChange,
        ),
        _ToolbarDropdown(
          value: ordering,
          options: _orderingOptions,
          onChanged: (value) {
            if (value != null && value.isNotEmpty) onOrderingChange(value);
          },
        ),
        TextButton(onPressed: onClearFilters, child: const Text('重置')),
        TextButton.icon(
          onPressed: onMarkAllRead,
          style: TextButton.styleFrom(foregroundColor: primary),
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

class _SearchField extends StatefulWidget {
  const _SearchField({required this.value, required this.onSubmitted});

  final String value;
  final ValueChanged<String> onSubmitted;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: widget.value.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        isDense: true,
        prefixIcon: Icon(Icons.search, size: 18),
        hintText: '搜索标题或内容',
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onSubmitted,
    );
  }
}

class _ToolbarDropdown extends StatelessWidget {
  const _ToolbarDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<DropdownMenuItem<String>> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: options,
      onChanged: onChanged,
    );
  }
}

const _notificationTypeOptions = [
  DropdownMenuItem(value: '', child: Text('全部类型')),
  DropdownMenuItem(value: 'workorder_created', child: Text('施工单创建')),
  DropdownMenuItem(value: 'workorder_updated', child: Text('施工单更新')),
  DropdownMenuItem(value: 'approval_passed', child: Text('审核通过')),
  DropdownMenuItem(value: 'approval_rejected', child: Text('审核拒绝')),
  DropdownMenuItem(value: 'approval_requested', child: Text('请求审核')),
  DropdownMenuItem(value: 'task_assigned', child: Text('任务分派')),
  DropdownMenuItem(value: 'task_overdue', child: Text('任务逾期')),
  DropdownMenuItem(value: 'process_completed', child: Text('工序完成')),
  DropdownMenuItem(value: 'low_stock_warning', child: Text('库存不足预警')),
  DropdownMenuItem(value: 'system', child: Text('系统通知')),
];

const _priorityOptions = [
  DropdownMenuItem(value: '', child: Text('全部优先级')),
  DropdownMenuItem(value: 'low', child: Text('低')),
  DropdownMenuItem(value: 'normal', child: Text('普通')),
  DropdownMenuItem(value: 'high', child: Text('高')),
  DropdownMenuItem(value: 'urgent', child: Text('紧急')),
];

const _orderingOptions = [
  DropdownMenuItem(value: '-created_at', child: Text('最新优先')),
  DropdownMenuItem(value: 'created_at', child: Text('最早优先')),
  DropdownMenuItem(value: 'is_read,-created_at', child: Text('未读优先')),
  DropdownMenuItem(value: '-priority,-created_at', child: Text('高优先级优先')),
];

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
      margin: EdgeInsets.only(bottom: SpacingTokens.md),
      padding: LayoutTokens.cardPadding(context),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
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
            margin: EdgeInsets.only(top: SpacingTokens.sm),
            decoration: BoxDecoration(
              color: item.isRead
                  ? levelColor.withValues(alpha: OpacityTokens.invisible)
                  : levelColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: SpacingTokens.md),
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
                SizedBox(height: SpacingTokens.sm),
                Text(
                  item.content,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subtleText,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: SpacingTokens.md),
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
