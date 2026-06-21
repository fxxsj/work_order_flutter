import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_dto.dart';
import 'package:work_order_app/src/features/tasks/data/task_list_support_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task_list_filter_options.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._apiService, this._supportService);

  final TaskApiService _apiService;
  final TaskListSupportService _supportService;

  @override
  Future<TaskPageDto> getTasks({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? priority,
    String? taskType,
    int? departmentId,
    int? assignedOperatorId,
    int? processId,
    String? workOrderNumber,
    String? workContent,
    String? departmentName,
    String? operatorName,
    bool? isDraft,
    String? ordering,
    String? todo,
  }) {
    return _apiService.fetchTasks(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      priority: priority,
      taskType: taskType,
      departmentId: departmentId,
      assignedOperatorId: assignedOperatorId,
      processId: processId,
      workOrderNumber: workOrderNumber,
      workContent: workContent,
      departmentName: departmentName,
      operatorName: operatorName,
      isDraft: isDraft,
      ordering: ordering,
      todo: todo,
    );
  }

  @override
  Future<Map<String, dynamic>> getSummary({
    String? search,
    String? status,
    String? priority,
    int? departmentId,
    int? processId,
    String? todo,
  }) {
    return _apiService.fetchSummary(
      search: search,
      status: status,
      priority: priority,
      departmentId: departmentId,
      processId: processId,
      todo: todo,
    );
  }

  @override
  Future<TaskListFilterOptions> loadFilterOptions() {
    return _supportService.loadFilterOptions();
  }

  @override
  Future<TaskExportResult> export(Map<String, dynamic> params) {
    return _supportService.export(params);
  }

  @override
  Future<List<Map<String, dynamic>>> loadOperators(int departmentId) {
    return _supportService.loadOperators(departmentId);
  }

  @override
  Future<List<TaskDepartmentOption>> loadProcessDepartments(int processId) {
    return _supportService.loadProcessDepartments(processId);
  }

  @override
  Future<void> updateQuantity(int taskId, Map<String, dynamic> payload) {
    return _supportService.updateQuantity(taskId, payload);
  }

  @override
  Future<void> completeTask(int taskId, Map<String, dynamic> payload) {
    return _supportService.completeTask(taskId, payload);
  }

  @override
  Future<void> assignTask(
    int taskId, {
    required int operatorId,
    required String notes,
  }) {
    return _supportService.assignTask(
      taskId,
      operatorId: operatorId,
      notes: notes,
    );
  }
}
