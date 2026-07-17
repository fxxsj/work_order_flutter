import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/app_config.dart';
import 'package:work_order_app/src/core/common/app_dio_interceptors.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/models/api_response.dart';
import 'package:work_order_app/src/core/utils/jwt_util.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';

class HttpClient {
  HttpClient._();

  static late Dio _dio;
  static String? _accessToken;
  static String? _refreshToken;
  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;
  static final List<_RetryRequest> _requestQueue = [];
  static final Set<ErrorInterceptorHandler> _processedHandlers = {};

  static Dio get dio => _dio;
  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static bool get isRefreshing => _isRefreshing;

  static void setRefreshing(bool value) {
    _isRefreshing = value;
  }

  static void enqueueRetry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) {
    _requestQueue.add(_RetryRequest(requestOptions, handler));
  }

  static Future<void> retryQueuedRequests() async {
    _processedHandlers.clear();
    for (final retry in _requestQueue) {
      if (_processedHandlers.contains(retry.handler)) {
        continue;
      }
      _processedHandlers.add(retry.handler);
      try {
        final token = _accessToken;
        retry.requestOptions.headers[HttpHeaders.authorizationHeader] =
            'Bearer $token';
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

  /// 拒绝队列中的所有请求
  static Future<void> rejectQueuedRequests(DioException error) async {
    _processedHandlers.clear();
    for (final retry in _requestQueue) {
      if (_processedHandlers.contains(retry.handler)) {
        continue;
      }
      _processedHandlers.add(retry.handler);
      retry.handler.next(error);
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
    final persistRefresh = refresh ?? _refreshToken;
    StoreUtil.writeTokens(access: access, refresh: persistRefresh);
  }

  /// 清除 tokens
  static void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    StoreUtil.clearTokens();
    // 取消所有进行中的请求并重置 Dio 实例
    try {
      _dio.close(force: true);
    } catch (_) {}
    init();
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
        options: Options(
          contentType: Headers.jsonContentType,
          extra: const {'skipAuthRefresh': true},
        ),
      );

      // 后端已统一返回标准格式:
      // { "success": true, "code": 200, "data": { "access": "...", "refresh": "...", "access_expires_at": ... } }
      final apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.success && apiResponse.data != null) {
        final data = apiResponse.data as Map<String, dynamic>;
        final access = data['access']?.toString();
        final refresh = data['refresh']?.toString();

        if (access != null && access.isNotEmpty) {
          updateTokens(access, refresh);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> refreshAccessTokenLocked() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }
    _refreshCompleter = Completer<bool>();
    _isRefreshing = true;
    final success = await refreshAccessToken();
    _isRefreshing = false;
    _refreshCompleter!.complete(success);
    _refreshCompleter = null;
    return success;
  }

  static bool isAccessTokenExpiring({int leewaySeconds = 30}) {
    final token = _accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }
    return JwtUtil.isExpiring(token, leewaySeconds: leewaySeconds);
  }

  static Future<void> ensureFreshAccessToken() async {
    if (!isAccessTokenExpiring()) {
      return;
    }
    if (_refreshToken == null || _refreshToken!.isEmpty) {
      return;
    }
    await refreshAccessTokenLocked();
  }

  static Future<Response<dynamic>> requestRaw(
    String path, {
    String method = 'get',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
    String? contentType,
    Duration? receiveTimeout,
  }) async {
    try {
      // 调试日志：打印完整的请求信息
      debugPrint(
        '[HttpClient.requestRaw] ${method.toUpperCase()} ${_dio.options.baseUrl}$path',
      );
      debugPrint('[HttpClient.requestRaw] data type: ${data.runtimeType}');
      final options = Options(
        method: method.toUpperCase(),
        responseType: responseType,
        receiveTimeout:
            receiveTimeout ??
            Duration(milliseconds: AppConfig.transferTimeoutMs),
      );
      if (contentType != null) {
        options.contentType = contentType;
      }
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (err) {
      debugPrint(
        '[HttpClient.requestRaw] ERROR: statusCode=${err.response?.statusCode}, '
        'type=${err.type}, realUri=${err.response?.realUri}, '
        'requestUri=${err.requestOptions.uri}',
      );
      debugPrint(
        '[HttpClient.requestRaw] ERROR responseData=${err.response?.data}',
      );
      throw ApiException.fromDio(err);
    }
  }

  static Future<ApiResponse> _requestWithParse(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );
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

  static Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestWithParse('GET', path, queryParameters: queryParameters);
  }

  static Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestWithParse(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static Future<ApiResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestWithParse(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static Future<ApiResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestWithParse(
      'PATCH',
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static Future<ApiResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestWithParse(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}

class _RetryRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _RetryRequest(this.requestOptions, this.handler);
}
