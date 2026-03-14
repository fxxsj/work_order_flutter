import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class MaterialSupplierListEntry extends StatelessWidget {
  const MaterialSupplierListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'material_suppliers',
        title: '物料供应商',
        endpoint: '/material-suppliers/',
        searchHintText: '搜索物料/供应商',
        emptyText: '暂无物料供应商关联',
        emptyIcon: Icons.handshake_outlined,
        columns: const [
          GenericColumn(label: '物料名称', value: _materialName),
          GenericColumn(label: '物料编码', value: _materialCode),
          GenericColumn(label: '供应商名称', value: _supplierName),
          GenericColumn(label: '供应商编码', value: _supplierCode),
          GenericColumn(label: '价格', value: _price),
          GenericColumn(label: '起订量', value: _minOrder),
        ],
        summaryFields: const [
          GenericSummaryField(label: '物料名称', value: _materialName),
          GenericSummaryField(label: '供应商名称', value: _supplierName),
          GenericSummaryField(label: '价格', value: _price),
          GenericSummaryField(label: '起订量', value: _minOrder),
        ],
        titleBuilder: _materialName,
      ),
    );
  }

  static String _materialName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_name'));
  }

  static String _materialCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_code'));
  }

  static String _supplierName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('supplier_name'));
  }

  static String _supplierCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('supplier_code'));
  }

  static String _price(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('supplier_price'));
  }

  static String _minOrder(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('min_order_quantity'));
  }
}
