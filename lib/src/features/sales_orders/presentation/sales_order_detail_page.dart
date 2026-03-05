import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

class SalesOrderDetailPage extends StatelessWidget {
  const SalesOrderDetailPage({super.key, required this.orderId});

  final int orderId;

  static const double _spacing = 12;
  static const double _sectionSpacing = 16;
  static const String _breadcrumbSeparator = ' / ';

  @override
  Widget build(BuildContext context) {
    final breadcrumb = [...buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    ), '详情'];

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
            const SizedBox(width: _spacing),
            PageActionButton.filled(
              onPressed: () => context.go('/sales-orders/$orderId/edit'),
              icon: const Icon(Icons.edit, size: 16),
              label: '编辑',
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _SectionCard(
            title: '销售订单 #$orderId',
            subtitle: '详情页正在建设中，将补充客户、明细、付款与施工单关联信息。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '客户信息',
            subtitle: '客户联系人、电话、地址等信息将在此展示。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '订单明细',
            subtitle: '产品明细、数量、价格、税率等信息将在此展示。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '付款与状态',
            subtitle: '付款记录、审核状态、生产状态将在此展示。',
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
