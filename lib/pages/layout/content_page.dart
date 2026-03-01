import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_order_app/common/theme_ext.dart';
import 'package:work_order_app/controllers/notification_controller.dart';
import 'package:work_order_app/models/notification_model.dart';
import 'package:work_order_app/pages/layout/nav_config.dart';
import 'package:work_order_app/pages/profile.dart';
import 'package:work_order_app/utils/breakpoints_util.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key, required this.selectedId});

  final String selectedId;

  @override
  Widget build(BuildContext context) {
    if (selectedId == 'profile') {
      return const ProfilePage();
    }
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isMd = BreakpointsUtil.isMd(context);
    final isXl = BreakpointsUtil.isXl(context);
    final is2xl = BreakpointsUtil.is2xl(context);

    final primary = theme.primaryColor;
    final accent = colors.sidebarText;
    final subtleText = colors.subtleText;
    final borderColor = colors.borderColor;

    return _ContentArea(
      selectedId: selectedId,
      breadcrumb: buildBreadcrumb(selectedId),
      primary: primary,
      accent: accent,
      surface: colors.surface,
      subtleText: subtleText,
      borderColor: borderColor,
      gridCount: is2xl
          ? 4
          : isXl
              ? 3
              : isMd
                  ? 2
                  : 1,
    );
  }
}

class _ContentArea extends StatelessWidget {
  const _ContentArea({
    required this.selectedId,
    required this.breadcrumb,
    required this.primary,
    required this.accent,
    required this.surface,
    required this.subtleText,
    required this.borderColor,
    required this.gridCount,
  });

  final String selectedId;
  final List<String> breadcrumb;
  final Color primary;
  final Color accent;
  final Color surface;
  final Color subtleText;
  final Color borderColor;
  final int gridCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(
              breadcrumb: breadcrumb,
              title: labelFor(selectedId),
              primary: primary,
              accent: accent,
              surface: surface,
              subtleText: subtleText,
              borderColor: borderColor,
            ),
            const SizedBox(height: 20),
            if (selectedId == 'notifications')
              _NotificationCenterView(
                primary: primary,
                surface: surface,
                accent: accent,
                subtleText: subtleText,
                borderColor: borderColor,
              )
            else ...[
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(gridCount * 2, (index) {
                  return _StatCard(
                    width: (width - (gridCount - 1) * 16) / gridCount,
                    title: '指标 ${index + 1}',
                    value: '${(index + 1) * 12}',
                    trend: index.isEven ? '+${index + 2}%' : '-${index + 1}%',
                    primary: primary,
                    surface: surface,
                    subtleText: subtleText,
                    borderColor: borderColor,
                  );
                }),
              ),
              const SizedBox(height: 24),
              _ListPlaceholder(
                title: '核心列表区域',
                subtitle: '这里是 $selectedId 的列表或表格布局，占位用于后续业务接入。',
                primary: primary,
                surface: surface,
                subtleText: subtleText,
                borderColor: borderColor,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.breadcrumb,
    required this.title,
    required this.primary,
    required this.accent,
    required this.surface,
    required this.subtleText,
    required this.borderColor,
  });

  final List<String> breadcrumb;
  final String title;
  final Color primary;
  final Color accent;
  final Color surface;
  final Color subtleText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: breadcrumb.map((item) {
              final isLast = item == breadcrumb.last;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      color: isLast ? accent : subtleText,
                      fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.chevron_right, size: 16, color: subtleText),
                    ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 6,
                height: 28,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: accent,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _HeaderChip(label: '本月', color: primary),
              const SizedBox(width: 8),
              _HeaderChip(label: '实时', color: accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.width,
    required this.title,
    required this.value,
    required this.trend,
    required this.primary,
    required this.surface,
    required this.subtleText,
    required this.borderColor,
  });

  final double width;
  final String title;
  final String value;
  final String trend;
  final Color primary;
  final Color surface;
  final Color subtleText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final positive = trend.contains('+');
    final trendColor = positive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: subtleText, fontSize: 12)),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(color: primary, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(positive ? Icons.trending_up : Icons.trending_down, color: trendColor, size: 16),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(color: trendColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListPlaceholder extends StatelessWidget {
  const _ListPlaceholder({
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.surface,
    required this.subtleText,
    required this.borderColor,
  });

  final String title;
  final String subtitle;
  final Color primary;
  final Color surface;
  final Color subtleText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: primary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: subtleText, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 2 ? 0 : 12),
                  height: 80,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primary.withOpacity(0.08)),
                  ),
                ),
              );
            }),
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

class _NotificationCenterView extends StatelessWidget {
  const _NotificationCenterView({
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
    final controller = Get.find<NotificationController>();
    return Obx(() {
      final showUnreadOnly = controller.showUnreadOnly.value;
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
              unreadCount: controller.unreadCount.value,
              totalCount: controller.totalCount.value,
              showUnreadOnly: showUnreadOnly,
              onFilterChange: controller.setShowUnreadOnly,
              onMarkAllRead: controller.markAllRead,
              onRefresh: controller.refreshAll,
            ),
            const SizedBox(height: 12),
            if (controller.isLoading.value)
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
              if (controller.hasMore.value)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: controller.isLoadingMore.value ? null : controller.loadMore,
                    child: controller.isLoadingMore.value
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('加载更多'),
                  ),
                ),
            ],
          ],
        ),
      );
    });
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('通知中心', style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
            const SizedBox(width: 12),
            _Badge(label: '未读 $unreadCount', color: primary),
            const SizedBox(width: 6),
            _Badge(label: '总数 $totalCount', color: subtleText),
            const Spacer(),
            IconButton(
              tooltip: '刷新',
              icon: Icon(Icons.refresh, color: subtleText),
              onPressed: onRefresh,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('仅看未读'),
              selected: showUnreadOnly,
              onSelected: onFilterChange,
              selectedColor: primary.withOpacity(0.12),
              checkmarkColor: primary,
              labelStyle: TextStyle(color: showUnreadOnly ? primary : subtleText),
              side: BorderSide(color: primary.withOpacity(0.2)),
            ),
            TextButton.icon(
              onPressed: onMarkAllRead,
              icon: Icon(Icons.done_all, size: 18, color: primary),
              label: Text('全部标记已读', style: TextStyle(color: primary)),
            ),
          ],
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
        border: Border.all(color: levelColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  ),
                ),
              ),
              Text(
                _formatRelativeTime(item.createdAt),
                style: TextStyle(color: subtleText, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.content, style: TextStyle(color: subtleText, height: 1.4)),
          if (!item.isRead) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => onMarkRead(item.id),
                child: Text('标记已读', style: TextStyle(color: primary)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
