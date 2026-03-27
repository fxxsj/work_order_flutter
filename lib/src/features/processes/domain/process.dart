// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'process.freezed.dart';
part 'process.g.dart';

/// 工序领域模型。
@freezed
class Process with _$Process {
  const factory Process({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String code,
    @JsonKey(fromJson: _stringFromJson) required String name,
    @JsonKey(fromJson: _stringOrNullFromJson) String? description,
    @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
    double? standardDuration,
    @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,
    @JsonKey(name: 'is_active', fromJson: _boolFromJson)
    @Default(true)
    bool isActive,
  }) = _Process;

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);
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

bool _boolFromJson(Object? value) {
  if (value == null) return true;
  return value == true;
}
