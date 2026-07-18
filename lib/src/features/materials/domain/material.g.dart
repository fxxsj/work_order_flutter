// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaterialItem _$MaterialItemFromJson(Map<String, dynamic> json) =>
    _MaterialItem(
      id: _intFromJson(json['id']),
      code: _stringFromJson(json['code']),
      name: _stringFromJson(json['name']),
      specification: _stringOrNullFromJson(json['specification']),
      specificationLevel: _stringOrNullFromJson(json['specification_level']),
      materialType: _stringOrNullFromJson(json['material_type']),
      unit: _stringOrNullFromJson(json['unit']),
      unitPrice: _doubleOrNullFromJson(json['unit_price']),
      stockQuantity: _doubleOrNullFromJson(json['stock_quantity']),
      minStockQuantity: _doubleOrNullFromJson(json['min_stock_quantity']),
      defaultSupplier: _intOrNullFromJson(json['default_supplier']),
      leadTimeDays: _intOrNullFromJson(json['lead_time_days']),
      needCutting: _boolOrNullFromJson(json['need_cutting']),
      isActive: _boolOrNullFromJson(json['is_active']),
      notes: _stringOrNullFromJson(json['notes']),
    );

Map<String, dynamic> _$MaterialItemToJson(_MaterialItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'specification': instance.specification,
      'specification_level': instance.specificationLevel,
      'material_type': instance.materialType,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'stock_quantity': instance.stockQuantity,
      'min_stock_quantity': instance.minStockQuantity,
      'default_supplier': instance.defaultSupplier,
      'lead_time_days': instance.leadTimeDays,
      'need_cutting': instance.needCutting,
      'is_active': instance.isActive,
      'notes': instance.notes,
    };
