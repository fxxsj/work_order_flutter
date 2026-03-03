import 'package:work_order_app/src/core/common/http_client.dart';
import 'package:work_order_app/src/core/models/api_response.dart';

class ApiClient {
  void init() => HttpClient.init();

  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) {
    return HttpClient.get(path, queryParameters: queryParameters);
  }

  Future<ApiResponse> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return HttpClient.post(path, data: data, queryParameters: queryParameters);
  }

  Future<ApiResponse> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return HttpClient.put(path, data: data, queryParameters: queryParameters);
  }

  Future<ApiResponse> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return HttpClient.delete(path, data: data, queryParameters: queryParameters);
  }

  void updateTokens(String access, [String? refresh]) {
    HttpClient.updateTokens(access, refresh);
  }

  void clearTokens() {
    HttpClient.clearTokens();
  }

  Future<bool> refreshAccessToken() => HttpClient.refreshAccessToken();
}
