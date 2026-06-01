import 'package:work_order_app/src/core/utils/parse_utils.dart';

class TaskAssignmentRule {
  const TaskAssignmentRule({
    required this.id,
    required this.processId,
    required this.departmentId,
    required this.priority,
    required this.operatorSelectionStrategy,
    required this.isActive,
    this.processName,
    this.processCode,
    this.departmentName,
    this.departmentCode,
    this.operatorSelectionStrategyDisplay,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int processId;
  final int departmentId;
  final int priority;
  final String operatorSelectionStrategy;
  final bool isActive;
  final String? processName;
  final String? processCode;
  final String? departmentName;
  final String? departmentCode;
  final String? operatorSelectionStrategyDisplay;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TaskAssignmentRule.fromJson(Map<String, dynamic> json) {
    return TaskAssignmentRule(
      id: toInt(json['id']) ?? 0,
      processId: toInt(json['process']) ?? 0,
      departmentId: toInt(json['department']) ?? 0,
      priority: toInt(json['priority']) ?? 0,
      operatorSelectionStrategy:
          toStringOrNull(json['operator_selection_strategy']) ?? 'least_tasks',
      isActive: json['is_active'] == true,
      processName: toStringOrNull(json['process_name']),
      processCode: toStringOrNull(json['process_code']),
      departmentName: toStringOrNull(json['department_name']),
      departmentCode: toStringOrNull(json['department_code']),
      operatorSelectionStrategyDisplay: toStringOrNull(
        json['operator_selection_strategy_display'],
      ),
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }
}
