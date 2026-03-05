import 'package:work_order_app/src/core/utils/parse_utils.dart';

class AuditLog {
  const AuditLog({
    required this.id,
    this.actionType,
    this.username,
    this.contentTypeName,
    this.objectRepr,
    this.changedFields,
    this.ipAddress,
    this.createdAt,
  });

  final int id;
  final String? actionType;
  final String? username;
  final String? contentTypeName;
  final String? objectRepr;
  final String? changedFields;
  final String? ipAddress;
  final DateTime? createdAt;

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: toInt(json['id']) ?? 0,
      actionType: toStringOrNull(json['action_type']),
      username: toStringOrNull(json['username']),
      contentTypeName: toStringOrNull(json['content_type_name']),
      objectRepr: toStringOrNull(json['object_repr']),
      changedFields: toStringOrNull(json['changed_fields']),
      ipAddress: toStringOrNull(json['ip_address']),
      createdAt: toDateTime(json['created_at']),
    );
  }
}
