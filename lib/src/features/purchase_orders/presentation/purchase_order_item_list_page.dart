import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

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
}
