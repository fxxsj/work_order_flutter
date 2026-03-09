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
    int? departmentId,
    int? processId,
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
    if (departmentId != null && departmentId > 0) {
      params['assigned_department'] = departmentId;
    }
    if (processId != null && processId > 0) {
      params['work_order_process'] = processId;
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
}
