// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaterialItemImpl _$$MaterialItemImplFromJson(Map<String, dynamic> json) =>
    _$MaterialItemImpl(
      id: _intFromJson(json['id']),
      code: _stringFromJson(json['code']),
      name: _stringFromJson(json['name']),
      unit: _stringOrNullFromJson(json['unit']),
      unitPrice: _doubleOrNullFromJson(json['unit_price']),
      stockQuantity: _doubleOrNullFromJson(json['stock_quantity']),
      minStockQuantity: _doubleOrNullFromJson(json['min_stock_quantity']),
      isActive: _boolOrNullFromJson(json['is_active']),
    );

Map<String, dynamic> _$$MaterialItemImplToJson(_$MaterialItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'stock_quantity': instance.stockQuantity,
      'min_stock_quantity': instance.minStockQuantity,
      'is_active': instance.isActive,
    };
