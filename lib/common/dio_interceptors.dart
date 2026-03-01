import 'dart:io';

import 'package:dio/dio.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/constants/response_code_constant.dart';
import 'package:work_order_app/models/api_response.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/utils.dart';
import 'package:get/get.dart' hide Response;

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
    if (response.data is Map && response.statusCode != null) {
      final data = response.data as Map;
      final hasWrapper = data.containsKey('success') || data.containsKey('code');
      if (!hasWrapper && response.statusCode! >= 200 && response.statusCode! < 300) {
        response.data = {
          'success': true,
          'code': response.statusCode.toString(),
          'data': data,
          'message': '',
        };
      }
    }

    final apiResponse = ApiResponse.fromJson(response.data);
    if (apiResponse.code == ResponseCodeConstant.SESSION_EXPIRE_CODE) {
      Utils.logout();
      appRouter.go('/login');
      _safeSnack('登录失效', apiResponse.message ?? ResponseCodeConstant.SESSION_EXPIRE_MESSAGE);
      return;
    }

    if (!apiResponse.success) {
      _safeSnack('请求失败', apiResponse.message ?? '服务器返回错误');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path.contains('/auth/login')) {
        final data = err.response?.data;
        final errorMsg = data is Map ? (data['error'] ?? '用户名或密码错误') : '用户名或密码错误';
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
      _safeSnack('登录失效', '请重新登录');
      handler.next(err);
      return;
    }
    _safeSnack('请求失败', '服务器忙，请稍后再试');
    handler.next(err);
  }
}

void _safeSnack(String title, String message) {
  if (Get.overlayContext == null) {
    return;
  }
  Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
}
