import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

Map<String, dynamic> requireImageUploadResponseData({
  required String label,
  required dynamic data,
}) {
  final body = _requireMap(label, data);
  final map = body['data'] is Map
      ? Map<String, dynamic>.from(body['data'] as Map)
      : body;

  final imageId = toInt(map['id']);
  final imageUrl = toStringOrNull(map['image']);
  if (imageId == null || imageId <= 0 || imageUrl == null) {
    throw ApiException(message: '$label 响应数据异常', data: data);
  }
  return map;
}

Map<String, dynamic> _requireMap(String label, dynamic data) {
  if (data is Map<String, dynamic>) {
    return Map<String, dynamic>.from(data);
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  throw ApiException(message: '$label 响应格式异常', data: data);
}
