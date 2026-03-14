import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

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
}
