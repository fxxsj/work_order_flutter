// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductGroup _$ProductGroupFromJson(Map<String, dynamic> json) {
  return _ProductGroup.fromJson(json);
}

/// @nodoc
mixin _$ProductGroup {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get code => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
  bool? get isActive => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'items_count',
      readValue: _readItemsCount,
      fromJson: _intOrNullFromJson)
  int? get itemsCount => throw _privateConstructorUsedError;

  /// Serializes this ProductGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductGroupCopyWith<ProductGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductGroupCopyWith<$Res> {
  factory $ProductGroupCopyWith(
          ProductGroup value, $Res Function(ProductGroup) then) =
      _$ProductGroupCopyWithImpl<$Res, ProductGroup>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String code,
      @JsonKey(fromJson: _stringFromJson) String name,
      @JsonKey(fromJson: _stringOrNullFromJson) String? description,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,
      @JsonKey(
          name: 'items_count',
          readValue: _readItemsCount,
          fromJson: _intOrNullFromJson)
      int? itemsCount});
}

/// @nodoc
class _$ProductGroupCopyWithImpl<$Res, $Val extends ProductGroup>
    implements $ProductGroupCopyWith<$Res> {
  _$ProductGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = freezed,
    Object? itemsCount = freezed,
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
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductGroupImplCopyWith<$Res>
    implements $ProductGroupCopyWith<$Res> {
  factory _$$ProductGroupImplCopyWith(
          _$ProductGroupImpl value, $Res Function(_$ProductGroupImpl) then) =
      __$$ProductGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String code,
      @JsonKey(fromJson: _stringFromJson) String name,
      @JsonKey(fromJson: _stringOrNullFromJson) String? description,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,
      @JsonKey(
          name: 'items_count',
          readValue: _readItemsCount,
          fromJson: _intOrNullFromJson)
      int? itemsCount});
}

/// @nodoc
class __$$ProductGroupImplCopyWithImpl<$Res>
    extends _$ProductGroupCopyWithImpl<$Res, _$ProductGroupImpl>
    implements _$$ProductGroupImplCopyWith<$Res> {
  __$$ProductGroupImplCopyWithImpl(
      _$ProductGroupImpl _value, $Res Function(_$ProductGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = freezed,
    Object? itemsCount = freezed,
  }) {
    return _then(_$ProductGroupImpl(
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
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductGroupImpl implements _ProductGroup {
  const _$ProductGroupImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(fromJson: _stringFromJson) required this.code,
      @JsonKey(fromJson: _stringFromJson) required this.name,
      @JsonKey(fromJson: _stringOrNullFromJson) this.description,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) this.isActive,
      @JsonKey(
          name: 'items_count',
          readValue: _readItemsCount,
          fromJson: _intOrNullFromJson)
      this.itemsCount});

  factory _$ProductGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductGroupImplFromJson(json);

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
  @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
  final bool? isActive;
  @override
  @JsonKey(
      name: 'items_count',
      readValue: _readItemsCount,
      fromJson: _intOrNullFromJson)
  final int? itemsCount;

  @override
  String toString() {
    return 'ProductGroup(id: $id, code: $code, name: $name, description: $description, isActive: $isActive, itemsCount: $itemsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, code, name, description, isActive, itemsCount);

  /// Create a copy of ProductGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductGroupImplCopyWith<_$ProductGroupImpl> get copyWith =>
      __$$ProductGroupImplCopyWithImpl<_$ProductGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductGroupImplToJson(
      this,
    );
  }
}

abstract class _ProductGroup implements ProductGroup {
  const factory _ProductGroup(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(fromJson: _stringFromJson) required final String code,
      @JsonKey(fromJson: _stringFromJson) required final String name,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? description,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
      final bool? isActive,
      @JsonKey(
          name: 'items_count',
          readValue: _readItemsCount,
          fromJson: _intOrNullFromJson)
      final int? itemsCount}) = _$ProductGroupImpl;

  factory _ProductGroup.fromJson(Map<String, dynamic> json) =
      _$ProductGroupImpl.fromJson;

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
  @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
  bool? get isActive;
  @override
  @JsonKey(
      name: 'items_count',
      readValue: _readItemsCount,
      fromJson: _intOrNullFromJson)
  int? get itemsCount;

  /// Create a copy of ProductGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductGroupImplCopyWith<_$ProductGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
