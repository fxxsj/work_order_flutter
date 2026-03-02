import 'dart:io';

import 'package:dio/dio.dart';
import 'package:work_order_app/common/app_events.dart';
import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/constants/response_code_constant.dart';
import 'package:work_order_app/models/api_response.dart';

class AppDioInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加 JWT access token
    final token = HttpClient.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final apiResponse = ApiResponse.fromJson(response.data);
    if (apiResponse.code == ResponseCodeConstant.SESSION_EXPIRE_CODE) {
      AppEvents.emit(AuthExpiredEvent(
        apiResponse.message ?? ResponseCodeConstant.SESSION_EXPIRE_MESSAGE,
      ));
      return;
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
      if (HttpClient.isRefreshing) {
        HttpClient.enqueueRetry(err.requestOptions, handler);
        return;
      }

      // 开始刷新
      HttpClient.setRefreshing(true);
      final success = await HttpClient.refreshAccessToken();
      HttpClient.setRefreshing(false);

      if (success) {
        // 刷新成功，重试当前请求和队列中的请求
        await HttpClient.retryQueuedRequests();

        // 重试当前请求
        final token = HttpClient.accessToken;
        err.requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        final response = await HttpClient.dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } else {
        // 刷新失败，触发全局登录失效事件
        AppEvents.emit(const AuthExpiredEvent('登录已过期，请重新登录'));
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
    handler.next(err);
  }
}
