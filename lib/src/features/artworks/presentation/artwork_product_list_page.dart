import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class ArtworkProductListEntry extends StatelessWidget {
  const ArtworkProductListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'artwork_products',
        title: '图稿关联产品',
        endpoint: '/artwork-products/',
        searchHintText: '搜索图稿/产品',
        emptyText: '暂无图稿关联产品',
        emptyIcon: Icons.image_outlined,
        columns: const [
          GenericColumn(label: '图稿', value: _artworkId),
          GenericColumn(label: '产品名称', value: _productName),
          GenericColumn(label: '产品编码', value: _productCode),
          GenericColumn(label: '拼版数量', value: _imposition),
          GenericColumn(label: '排序', value: _sortOrder),
        ],
        summaryFields: const [
          GenericSummaryField(label: '产品名称', value: _productName),
          GenericSummaryField(label: '产品编码', value: _productCode),
          GenericSummaryField(label: '拼版数量', value: _imposition),
          GenericSummaryField(label: '排序', value: _sortOrder),
        ],
        titleBuilder: _productName,
      ),
    );
  }

  static String _artworkId(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('artwork') ?? record.getString('artwork'));
  }

  static String _productName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_name'));
  }

  static String _productCode(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('product_code'));
  }

  static String _imposition(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('imposition_quantity'));
  }

  static String _sortOrder(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('sort_order'));
  }
}
