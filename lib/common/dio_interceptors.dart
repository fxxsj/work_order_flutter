import 'dart:io';

import 'package:dio/dio.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/constants/response_code_constant.dart';
import 'package:work_order_app/models/api_response.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/utils.dart';
import 'package:work_order_app/utils/toast_util.dart';

class AppDioInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = StoreUtil.read(Constant.KEY_TOKEN);
    if (token != null && token.toString().isNotEmpty) {
      final authToken = token.toString().startsWith('Token ') ? token.toString() : 'Token $token';
      options.headers[HttpHeaders.authorizationHeader] = authToken;
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final apiResponse = ApiResponse.fromJson(response.data);
    if (apiResponse.code == ResponseCodeConstant.SESSION_EXPIRE_CODE) {
      Utils.logout();
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
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
      Utils.logout();
      appRouter.go('/login');
      ToastUtil.showError('请重新登录');
      handler.next(err);
      return;
    }
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
