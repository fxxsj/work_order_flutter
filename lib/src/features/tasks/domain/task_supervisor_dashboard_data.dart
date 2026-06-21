import 'package:work_order_app/src/features/tasks/domain/task.dart';

class TaskSupervisorFlowSummary {
  const TaskSupervisorFlowSummary({
    this.pendingInspections = 0,
    this.exceptionInspections = 0,
    this.pendingReceipts = 0,
    this.rejectedDeliveries = 0,
  });

  final int pendingInspections;
  final int exceptionInspections;
  final int pendingReceipts;
  final int rejectedDeliveries;
}

class TaskSupervisorOperatorOption {
  const TaskSupervisorOperatorOption({required this.id, required this.name});

  final int id;
  final String name;

  factory TaskSupervisorOperatorOption.fromJson(Map<String, dynamic> json) {
    final id = _toInt(json['id']);
    final first = json['first_name']?.toString() ?? '';
    final last = json['last_name']?.toString() ?? '';
    final username = json['username']?.toString() ?? '';
    final fullName = '$first$last'.trim();
    final name = fullName.isNotEmpty
        ? fullName
        : (username.isNotEmpty ? username : '操作员 $id');
    return TaskSupervisorOperatorOption(id: id, name: name);
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class TaskSupervisorDashboardData {
  const TaskSupervisorDashboardData({
    required this.workload,
    required this.tasks,
    required this.operators,
    required this.flowSummary,
  });

  final Map<String, dynamic> workload;
  final List<Task> tasks;
  final List<TaskSupervisorOperatorOption> operators;
  final TaskSupervisorFlowSummary flowSummary;
}
