// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'product_group.freezed.dart';
part 'product_group.g.dart';

@freezed
abstract class ProductGroup with _$ProductGroup {
  const factory ProductGroup({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String code,
    @JsonKey(fromJson: _stringFromJson) required String name,
    @JsonKey(fromJson: _stringOrNullFromJson) String? description,
    @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,
    @JsonKey(
      name: 'items_count',
      readValue: _readItemsCount,
      fromJson: _intOrNullFromJson,
    )
    int? itemsCount,
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? updatedAt,
  }) = _ProductGroup;

  factory ProductGroup.fromJson(Map<String, dynamic> json) =>
      _$ProductGroupFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

bool? _boolOrNullFromJson(Object? value) {
  if (value == null) return null;
  return value == true;
}

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

Object? _readItemsCount(Map json, String key) {
  final items = json['items'];
  if (items is List) {
    return items.length;
  }
  return json[key];
}
