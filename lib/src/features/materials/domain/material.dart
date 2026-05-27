// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'material.freezed.dart';
part 'material.g.dart';

@freezed
abstract class MaterialItem with _$MaterialItem {
  const factory MaterialItem({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String code,
    @JsonKey(fromJson: _stringFromJson) required String name,
    @JsonKey(fromJson: _stringOrNullFromJson) String? specification,
    @JsonKey(fromJson: _stringOrNullFromJson) String? unit,
    @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
    double? unitPrice,
    @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
    double? stockQuantity,
    @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
    double? minStockQuantity,
    @JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson)
    int? defaultSupplier,
    @JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson)
    int? leadTimeDays,
    @JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson)
    bool? needCutting,
    @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
  }) = _MaterialItem;

  factory MaterialItem.fromJson(Map<String, dynamic> json) =>
      _$MaterialItemFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

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

class MaterialSupplierOption {
  const MaterialSupplierOption({
    required this.id,
    required this.name,
    this.code,
  });

  final int id;
  final String name;
  final String? code;

  factory MaterialSupplierOption.fromJson(Map<String, dynamic> json) {
    return MaterialSupplierOption(
      id: toInt(json['id']) ?? 0,
      name: _stringFromJson(json['name']),
      code: _stringOrNullFromJson(json['code']),
    );
  }

  String get label {
    final supplierCode = code;
    if (supplierCode == null || supplierCode.isEmpty) return name;
    return '$supplierCode - $name';
  }
}
