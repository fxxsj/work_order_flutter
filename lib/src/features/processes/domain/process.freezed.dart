// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'process.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Process {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(fromJson: _stringFromJson) String get code;@JsonKey(fromJson: _stringFromJson) String get name;@JsonKey(fromJson: _stringOrNullFromJson) String? get description;@JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson) int? get standardDuration;@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? get sortOrder;@JsonKey(name: 'is_active', fromJson: _boolTrueFromJson) bool get isActive;@JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson) bool get isBuiltin;@JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson) String get taskGenerationRule;@JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson) bool get requiresArtwork;@JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson) bool get requiresDie;@JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson) bool get requiresFoilingPlate;@JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson) bool get requiresEmbossingPlate;@JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson) bool get artworkRequired;@JsonKey(name: 'die_required', fromJson: _boolTrueFromJson) bool get dieRequired;@JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson) bool get foilingPlateRequired;@JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson) bool get embossingPlateRequired;@JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson) bool get isParallel;@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? get createdAt;
/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessCopyWith<Process> get copyWith => _$ProcessCopyWithImpl<Process>(this as Process, _$identity);

  /// Serializes this Process to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Process&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.standardDuration, standardDuration) || other.standardDuration == standardDuration)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isBuiltin, isBuiltin) || other.isBuiltin == isBuiltin)&&(identical(other.taskGenerationRule, taskGenerationRule) || other.taskGenerationRule == taskGenerationRule)&&(identical(other.requiresArtwork, requiresArtwork) || other.requiresArtwork == requiresArtwork)&&(identical(other.requiresDie, requiresDie) || other.requiresDie == requiresDie)&&(identical(other.requiresFoilingPlate, requiresFoilingPlate) || other.requiresFoilingPlate == requiresFoilingPlate)&&(identical(other.requiresEmbossingPlate, requiresEmbossingPlate) || other.requiresEmbossingPlate == requiresEmbossingPlate)&&(identical(other.artworkRequired, artworkRequired) || other.artworkRequired == artworkRequired)&&(identical(other.dieRequired, dieRequired) || other.dieRequired == dieRequired)&&(identical(other.foilingPlateRequired, foilingPlateRequired) || other.foilingPlateRequired == foilingPlateRequired)&&(identical(other.embossingPlateRequired, embossingPlateRequired) || other.embossingPlateRequired == embossingPlateRequired)&&(identical(other.isParallel, isParallel) || other.isParallel == isParallel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,code,name,description,standardDuration,sortOrder,isActive,isBuiltin,taskGenerationRule,requiresArtwork,requiresDie,requiresFoilingPlate,requiresEmbossingPlate,artworkRequired,dieRequired,foilingPlateRequired,embossingPlateRequired,isParallel,createdAt]);

