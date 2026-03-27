// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'material.freezed.dart';
part 'material.g.dart';

@freezed
class MaterialItem with _$MaterialItem {
  const factory MaterialItem({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String code,
    @JsonKey(fromJson: _stringFromJson) required String name,
    @JsonKey(fromJson: _stringOrNullFromJson) String? unit,
    @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
    double? unitPrice,
    @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
    double? stockQuantity,
    @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
    double? minStockQuantity,
    @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,
  }) = _MaterialItem;

  factory MaterialItem.fromJson(Map<String, dynamic> json) =>
      _$MaterialItemFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

double? _doubleOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

bool? _boolOrNullFromJson(Object? value) {
  if (value == null) return null;
  return value == true;
}
