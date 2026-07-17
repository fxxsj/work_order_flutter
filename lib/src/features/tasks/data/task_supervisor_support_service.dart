import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_quality/data/quality_inspection_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_supervisor_dashboard_data.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

class TaskSupervisorSupportService {
  TaskSupervisorSupportService(this._client);

  static const int taskPageSize = 50;

  final ApiClient _client;

  Future<List<TaskDepartmentOption>> fetchDepartments() async {
    final page = await DepartmentApiService(
      _client,
    ).fetchDepartments(page: 1, pageSize: 50);
    return page.items
        .map((dto) => TaskDepartmentOption(id: dto.id, name: dto.name))
        .toList();
  }

  Future<TaskSupervisorDashboardData> loadDepartmentDashboard(
    int departmentId, {
    int taskPage = 1,
  }) async {
    final api = TaskApiService(_client);
    final workloadFuture = api.fetchDepartmentWorkload(
      params: {'department_id': departmentId},
    );
    final operatorsFuture = api.fetchDepartmentOperators(departmentId);
    final flowSummaryFuture = _loadFlowSummary(departmentId: departmentId);

    final workload = await workloadFuture;
    final tasksPage = await api.fetchTasks(
      departmentId: departmentId,
      page: taskPage,
      pageSize: taskPageSize,
      ordering: '-created_at',
    );
    final operators = await operatorsFuture;
    final flowSummary = await flowSummaryFuture;
    return TaskSupervisorDashboardData(
      workload: workload,
      tasks: tasksPage.items.map((dto) => dto.toEntity()).toList(),
      taskTotal: tasksPage.total,
      taskPage: tasksPage.page,
      taskPageSize: tasksPage.pageSize,
      operators: operators
          .map((item) => TaskSupervisorOperatorOption.fromJson(item))
          .where((item) => item.id > 0)
          .toList(),
      flowSummary: flowSummary,
    );
  }

  Future<List<Task>> loadDepartmentBoardTasks(int departmentId) async {
    final api = TaskApiService(_client);
    final tasks = <Task>[];
    var page = 1;
    while (true) {
      final taskPage = await api.fetchTasks(
        departmentId: departmentId,
        page: page,
        pageSize: taskPageSize,
        ordering: '-created_at',
      );
      tasks.addAll(taskPage.items.map((dto) => dto.toEntity()));
      if (tasks.length >= taskPage.total || taskPage.items.isEmpty) break;
      page += 1;
    }
    return tasks;
  }

  Future<void> assignTask(
    int taskId, {
    required int operatorId,
    required String notes,
  }) {
    return TaskApiService(
      _client,
    ).assignToOperator(taskId, operatorId: operatorId, notes: notes);
  }

  Future<TaskSupervisorFlowSummary> _loadFlowSummary({
    int? departmentId,
  }) async {
    try {
      final qualityApi = QualityInspectionApiService(_client);
      final deliveryApi = DeliveryOrderApiService(_client);
      final qualitySummaryFuture = qualityApi.fetchSummary(
        departmentId: departmentId,
      );
      final deliverySummaryFuture = deliveryApi.fetchSummary(
        departmentId: departmentId,
      );

      final qualitySummary = await qualitySummaryFuture;
      final deliverySummary = await deliverySummaryFuture;
      final qualityByResult = qualitySummary['by_result'] as List? ?? const [];
      final deliveryByStatus =
          deliverySummary['by_status'] as List? ?? const [];

      return TaskSupervisorFlowSummary(
        pendingInspections: _countByKey(
          qualityByResult,
          keyName: 'result',
          keyValue: 'pending',
        ),
        exceptionInspections:
            _countByKey(
              qualityByResult,
              keyName: 'result',
              keyValue: 'failed',
            ) +
            _countByKey(
              qualityByResult,
              keyName: 'result',
              keyValue: 'conditional',
            ),
        pendingReceipts:
            _countByKey(
              deliveryByStatus,
              keyName: 'status',
              keyValue: 'shipped',
            ) +
            _countByKey(
              deliveryByStatus,
              keyName: 'status',
              keyValue: 'in_transit',
            ),
        rejectedDeliveries: _countByKey(
          deliveryByStatus,
          keyName: 'status',
          keyValue: 'rejected',
        ),
      );
    } catch (_) {
      return const TaskSupervisorFlowSummary();
    }
  }

  int _countByKey(
    List<dynamic> items, {
    required String keyName,
    required String keyValue,
  }) {
    for (final item in items) {
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);
      if (map[keyName]?.toString() != keyValue) continue;
      return _toInt(map['count']);
    }
    return 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
