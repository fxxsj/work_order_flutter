import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/page_registry.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key, required this.selectedId});

  final String selectedId;

  @override
  Widget build(BuildContext context) {
    final fullPage = buildFullPage(selectedId);
    if (fullPage != null) {
      return fullPage;
    }
    if (selectedId == 'dashboard') {
      return const _DashboardPage();
    }

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final style = ContentAreaStyle(
      primary: theme.colorScheme.primary,
      surface: colors.surface,
      accent: colors.sidebarText,
      subtleText: colors.subtleText,
      borderColor: colors.borderColor,
    );

    return _ContentArea(
      selectedId: selectedId,
      style: style,
      bodyBuilder: buildContentBody(selectedId),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  static const List<String> _quickIds = [
    'workorders',
    'tasks_list',
    'sales_orders',
    'delivery',
    'quality',
    'notifications',
  ];

  static const List<String> _spotlightIds = [
    'products',
    'customers',
    'purchase_orders',
    'statements',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;
    final leaves = leafNavItemsByBranch();
    final quickEntries = _quickIds
        .map((id) => leaves.where((item) => item.id == id).firstOrNull)
        .whereType<NavItem>()
        .toList();
    final spotlightEntries = _spotlightIds
        .map((id) => leaves.where((item) => item.id == id).firstOrNull)
        .whereType<NavItem>()
        .toList();
    final groups = navItems
        .where((item) => item.showInSidebar)
        .where((item) => item.children.isNotEmpty)
        .take(4)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final narrow = constraints.maxWidth < 640;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            narrow ? 16 : 24,
            narrow ? 16 : 20,
            narrow ? 16 : 24,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardHero(
                title: '工作台',
                subtitle: _todayLabel(),
                primary: scheme.primary,
                accent: colors.sidebarText,
                borderColor: colors.borderColor,
                surface: colors.surface,
              ),
              const SizedBox(height: 16),
              if (compact) ...[
                _QuickEntrySection(
                  entries: quickEntries,
                  surface: colors.surface,
                  borderColor: colors.borderColor,
                  accent: colors.sidebarText,
                  subtleText: colors.subtleText,
                  primary: scheme.primary,
                ),
                const SizedBox(height: 16),
                _SimpleModuleSection(
                  entries: spotlightEntries,
                  surface: colors.surface,
                  borderColor: colors.borderColor,
                  accent: colors.sidebarText,
                  subtleText: colors.subtleText,
                  primary: scheme.primary,
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 13,
                      child: _QuickEntrySection(
                        entries: quickEntries,
                        surface: colors.surface,
                        borderColor: colors.borderColor,
                        accent: colors.sidebarText,
                        subtleText: colors.subtleText,
                        primary: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 7,
                      child: _SimpleModuleSection(
                        entries: spotlightEntries,
                        surface: colors.surface,
                        borderColor: colors.borderColor,
                        accent: colors.sidebarText,
                        subtleText: colors.subtleText,
                        primary: scheme.primary,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              _GroupPanel(
                groups: groups,
                surface: colors.surface,
                borderColor: colors.borderColor,
                accent: colors.sidebarText,
                subtleText: colors.subtleText,
                primary: scheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return '${now.month} 月 ${now.day} 日 ${weekdays[now.weekday - 1]}';
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.accent,
    required this.borderColor,
    required this.surface,
  });

  final String title;
  final String subtitle;
  final Color primary;
  final Color accent;
  final Color borderColor;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusXl),
        border: Border.all(color: borderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final badgeWrap = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _TinyBadge(
                label: subtitle,
                color: accent,
                background: primary.withValues(alpha: 0.08),
              ),
            ],
          );

          final titleBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                  ),
                  child:
                      Icon(Icons.dashboard_outlined, color: primary, size: 18),
                ),
                const SizedBox(height: 12),
                titleBlock,
                const SizedBox(height: 12),
                badgeWrap,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                ),
                child: Icon(Icons.dashboard_outlined, color: primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: titleBlock),
              const SizedBox(width: 10),
              badgeWrap,
            ],
          );
        },
      ),
    );
  }
}

