import 'package:dio/dio.dart';
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
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
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
      params['work_order_process'] = processId;
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

    final response = await _client.get('/workorder-tasks/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => TaskDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <TaskDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return TaskPageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => TaskDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return TaskPageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const TaskPageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<Map<String, dynamic>> complete(int id, Map<String, dynamic> payload) async {
    final response = await _client.post('/workorder-tasks/$id/complete/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> updateQuantity(int id, Map<String, dynamic> payload) async {
    final response = await _client.post('/workorder-tasks/$id/update_quantity/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> assign(int id, Map<String, dynamic> payload) async {
    final response = await _client.post('/workorder-tasks/$id/assign/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> assignToOperator(int id, {required int operatorId, String? notes}) async {
    final response = await _client.post(
      '/workorder-tasks/$id/assign/',
      data: {
        'assigned_operator': operatorId,
        'notes': notes ?? '',
      },
    );
    return _mapFromResponse(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchDepartmentOperators(int departmentId) async {
    final response = await _client.get(
      '/workorder-tasks/department-operators/',
      queryParameters: {'department_id': departmentId},
    );
    return _listFromResponse(response.data);
  }

  Future<Map<String, dynamic>> claimTask(int id, {String? notes}) async {
    final response = await _client.post(
      '/workorder-tasks/$id/claim/',
      data: {'notes': notes ?? ''},
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchClaimableTasks({Map<String, dynamic>? params}) async {
    final response = await _client.get('/workorder-tasks/claimable/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchOperatorCenterData({Map<String, dynamic>? params}) async {
    final response = await _client.get('/workorder-tasks/operator_center/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> splitTask(int id, Map<String, dynamic> payload) async {
    final response = await _client.post('/workorder-tasks/$id/split/', data: payload);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchCollaborationStats({Map<String, dynamic>? params}) async {
    final response = await _client.get('/workorder-tasks/collaboration_stats/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchDepartmentWorkload({Map<String, dynamic>? params}) async {
    final response = await _client.get('/workorder-tasks/department_workload/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> fetchAssignmentHistory({Map<String, dynamic>? params}) async {
    final response = await _client.get('/workorder-tasks/assignment_history/', queryParameters: params);
    return _mapFromResponse(response.data);
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
        'columns': columns ??
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

  Future<Map<String, dynamic>> bulkUpdate({
    required List<int> taskIds,
    required Map<String, dynamic> updates,
  }) async {
    final response = await _client.patch(
      '/draft-tasks/bulk_update/',
      data: {
        'task_ids': taskIds,
        'updates': updates,
      },
    );
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> bulkDelete(List<int> taskIds) async {
    if (taskIds.isEmpty) {
      return {
        'message': '未选择任务',
        'deleted_count': 0,
        'failed_count': 0,
      };
    }
    var deleted = 0;
    final failed = <int>[];
    for (final id in taskIds) {
      try {
        await _client.delete('/draft-tasks/$id/');
        deleted += 1;
      } catch (_) {
        failed.add(id);
      }
    }
    return {
      'message': '成功删除 $deleted 个草稿任务',
      'deleted_count': deleted,
      'failed_count': failed.length,
      'failed_tasks': failed.map((id) => {'id': id}).toList(),
    };
  }

  Future<Map<String, dynamic>> batchAssign(Map<String, dynamic> payload) async {
    final response = await _client.post('/workorder-tasks/batch_assign/', data: payload);
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }

  List<Map<String, dynamic>> _listFromResponse(dynamic data) {
    if (data is List) {
      return data.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    if (data is Map && data['results'] is List) {
      final results = data['results'] as List;
      return results.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }
}
