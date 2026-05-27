// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_cost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductionCost _$ProductionCostFromJson(Map<String, dynamic> json) =>
    _ProductionCost(
      id: _intFromJson(json['id']),
      workOrderNumber: _stringOrNullFromJson(
        _readWorkOrderNumber(json, 'work_order_number'),
      ),
      customerName: _stringOrNullFromJson(json['customer_name']),
      productName: _stringOrNullFromJson(json['product_name']),
      period: _stringOrNullFromJson(json['period']),
      materialCost: _doubleOrNullFromJson(json['material_cost']),
      laborCost: _doubleOrNullFromJson(json['labor_cost']),
      equipmentCost: _doubleOrNullFromJson(json['equipment_cost']),
      overheadCost: _doubleOrNullFromJson(json['overhead_cost']),
      totalCost: _doubleOrNullFromJson(_readTotalCost(json, 'total_cost')),
      standardCost: _doubleOrNullFromJson(json['standard_cost']),
      variance: _doubleOrNullFromJson(json['variance']),
      varianceRate: _doubleOrNullFromJson(json['variance_rate']),
      varianceRateFormatted: _stringOrNullFromJson(
        json['variance_rate_formatted'],
      ),
      calculatedByName: _stringOrNullFromJson(json['calculated_by_name']),
      notes: _stringOrNullFromJson(json['notes']),
      calculatedAt: _dateTimeOrNullFromJson(
        _readCalculatedAt(json, 'calculated_at'),
      ),
      createdAt: _dateTimeOrNullFromJson(json['created_at']),
      updatedAt: _dateTimeOrNullFromJson(json['updated_at']),
    );

Map<String, dynamic> _$ProductionCostToJson(_ProductionCost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'work_order_number': instance.workOrderNumber,
      'customer_name': instance.customerName,
      'product_name': instance.productName,
      'period': instance.period,
      'material_cost': instance.materialCost,
      'labor_cost': instance.laborCost,
      'equipment_cost': instance.equipmentCost,
      'overhead_cost': instance.overheadCost,
      'total_cost': instance.totalCost,
      'standard_cost': instance.standardCost,
      'variance': instance.variance,
      'variance_rate': instance.varianceRate,
      'variance_rate_formatted': instance.varianceRateFormatted,
      'calculated_by_name': instance.calculatedByName,
      'notes': instance.notes,
      'calculated_at': instance.calculatedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
