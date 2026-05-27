// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Process _$ProcessFromJson(Map<String, dynamic> json) => _Process(
  id: _intFromJson(json['id']),
  code: _stringFromJson(json['code']),
  name: _stringFromJson(json['name']),
  description: _stringOrNullFromJson(json['description']),
  standardDuration: _intOrNullFromJson(json['standard_duration']),
  sortOrder: _intOrNullFromJson(json['sort_order']),
  isActive: json['is_active'] == null
      ? true
      : _boolTrueFromJson(json['is_active']),
  isBuiltin: json['is_builtin'] == null
      ? false
      : _boolFalseFromJson(json['is_builtin']),
  taskGenerationRule: json['task_generation_rule'] == null
      ? 'general'
      : _stringFromJson(json['task_generation_rule']),
  requiresArtwork: json['requires_artwork'] == null
      ? false
      : _boolFalseFromJson(json['requires_artwork']),
  requiresDie: json['requires_die'] == null
      ? false
      : _boolFalseFromJson(json['requires_die']),
  requiresFoilingPlate: json['requires_foiling_plate'] == null
      ? false
      : _boolFalseFromJson(json['requires_foiling_plate']),
  requiresEmbossingPlate: json['requires_embossing_plate'] == null
      ? false
      : _boolFalseFromJson(json['requires_embossing_plate']),
  artworkRequired: json['artwork_required'] == null
      ? true
      : _boolTrueFromJson(json['artwork_required']),
  dieRequired: json['die_required'] == null
      ? true
      : _boolTrueFromJson(json['die_required']),
  foilingPlateRequired: json['foiling_plate_required'] == null
      ? true
      : _boolTrueFromJson(json['foiling_plate_required']),
  embossingPlateRequired: json['embossing_plate_required'] == null
      ? true
      : _boolTrueFromJson(json['embossing_plate_required']),
  isParallel: json['is_parallel'] == null
      ? false
      : _boolFalseFromJson(json['is_parallel']),
  createdAt: _dateTimeOrNullFromJson(json['created_at']),
);

Map<String, dynamic> _$ProcessToJson(_Process instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'description': instance.description,
  'standard_duration': instance.standardDuration,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'is_builtin': instance.isBuiltin,
  'task_generation_rule': instance.taskGenerationRule,
  'requires_artwork': instance.requiresArtwork,
  'requires_die': instance.requiresDie,
  'requires_foiling_plate': instance.requiresFoilingPlate,
  'requires_embossing_plate': instance.requiresEmbossingPlate,
  'artwork_required': instance.artworkRequired,
  'die_required': instance.dieRequired,
  'foiling_plate_required': instance.foilingPlateRequired,
  'embossing_plate_required': instance.embossingPlateRequired,
  'is_parallel': instance.isParallel,
  'created_at': _dateTimeOrNullToJson(instance.createdAt),
};
