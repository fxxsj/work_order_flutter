import 'package:work_order_app/src/core/network/api_client.dart';

class TaskAssignmentRuleApiService {
  TaskAssignmentRuleApiService(this._client);

  final ApiClient _client;

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
