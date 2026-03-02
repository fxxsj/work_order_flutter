import 'package:work_order_app/common/api_result.dart';
import 'package:work_order_app/src/core/network/api_client.dart';

class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  Future<ApiResult<Map<String, dynamic>>> login(Map<String, dynamic> data) async {
    final response = await _client.post('/auth/login/', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  Future<ApiResult<void>> logout() async {
    final response = await _client.post('/auth/logout/');
    return ApiResult(message: response.message);
  }

  Future<ApiResult<Map<String, dynamic>>> getCurrentUser() async {
    final response = await _client.get('/auth/user/');
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  Future<ApiResult<Map<String, dynamic>>> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.put('/auth/update-profile/', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  Future<ApiResult<void>> changePassword(Map<String, dynamic> data) async {
    final response = await _client.post('/auth/change-password/', data: data);
    return ApiResult(message: response.message);
  }

  Future<ApiResult<List<Map<String, dynamic>>>> getSalespersons() async {
    final response = await _client.get('/auth/salespersons/');
    final payload = response.data;
    if (payload is List) {
      return ApiResult(
        data: payload
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
        message: response.message,
      );
    }
    return ApiResult(data: const [], message: response.message);
  }
}
