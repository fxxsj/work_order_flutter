import 'package:work_order_app/src/core/common/api_result.dart';

/// Factory helpers for creating ApiResult instances in tests.
///
/// Usage:
/// ```dart
/// final success = ApiResultFactory.success(data: {'id': 1});
/// final failure = ApiResultFactory.failure(message: 'Not found');
/// ```
class ApiResultFactory {
  /// Creates a successful ApiResult with data.
  static ApiResult<T> success<T>({T? data, String? message}) {
    return ApiResult(data: data, message: message);
  }

  /// Creates a failed ApiResult with message.
  static ApiResult<T> failure<T>({String? message}) {
    return ApiResult<T>(message: message ?? 'Error');
  }
}