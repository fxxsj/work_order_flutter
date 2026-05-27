// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  const factory AuditLog({
    @JsonKey(fromJson: _stringFromJson) required String id,
    @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
    String? actionType,
    @JsonKey(fromJson: _stringOrNullFromJson) String? username,
    @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
    String? contentTypeName,
    @JsonKey(name: 'object_id', fromJson: _stringOrNullFromJson)
    String? objectId,
    @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
    String? objectRepr,
    @JsonKey(name: 'changed_fields', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> changedFields,
    @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
    String? ipAddress,
    @JsonKey(name: 'request_method', fromJson: _stringOrNullFromJson)
    String? requestMethod,
    @JsonKey(name: 'request_path', fromJson: _stringOrNullFromJson)
    String? requestPath,
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}

String _stringFromJson(Object? value) => toStringOrNull(value) ?? '';

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

List<String> _stringListFromJson(Object? value) {
  if (value is List) return value.map((item) => item.toString()).toList();
  final text = toStringOrNull(value);
  return text == null || text.isEmpty ? const [] : [text];
}
