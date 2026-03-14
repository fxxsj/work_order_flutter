import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class CostItemListEntry extends StatelessWidget {
  const CostItemListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'cost_items',
        title: '成本项目',
        endpoint: '/cost-items/',
        searchHintText: '搜索成本项目名称/编码',
        emptyText: '暂无成本项目',
        emptyIcon: Icons.receipt_long_outlined,
        columns: const [
          GenericColumn(label: '编码', value: _code),
          GenericColumn(label: '名称', value: _name),
          GenericColumn(label: '类型', value: _type),
          GenericColumn(label: '分摊方式', value: _allocation),
          GenericColumn(label: '启用', value: _active),
        ],
        summaryFields: const [
          GenericSummaryField(label: '类型', value: _type),
          GenericSummaryField(label: '分摊方式', value: _allocation),
          GenericSummaryField(label: '启用', value: _active),
        ],
        titleBuilder: _name,
      ),
    );
  }

  static String _code(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('code'));
  }

  static String _name(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('name'));
  }

  static String _type(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('type_display'));
  }

  static String _allocation(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('allocation_method_display'));
  }

  static String _active(GenericRecord record) {
    return GenericValueFormatter.boolText(record.getBool('is_active'));
  }
}
