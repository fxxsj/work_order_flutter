import 'package:work_order_app/src/core/common/api_exception.dart';

/// API 错误处理工具类
///
/// 提供统一的 API 错误解析和处理方法
class ApiErrorHandler {
  ApiErrorHandler._();

  /// 解析 ApiException 并提取字段错误
  ///
  /// 返回 Map，key 是字段名，value 是错误消息
  static Map<String, String> parseFieldErrors(ApiException exception) {
    final errors = <String, String>{};
    final fieldErrors = exception.errors;

    if (fieldErrors == null) return errors;

    for (final entry in fieldErrors.entries) {
      final fieldName = entry.key;
      final errorValue = entry.value;

      if (errorValue is List && errorValue.isNotEmpty) {
        errors[fieldName] = errorValue.first.toString();
      } else if (errorValue is String) {
        errors[fieldName] = errorValue;
      }
    }

    return errors;
  }

  /// 从异常中获取用户友好的错误消息
  ///
  /// 优先返回 message，其次是第一个字段错误
  static String getFriendlyMessage(ApiException exception) {
    // 优先返回 message
    if (exception.message.isNotEmpty) {
      return exception.message;
    }

    // 其次返回第一个字段错误
    final fieldErrors = parseFieldErrors(exception);
    if (fieldErrors.isNotEmpty) {
      return fieldErrors.values.first;
    }

    return '操作失败';
  }

  /// 检查是否是字段验证错误
  static bool isValidationError(ApiException exception) {
    if (exception.statusCode != 400) return false;
    return exception.errors != null && exception.errors!.isNotEmpty;
  }
}
