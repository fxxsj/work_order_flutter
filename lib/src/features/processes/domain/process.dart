// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'process.freezed.dart';
part 'process.g.dart';

/// 工序领域模型。
@freezed
abstract class Process with _$Process {
  const factory Process({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String code,
    @JsonKey(fromJson: _stringFromJson) required String name,
    @JsonKey(fromJson: _stringOrNullFromJson) String? description,
    @JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson)
    int? standardDuration,
    @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,
    @JsonKey(name: 'is_active', fromJson: _boolTrueFromJson)
    @Default(true)
    bool isActive,
    @JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson)
    @Default(false)
    bool isBuiltin,
    @JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson)
    @Default('general')
    String taskGenerationRule,
    @JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson)
    @Default(false)
    bool requiresArtwork,
    @JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson)
    @Default(false)
    bool requiresDie,
    @JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson)
    @Default(false)
    bool requiresFoilingPlate,
    @JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson)
    @Default(false)
    bool requiresEmbossingPlate,
    @JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson)
    @Default(true)
    bool artworkRequired,
    @JsonKey(name: 'die_required', fromJson: _boolTrueFromJson)
    @Default(true)
    bool dieRequired,
    @JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson)
    @Default(true)
    bool foilingPlateRequired,
    @JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson)
    @Default(true)
    bool embossingPlateRequired,
    @JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson)
    @Default(false)
    bool isParallel,
    @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeOrNullFromJson,
      toJson: _dateTimeOrNullToJson,
    )
    DateTime? createdAt,
  }) = _Process;

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

bool _boolTrueFromJson(Object? value) {
  if (value == null) return true;
  return value == true;
}

bool _boolFalseFromJson(Object? value) {
  if (value == null) return false;
  return value == true;
}

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

String? _dateTimeOrNullToJson(DateTime? value) => value?.toIso8601String();
