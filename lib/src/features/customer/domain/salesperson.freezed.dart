// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salesperson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Salesperson _$SalespersonFromJson(Map<String, dynamic> json) {
  return _Salesperson.fromJson(json);
}

/// @nodoc
mixin _$Salesperson {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get name => throw _privateConstructorUsedError;

  /// Serializes this Salesperson to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Salesperson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalespersonCopyWith<Salesperson> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalespersonCopyWith<$Res> {
  factory $SalespersonCopyWith(
          Salesperson value, $Res Function(Salesperson) then) =
      _$SalespersonCopyWithImpl<$Res, Salesperson>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String name});
}

/// @nodoc
class _$SalespersonCopyWithImpl<$Res, $Val extends Salesperson>
    implements $SalespersonCopyWith<$Res> {
  _$SalespersonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Salesperson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalespersonImplCopyWith<$Res>
    implements $SalespersonCopyWith<$Res> {
  factory _$$SalespersonImplCopyWith(
          _$SalespersonImpl value, $Res Function(_$SalespersonImpl) then) =
      __$$SalespersonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String name});
}

/// @nodoc
class __$$SalespersonImplCopyWithImpl<$Res>
    extends _$SalespersonCopyWithImpl<$Res, _$SalespersonImpl>
    implements _$$SalespersonImplCopyWith<$Res> {
  __$$SalespersonImplCopyWithImpl(
      _$SalespersonImpl _value, $Res Function(_$SalespersonImpl) _then)
      : super(_value, _then);

  /// Create a copy of Salesperson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$SalespersonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalespersonImpl implements _Salesperson {
  const _$SalespersonImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(fromJson: _stringFromJson) required this.name});

  factory _$SalespersonImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalespersonImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String name;

  @override
  String toString() {
    return 'Salesperson(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalespersonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of Salesperson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalespersonImplCopyWith<_$SalespersonImpl> get copyWith =>
      __$$SalespersonImplCopyWithImpl<_$SalespersonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalespersonImplToJson(
      this,
    );
  }
}

abstract class _Salesperson implements Salesperson {
  const factory _Salesperson(
          {@JsonKey(fromJson: _intFromJson) required final int id,
          @JsonKey(fromJson: _stringFromJson) required final String name}) =
      _$SalespersonImpl;

  factory _Salesperson.fromJson(Map<String, dynamic> json) =
      _$SalespersonImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get name;

  /// Create a copy of Salesperson
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalespersonImplCopyWith<_$SalespersonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
