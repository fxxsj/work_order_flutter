import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class DieProductListEntry extends StatelessWidget {
  const DieProductListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'die_products',
        title: '刀模关联产品',
        endpoint: '/die-products/',
        searchHintText: '搜索刀模/产品',
        emptyText: '暂无刀模关联产品',
        emptyIcon: Icons.cut_outlined,
        columns: const [
          GenericColumn(label: '刀模', value: _dieId),
          GenericColumn(label: '产品名称', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '数量', value: _quantity),
          GenericColumn(label: '关系类型', value: _relationType),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品名称', value: _productName),
          GenericSummaryField(label: '产品编码', value: _productCode),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '关系类型', value: _relationType),
        ],
        titleBuilder: _productName,
      ),
    );
  }

  static String _dieId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('die') ?? record.getString('die'));
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

  static String _relationType(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('relation_type_display'));
  }
}
