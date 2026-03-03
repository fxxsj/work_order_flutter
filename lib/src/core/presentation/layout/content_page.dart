import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/core/presentation/layout/page_registry.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key, required this.selectedId});

  final String selectedId;

  @override
  Widget build(BuildContext context) {
    final fullPage = buildFullPage(selectedId);
    if (fullPage != null) {
      return fullPage;
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
    final style = ContentAreaStyle(
      primary: primary,
      surface: colors.surface,
      accent: accent,
      subtleText: subtleText,
      borderColor: borderColor,
    );

    return _ContentArea(
      selectedId: selectedId,
      breadcrumb: buildBreadcrumb(selectedId),
      primary: primary,
      accent: accent,
      surface: style.surface,
      subtleText: subtleText,
      borderColor: borderColor,
      style: style,
      bodyBuilder: buildContentBody(selectedId),
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
    required this.style,
    required this.bodyBuilder,
  });

  final String selectedId;
  final List<String> breadcrumb;
  final Color primary;
  final Color accent;
  final Color surface;
  final Color subtleText;
  final Color borderColor;
  final int gridCount;
  final ContentAreaStyle style;
  final ContentBodyBuilder? bodyBuilder;

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
            if (bodyBuilder != null)
              bodyBuilder!(context, style)
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
