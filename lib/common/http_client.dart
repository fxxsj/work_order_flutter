import 'dart:io';
import 'package:dio/dio.dart';
import 'package:work_order_app/common/app_config.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/constants/response_code_constant.dart';
import 'package:work_order_app/models/api_response.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/utils.dart';
import 'package:work_order_app/utils/toast_util.dart';

class HttpClient {
  HttpClient._();

  static late final Dio _dio;
  static String? _accessToken;
  static String? _refreshToken;
  static bool _isRefreshing = false;
  static final List<_RetryRequest> _requestQueue = [];

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
    _accessToken = StoreUtil.read(Constant.KEY_ACCESS_TOKEN);
    _refreshToken = StoreUtil.read(Constant.KEY_REFRESH_TOKEN);
  }

  /// 更新 tokens
  static void updateTokens(String access, [String? refresh]) {
    _accessToken = access;
    if (refresh != null) {
      _refreshToken = refresh;
      StoreUtil.save(Constant.KEY_REFRESH_TOKEN, refresh);
    }
    StoreUtil.save(Constant.KEY_ACCESS_TOKEN, access);
  }

  /// 清除 tokens
  static void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    StoreUtil.remove(Constant.KEY_ACCESS_TOKEN);
    StoreUtil.remove(Constant.KEY_REFRESH_TOKEN);
  }

  /// 刷新 access token
  static Future<bool> _refreshAccessToken() async {
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

class _RetryRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _RetryRequest(this.requestOptions, this.handler);
}

class AppDioInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加 JWT access token
    final token = HttpClient._accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';  // JWT Bearer token
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final apiResponse = ApiResponse.fromJson(response.data);
    if (apiResponse.code == ResponseCodeConstant.SESSION_EXPIRE_CODE) {
      Utils.logout();
      HttpClient.clearTokens();
      appRouter.go('/login');
      ToastUtil.showError(apiResponse.message ?? ResponseCodeConstant.SESSION_EXPIRE_MESSAGE);
      return;
    }

    if (!apiResponse.success) {
      ToastUtil.showError(apiResponse.message ?? '服务器返回错误');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 错误处理：尝试刷新 token
    if (err.response?.statusCode == 401) {
      // 登录接口的 401 错误不刷新
      if (err.requestOptions.path.contains('/auth/login')) {
        final data = err.response?.data;
        final apiResponse = ApiResponse.fromJson(data);
        final errorMsg = apiResponse.message?.toString().trim().isNotEmpty == true
            ? apiResponse.message!.trim()
            : '用户名或密码错误';
        final response = Response(
          requestOptions: err.requestOptions,
          statusCode: 401,
          data: {
            'success': false,
            'code': '401',
            'data': null,
            'message': errorMsg,
          },
        );
        handler.resolve(response);
        return;
      }

      // 如果正在刷新，加入队列
      if (HttpClient._isRefreshing) {
        HttpClient._requestQueue.add(_RetryRequest(err.requestOptions, handler));
        return;
      }

      // 开始刷新
      HttpClient._isRefreshing = true;
      final success = await HttpClient._refreshAccessToken();
      HttpClient._isRefreshing = false;

      if (success) {
        // 刷新成功，重试当前请求和队列中的请求
        final retryRequest = () async {
          // 重试队列中的请求
          for (final retry in HttpClient._requestQueue) {
            try {
              final token = HttpClient._accessToken;
              retry.requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
              final response = await HttpClient._dio.fetch(retry.requestOptions);
              retry.handler.resolve(response);
            } catch (e) {
              retry.handler.next(e);
            }
          }
          HttpClient._requestQueue.clear();

          // 重试当前请求
          final token = HttpClient._accessToken;
          err.requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
          final response = await HttpClient._dio.fetch(err.requestOptions);
          handler.resolve(response);
        };

        await retryRequest();
        return;
      } else {
        // 刷新失败，清除 tokens 并跳转登录
        HttpClient.clearTokens();
        Utils.logout();
        appRouter.go('/login');
        ToastUtil.showError('登录已过期，请重新登录');
        handler.next(err);
        return;
      }
    }

    // 其他错误处理
    final response = err.response;
    final data = response?.data;
    final apiResponse = ApiResponse.fromJson(data);
    String? message = apiResponse.message;
    if (message == null || message.isEmpty) {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          message = '网络连接异常，请检查网络';
          break;
        default:
          final code = response?.statusCode?.toString() ?? '未知错误';
          final path = err.requestOptions.path;
          message = '请求失败（$code）：$path';
      }
    }
    ToastUtil.showError(message);
    handler.next(err);
  }
}
