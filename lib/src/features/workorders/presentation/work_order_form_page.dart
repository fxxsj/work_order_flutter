import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

enum WorkOrderFormMode { create, edit }

class WorkOrderFormPage extends StatelessWidget {
  const WorkOrderFormPage({super.key, required this.mode, this.workOrderId});

  final WorkOrderFormMode mode;
  final int? workOrderId;

  static const double _spacing = 12;
  static const double _sectionSpacing = 16;
  static const String _breadcrumbSeparator = ' / ';

  @override
  Widget build(BuildContext context) {
    final title = mode == WorkOrderFormMode.create ? '新建施工单' : '编辑施工单';
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
            subtitle: mode == WorkOrderFormMode.create
                ? '创建施工单流程正在建设中，将包含客户、产品、工序、物料等信息录入。'
                : '编辑施工单流程正在建设中，将支持核心字段编辑与重新审核。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '基本信息',
            subtitle: '客户、订单号、交货日期、优先级等字段待接入。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '产品与工序',
            subtitle: '产品清单、工序配置、同步任务预览待接入。',
          ),
          const SizedBox(height: _sectionSpacing),
          const _SectionCard(
            title: '物料与备注',
            subtitle: '物料需求、采购信息、备注信息待接入。',
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
