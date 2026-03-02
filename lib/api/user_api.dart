import 'package:dio/dio.dart';
import 'package:work_order_app/common/api_result.dart';
import 'package:work_order_app/src/core/network/api_client.dart';

class UserApi {
  UserApi(this._client);

  final ApiClient _client;

  Future<ApiResult<void>> register(FormData data) async {
    final response = await _client.post('/user/register', data: data);
    return ApiResult(message: response.message);
  }

  Future<ApiResult<Map<String, dynamic>>> login(Map<String, dynamic> data) async {
    final response = await _client.post('/user/login', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }

  Future<ApiResult<Map<String, dynamic>>> loginByFace(Map<String, dynamic> data) async {
    final response = await _client.post('/user/loginByFace', data: data);
    final payload = response.data;
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    return ApiResult(data: map, message: response.message);
  }
}
