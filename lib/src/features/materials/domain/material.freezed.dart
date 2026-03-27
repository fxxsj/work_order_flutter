// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MaterialItem _$MaterialItemFromJson(Map<String, dynamic> json) {
  return _MaterialItem.fromJson(json);
}

/// @nodoc
mixin _$MaterialItem {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get code => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
  double? get stockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
  double? get minStockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this MaterialItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaterialItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaterialItemCopyWith<MaterialItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaterialItemCopyWith<$Res> {
  factory $MaterialItemCopyWith(
          MaterialItem value, $Res Function(MaterialItem) then) =
      _$MaterialItemCopyWithImpl<$Res, MaterialItem>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String code,
      @JsonKey(fromJson: _stringFromJson) String name,
      @JsonKey(fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
      double? stockQuantity,
      @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
      double? minStockQuantity,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
      bool? isActive});
}

/// @nodoc
class _$MaterialItemCopyWithImpl<$Res, $Val extends MaterialItem>
    implements $MaterialItemCopyWith<$Res> {
  _$MaterialItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaterialItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? stockQuantity = freezed,
    Object? minStockQuantity = freezed,
    Object? isActive = freezed,
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
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stockQuantity: freezed == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      minStockQuantity: freezed == minStockQuantity
          ? _value.minStockQuantity
          : minStockQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MaterialItemImplCopyWith<$Res>
    implements $MaterialItemCopyWith<$Res> {
  factory _$$MaterialItemImplCopyWith(
          _$MaterialItemImpl value, $Res Function(_$MaterialItemImpl) then) =
      __$$MaterialItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String code,
      @JsonKey(fromJson: _stringFromJson) String name,
      @JsonKey(fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
      double? stockQuantity,
      @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
      double? minStockQuantity,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
      bool? isActive});
}

/// @nodoc
class __$$MaterialItemImplCopyWithImpl<$Res>
    extends _$MaterialItemCopyWithImpl<$Res, _$MaterialItemImpl>
    implements _$$MaterialItemImplCopyWith<$Res> {
  __$$MaterialItemImplCopyWithImpl(
      _$MaterialItemImpl _value, $Res Function(_$MaterialItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of MaterialItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? stockQuantity = freezed,
    Object? minStockQuantity = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$MaterialItemImpl(
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
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stockQuantity: freezed == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      minStockQuantity: freezed == minStockQuantity
          ? _value.minStockQuantity
          : minStockQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MaterialItemImpl implements _MaterialItem {
  const _$MaterialItemImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(fromJson: _stringFromJson) required this.code,
      @JsonKey(fromJson: _stringFromJson) required this.name,
      @JsonKey(fromJson: _stringOrNullFromJson) this.unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      this.unitPrice,
      @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
      this.stockQuantity,
      @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
      this.minStockQuantity,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
      this.isActive});

  factory _$MaterialItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaterialItemImplFromJson(json);

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
  final String? unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  final double? unitPrice;
  @override
  @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
  final double? stockQuantity;
  @override
  @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
  final double? minStockQuantity;
  @override
  @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
  final bool? isActive;

  @override
  String toString() {
    return 'MaterialItem(id: $id, code: $code, name: $name, unit: $unit, unitPrice: $unitPrice, stockQuantity: $stockQuantity, minStockQuantity: $minStockQuantity, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaterialItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.minStockQuantity, minStockQuantity) ||
                other.minStockQuantity == minStockQuantity) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, unit, unitPrice,
      stockQuantity, minStockQuantity, isActive);

  /// Create a copy of MaterialItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaterialItemImplCopyWith<_$MaterialItemImpl> get copyWith =>
      __$$MaterialItemImplCopyWithImpl<_$MaterialItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaterialItemImplToJson(
      this,
    );
  }
}

abstract class _MaterialItem implements MaterialItem {
  const factory _MaterialItem(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(fromJson: _stringFromJson) required final String code,
      @JsonKey(fromJson: _stringFromJson) required final String name,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      final double? unitPrice,
      @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
      final double? stockQuantity,
      @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
      final double? minStockQuantity,
      @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
      final bool? isActive}) = _$MaterialItemImpl;

  factory _MaterialItem.fromJson(Map<String, dynamic> json) =
      _$MaterialItemImpl.fromJson;

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
  String? get unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice;
  @override
  @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)
  double? get stockQuantity;
  @override
  @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)
  double? get minStockQuantity;
  @override
  @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)
  bool? get isActive;

  /// Create a copy of MaterialItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaterialItemImplCopyWith<_$MaterialItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