@override
String toString() {
  return 'Process(id: $id, code: $code, name: $name, description: $description, standardDuration: $standardDuration, sortOrder: $sortOrder, isActive: $isActive, isBuiltin: $isBuiltin, taskGenerationRule: $taskGenerationRule, requiresArtwork: $requiresArtwork, requiresDie: $requiresDie, requiresFoilingPlate: $requiresFoilingPlate, requiresEmbossingPlate: $requiresEmbossingPlate, artworkRequired: $artworkRequired, dieRequired: $dieRequired, foilingPlateRequired: $foilingPlateRequired, embossingPlateRequired: $embossingPlateRequired, isParallel: $isParallel, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProcessCopyWith<$Res>  {
  factory $ProcessCopyWith(Process value, $Res Function(Process) _then) = _$ProcessCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? description,@JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson) int? standardDuration,@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,@JsonKey(name: 'is_active', fromJson: _boolTrueFromJson) bool isActive,@JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson) bool isBuiltin,@JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson) String taskGenerationRule,@JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson) bool requiresArtwork,@JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson) bool requiresDie,@JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson) bool requiresFoilingPlate,@JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson) bool requiresEmbossingPlate,@JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson) bool artworkRequired,@JsonKey(name: 'die_required', fromJson: _boolTrueFromJson) bool dieRequired,@JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson) bool foilingPlateRequired,@JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson) bool embossingPlateRequired,@JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson) bool isParallel,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? createdAt
});




}
/// @nodoc
class _$ProcessCopyWithImpl<$Res>
    implements $ProcessCopyWith<$Res> {
  _$ProcessCopyWithImpl(this._self, this._then);

  final Process _self;
  final $Res Function(Process) _then;

/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? standardDuration = freezed,Object? sortOrder = freezed,Object? isActive = null,Object? isBuiltin = null,Object? taskGenerationRule = null,Object? requiresArtwork = null,Object? requiresDie = null,Object? requiresFoilingPlate = null,Object? requiresEmbossingPlate = null,Object? artworkRequired = null,Object? dieRequired = null,Object? foilingPlateRequired = null,Object? embossingPlateRequired = null,Object? isParallel = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,standardDuration: freezed == standardDuration ? _self.standardDuration : standardDuration // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isBuiltin: null == isBuiltin ? _self.isBuiltin : isBuiltin // ignore: cast_nullable_to_non_nullable
as bool,taskGenerationRule: null == taskGenerationRule ? _self.taskGenerationRule : taskGenerationRule // ignore: cast_nullable_to_non_nullable
as String,requiresArtwork: null == requiresArtwork ? _self.requiresArtwork : requiresArtwork // ignore: cast_nullable_to_non_nullable
as bool,requiresDie: null == requiresDie ? _self.requiresDie : requiresDie // ignore: cast_nullable_to_non_nullable
as bool,requiresFoilingPlate: null == requiresFoilingPlate ? _self.requiresFoilingPlate : requiresFoilingPlate // ignore: cast_nullable_to_non_nullable
as bool,requiresEmbossingPlate: null == requiresEmbossingPlate ? _self.requiresEmbossingPlate : requiresEmbossingPlate // ignore: cast_nullable_to_non_nullable
as bool,artworkRequired: null == artworkRequired ? _self.artworkRequired : artworkRequired // ignore: cast_nullable_to_non_nullable
as bool,dieRequired: null == dieRequired ? _self.dieRequired : dieRequired // ignore: cast_nullable_to_non_nullable
as bool,foilingPlateRequired: null == foilingPlateRequired ? _self.foilingPlateRequired : foilingPlateRequired // ignore: cast_nullable_to_non_nullable
as bool,embossingPlateRequired: null == embossingPlateRequired ? _self.embossingPlateRequired : embossingPlateRequired // ignore: cast_nullable_to_non_nullable
as bool,isParallel: null == isParallel ? _self.isParallel : isParallel // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Process].
extension ProcessPatterns on Process {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Process value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Process() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Process value)  $default,){
final _that = this;
switch (_that) {
case _Process():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Process value)?  $default,){
final _that = this;
switch (_that) {
case _Process() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson)  int? standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)  int? sortOrder, @JsonKey(name: 'is_active', fromJson: _boolTrueFromJson)  bool isActive, @JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson)  bool isBuiltin, @JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson)  String taskGenerationRule, @JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson)  bool requiresArtwork, @JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson)  bool requiresDie, @JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson)  bool requiresFoilingPlate, @JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson)  bool requiresEmbossingPlate, @JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson)  bool artworkRequired, @JsonKey(name: 'die_required', fromJson: _boolTrueFromJson)  bool dieRequired, @JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson)  bool foilingPlateRequired, @JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson)  bool embossingPlateRequired, @JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson)  bool isParallel, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Process() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.standardDuration,_that.sortOrder,_that.isActive,_that.isBuiltin,_that.taskGenerationRule,_that.requiresArtwork,_that.requiresDie,_that.requiresFoilingPlate,_that.requiresEmbossingPlate,_that.artworkRequired,_that.dieRequired,_that.foilingPlateRequired,_that.embossingPlateRequired,_that.isParallel,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson)  int? standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)  int? sortOrder, @JsonKey(name: 'is_active', fromJson: _boolTrueFromJson)  bool isActive, @JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson)  bool isBuiltin, @JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson)  String taskGenerationRule, @JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson)  bool requiresArtwork, @JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson)  bool requiresDie, @JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson)  bool requiresFoilingPlate, @JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson)  bool requiresEmbossingPlate, @JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson)  bool artworkRequired, @JsonKey(name: 'die_required', fromJson: _boolTrueFromJson)  bool dieRequired, @JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson)  bool foilingPlateRequired, @JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson)  bool embossingPlateRequired, @JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson)  bool isParallel, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Process():
return $default(_that.id,_that.code,_that.name,_that.description,_that.standardDuration,_that.sortOrder,_that.isActive,_that.isBuiltin,_that.taskGenerationRule,_that.requiresArtwork,_that.requiresDie,_that.requiresFoilingPlate,_that.requiresEmbossingPlate,_that.artworkRequired,_that.dieRequired,_that.foilingPlateRequired,_that.embossingPlateRequired,_that.isParallel,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson)  int? standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)  int? sortOrder, @JsonKey(name: 'is_active', fromJson: _boolTrueFromJson)  bool isActive, @JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson)  bool isBuiltin, @JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson)  String taskGenerationRule, @JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson)  bool requiresArtwork, @JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson)  bool requiresDie, @JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson)  bool requiresFoilingPlate, @JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson)  bool requiresEmbossingPlate, @JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson)  bool artworkRequired, @JsonKey(name: 'die_required', fromJson: _boolTrueFromJson)  bool dieRequired, @JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson)  bool foilingPlateRequired, @JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson)  bool embossingPlateRequired, @JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson)  bool isParallel, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Process() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.standardDuration,_that.sortOrder,_that.isActive,_that.isBuiltin,_that.taskGenerationRule,_that.requiresArtwork,_that.requiresDie,_that.requiresFoilingPlate,_that.requiresEmbossingPlate,_that.artworkRequired,_that.dieRequired,_that.foilingPlateRequired,_that.embossingPlateRequired,_that.isParallel,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Process implements Process {
  const _Process({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(fromJson: _stringFromJson) required this.code, @JsonKey(fromJson: _stringFromJson) required this.name, @JsonKey(fromJson: _stringOrNullFromJson) this.description, @JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson) this.standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) this.sortOrder, @JsonKey(name: 'is_active', fromJson: _boolTrueFromJson) this.isActive = true, @JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson) this.isBuiltin = false, @JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson) this.taskGenerationRule = 'general', @JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson) this.requiresArtwork = false, @JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson) this.requiresDie = false, @JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson) this.requiresFoilingPlate = false, @JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson) this.requiresEmbossingPlate = false, @JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson) this.artworkRequired = true, @JsonKey(name: 'die_required', fromJson: _boolTrueFromJson) this.dieRequired = true, @JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson) this.foilingPlateRequired = true, @JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson) this.embossingPlateRequired = true, @JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson) this.isParallel = false, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) this.createdAt});
  factory _Process.fromJson(Map<String, dynamic> json) => _$ProcessFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(fromJson: _stringFromJson) final  String code;
