// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductGroup _$ProductGroupFromJson(Map<String, dynamic> json) =>
    _ProductGroup(
      id: _intFromJson(json['id']),
      code: _stringFromJson(json['code']),
      name: _stringFromJson(json['name']),
      description: _stringOrNullFromJson(json['description']),
      isActive: _boolOrNullFromJson(json['is_active']),
      itemsCount: _intOrNullFromJson(_readItemsCount(json, 'items_count')),
      createdAt: _dateTimeOrNullFromJson(json['created_at']),
      updatedAt: _dateTimeOrNullFromJson(json['updated_at']),
    );

Map<String, dynamic> _$ProductGroupToJson(_ProductGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'is_active': instance.isActive,
      'items_count': instance.itemsCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
