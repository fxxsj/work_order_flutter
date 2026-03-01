import 'dart:io';

import 'package:dio/dio.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/constants/response_code_constant.dart';
import 'package:work_order_app/models/api_response.dart';
import 'package:work_order_app/utils/store_util.dart';
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
      Get.offAllNamed('/login');
      Get.snackbar('登录失效', apiResponse.message ?? ResponseCodeConstant.SESSION_EXPIRE_MESSAGE,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!apiResponse.success) {
      Get.snackbar('请求失败', apiResponse.message ?? '服务器返回错误',
          snackPosition: SnackPosition.BOTTOM);
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
      Get.offAllNamed('/login');
      Get.snackbar('登录失效', '请重新登录', snackPosition: SnackPosition.BOTTOM);
      handler.next(err);
      return;
    }
    Get.snackbar('请求失败', '服务器忙，请稍后再试', snackPosition: SnackPosition.BOTTOM);
    handler.next(err);
  }
}