@override@JsonKey(fromJson: _stringFromJson) final  String name;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? description;
@override@JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson) final  int? standardDuration;
@override@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) final  int? sortOrder;
@override@JsonKey(name: 'is_active', fromJson: _boolTrueFromJson) final  bool isActive;
@override@JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson) final  bool isBuiltin;
@override@JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson) final  String taskGenerationRule;
@override@JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson) final  bool requiresArtwork;
@override@JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson) final  bool requiresDie;
@override@JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson) final  bool requiresFoilingPlate;
@override@JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson) final  bool requiresEmbossingPlate;
@override@JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson) final  bool artworkRequired;
@override@JsonKey(name: 'die_required', fromJson: _boolTrueFromJson) final  bool dieRequired;
@override@JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson) final  bool foilingPlateRequired;
@override@JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson) final  bool embossingPlateRequired;
@override@JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson) final  bool isParallel;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) final  DateTime? createdAt;

/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcessCopyWith<_Process> get copyWith => __$ProcessCopyWithImpl<_Process>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProcessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Process&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.standardDuration, standardDuration) || other.standardDuration == standardDuration)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isBuiltin, isBuiltin) || other.isBuiltin == isBuiltin)&&(identical(other.taskGenerationRule, taskGenerationRule) || other.taskGenerationRule == taskGenerationRule)&&(identical(other.requiresArtwork, requiresArtwork) || other.requiresArtwork == requiresArtwork)&&(identical(other.requiresDie, requiresDie) || other.requiresDie == requiresDie)&&(identical(other.requiresFoilingPlate, requiresFoilingPlate) || other.requiresFoilingPlate == requiresFoilingPlate)&&(identical(other.requiresEmbossingPlate, requiresEmbossingPlate) || other.requiresEmbossingPlate == requiresEmbossingPlate)&&(identical(other.artworkRequired, artworkRequired) || other.artworkRequired == artworkRequired)&&(identical(other.dieRequired, dieRequired) || other.dieRequired == dieRequired)&&(identical(other.foilingPlateRequired, foilingPlateRequired) || other.foilingPlateRequired == foilingPlateRequired)&&(identical(other.embossingPlateRequired, embossingPlateRequired) || other.embossingPlateRequired == embossingPlateRequired)&&(identical(other.isParallel, isParallel) || other.isParallel == isParallel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,code,name,description,standardDuration,sortOrder,isActive,isBuiltin,taskGenerationRule,requiresArtwork,requiresDie,requiresFoilingPlate,requiresEmbossingPlate,artworkRequired,dieRequired,foilingPlateRequired,embossingPlateRequired,isParallel,createdAt]);

