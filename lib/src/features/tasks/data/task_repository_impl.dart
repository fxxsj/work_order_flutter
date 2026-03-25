import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._apiService);

  final TaskApiService _apiService;

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
}
