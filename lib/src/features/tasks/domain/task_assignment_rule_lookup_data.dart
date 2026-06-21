import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

class TaskAssignmentRuleLookupData {
  const TaskAssignmentRuleLookupData({
    required this.processes,
    required this.departments,
  });

  final List<Process> processes;
  final List<TaskDepartmentOption> departments;
}

class TaskAssignmentRulePreviewData {
  const TaskAssignmentRulePreviewData({
    required this.previewItems,
    required this.globalEnabled,
  });

  final List<Map<String, dynamic>> previewItems;
  final bool? globalEnabled;
}
