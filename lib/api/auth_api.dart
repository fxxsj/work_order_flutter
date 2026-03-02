import 'package:work_order_app/common/api_result.dart';
import 'package:work_order_app/common/http_client.dart';

class AuthApi {
  static Future<ApiResult<Map<String, dynamic>>> login(Map<String, dynamic> data) async {
    final response = await HttpClient.post('/auth/login/', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  static Future<ApiResult<void>> logout() async {
    final response = await HttpClient.post('/auth/logout/');
    return ApiResult(message: response.message);
  }

  static Future<ApiResult<Map<String, dynamic>>> getCurrentUser() async {
    final response = await HttpClient.get('/auth/user/');
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  static Future<ApiResult<Map<String, dynamic>>> updateProfile(Map<String, dynamic> data) async {
    final response = await HttpClient.put('/auth/update-profile/', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  static Future<ApiResult<void>> changePassword(Map<String, dynamic> data) async {
    final response = await HttpClient.post('/auth/change-password/', data: data);
    return ApiResult(message: response.message);
  }
}
