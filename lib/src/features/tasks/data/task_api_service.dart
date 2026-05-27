import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/tasks/data/task_dto.dart';

class TaskApiService {
  TaskApiService(this._client);

  final ApiClient _client;

  Future<TaskPageDto> fetchTasks({
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
  }) async {
    final params = <String, dynamic>{'page': page, 'page_size': pageSize};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }
    if (priority != null && priority.isNotEmpty) {
      params['priority'] = priority;
    }
    if (taskType != null && taskType.isNotEmpty) {
      params['task_type'] = taskType;
    }
    if (departmentId != null && departmentId > 0) {
      params['assigned_department'] = departmentId;
    }
    if (assignedOperatorId != null && assignedOperatorId > 0) {
      params['assigned_operator'] = assignedOperatorId;
    }
    if (processId != null && processId > 0) {
      params['process'] = processId;
    }
    final trimmedWorkOrder = workOrderNumber?.trim();
    if (trimmedWorkOrder != null && trimmedWorkOrder.isNotEmpty) {
      params['work_order_number'] = trimmedWorkOrder;
    }
    final trimmedContent = workContent?.trim();
    if (trimmedContent != null && trimmedContent.isNotEmpty) {
      params['work_content'] = trimmedContent;
    }
    final trimmedDepartment = departmentName?.trim();
    if (trimmedDepartment != null && trimmedDepartment.isNotEmpty) {
      params['department_name'] = trimmedDepartment;
    }
    final trimmedOperator = operatorName?.trim();
    if (trimmedOperator != null && trimmedOperator.isNotEmpty) {
      params['operator_name'] = trimmedOperator;
    }
    if (isDraft != null) {
      params['is_draft'] = isDraft.toString();
    }
    if (ordering != null && ordering.trim().isNotEmpty) {
      params['ordering'] = ordering.trim();
    }
    if (todo != null && todo.trim().isNotEmpty) {
      params['todo'] = todo.trim();
    }

