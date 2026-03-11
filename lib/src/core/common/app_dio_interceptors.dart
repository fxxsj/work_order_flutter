import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:work_order_app/src/core/common/app_events.dart';
import 'package:work_order_app/src/core/common/http_client.dart';
import 'package:work_order_app/src/core/constants/response_code_constant.dart';
import 'package:work_order_app/src/core/models/api_response.dart';

class AppDioInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path;
    final skipRefresh = options.extra['skipAuthRefresh'] == true ||
        path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh') ||
        path.contains('/user/login') ||
        path.contains('/user/loginByFace');
    if (!skipRefresh) {
      await HttpClient.ensureFreshAccessToken();
    }
    // 添加 JWT access token
    final token = HttpClient.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    if (kDebugMode && options.path.contains('/notifications/unread_count/')) {
      final hasAuth = options.headers.containsKey(HttpHeaders.authorizationHeader);
      final access = token ?? '';
      final head = access.length >= 12 ? access.substring(0, 12) : access;
      final tail = access.length >= 6 ? access.substring(access.length - 6) : access;
      debugPrint('[auth] unread_count request authHeader=$hasAuth '
          'tokenLen=${access.length} token=${head}...${tail}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final apiResponse = ApiResponse.fromJson(response.data);
    if (apiResponse.code == ResponseCodeConstant.SESSION_EXPIRE_CODE) {
      AppEvents.emit(AuthExpiredEvent(apiResponse.message));
      return;
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 错误处理：尝试刷新 token
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('[auth] 401 response data: ${err.response?.data}');
        debugPrint('[auth] 401 on ${err.requestOptions.path} '
            'hasAccess=${(HttpClient.accessToken ?? '').isNotEmpty} '
            'hasRefresh=${(HttpClient.refreshToken ?? '').isNotEmpty} '
            'isRefreshing=${HttpClient.isRefreshing}');
      }
      // 登录接口的 401 错误不刷新，交给调用方处理
      if (err.requestOptions.path.contains('/auth/login') ||
          err.requestOptions.path.contains('/auth/refresh') ||
          err.requestOptions.extra['skipAuthRefresh'] == true) {
        handler.next(err);
        return;
      }

      // 如果正在刷新，加入队列
      if (HttpClient.isRefreshing) {
        HttpClient.enqueueRetry(err.requestOptions, handler);
        return;
      }

      // 开始刷新
      final success = await HttpClient.refreshAccessTokenLocked();

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
        await HttpClient.rejectQueuedRequests(err);
        AppEvents.emit(const AuthExpiredEvent());
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }
}
