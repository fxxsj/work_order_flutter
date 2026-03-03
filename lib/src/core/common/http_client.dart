import 'dart:io';
import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/app_config.dart';
import 'package:work_order_app/src/core/common/app_dio_interceptors.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/models/api_response.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';

class HttpClient {
  HttpClient._();

  static late final Dio _dio;
  static String? _accessToken;
  static String? _refreshToken;
  static bool _isRefreshing = false;
  static final List<_RetryRequest> _requestQueue = [];

  static Dio get dio => _dio;
  static String? get accessToken => _accessToken;
  static bool get isRefreshing => _isRefreshing;

  static void setRefreshing(bool value) {
    _isRefreshing = value;
  }

  static void enqueueRetry(RequestOptions requestOptions, ErrorInterceptorHandler handler) {
    _requestQueue.add(_RetryRequest(requestOptions, handler));
  }

  static Future<void> retryQueuedRequests() async {
    for (final retry in _requestQueue) {
      try {
        final token = _accessToken;
        retry.requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        final response = await _dio.fetch(retry.requestOptions);
        retry.handler.resolve(response);
      } catch (e) {
        final dioError = e is DioException
            ? e
            : DioException(
                requestOptions: retry.requestOptions,
                error: e,
                type: DioExceptionType.unknown,
              );
        retry.handler.next(dioError);
      }
    }
    _requestQueue.clear();
  }

  static void init() {
    final options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeoutMs),
      contentType: 'application/json',
    );
    _dio = Dio(options);
    _dio.interceptors.add(AppDioInterceptors());

    // 从存储恢复 tokens
    _accessToken = StoreUtil.readAccessToken();
    _refreshToken = StoreUtil.read(Constant.KEY_REFRESH_TOKEN);
  }

  /// 更新 tokens
  static void updateTokens(String access, [String? refresh]) {
    _accessToken = access;
    if (refresh != null) {
      _refreshToken = refresh;
    }
    StoreUtil.writeTokens(access: access, refresh: refresh);
  }

  /// 清除 tokens
  static void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    StoreUtil.clearTokens();
  }

  /// 刷新 access token
  static Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) {
      return false;
    }

    try {
      final response = await _dio.post(
        '/auth/refresh/',
        data: {'refresh': _refreshToken},
        options: Options(contentType: Headers.jsonContentType),
      );

      final apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.success && apiResponse.data != null) {
        final data = apiResponse.data as Map<String, dynamic>;
        final access = data['access'] as String?;
        final refresh = data['refresh'] as String?;

        if (access != null) {
          updateTokens(access, refresh);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final apiResponse = ApiResponse.fromJson(response.data);
      if (!apiResponse.success) {
        throw ApiException(
          message: apiResponse.message ?? '请求失败',
          statusCode: response.statusCode,
          data: response.data,
          response: apiResponse,
        );
      }
      return apiResponse;
    } on DioException catch (err) {
      throw ApiException.fromDio(err);
    }
  }

  static Future<ApiResponse> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      final apiResponse = ApiResponse.fromJson(response.data);
      if (!apiResponse.success) {
        throw ApiException(
          message: apiResponse.message ?? '请求失败',
          statusCode: response.statusCode,
          data: response.data,
          response: apiResponse,
        );
      }
      return apiResponse;
    } on DioException catch (err) {
      throw ApiException.fromDio(err);
    }
  }

  static Future<ApiResponse> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters);
      final apiResponse = ApiResponse.fromJson(response.data);
      if (!apiResponse.success) {
        throw ApiException(
          message: apiResponse.message ?? '请求失败',
          statusCode: response.statusCode,
          data: response.data,
          response: apiResponse,
        );
      }
      return apiResponse;
    } on DioException catch (err) {
      throw ApiException.fromDio(err);
    }
  }

  static Future<ApiResponse> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters);
      final apiResponse = ApiResponse.fromJson(response.data);
      if (!apiResponse.success) {
        throw ApiException(
          message: apiResponse.message ?? '请求失败',
          statusCode: response.statusCode,
          data: response.data,
          response: apiResponse,
        );
      }
      return apiResponse;
    } on DioException catch (err) {
      throw ApiException.fromDio(err);
    }
  }
}

class _RetryRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _RetryRequest(this.requestOptions, this.handler);
}
