// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductGroupImpl _$$ProductGroupImplFromJson(Map<String, dynamic> json) =>
    _$ProductGroupImpl(
      id: _intFromJson(json['id']),
      code: _stringFromJson(json['code']),
      name: _stringFromJson(json['name']),
      description: _stringOrNullFromJson(json['description']),
      isActive: _boolOrNullFromJson(json['is_active']),
      itemsCount: _intOrNullFromJson(_readItemsCount(json, 'items_count')),
    );

Map<String, dynamic> _$$ProductGroupImplToJson(_$ProductGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'is_active': instance.isActive,
      'items_count': instance.itemsCount,
    };
