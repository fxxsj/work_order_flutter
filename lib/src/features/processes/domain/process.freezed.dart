// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'process.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Process _$ProcessFromJson(Map<String, dynamic> json) {
  return _Process.fromJson(json);
}

/// @nodoc
mixin _$Process {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get code => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
  double? get standardDuration => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)
  int? get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active', fromJson: _boolFromJson)
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this Process to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Process
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcessCopyWith<Process> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcessCopyWith<$Res> {
  factory $ProcessCopyWith(Process value, $Res Function(Process) then) =
      _$ProcessCopyWithImpl<$Res, Process>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String code,
      @JsonKey(fromJson: _stringFromJson) String name,
      @JsonKey(fromJson: _stringOrNullFromJson) String? description,
      @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
      double? standardDuration,
      @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,
      @JsonKey(name: 'is_active', fromJson: _boolFromJson) bool isActive});
}

/// @nodoc
class _$ProcessCopyWithImpl<$Res, $Val extends Process>
    implements $ProcessCopyWith<$Res> {
  _$ProcessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Process
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? standardDuration = freezed,
    Object? sortOrder = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      standardDuration: freezed == standardDuration
          ? _value.standardDuration
          : standardDuration // ignore: cast_nullable_to_non_nullable
              as double?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProcessImplCopyWith<$Res> implements $ProcessCopyWith<$Res> {
  factory _$$ProcessImplCopyWith(
          _$ProcessImpl value, $Res Function(_$ProcessImpl) then) =
      __$$ProcessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String code,
      @JsonKey(fromJson: _stringFromJson) String name,
      @JsonKey(fromJson: _stringOrNullFromJson) String? description,
      @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
      double? standardDuration,
      @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) int? sortOrder,
      @JsonKey(name: 'is_active', fromJson: _boolFromJson) bool isActive});
}

/// @nodoc
class __$$ProcessImplCopyWithImpl<$Res>
    extends _$ProcessCopyWithImpl<$Res, _$ProcessImpl>
    implements _$$ProcessImplCopyWith<$Res> {
  __$$ProcessImplCopyWithImpl(
      _$ProcessImpl _value, $Res Function(_$ProcessImpl) _then)
      : super(_value, _then);

  /// Create a copy of Process
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? standardDuration = freezed,
    Object? sortOrder = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ProcessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      standardDuration: freezed == standardDuration
          ? _value.standardDuration
          : standardDuration // ignore: cast_nullable_to_non_nullable
              as double?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcessImpl implements _Process {
  const _$ProcessImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(fromJson: _stringFromJson) required this.code,
      @JsonKey(fromJson: _stringFromJson) required this.name,
      @JsonKey(fromJson: _stringOrNullFromJson) this.description,
      @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
      this.standardDuration,
      @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson) this.sortOrder,
      @JsonKey(name: 'is_active', fromJson: _boolFromJson)
      this.isActive = true});

  factory _$ProcessImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcessImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String code;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String name;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? description;
  @override
  @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
  final double? standardDuration;
  @override
  @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)
  final int? sortOrder;
  @override
  @JsonKey(name: 'is_active', fromJson: _boolFromJson)
  final bool isActive;

  @override
  String toString() {
    return 'Process(id: $id, code: $code, name: $name, description: $description, standardDuration: $standardDuration, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.standardDuration, standardDuration) ||
                other.standardDuration == standardDuration) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, description,
      standardDuration, sortOrder, isActive);

  /// Create a copy of Process
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcessImplCopyWith<_$ProcessImpl> get copyWith =>
      __$$ProcessImplCopyWithImpl<_$ProcessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcessImplToJson(
      this,
    );
  }
}

abstract class _Process implements Process {
  const factory _Process(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(fromJson: _stringFromJson) required final String code,
      @JsonKey(fromJson: _stringFromJson) required final String name,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? description,
      @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
      final double? standardDuration,
      @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)
      final int? sortOrder,
      @JsonKey(name: 'is_active', fromJson: _boolFromJson)
      final bool isActive}) = _$ProcessImpl;

  factory _Process.fromJson(Map<String, dynamic> json) = _$ProcessImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get code;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get name;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get description;
  @override
  @JsonKey(name: 'standard_duration', fromJson: _doubleOrNullFromJson)
  double? get standardDuration;
  @override
  @JsonKey(name: 'sort_order', fromJson: _intOrNullFromJson)
  int? get sortOrder;
  @override
  @JsonKey(name: 'is_active', fromJson: _boolFromJson)
  bool get isActive;

  /// Create a copy of Process
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcessImplCopyWith<_$ProcessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
