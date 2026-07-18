import 'package:work_order_app/src/core/common/api_exception.dart';

/// Extracts a map payload from a raw Dio response.
///
/// [ApiClient.requestRaw] intentionally bypasses the normal response parsing,
/// so standard API envelopes still have the shape `{success, data, ...}`.
/// Legacy endpoints that return a map directly remain supported.
Map<String, dynamic> requireRawApiResponseData({
  required String label,
  required dynamic data,
}) {
  final body = _requireMap(label, data);
  final isEnvelope = body.containsKey('success');

  if (!isEnvelope) {
    return body;
  }

  if (body['success'] == false) {
    throw ApiException(
      message: body['message']?.toString().trim().isNotEmpty == true
          ? body['message'].toString()
          : '$label 失败',
      data: data,
    );
  }

  final payload = body['data'];
  if (payload is Map) {
    return Map<String, dynamic>.from(payload);
  }
  throw ApiException(message: '$label 响应数据异常', data: data);
}

Map<String, dynamic> _requireMap(String label, dynamic data) {
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  throw ApiException(message: '$label 响应格式异常', data: data);
}
