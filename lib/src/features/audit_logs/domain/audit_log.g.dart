// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => _AuditLog(
  id: _intFromJson(json['id']),
  actionType: _stringOrNullFromJson(json['action_type']),
  username: _stringOrNullFromJson(json['username']),
  contentTypeName: _stringOrNullFromJson(json['content_type_name']),
  objectRepr: _stringOrNullFromJson(json['object_repr']),
  changedFields: _stringOrNullFromJson(json['changed_fields']),
  ipAddress: _stringOrNullFromJson(json['ip_address']),
  createdAt: _dateTimeOrNullFromJson(json['created_at']),
);

Map<String, dynamic> _$AuditLogToJson(_AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'action_type': instance.actionType,
  'username': instance.username,
  'content_type_name': instance.contentTypeName,
  'object_repr': instance.objectRepr,
  'changed_fields': instance.changedFields,
  'ip_address': instance.ipAddress,
  'created_at': instance.createdAt?.toIso8601String(),
};
