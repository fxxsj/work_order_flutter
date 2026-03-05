import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

enum SalesOrderFormMode { create, edit }

class SalesOrderFormPage extends StatelessWidget {
  const SalesOrderFormPage({super.key, required this.mode, this.orderId});

  final SalesOrderFormMode mode;
  final int? orderId;

  static const double _spacing = 12;
  static const double _sectionSpacing = 16;
  static const String _breadcrumbSeparator = ' / ';

  @override
  Widget build(BuildContext context) {
    final title = mode == SalesOrderFormMode.create ? '新建销售订单' : '编辑销售订单';
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
            const SizedBox(width: _spacing),
            PageActionButton.filled(
              onPressed: null,
              icon: const Icon(Icons.save, size: 16),
              label: '保存',
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _SectionCard(
            title: title,
            subtitle: mode == SalesOrderFormMode.create
                ? '创建销售订单流程正在建设中，将包含客户、产品明细、价格与税率录入。'
                : '编辑销售订单流程正在建设中，将支持明细与付款信息调整。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '客户与订单信息',
            subtitle: '客户选择、订单日期、交货日期等信息待接入。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '产品明细',
            subtitle: '产品、数量、单价、折扣等明细待接入。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '付款与备注',
            subtitle: '付款状态、税率、备注等信息待接入。',
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
