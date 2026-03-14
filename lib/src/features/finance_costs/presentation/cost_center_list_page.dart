import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class CostCenterListEntry extends StatelessWidget {
  const CostCenterListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'cost_centers',
        title: '成本中心',
        endpoint: '/cost-centers/',
        searchHintText: '搜索成本中心名称/编码',
        emptyText: '暂无成本中心',
        emptyIcon: Icons.account_tree_outlined,
        columns: const [
          GenericColumn(label: '编码', value: _code),
          GenericColumn(label: '名称', value: _name),
          GenericColumn(label: '类型', value: _type),
          GenericColumn(label: '负责人', value: _manager),
          GenericColumn(label: '上级', value: _parent),
          GenericColumn(label: '启用', value: _active),
        ],
        summaryFields: const [
          GenericSummaryField(label: '类型', value: _type),
          GenericSummaryField(label: '负责人', value: _manager),
          GenericSummaryField(label: '上级', value: _parent),
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

  static String _manager(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('manager_name'));
  }

  static String _parent(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('parent_name'));
  }

  static String _active(GenericRecord record) {
    return GenericValueFormatter.boolText(record.getBool('is_active'));
  }
}
