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

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(fromJson: _stringFromJson) String get code;@JsonKey(fromJson: _stringFromJson) String get name;@JsonKey(fromJson: _stringOrNullFromJson) String? get description;@JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson) double? get standardDuration;@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? get sortOrder;@JsonKey(name: 'is_active', fromJson: _boolFromJson) bool get isActive;
/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessCopyWith<Process> get copyWith => _$ProcessCopyWithImpl<Process>(this as Process, _$identity);

  /// Serializes this Process to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Process&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.standardDuration, standardDuration) || other.standardDuration == standardDuration)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,description,standardDuration,sortOrder,isActive);

@override
String toString() {
  return 'Process(id: $id, code: $code, name: $name, description: $description, standardDuration: $standardDuration, sortOrder: $sortOrder, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProcessCopyWith<$Res>  {
  factory $ProcessCopyWith(Process value, $Res Function(Process) _then) = _$ProcessCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? description,@JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson) double? standardDuration,@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,@JsonKey(name: 'is_active', fromJson: _boolFromJson) bool isActive
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? standardDuration = freezed,Object? sortOrder = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,standardDuration: freezed == standardDuration ? _self.standardDuration : standardDuration // ignore: cast_nullable_to_non_nullable
as double?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)  double? standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)  int? sortOrder, @JsonKey(name: 'is_active', fromJson: _boolFromJson)  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Process() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.standardDuration,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)  double? standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)  int? sortOrder, @JsonKey(name: 'is_active', fromJson: _boolFromJson)  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Process():
return $default(_that.id,_that.code,_that.name,_that.description,_that.standardDuration,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)  double? standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)  int? sortOrder, @JsonKey(name: 'is_active', fromJson: _boolFromJson)  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Process() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.standardDuration,_that.sortOrder,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Process implements Process {
  const _Process({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(fromJson: _stringFromJson) required this.code, @JsonKey(fromJson: _stringFromJson) required this.name, @JsonKey(fromJson: _stringOrNullFromJson) this.description, @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson) this.standardDuration, @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) this.sortOrder, @JsonKey(name: 'is_active', fromJson: _boolFromJson) this.isActive = true});
  factory _Process.fromJson(Map<String, dynamic> json) => _$ProcessFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(fromJson: _stringFromJson) final  String code;
@override@JsonKey(fromJson: _stringFromJson) final  String name;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? description;
@override@JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson) final  double? standardDuration;
@override@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) final  int? sortOrder;
@override@JsonKey(name: 'is_active', fromJson: _boolFromJson) final  bool isActive;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Process&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.standardDuration, standardDuration) || other.standardDuration == standardDuration)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,description,standardDuration,sortOrder,isActive);

@override
String toString() {
  return 'Process(id: $id, code: $code, name: $name, description: $description, standardDuration: $standardDuration, sortOrder: $sortOrder, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProcessCopyWith<$Res> implements $ProcessCopyWith<$Res> {
  factory _$ProcessCopyWith(_Process value, $Res Function(_Process) _then) = __$ProcessCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? description,@JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson) double? standardDuration,@JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,@JsonKey(name: 'is_active', fromJson: _boolFromJson) bool isActive
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? standardDuration = freezed,Object? sortOrder = freezed,Object? isActive = null,}) {
  return _then(_Process(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,standardDuration: freezed == standardDuration ? _self.standardDuration : standardDuration // ignore: cast_nullable_to_non_nullable
as double?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
