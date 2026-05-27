// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Process _$ProcessFromJson(Map<String, dynamic> json) => _Process(
  id: _intFromJson(json['id']),
  code: _stringFromJson(json['code']),
  name: _stringFromJson(json['name']),
  description: _stringOrNullFromJson(json['description']),
  standardDuration: _doubleOrNullFromJson(json['standard_duration']),
  sortOrder: _intOrNullFromJson(json['sort_order']),
  isActive: json['is_active'] == null ? true : _boolFromJson(json['is_active']),
);

Map<String, dynamic> _$ProcessToJson(_Process instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'description': instance.description,
  'standard_duration': instance.standardDuration,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
};
