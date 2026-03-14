import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';

class ApprovalStepListEntry extends StatelessWidget {
  const ApprovalStepListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericResourceListEntry(
      config: GenericResourceConfig(
        id: 'approval_steps',
        title: '审批步骤',
        endpoint: '/approval-steps/',
        searchHintText: '搜索步骤/施工单',
        emptyText: '暂无审批步骤',
        emptyIcon: Icons.fact_check_outlined,
        columns: const [
          GenericColumn(label: '施工单号', value: _workOrderNumber),
          GenericColumn(label: '工作流', value: _workflowName),
          GenericColumn(label: '步骤', value: _stepName),
          GenericColumn(label: '状态', value: _status),
          GenericColumn(label: '负责人', value: _assignee),
          GenericColumn(label: '开始时间', value: _startedAt),
          GenericColumn(label: '完成时间', value: _completedAt),
        ],
        summaryFields: const [
          GenericSummaryField(label: '工作流', value: _workflowName),
          GenericSummaryField(label: '步骤', value: _stepName),
          GenericSummaryField(label: '状态', value: _status),
          GenericSummaryField(label: '负责人', value: _assignee),
        ],
        titleBuilder: _stepName,
      ),
    );
  }

  static String _workOrderNumber(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('work_order_number'));
  }

  static String _workflowName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('workflow_name'));
  }

  static String _stepName(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('step_name'));
  }

  static String _status(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('status'));
  }

  static String _assignee(GenericRecord record) {
    return GenericValueFormatter.text(record.getString('assigned_to_name'));
  }

  static String _startedAt(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('started_at'));
  }

  static String _completedAt(GenericRecord record) {
    return GenericValueFormatter.date(record.getString('completed_at'));
  }
}
