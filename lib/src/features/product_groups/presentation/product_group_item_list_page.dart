import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class ProductGroupItemListEntry extends StatelessWidget {
  const ProductGroupItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'product_group_items',
        title: '产品组子项',
        endpoint: '/product-group-items/',
        searchHintText: '搜索产品组/产品',
        emptyText: '暂无产品组子项',
        emptyIcon: Icons.layers_outlined,
        columns: const [
          GenericColumn(label: '产品组', value: _groupName),
          GenericColumn(label: '产品组编码', value: _groupCode),
          GenericColumn(label: '产品', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '子项名称', value: _itemName),
          GenericColumn(label: '排序', value: _sortOrder),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品组', value: _groupName),
          GenericSummaryField(label: '产品', value: _productName),
          GenericSummaryField(label: '子项名称', value: _itemName),
          GenericSummaryField(label: '排序', value: _sortOrder),
        ],
        titleBuilder: _itemName,
      ),
    );
  }

  static String _groupName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_group_name'));
  }

  static String _groupCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_group_code'));
  }

  static String _productName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_name'));
  }

  static String _productCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_code'));
  }

  static String _itemName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('item_name'));
  }

  static String _sortOrder(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('sort_order'));
  }
}
