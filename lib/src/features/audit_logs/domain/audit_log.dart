// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  const factory AuditLog({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
    String? actionType,
    @JsonKey(fromJson: _stringOrNullFromJson) String? username,
    @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
    String? contentTypeName,
    @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
    String? objectRepr,
    @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
    String? changedFields,
    @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
    String? ipAddress,
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);
