import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';

class TaskBoardSupportService {
  TaskBoardSupportService(this._client);

  final ApiClient _client;

  Future<List<Department>> fetchDepartments() async {
    final result = await DepartmentApiService(
      _client,
    ).fetchDepartments(page: 1, pageSize: 200);
    return result.items.map((item) => item.toEntity()).toList();
  }

  Future<void> updateQuantity(int taskId, Map<String, dynamic> payload) {
    return TaskApiService(_client).updateQuantity(taskId, payload);
  }

  Future<void> completeTask(int taskId, Map<String, dynamic> payload) {
    return TaskApiService(_client).complete(taskId, payload);
  }
}
