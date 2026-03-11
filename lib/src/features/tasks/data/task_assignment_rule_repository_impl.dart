import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_api_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task_assignment_rule_repository.dart';

class TaskAssignmentRuleRepositoryImpl implements TaskAssignmentRuleRepository {
  TaskAssignmentRuleRepositoryImpl(this._apiService);

  final TaskAssignmentRuleApiService _apiService;

  @override
  Future<Map<String, dynamic>> preview({Map<String, dynamic>? params}) {
    return _apiService.preview(params: params);
  }

  @override
  Future<Map<String, dynamic>> getGlobalState() {
    return _apiService.getGlobalState();
  }

  @override
  Future<Map<String, dynamic>> setGlobalState(bool enabled) {
    return _apiService.setGlobalState(enabled);
  }
}
