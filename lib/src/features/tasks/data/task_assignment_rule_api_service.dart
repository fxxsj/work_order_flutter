import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/tasks/data/task_assignment_rule_dto.dart';

class TaskAssignmentRuleApiService {
  TaskAssignmentRuleApiService(this._client);

  final ApiClient _client;

  Future<TaskAssignmentRulePageDto> fetchRules({
    int page = 1,
    int pageSize = 20,
    String? search,
    int? processId,
    int? departmentId,
    bool? isActive,
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
    if (processId != null && processId > 0) {
      params['process'] = processId;
    }
    if (departmentId != null && departmentId > 0) {
      params['department'] = departmentId;
    }
    if (isActive != null) {
      params['is_active'] = isActive.toString();
    }
    if (ordering != null && ordering.trim().isNotEmpty) {
      params['ordering'] = ordering.trim();
    }

    final response = await _client.get('/task-assignment-rules/', queryParameters: params);
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final results = payload['results'];
      final list = results is List
          ? results
              .whereType<Map>()
              .map((item) => TaskAssignmentRuleDto.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : <TaskAssignmentRuleDto>[];
      final total = toInt(payload['count']) ?? list.length;
      return TaskAssignmentRulePageDto(items: list, total: total, page: page, pageSize: pageSize);
    }
    if (payload is List) {
      final list = payload
          .whereType<Map>()
          .map((item) => TaskAssignmentRuleDto.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      return TaskAssignmentRulePageDto(items: list, total: list.length, page: 1, pageSize: list.length);
    }
    return const TaskAssignmentRulePageDto(items: [], total: 0, page: 1, pageSize: 20);
  }

  Future<TaskAssignmentRuleDto> createRule(TaskAssignmentRuleDto dto) async {
    final response = await _client.post('/task-assignment-rules/', data: dto.toPayload());
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return TaskAssignmentRuleDto.fromJson(map);
  }

  Future<TaskAssignmentRuleDto> updateRule(int id, Map<String, dynamic> payload) async {
    final response = await _client.put('/task-assignment-rules/$id/', data: payload);
    final data = response.data;
    final map = data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    return TaskAssignmentRuleDto.fromJson(map);
  }

  Future<void> deleteRule(int id) async {
    await _client.delete('/task-assignment-rules/$id/');
  }

  Future<Map<String, dynamic>> preview({Map<String, dynamic>? params}) async {
    final response = await _client.get('/task-assignment-rules/preview/', queryParameters: params);
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> getGlobalState() async {
    final response = await _client.get('/task-assignment-rules/global_state/');
    return _mapFromResponse(response.data);
  }

  Future<Map<String, dynamic>> setGlobalState(bool enabled) async {
    final response = await _client.post(
      '/task-assignment-rules/set_global_state/',
      data: {'enabled': enabled},
    );
    return _mapFromResponse(response.data);
  }

  Map<String, dynamic> _mapFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
