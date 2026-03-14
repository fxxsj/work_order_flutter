import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class ProductMaterialListEntry extends StatelessWidget {
  const ProductMaterialListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'product_materials',
        title: '产品物料关系',
        endpoint: '/product-materials/',
        searchHintText: '搜索产品/物料',
        emptyText: '暂无产品物料关系',
        emptyIcon: Icons.link_outlined,
        columns: const [
          GenericColumn(label: '产品ID', value: _productId),
          GenericColumn(label: '物料名称', value: _materialName),
          GenericColumn(label: '物料编码', value: _materialCode),
          GenericColumn(label: '用量', value: _quantity),
          GenericColumn(label: '单位', value: _unit),
        ],
        summaryFields: const [
          GenericSummaryField(label: '物料名称', value: _materialName),
          GenericSummaryField(label: '物料编码', value: _materialCode),
          GenericSummaryField(label: '用量', value: _quantity),
          GenericSummaryField(label: '单位', value: _unit),
        ],
        titleBuilder: _materialName,
      ),
    );
  }

  static String _productId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('product') ?? record.getString('product'));
  }

  static String _materialName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_name'));
  }

  static String _materialCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('material_code'));
  }

  static String _quantity(GenericRecord record) {
    final value = record.getNumber('quantity') ?? record.getNumber('material_usage');
    return GenericValueFormatter.text(value);
  }

  static String _unit(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('unit'));
  }
}
