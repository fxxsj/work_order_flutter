/// 统一 API 响应模型，与后端 response_format.py 对齐。
///
/// 后端标准格式：
/// ```json
/// {
///   "success": true/false,
///   "code": 200,
///   "message": "操作成功",
///   "data": <any>,
///   "errors": {},     // 仅错误响应有此字段
///   "timestamp": "2026-05-26T07:00:00+00:00"
/// }
/// ```
class ApiResponse {
  final bool success;
  final int? code;
  final dynamic data;
  final dynamic errors;
  final String? message;
  final String? timestamp;

  const ApiResponse({
    required this.success,
    this.code,
    this.data,
    this.errors,
    this.message,
    this.timestamp,
  });

  factory ApiResponse.fromJson(dynamic payload) {
    if (payload is ApiResponse) {
      return payload;
    }
    if (payload is Map<String, dynamic>) {
      return ApiResponse(
        success: payload['success'] == true,
        code: _parseCode(payload['code']),
        data: payload['data'],
        errors: payload['errors'],
        message: payload['message']?.toString(),
        timestamp: payload['timestamp']?.toString(),
      );
    }
    return ApiResponse(
      success: true,
      data: payload,
    );
  }

  ApiResponse copyWith({
    bool? success,
    int? code,
    dynamic data,
    dynamic errors,
    String? message,
    String? timestamp,
  }) {
    return ApiResponse(
      success: success ?? this.success,
      code: code ?? this.code,
      data: data ?? this.data,
      errors: errors ?? this.errors,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// 解析 code 字段为 int，后端始终返回 int，做防御性兼容
  static int? _parseCode(dynamic value) {
    if (value is int) return value;
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}
