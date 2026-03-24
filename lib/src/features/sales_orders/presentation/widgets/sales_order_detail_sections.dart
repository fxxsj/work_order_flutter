import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/traceability_summary_item.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/traceability_summary_section.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';

class SalesOrderInfoItem {
  const SalesOrderInfoItem(this.label, this.value);

  final String label;
  final String value;
}

class SalesOrderActionItem {
  const SalesOrderActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;
}

class SalesOrderActionMenu extends StatelessWidget {
  const SalesOrderActionMenu({
    super.key,
    required this.actions,
    this.disabled = false,
  });

  final List<SalesOrderActionItem> actions;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final available =
        actions.where((action) => action.label.trim().isNotEmpty).toList();
    if (available.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isEnabled = !disabled;

    return PopupMenuButton<int>(
      enabled: isEnabled,
      tooltip: '更多操作',
      onSelected: (index) => available[index].onTap(),
      itemBuilder: (context) => [
        for (var i = 0; i < available.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              children: [
                Icon(
                  available[i].icon,
                  size: 16,
                  color: available[i].destructive
                      ? theme.colorScheme.error
                      : theme.iconTheme.color,
                ),
                const SizedBox(width: 8),
                Text(
                  available[i].label,
                  style: available[i].destructive
                      ? TextStyle(color: theme.colorScheme.error)
                      : null,
                ),
              ],
            ),
          ),
      ],
      child: IgnorePointer(
        ignoring: true,
        child: PageActionButton.outlined(
          onPressed: isEnabled ? () {} : null,
          icon: const Icon(Icons.more_horiz, size: 16),
          label: '更多操作',
        ),
      ),
    );
  }
}

class SalesOrderOverviewSection extends StatelessWidget {
  const SalesOrderOverviewSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<SalesOrderInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(
      title: title,
      child: SalesOrderInfoGrid(items: items),
    );
  }
}

class SalesOrderInfoSection extends StatelessWidget {
  const SalesOrderInfoSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<SalesOrderInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(
      title: title,
      child: SalesOrderInfoGrid(items: items),
    );
  }
}

class SalesOrderItemsSection extends StatelessWidget {
  const SalesOrderItemsSection({
    super.key,
    required this.items,
    required this.emptyText,
  });

  final List<SalesOrderItem> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(
      title: '订单明细',
      child: items.isEmpty
          ? Text('暂无订单明细', style: Theme.of(context).textTheme.bodyMedium)
          : Column(
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DetailSectionCard(
                      title: item.productName ?? emptyText,
                      child: SalesOrderInfoGrid(
                        itemWidth: 220,
                        items: [
                          SalesOrderInfoItem(
                              '编码', item.productCode ?? emptyText),
                          SalesOrderInfoItem(
                            '数量',
                            item.quantity?.toString() ?? emptyText,
                          ),
                          SalesOrderInfoItem('单位', item.unit ?? emptyText),
                          SalesOrderInfoItem(
                            '单价',
                            item.unitPrice == null
                                ? emptyText
                                : item.unitPrice!.toStringAsFixed(2),
                          ),
                          SalesOrderInfoItem(
                            '税率',
                            item.taxRate == null
                                ? emptyText
                                : item.taxRate!.toStringAsFixed(2),
                          ),
                          SalesOrderInfoItem(
                            '折扣',
                            item.discountAmount == null
                                ? emptyText
                                : item.discountAmount!.toStringAsFixed(2),
                          ),
                          SalesOrderInfoItem(
                            '小计',
                            item.subtotal == null
                                ? emptyText
                                : item.subtotal!.toStringAsFixed(2),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class SalesOrderTraceabilitySection extends StatelessWidget {
  const SalesOrderTraceabilitySection({
    super.key,
    required this.workOrderSummaries,
    required this.deliveryOrderSummaries,
    required this.invoiceSummaries,
    required this.onOpenWorkOrder,
    required this.onOpenWorkOrderPage,
    required this.onOpenDeliveryPage,
    required this.onOpenInvoicePage,
    required this.emptyText,
  });

  final List<TraceabilitySummaryItem> workOrderSummaries;
  final List<TraceabilitySummaryItem> deliveryOrderSummaries;
  final List<TraceabilitySummaryItem> invoiceSummaries;
  final ValueChanged<TraceabilitySummaryItem> onOpenWorkOrder;
  final VoidCallback onOpenWorkOrderPage;
  final VoidCallback onOpenDeliveryPage;
  final VoidCallback onOpenInvoicePage;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return TraceabilitySummarySection(
      title: '上下游关联',
      emptyText: emptyText,
      groups: [
        TraceabilitySummaryGroupData(
          title: '关联施工单',
          items: workOrderSummaries,
          actionLabel: '施工单列表',
          onActionTap: onOpenWorkOrderPage,
          onItemTap: onOpenWorkOrder,
        ),
        TraceabilitySummaryGroupData(
          title: '关联发货单',
          items: deliveryOrderSummaries,
          actionLabel: '发货列表',
          onActionTap: onOpenDeliveryPage,
        ),
        TraceabilitySummaryGroupData(
          title: '关联发票',
          items: invoiceSummaries,
          actionLabel: '发票列表',
          onActionTap: onOpenInvoicePage,
        ),
      ],
    );
  }
}

class SalesOrderInfoGrid extends StatelessWidget {
  const SalesOrderInfoGrid({
    super.key,
    required this.items,
    this.itemWidth = 240,
  });

  final List<SalesOrderInfoItem> items;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
              width: itemWidth,
              child: SalesOrderInfoRow(label: item.label, value: item.value),
            ),
          )
          .toList(),
    );
  }
}

class SalesOrderInfoRow extends StatelessWidget {
  const SalesOrderInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
