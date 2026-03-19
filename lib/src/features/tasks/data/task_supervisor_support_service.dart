import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';

class TaskSupervisorDashboardData {
  const TaskSupervisorDashboardData({
    required this.workload,
    required this.tasks,
    required this.operators,
  });

  final Map<String, dynamic> workload;
  final List<Task> tasks;
  final List<TaskSupervisorOperatorOption> operators;
}

class TaskSupervisorOperatorOption {
  const TaskSupervisorOperatorOption({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory TaskSupervisorOperatorOption.fromJson(Map<String, dynamic> json) {
    final id = _toInt(json['id']);
    final first = json['first_name']?.toString() ?? '';
    final last = json['last_name']?.toString() ?? '';
    final username = json['username']?.toString() ?? '';
    final fullName = '$first$last'.trim();
    final name = fullName.isNotEmpty
        ? fullName
        : (username.isNotEmpty ? username : '操作员 $id');
    return TaskSupervisorOperatorOption(id: id, name: name);
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class TaskSupervisorSupportService {
  TaskSupervisorSupportService(this._client);

  final ApiClient _client;

  Future<List<Department>> fetchDepartments() async {
    final page = await DepartmentApiService(
      _client,
    ).fetchDepartments(page: 1, pageSize: 200);
    return page.items.map((dto) => dto.toEntity()).toList();
  }

  Future<TaskSupervisorDashboardData> loadDepartmentDashboard(
    int departmentId,
  ) async {
    final api = TaskApiService(_client);
    final workload = await api.fetchDepartmentWorkload(params: {
      'department_id': departmentId,
    });
    final tasksPage = await api.fetchTasks(
      departmentId: departmentId,
      page: 1,
      pageSize: 50,
      ordering: '-created_at',
    );
    final operators = await api.fetchDepartmentOperators(departmentId);
    return TaskSupervisorDashboardData(
      workload: workload,
      tasks: tasksPage.items.map((dto) => dto.toEntity()).toList(),
      operators: operators
          .map((item) => TaskSupervisorOperatorOption.fromJson(item))
          .where((item) => item.id > 0)
          .toList(),
    );
  }

  Future<void> assignTask(
    int taskId, {
    required int operatorId,
    required String notes,
  }) {
    return TaskApiService(_client).assign(taskId, {
      'operator_id': operatorId,
      'notes': notes,
    });
  }
}
