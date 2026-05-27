// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'production_cost.freezed.dart';
part 'production_cost.g.dart';

@freezed
abstract class ProductionCost with _$ProductionCost {
  const factory ProductionCost({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson,
    )
    String? workOrderNumber,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
    String? productName,
    @JsonKey(fromJson: _stringOrNullFromJson) String? period,
    @JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson)
    double? materialCost,
    @JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson)
    double? laborCost,
    @JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson)
    double? equipmentCost,
    @JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson)
    double? overheadCost,
    @JsonKey(
      name: 'total_cost',
      readValue: _readTotalCost,
      fromJson: _doubleOrNullFromJson,
    )
    double? totalCost,
    @JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson)
    double? standardCost,
    @JsonKey(fromJson: _doubleOrNullFromJson) double? variance,
    @JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson)
    double? varianceRate,
    @JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson)
    String? varianceRateFormatted,
    @JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson)
    String? calculatedByName,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
    @JsonKey(
      name: 'calculated_at',
      readValue: _readCalculatedAt,
      fromJson: _dateTimeOrNullFromJson,
    )
    DateTime? calculatedAt,
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? updatedAt,
  }) = _ProductionCost;

  factory ProductionCost.fromJson(Map<String, dynamic> json) =>
      _$ProductionCostFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

double? _doubleOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

Object? _readWorkOrderNumber(Map json, String key) {
  return json[key] ?? json['workorder_number'];
}

Object? _readTotalCost(Map json, String key) {
  return json[key] ?? json['amount'];
}

Object? _readCalculatedAt(Map json, String key) {
  return json['updated_at'] ?? json[key];
}
