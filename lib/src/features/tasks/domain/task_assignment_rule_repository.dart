import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_lookup_data.dart';

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

  Future<TaskAssignmentRuleDto> updateRule(
    int id,
    Map<String, dynamic> payload,
  );

  Future<void> deleteRule(int id);

  Future<TaskAssignmentRuleLookupData> loadLookup();

  Future<TaskAssignmentRulePreviewData> loadPreview();

  Future<bool> getGlobalState();

  Future<bool> setGlobalState(bool enabled);
}