class _QuickEntrySection extends StatelessWidget {
  const _QuickEntrySection({
    required this.entries,
    required this.surface,
    required this.borderColor,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final List<NavItem> entries;
  final Color surface;
  final Color borderColor;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      title: '常用入口',
      subtitle: '优先处理高频操作。',
      surface: surface,
      borderColor: borderColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final item in entries)
                _QuickEntryCard(
                  item: item,
                  width: compact
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 12) / 2,
                  accent: accent,
                  subtleText: subtleText,
                  primary: primary,
                  borderColor: borderColor,
                  surface: surface,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SimpleModuleSection extends StatelessWidget {
  const _SimpleModuleSection({
    required this.entries,
    required this.surface,
    required this.borderColor,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final List<NavItem> entries;
  final Color surface;
  final Color borderColor;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      title: '常用模块',
      subtitle: '少量保留，避免首页过载。',
      surface: surface,
      borderColor: borderColor,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _SimpleNavRow(
              item: entries[i],
              accent: accent,
              subtleText: subtleText,
              primary: primary,
            ),
            if (i != entries.length - 1)
              Divider(height: 20, color: borderColor),
          ],
        ],
      ),
    );
  }
}

class _GroupPanel extends StatelessWidget {
  const _GroupPanel({
    required this.groups,
    required this.surface,
    required this.borderColor,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final List<NavItem> groups;
  final Color surface;
  final Color borderColor;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      title: '全部模块',
      subtitle: '按模块进入处理。',
      surface: surface,
      borderColor: borderColor,
      child: Column(
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            _GroupRow(
              group: groups[i],
              accent: accent,
              subtleText: subtleText,
              primary: primary,
            ),
            if (i != groups.length - 1) Divider(height: 22, color: borderColor),
          ],
        ],
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  const _ContentArea({
    required this.selectedId,
    required this.style,
    required this.bodyBuilder,
  });

  final String selectedId;
  final ContentAreaStyle style;
  final ContentBodyBuilder? bodyBuilder;

  @override
  Widget build(BuildContext context) {
    final padding = LayoutTokens.pagePadding(context);
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bodyBuilder != null)
            bodyBuilder!(context, style)
          else
            _ModulePlaceholder(
              title: labelFor(selectedId),
              style: style,
            ),
        ],
      ),
    );
  }
}

class _ModulePlaceholder extends StatelessWidget {
  const _ModulePlaceholder({
    required this.title,
    required this.style,
  });

  final String title;
  final ContentAreaStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = LayoutTokens.cardPadding(context);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: style.surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: style.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: style.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '当前模块入口已接入统一布局。',
            style:
                theme.textTheme.bodySmall?.copyWith(color: style.subtleText),
          ),
        ],
      ),
    );
  }
}

class _PanelShell extends StatelessWidget {
  const _PanelShell({
    required this.title,
    required this.subtitle,
    required this.surface,
    required this.borderColor,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Color surface;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final padding = LayoutTokens.cardPadding(context);

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.sidebarText,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.subtleText,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
          ] else
            const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _QuickEntryCard extends StatelessWidget {
  const _QuickEntryCard({
    required this.item,
    required this.width,
    required this.accent,
    required this.subtleText,
    required this.primary,
    required this.borderColor,
    required this.surface,
  });

  final NavItem item;
  final double width;
  final Color accent;
  final Color subtleText;
  final Color primary;
  final Color borderColor;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.path == null ? null : () => context.go(item.path!),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusXl),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
          border: Border.all(color: borderColor),
          color: surface,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
              ),
              child: Icon(item.icon, color: primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '进入处理',
                    style: TextStyle(color: subtleText, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: subtleText, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SimpleNavRow extends StatelessWidget {
  const _SimpleNavRow({
    required this.item,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final NavItem item;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.path == null ? null : () => context.go(item.path!),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '进入',
              style: TextStyle(color: subtleText, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  const _GroupRow({
    required this.group,
    required this.accent,
    required this.subtleText,
    required this.primary,
  });

  final NavItem group;
  final Color accent;
  final Color subtleText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(group.icon, size: 18, color: primary),
            const SizedBox(width: 10),
            Text(
              group.label,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final child in group.children)
              _RoutePill(
                item: child,
                primary: primary,
                subtleText: subtleText,
              ),
          ],
        ),
      ],
    );
  }
}

class _RoutePill extends StatelessWidget {
  const _RoutePill({
    required this.item,
    required this.primary,
    required this.subtleText,
  });

  final NavItem item;
  final Color primary;
  final Color subtleText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: item.path == null ? null : () => context.go(item.path!),
      borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
        ),
        child: Text(
          item.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: subtleText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
