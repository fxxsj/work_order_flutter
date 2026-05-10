import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

class TaskBoardSupportService {
  TaskBoardSupportService(this._client);

  final ApiClient _client;

  Future<List<TaskDepartmentOption>> fetchDepartments() async {
    final result = await DepartmentApiService(
      _client,
    ).fetchDepartments(page: 1, pageSize: 200);
    return result.items
        .map(
          (item) => TaskDepartmentOption(
            id: item.id,
            name: item.name,
            processIds: item.processIds,
          ),
        )
        .toList();
  }

  Future<void> updateQuantity(int taskId, Map<String, dynamic> payload) {
    return TaskApiService(_client).updateQuantity(taskId, payload);
  }

  Future<void> completeTask(int taskId, Map<String, dynamic> payload) {
    return TaskApiService(_client).complete(taskId, payload);
  }
}
