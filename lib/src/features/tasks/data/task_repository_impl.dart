import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_dto.dart';
import 'package:work_order_app/src/features/tasks/data/task_list_support_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_supervisor_support_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_list_filter_options.dart';
import 'package:work_order_app/src/features/tasks/domain/task_operator_center_result.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';
import 'package:work_order_app/src/features/tasks/domain/task_supervisor_dashboard_data.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(
    this._apiService,
    this._listSupportService,
    this._supervisorSupportService,
  );

  final TaskApiService _apiService;
  final TaskListSupportService _listSupportService;
  final TaskSupervisorSupportService _supervisorSupportService;

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
    return _listSupportService.loadFilterOptions();
  }

  @override
  Future<TaskExportResult> export(Map<String, dynamic> params) {
    return _listSupportService.export(params);
  }

  @override
  Future<List<Map<String, dynamic>>> loadOperators(int departmentId) {
    return _listSupportService.loadOperators(departmentId);
  }

  @override
  Future<List<TaskDepartmentOption>> loadProcessDepartments(int processId) {
    return _listSupportService.loadProcessDepartments(processId);
  }

  @override
  Future<void> updateQuantity(int taskId, Map<String, dynamic> payload) {
    return _listSupportService.updateQuantity(taskId, payload);
  }

  @override
  Future<void> completeTask(int taskId, Map<String, dynamic> payload) {
    return _listSupportService.completeTask(taskId, payload);
  }

  @override
  Future<void> assignTask(
    int taskId, {
    required int operatorId,
    required String notes,
  }) {
    return _listSupportService.assignTask(
      taskId,
      operatorId: operatorId,
      notes: notes,
    );
  }

  @override
  Future<TaskOperatorCenterResult> fetchOperatorCenterData({
    Map<String, dynamic>? params,
    int myLimit = 50,
    int myOffset = 0,
    int claimableLimit = 50,
    int claimableOffset = 0,
  }) async {
    final payload = await _apiService.fetchOperatorCenterData(
      params: params,
      myLimit: myLimit,
      myOffset: myOffset,
      claimableLimit: claimableLimit,
      claimableOffset: claimableOffset,
    );
    final myTasksPayload = payload['my_tasks'];
    final claimablePayload = payload['claimable_tasks'];
    final myTasksRaw = (myTasksPayload is List)
        ? myTasksPayload.whereType<Map>().toList().cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    final claimableTasksRaw = (claimablePayload is List)
        ? claimablePayload
              .whereType<Map>()
              .toList()
              .cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    return TaskOperatorCenterResult(
      myTasks: _mapTasks(myTasksPayload),
      claimableTasks: _mapTasks(claimablePayload),
      myTasksRaw: myTasksRaw,
      claimableTasksRaw: claimableTasksRaw,
      summary: OperatorSummary.fromJson(
        payload['summary'] as Map<String, dynamic>?,
      ),
      meta: PaginationMeta.fromJson(payload['meta'] as Map<String, dynamic>?),
    );
  }

  List<Task> _mapTasks(dynamic payload) {
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) => Task.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }

  @override
  Future<void> claimTask(int taskId, {String? notes}) async {
    await _apiService.claimTask(taskId, notes: notes);
  }

  @override
  Future<List<TaskDepartmentOption>> loadDepartments() {
    return _supervisorSupportService.fetchDepartments();
  }

  @override
  Future<TaskSupervisorBoardData> loadDepartmentBoardTasks(
    int departmentId, {
    int taskPage = 1,
  }) {
    return _supervisorSupportService.loadDepartmentBoardTasks(
      departmentId,
      taskPage: taskPage,
    );
  }

  @override
  Future<TaskSupervisorDashboardData> loadDepartmentDashboard(
    int departmentId, {
    int taskPage = 1,
  }) {
    return _supervisorSupportService.loadDepartmentDashboard(
      departmentId,
      taskPage: taskPage,
    );
  }
}
