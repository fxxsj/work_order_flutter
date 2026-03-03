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

  @override
  String toString() => 'ApiException($statusCode): $message';
}
