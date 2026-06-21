import 'package:work_order_app/src/features/tasks/data/task_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task_list_filter_options.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

abstract class TaskRepository {
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
  });

  Future<Map<String, dynamic>> getSummary({
    String? search,
    String? status,
    String? priority,
    int? departmentId,
    int? processId,
    String? todo,
  });

  Future<TaskListFilterOptions> loadFilterOptions();

  Future<TaskExportResult> export(Map<String, dynamic> params);

  Future<List<Map<String, dynamic>>> loadOperators(int departmentId);

  Future<List<TaskDepartmentOption>> loadProcessDepartments(int processId);

  Future<void> updateQuantity(int taskId, Map<String, dynamic> payload);

  Future<void> completeTask(int taskId, Map<String, dynamic> payload);

  Future<void> assignTask(
    int taskId, {
    required int operatorId,
    required String notes,
  });
}