    final response = await _client.get(
      '/workorder-tasks/',
      queryParameters: params,
    );
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
                .whereType<Map>()
                .map(
                  (item) => TaskDto.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : <TaskDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return TaskPageDto(
        items: list,
        total: total,
        page: page,
        pageSize: pageSize,
      );
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => TaskDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return TaskPageDto(
        items: list,
        total: list.length,
        page: 1,
        pageSize: list.length,
      );
    }
    throw _unexpectedPayload('任务列表', payload);
  }

  Future<Map<String, dynamic>> fetchSummary({
    String? search,
    String? status,
    String? priority,
    int? departmentId,
    int? processId,
    String? todo,
  }) async {
    final params = <String, dynamic>{};
    final trimmed = search?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      params['search'] = trimmed;
    }
    if (status != null && status.trim().isNotEmpty) {
      params['status'] = status.trim();
    }
    if (priority != null && priority.trim().isNotEmpty) {
      params['priority'] = priority.trim();
    }
    if (departmentId != null && departmentId > 0) {
      params['assigned_department'] = departmentId;
    }
    if (processId != null && processId > 0) {
      params['process'] = processId;
    }
    if (todo != null && todo.trim().isNotEmpty) {
      params['todo'] = todo.trim();
    }
    final response = await _client.get(
      '/workorder-tasks/summary/',
      queryParameters: params,
    );
    return _requireMap('任务汇总', response.data);
  }

  Future<Map<String, dynamic>> complete(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-tasks/$id/complete/',
      data: payload,
    );
    return _requireMap('完成任务', response.data);
  }

  Future<Map<String, dynamic>> updateQuantity(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-tasks/$id/update_quantity/',
      data: payload,
    );
    return _requireMap('更新任务进度', response.data);
  }

  Future<Map<String, dynamic>> assign(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-tasks/$id/assign/',
      data: payload,
    );
    return _requireMap('分派任务', response.data);
  }

  Future<Map<String, dynamic>> assignToOperator(
    int id, {
    required int operatorId,
    String? notes,
  }) async {
    final response = await _client.post(
      '/workorder-tasks/$id/assign/',
      data: {'assigned_operator': operatorId, 'notes': notes ?? ''},
    );
    return _requireMap('指派任务操作员', response.data);
  }

  Future<List<Map<String, dynamic>>> fetchDepartmentOperators(
    int departmentId,
  ) async {
    final response = await _client.get(
      '/workorder-tasks/department-operators/',
      queryParameters: {'department_id': departmentId},
    );
    return _requireList('部门操作员列表', response.data);
  }

  Future<List<Map<String, dynamic>>> fetchProcessDepartments(
    int processId,
  ) async {
    final response = await _client.get(
      '/workorder-tasks/process-departments/',
      queryParameters: {'process_id': processId},
    );
    return _requireList('工序负责部门', response.data);
  }

  Future<Map<String, dynamic>> claimTask(int id, {String? notes}) async {
    final response = await _client.post(
      '/workorder-tasks/$id/claim/',
      data: {'notes': notes ?? ''},
    );
    return _requireMap('认领任务', response.data);
  }

  Future<Map<String, dynamic>> fetchClaimableTasks({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/workorder-tasks/claimable/',
      queryParameters: params,
    );
    return _requireMap('可认领任务', response.data);
  }

  Future<Map<String, dynamic>> fetchOperatorCenterData({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/workorder-tasks/operator_center/',
      queryParameters: params,
    );
    return _requireMap('操作员工作台', response.data);
  }

  Future<Map<String, dynamic>> splitTask(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(
      '/workorder-tasks/$id/split/',
      data: payload,
    );
    return _requireMap('拆分任务', response.data);
  }

  Future<Map<String, dynamic>> fetchCollaborationStats({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/workorder-tasks/collaboration_stats/',
      queryParameters: params,
    );
    return _requireMap('任务协作统计', response.data);
  }

  Future<Map<String, dynamic>> fetchDepartmentWorkload({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/workorder-tasks/department_workload/',
      queryParameters: params,
    );
    return _requireMap('部门任务负载', response.data);
  }

  Future<Map<String, dynamic>> fetchAssignmentHistory({
    Map<String, dynamic>? params,
  }) async {
    final response = await _client.get(
      '/workorder-tasks/assignment_history/',
      queryParameters: params,
    );
    return _requireMap('任务分派历史', response.data);
  }

  Future<Response<dynamic>> export({Map<String, dynamic>? params}) {
    return _client.requestRaw(
      '/workorder-tasks/export/',
      method: 'get',
      queryParameters: params,
      responseType: ResponseType.bytes,
    );
  }

  Future<Response<dynamic>> exportExcel({
    List<int>? taskIds,
    Map<String, dynamic>? filters,
    List<String>? columns,
  }) {
    return _client.requestRaw(
      '/workorder-tasks/export/',
      method: 'post',
      queryParameters: filters,
      data: {
        'task_ids': taskIds ?? <int>[],
        'filters': filters ?? <String, dynamic>{},
        'columns':
            columns ??
            const [
              'id',
              'work_order_number',
              'process_name',
              'task_type',
              'work_content',
              'assigned_department',
              'assigned_operator',
              'production_quantity',
              'quantity_completed',
              'progress',
              'priority',
              'status',
              'created_at',
              'updated_at',
            ],
      },
      responseType: ResponseType.bytes,
    );
  }

  Future<Map<String, dynamic>> batchAssign(Map<String, dynamic> payload) async {
    final response = await _client.post(
      '/workorder-tasks/batch_assign/',
      data: payload,
    );
    return _requireMap('批量分派任务', response.data);
  }

  Map<String, dynamic> _requireMap(String label, dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw _unexpectedPayload(label, data);
  }

  List<Map<String, dynamic>> _requireList(String label, dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (data is Map && data['results'] is List) {
      final results = data['results'] as List;
      return results
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    throw _unexpectedPayload(label, data);
  }

  ApiException _unexpectedPayload(String label, dynamic data) {
    return ApiException(message: '$label 响应格式异常', data: data);
  }
}
