import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';

class PurchaseOrderItemListEntry extends StatelessWidget {
  const PurchaseOrderItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'purchase_order_items',
        title: '采购明细',
        endpoint: '/purchase-order-items/',
        searchHintText: '搜索采购明细/物料',
        emptyText: '暂无采购明细',
        emptyIcon: Icons.playlist_add_check_outlined,
        columns: const [
          GenericColumn(label: '采购单', value: _orderId),
          GenericColumn(label: '物料名称', value: _materialName),
          GenericColumn(label: '物料编码', value: _materialCode),
          GenericColumn(label: '数量', value: _quantity, numeric: true),
          GenericColumn(label: '单价', value: _unitPrice, numeric: true),
          GenericColumn(label: '小计', value: _subtotal, numeric: true),
          GenericColumn(label: '状态', value: _status),
        ],
        summaryFields: const [
          GenericSummaryField(label: '物料名称', value: _materialName),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '单价', value: _unitPrice),
          GenericSummaryField(label: '状态', value: _status),
        ],
        titleBuilder: _materialName,
        rowActionsBuilder: (context, record, openDetails) {
          final actions = <RowAction>[
            RowAction(label: '查看', onPressed: openDetails),
          ];
          final orderId = record.getNumber('purchase_order') ??
              int.tryParse(record.getString('purchase_order') ?? '');
          if (orderId != null && orderId.toInt() > 0) {
            actions.add(RowAction(
              label: '查看采购单',
              icon: Icons.receipt_long_outlined,
              onPressed: () => _openPurchaseOrderDialog(context, orderId.toInt()),
            ));
          }
          return actions;
        },
      ),
    );
  }

  static String _orderId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('purchase_order') ?? record.getString('purchase_order'));
  }

  static String _materialName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_name'));
  }

  static String _materialCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_code'));
  }

  static String _quantity(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('quantity'));
  }

  static String _unitPrice(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('unit_price'));
  }

  static String _subtotal(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('subtotal'));
  }

  static String _status(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('status_display'));
  }

  static Future<void> _openPurchaseOrderDialog(
    BuildContext context,
    int orderId,
  ) async {
    final apiClient = context.read<ApiClient>();
    final apiService = PurchaseOrderApiService(apiClient);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('采购单详情'),
        content: FutureBuilder<PurchaseOrderDetail>(
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
                    _DetailRow(label: '采购单号', value: detail.orderNumber),
                    _DetailRow(
                        label: '供应商',
                        value: detail.supplierName ?? '-'),
                    _DetailRow(
                        label: '状态',
                        value: detail.statusDisplay ?? detail.status ?? '-'),
                    _DetailRow(
                        label: '关联施工单',
                        value: detail.workOrderNumber ?? '-'),
                    _DetailRow(
                        label: '预计到货',
                        value: _formatDate(detail.expectedDate)),
                    _DetailRow(
                        label: '下单日期',
                        value: _formatDate(detail.orderedDate)),
                    _DetailRow(
                        label: '总金额',
                        value: _formatAmount(detail.totalAmount)),
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

  static String _formatAmount(double? value) {
    if (value == null) return '-';
    return value.toStringAsFixed(2);
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
