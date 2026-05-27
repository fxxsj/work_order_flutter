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
      totalCost: _doubleOrNullFromJson(_readTotalCost(json, 'total_cost')),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      calculatedAt: _dateTimeOrNullFromJson(
        _readCalculatedAt(json, 'calculated_at'),
      ),
    );

Map<String, dynamic> _$ProductionCostToJson(_ProductionCost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'work_order_number': instance.workOrderNumber,
      'total_cost': instance.totalCost,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'calculated_at': instance.calculatedAt?.toIso8601String(),
    };
