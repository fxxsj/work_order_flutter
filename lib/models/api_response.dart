class ApiResponse {
  final bool success;
  final String? code;
  final dynamic data;
  final String? message;

  const ApiResponse({
    required this.success,
    this.code,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(dynamic payload) {
    if (payload is ApiResponse) {
      return payload;
    }
    if (payload is Map<String, dynamic>) {
      return ApiResponse(
        success: payload['success'] == true,
        code: payload['code']?.toString(),
        data: payload['data'],
        message: payload['message']?.toString(),
      );
    }
    return ApiResponse(
      success: true,
      data: payload,
    );
  }

  ApiResponse copyWith({
    bool? success,
    String? code,
    dynamic data,
    String? message,
  }) {
    return ApiResponse(
      success: success ?? this.success,
      code: code ?? this.code,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
