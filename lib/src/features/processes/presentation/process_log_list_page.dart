import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class ProcessLogListEntry extends StatelessWidget {
  const ProcessLogListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'process_logs',
        title: '工序日志',
        endpoint: '/process-logs/',
        searchHintText: '搜索工序日志',
        emptyText: '暂无工序日志',
        emptyIcon: Icons.article_outlined,
        columns: const [
          GenericColumn(label: '施工单', value: _workOrder),
          GenericColumn(label: '工序', value: _process),
          GenericColumn(label: '类型', value: _logType),
          GenericColumn(label: '操作人', value: _operator),
          GenericColumn(label: '创建时间', value: _createdAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '施工单', value: _workOrder),
          GenericSummaryField(label: '工序', value: _process),
          GenericSummaryField(label: '类型', value: _logType),
          GenericSummaryField(label: '操作人', value: _operator),
        ],
        titleBuilder: _logType,
      ),
    );
  }

  static String _workOrder(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('work_order') ?? record.getString('work_order'));
  }

  static String _process(GenericRecord record) {
    return GenericValueFormatter.text(record.getNumber('process') ?? record.getString('process'));
  }

  static String _logType(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('log_type_display'));
  }

  static String _operator(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('operator_name'));
  }

  static String _createdAt(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('created_at'));
  }
}
