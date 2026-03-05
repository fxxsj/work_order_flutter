import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

class TaskPlaceholderPage extends StatelessWidget {
  const TaskPlaceholderPage({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  static const double _spacing = 12;
  static const double _sectionSpacing = 16;
  static const String _breadcrumbSeparator = ' / ';

  @override
  Widget build(BuildContext context) {
    final breadcrumb = [...buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    ), title];

    return ListPageScaffold(
      spacing: _spacing,
      header: PageHeaderBar(
        breadcrumb: breadcrumb.join(_breadcrumbSeparator),
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PageActionButton.outlined(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: '返回',
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _SectionCard(title: title, subtitle: description),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '建设计划',
            subtitle: '该模块将按照 Web 端页面结构逐步补齐筛选、表格、操作与统计组件。',
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(subtitle, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
