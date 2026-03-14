import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class EmbossingPlateProductListEntry extends StatelessWidget {
  const EmbossingPlateProductListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'embossing_plate_products',
        title: '压凸版关联产品',
        endpoint: '/embossing-plate-products/',
        searchHintText: '搜索压凸版/产品',
        emptyText: '暂无压凸版关联产品',
        emptyIcon: Icons.texture_outlined,
        columns: const [
          GenericColumn(label: '压凸版', value: _plateId),
          GenericColumn(label: '产品名称', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '数量', value: _quantity),
          GenericColumn(label: '排序', value: _sortOrder),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品名称', value: _productName),
          GenericSummaryField(label: '产品编码', value: _productCode),
          GenericSummaryField(label: '数量', value: _quantity),
          GenericSummaryField(label: '排序', value: _sortOrder),
        ],
        titleBuilder: _productName,
      ),
    );
  }

  static String _plateId(GenericRecord record) {
    return GenericValueFormatter.text(
        record.getNumber('embossing_plate') ?? record.getString('embossing_plate'));
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

  static String _sortOrder(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('sort_order'));
  }
}
