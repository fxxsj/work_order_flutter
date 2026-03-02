import 'package:dio/dio.dart';
import 'package:work_order_app/common/api_result.dart';
import 'package:work_order_app/common/http_client.dart';

class UserApi {
  static Future<ApiResult<void>> register(FormData data) async {
    final response = await HttpClient.post('/user/register', data: data);
    return ApiResult(message: response.message);
  }

  static Future<ApiResult<Map<String, dynamic>>> login(Map<String, dynamic> data) async {
    final response = await HttpClient.post('/user/login', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  static Future<ApiResult<Map<String, dynamic>>> loginByFace(Map<String, dynamic> data) async {
    final response = await HttpClient.post('/user/loginByFace', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }
}
