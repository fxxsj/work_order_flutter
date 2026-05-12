import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule.dart';

/// 分派规则默认常量
const kTaskAssignmentRuleDefaults = (
  priority: 50,
  strategy: 'least_tasks',
);

class TaskAssignmentRuleDto {
  TaskAssignmentRuleDto({
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

  factory TaskAssignmentRuleDto.fromJson(Map<String, dynamic> json) {
    return TaskAssignmentRuleDto(
      id: toInt(json['id']) ?? 0,
      processId: toInt(json['process']) ?? 0,
      departmentId: toInt(json['department']) ?? 0,
      priority: toInt(json['priority']) ?? 50,
      operatorSelectionStrategy:
          toStringOrNull(json['operator_selection_strategy']) ?? 'least_tasks',
      isActive: json['is_active'] == true,
      processName: toStringOrNull(json['process_name']),
      processCode: toStringOrNull(json['process_code']),
      departmentName: toStringOrNull(json['department_name']),
      departmentCode: toStringOrNull(json['department_code']),
      operatorSelectionStrategyDisplay:
          toStringOrNull(json['operator_selection_strategy_display']),
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }

  /// 创建新规则时的默认值
  factory TaskAssignmentRuleDto.createDefault({
    required int processId,
    required int departmentId,
    int priority = 50,
    String operatorSelectionStrategy = 'least_tasks',
    bool isActive = true,
  }) {
    return TaskAssignmentRuleDto(
      id: 0,
      processId: processId,
      departmentId: departmentId,
      priority: priority,
      operatorSelectionStrategy: operatorSelectionStrategy,
      isActive: isActive,
    );
  }

  factory TaskAssignmentRuleDto.fromEntity(TaskAssignmentRule entity) {
    return TaskAssignmentRuleDto(
      id: entity.id,
      processId: entity.processId,
      departmentId: entity.departmentId,
      priority: entity.priority,
      operatorSelectionStrategy: entity.operatorSelectionStrategy,
      isActive: entity.isActive,
      processName: entity.processName,
      processCode: entity.processCode,
      departmentName: entity.departmentName,
      departmentCode: entity.departmentCode,
      operatorSelectionStrategyDisplay: entity.operatorSelectionStrategyDisplay,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TaskAssignmentRule toEntity() {
    return TaskAssignmentRule(
      id: id,
      processId: processId,
      departmentId: departmentId,
      priority: priority,
      operatorSelectionStrategy: operatorSelectionStrategy,
      isActive: isActive,
      processName: processName,
      processCode: processCode,
      departmentName: departmentName,
      departmentCode: departmentCode,
      operatorSelectionStrategyDisplay: operatorSelectionStrategyDisplay,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'process': processId,
      'department': departmentId,
      'priority': priority,
      'operator_selection_strategy': operatorSelectionStrategy,
      'is_active': isActive,
      'notes': notes,
    };
  }
}

class TaskAssignmentRulePageDto {
  const TaskAssignmentRulePageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<TaskAssignmentRuleDto> items;
  final int total;
  final int page;
  final int pageSize;
}
