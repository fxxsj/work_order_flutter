import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';

abstract class TaskAssignmentRuleRepository {
  Future<TaskAssignmentRulePageDto> getRules({
    int page = 1,
    int pageSize = 20,
    String? search,
    int? processId,
    int? departmentId,
    bool? isActive,
    String? ordering,
  });

  Future<TaskAssignmentRuleDto> createRule(TaskAssignmentRuleDto dto);

  Future<TaskAssignmentRuleDto> updateRule(int id, Map<String, dynamic> payload);

  Future<void> deleteRule(int id);

  Future<Map<String, dynamic>> preview({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getGlobalState();

  Future<Map<String, dynamic>> setGlobalState(bool enabled);
}
