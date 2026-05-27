// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => _AuditLog(
  id: _stringFromJson(json['id']),
  actionType: _stringOrNullFromJson(json['action_type']),
  username: _stringOrNullFromJson(json['username']),
  contentTypeName: _stringOrNullFromJson(json['content_type_name']),
  objectId: _stringOrNullFromJson(json['object_id']),
  objectRepr: _stringOrNullFromJson(json['object_repr']),
  changedFields: json['changed_fields'] == null
      ? const <String>[]
      : _stringListFromJson(json['changed_fields']),
  ipAddress: _stringOrNullFromJson(json['ip_address']),
  requestMethod: _stringOrNullFromJson(json['request_method']),
  requestPath: _stringOrNullFromJson(json['request_path']),
  createdAt: _dateTimeOrNullFromJson(json['created_at']),
);

Map<String, dynamic> _$AuditLogToJson(_AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'action_type': instance.actionType,
  'username': instance.username,
  'content_type_name': instance.contentTypeName,
  'object_id': instance.objectId,
  'object_repr': instance.objectRepr,
  'changed_fields': instance.changedFields,
  'ip_address': instance.ipAddress,
  'request_method': instance.requestMethod,
  'request_path': instance.requestPath,
  'created_at': instance.createdAt?.toIso8601String(),
};
