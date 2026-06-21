import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_support_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_lookup_data.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_repository.dart';

class TaskAssignmentRuleRepositoryImpl implements TaskAssignmentRuleRepository {
  TaskAssignmentRuleRepositoryImpl(this._apiService, this._supportService);

  final TaskAssignmentRuleApiService _apiService;
  final TaskAssignmentRuleSupportService _supportService;

  @override
  Future<TaskAssignmentRulePageDto> getRules({
    int page = 1,
    int pageSize = 20,
    String? search,
    int? processId,
    int? departmentId,
    bool? isActive,
    String? ordering,
  }) {
    return _apiService.fetchRules(
      page: page,
      pageSize: pageSize,
      search: search,
      processId: processId,
      departmentId: departmentId,
      isActive: isActive,
      ordering: ordering,
    );
  }

  @override
  Future<TaskAssignmentRuleDto> createRule(TaskAssignmentRuleDto dto) {
    return _apiService.createRule(dto);
  }

  @override
  Future<TaskAssignmentRuleDto> updateRule(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateRule(id, payload);
  }

  @override
  Future<void> deleteRule(int id) {
    return _apiService.deleteRule(id);
  }

  @override
  Future<TaskAssignmentRuleLookupData> loadLookup() {
    return _supportService.loadLookup();
  }

  @override
  Future<TaskAssignmentRulePreviewData> loadPreview() {
    return _supportService.loadPreview();
  }

  @override
  Future<bool> getGlobalState() {
    return _supportService.getGlobalState();
  }

  @override
  Future<bool> setGlobalState(bool enabled) {
    return _supportService.setGlobalState(enabled);
  }
}
