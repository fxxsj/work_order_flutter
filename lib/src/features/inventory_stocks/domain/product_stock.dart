// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'product_stock.freezed.dart';
part 'product_stock.g.dart';

@freezed
class ProductStock with _$ProductStock {
  const factory ProductStock({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
    String? productName,
    @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
    String? productCode,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? batchNo,
    @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
    String? workOrderNumber,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
    @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
    double? reservedQuantity,
    @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
    double? availableQuantity,
    @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
    int? minStockLevel,
    @JsonKey(fromJson: _stringOrNullFromJson) String? location,
    @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? productionDate,
    @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
    double? unitCost,
    @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
    double? totalValue,
    @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
    bool? isLowStock,
    @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? expiryDate,
    @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
    int? daysUntilExpiry,
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
  }) = _ProductStock;

  factory ProductStock.fromJson(Map<String, dynamic> json) =>
      _$ProductStockFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

double? _doubleOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

bool? _boolOrNullFromJson(Object? value) {
  if (value == null) return null;
  return value == true;
}
