import 'package:dio/dio.dart';
import 'package:work_order_app/common/app_config.dart';
import 'package:work_order_app/common/dio_interceptors.dart';
import 'package:work_order_app/models/api_response.dart';

class HttpClient {
  HttpClient._();

  static late final Dio _dio;

  static void init() {
    final options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeoutMs),
      contentType: 'application/json',
    );
    _dio = Dio(options);
    _dio.interceptors.add(AppDioInterceptors());
  }

  static Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.post(path, data: data, queryParameters: queryParameters);
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.put(path, data: data, queryParameters: queryParameters);
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.delete(path, data: data, queryParameters: queryParameters);
    return ApiResponse.fromJson(response.data);
  }
}
