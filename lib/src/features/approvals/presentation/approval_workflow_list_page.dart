import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class ApprovalWorkflowListEntry extends StatelessWidget {
  const ApprovalWorkflowListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'approval_workflows',
        title: '审批工作流',
        endpoint: '/approval-workflows/',
        searchHintText: '搜索工作流名称/类型',
        emptyText: '暂无审批工作流',
        emptyIcon: Icons.route_outlined,
        columns: const [
          GenericColumn(label: '名称', value: _name),
          GenericColumn(label: '类型', value: _type),
          GenericColumn(label: '启用', value: _active),
          GenericColumn(label: '创建人', value: _createdBy),
          GenericColumn(label: '创建时间', value: _createdAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '类型', value: _type),
          GenericSummaryField(label: '启用', value: _active),
          GenericSummaryField(label: '创建人', value: _createdBy),
          GenericSummaryField(label: '创建时间', value: _createdAt),
        ],
        titleBuilder: _name,
      ),
    );
  }

  static String _name(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('name'));
  }

  static String _type(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('workflow_type'));
  }

  static String _active(GenericRecord record) {
    return GenericValueFormatter.boolText(record.getBool('is_active'));
  }

  static String _createdBy(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('created_by_name'));
  }

  static String _createdAt(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('created_at'));
  }
}
