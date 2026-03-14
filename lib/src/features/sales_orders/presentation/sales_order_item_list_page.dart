import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class SalesOrderItemListEntry extends StatelessWidget {
  const SalesOrderItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'sales_order_items',
        title: '销售明细',
        endpoint: '/sales-order-items/',
        searchHintText: '搜索销售明细/产品',
        emptyText: '暂无销售明细',
        emptyIcon: Icons.list_alt_outlined,
        columns: const [
          GenericColumn(label: '销售订单', value: _orderId),
          GenericColumn(label: '产品名称', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '数量', value: _quantity, numeric: true),
          GenericColumn(label: '单价', value: _unitPrice, numeric: true),
          GenericColumn(label: '小计', value: _subtotal, numeric: true),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品名称', value: _productName),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '单价', value: _unitPrice),
          GenericSummaryField(label: '小计', value: _subtotal),
        ],
        titleBuilder: _productName,
      ),
    );
  }

  static String _orderId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('sales_order') ?? record.getString('sales_order'));
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

  static String _unitPrice(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('unit_price'));
  }

  static String _subtotal(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('subtotal'));
  }
}
