import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';

class DeliveryItemListEntry extends StatelessWidget {
  const DeliveryItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'delivery_items',
        title: '发货明细',
        endpoint: '/delivery-items/',
        searchHintText: '搜索发货明细/产品',
        emptyText: '暂无发货明细',
        emptyIcon: Icons.local_shipping_outlined,
        columns: const [
          GenericColumn(label: '发货单', value: _orderId),
          GenericColumn(label: '产品名称', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '数量', value: _quantity, numeric: true),
          GenericColumn(label: '备注', value: _notes),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品名称', value: _productName),
          GenericSummaryField(label: '产品编码', value: _productCode),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '备注', value: _notes),
        ],
        titleBuilder: _productName,
        rowActionsBuilder: (context, record, openDetails) {
          final actions = <RowAction>[
            RowAction(label: '查看', onPressed: openDetails),
          ];
          final orderId = record.getNumber('delivery_order') ??
              int.tryParse(record.getString('delivery_order') ?? '');
          if (orderId != null && orderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看发货单',
              icon: Icons.local_shipping_outlined,
              onPressed: () => _openDeliveryOrderDialog(context, orderId.toInt()),
            ));
          }
          return actions;
        },
      ),
    );
  }

  static String _orderId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('delivery_order') ?? record.getString('delivery_order'));
  }

  static String _productName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_name'));
  }

  static String _productCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_code'));
  }

  static String _quantity(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('quantity'));
  }

  static String _notes(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('notes'));
  }

  static Future<void> _openDeliveryOrderDialog(
    BuildContext context,
    int orderId,
  ) async {
    final apiClient = context.read<ApiClient>();
    final apiService = DeliveryOrderApiService(apiClient);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('发货单详情'),
        content: FutureBuilder<DeliveryOrderDetail>(
          future: apiService.fetchDetail(orderId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                width: 520,
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return SizedBox(
                width: 520,
                child: Text('加载失败: ${snapshot.error ?? '未知错误'}'),
              );
            }
            final detail = snapshot.data!;
            return SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: '发货单号', value: detail.orderNumber),
                    _DetailRow(
                        label: '客户', value: detail.customerName ?? '-'),
                    _DetailRow(
                        label: '状态',
                        value: detail.statusDisplay ?? detail.status ?? '-'),
                    _DetailRow(
                        label: '销售单号',
                        value: detail.salesOrderNumber ?? '-'),
                    _DetailRow(
                        label: '发货日期',
                        value: _formatDate(detail.deliveryDate)),
                    _DetailRow(
                        label: '收货人', value: detail.receiverName ?? '-'),
                    _DetailRow(
                        label: '物流公司',
                        value: detail.logisticsCompany ?? '-'),
                    _DetailRow(
                        label: '运单号', value: detail.trackingNumber ?? '-'),
                    if ((detail.notes ?? '').trim().isNotEmpty)
                      _DetailRow(label: '备注', value: detail.notes ?? ''),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime? value) {
    if (value == null) return '-';
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
