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
    @JsonKey(
      name: 'total_cost',
      readValue: _readTotalCost,
      fromJson: _doubleOrNullFromJson,
    )
    double? totalCost,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(
      name: 'calculated_at',
      readValue: _readCalculatedAt,
      fromJson: _dateTimeOrNullFromJson,
    )
    DateTime? calculatedAt,
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
