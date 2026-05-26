import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/models/api_response.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final ApiResponse? response;
  final DioException? dioException;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.response,
    this.dioException,
  });

  factory ApiException.fromDio(DioException err) {
    final response = err.response;
    final apiResponse = ApiResponse.fromJson(response?.data);
    return ApiException(
      message: apiResponse.message ?? err.message ?? '请求失败',
      statusCode: response?.statusCode,
      data: response?.data,
      response: apiResponse,
      dioException: err,
    );
  }

  /// 获取 errors 字段（结构化错误信息）
  Map<String, dynamic>? get errors {
    // 优先从 ApiResponse 获取
    if (response?.errors != null && response!.errors is Map) {
      return response!.errors as Map<String, dynamic>;
    }
    // 其次从 raw data 获取
    if (data != null && data is Map) {
      final dataMap = data as Map<String, dynamic>;
      if (dataMap['errors'] != null && dataMap['errors'] is Map) {
        return dataMap['errors'] as Map<String, dynamic>;
      }
    }
    return null;
  }

  /// 获取特定字段的错误信息
  String? getFieldError(String fieldName) {
    final errors = this.errors;
    if (errors != null && errors.containsKey(fieldName)) {
      final fieldError = errors[fieldName];
      if (fieldError is List && fieldError.isNotEmpty) {
        return fieldError.first.toString();
      }
      if (fieldError is String) {
        return fieldError;
      }
    }
    return null;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