@override
String toString() {
  return 'Process(id: $id, code: $code, name: $name, description: $description, standardDuration: $standardDuration, sortOrder: $sortOrder, isActive: $isActive, isBuiltin: $isBuiltin, taskGenerationRule: $taskGenerationRule, requiresArtwork: $requiresArtwork, requiresDie: $requiresDie, requiresFoilingPlate: $requiresFoilingPlate, requiresEmbossingPlate: $requiresEmbossingPlate, artworkRequired: $artworkRequired, dieRequired: $dieRequired, foilingPlateRequired: $foilingPlateRequired, embossingPlateRequired: $embossingPlateRequired, isParallel: $isParallel, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProcessCopyWith<$Res> implements $ProcessCopyWith<$Res> {
  factory _$ProcessCopyWith(_Process value, $Res Function(_Process) _then) = __$ProcessCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? description,@JsonKey(name: 'standard_duration', fromJson: _intOrNullFromJson) int? standardDuration,@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,@JsonKey(name: 'is_active', fromJson: _boolTrueFromJson) bool isActive,@JsonKey(name: 'is_builtin', fromJson: _boolFalseFromJson) bool isBuiltin,@JsonKey(name: 'task_generation_rule', fromJson: _stringFromJson) String taskGenerationRule,@JsonKey(name: 'requires_artwork', fromJson: _boolFalseFromJson) bool requiresArtwork,@JsonKey(name: 'requires_die', fromJson: _boolFalseFromJson) bool requiresDie,@JsonKey(name: 'requires_foiling_plate', fromJson: _boolFalseFromJson) bool requiresFoilingPlate,@JsonKey(name: 'requires_embossing_plate', fromJson: _boolFalseFromJson) bool requiresEmbossingPlate,@JsonKey(name: 'artwork_required', fromJson: _boolTrueFromJson) bool artworkRequired,@JsonKey(name: 'die_required', fromJson: _boolTrueFromJson) bool dieRequired,@JsonKey(name: 'foiling_plate_required', fromJson: _boolTrueFromJson) bool foilingPlateRequired,@JsonKey(name: 'embossing_plate_required', fromJson: _boolTrueFromJson) bool embossingPlateRequired,@JsonKey(name: 'is_parallel', fromJson: _boolFalseFromJson) bool isParallel,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? createdAt
});




}
/// @nodoc
class __$ProcessCopyWithImpl<$Res>
    implements _$ProcessCopyWith<$Res> {
  __$ProcessCopyWithImpl(this._self, this._then);

  final _Process _self;
  final $Res Function(_Process) _then;

/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? standardDuration = freezed,Object? sortOrder = freezed,Object? isActive = null,Object? isBuiltin = null,Object? taskGenerationRule = null,Object? requiresArtwork = null,Object? requiresDie = null,Object? requiresFoilingPlate = null,Object? requiresEmbossingPlate = null,Object? artworkRequired = null,Object? dieRequired = null,Object? foilingPlateRequired = null,Object? embossingPlateRequired = null,Object? isParallel = null,Object? createdAt = freezed,}) {
  return _then(_Process(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,standardDuration: freezed == standardDuration ? _self.standardDuration : standardDuration // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isBuiltin: null == isBuiltin ? _self.isBuiltin : isBuiltin // ignore: cast_nullable_to_non_nullable
as bool,taskGenerationRule: null == taskGenerationRule ? _self.taskGenerationRule : taskGenerationRule // ignore: cast_nullable_to_non_nullable
as String,requiresArtwork: null == requiresArtwork ? _self.requiresArtwork : requiresArtwork // ignore: cast_nullable_to_non_nullable
as bool,requiresDie: null == requiresDie ? _self.requiresDie : requiresDie // ignore: cast_nullable_to_non_nullable
as bool,requiresFoilingPlate: null == requiresFoilingPlate ? _self.requiresFoilingPlate : requiresFoilingPlate // ignore: cast_nullable_to_non_nullable
as bool,requiresEmbossingPlate: null == requiresEmbossingPlate ? _self.requiresEmbossingPlate : requiresEmbossingPlate // ignore: cast_nullable_to_non_nullable
as bool,artworkRequired: null == artworkRequired ? _self.artworkRequired : artworkRequired // ignore: cast_nullable_to_non_nullable
as bool,dieRequired: null == dieRequired ? _self.dieRequired : dieRequired // ignore: cast_nullable_to_non_nullable
as bool,foilingPlateRequired: null == foilingPlateRequired ? _self.foilingPlateRequired : foilingPlateRequired // ignore: cast_nullable_to_non_nullable
as bool,embossingPlateRequired: null == embossingPlateRequired ? _self.embossingPlateRequired : embossingPlateRequired // ignore: cast_nullable_to_non_nullable
as bool,isParallel: null == isParallel ? _self.isParallel : isParallel // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
