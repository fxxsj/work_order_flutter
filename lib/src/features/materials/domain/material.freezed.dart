// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaterialItem {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(fromJson: _stringFromJson) String get code;@JsonKey(fromJson: _stringFromJson) String get name;@JsonKey(fromJson: _stringOrNullFromJson) String? get specification;@JsonKey(fromJson: _stringOrNullFromJson) String? get unit;@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? get unitPrice;@JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson) double? get stockQuantity;@JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson) double? get minStockQuantity;@JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson) int? get defaultSupplier;@JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson) int? get leadTimeDays;@JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson) bool? get needCutting;@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? get isActive;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;
/// Create a copy of MaterialItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialItemCopyWith<MaterialItem> get copyWith => _$MaterialItemCopyWithImpl<MaterialItem>(this as MaterialItem, _$identity);

  /// Serializes this MaterialItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialItem&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.specification, specification) || other.specification == specification)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.minStockQuantity, minStockQuantity) || other.minStockQuantity == minStockQuantity)&&(identical(other.defaultSupplier, defaultSupplier) || other.defaultSupplier == defaultSupplier)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.needCutting, needCutting) || other.needCutting == needCutting)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,specification,unit,unitPrice,stockQuantity,minStockQuantity,defaultSupplier,leadTimeDays,needCutting,isActive,notes);

@override
String toString() {
  return 'MaterialItem(id: $id, code: $code, name: $name, specification: $specification, unit: $unit, unitPrice: $unitPrice, stockQuantity: $stockQuantity, minStockQuantity: $minStockQuantity, defaultSupplier: $defaultSupplier, leadTimeDays: $leadTimeDays, needCutting: $needCutting, isActive: $isActive, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $MaterialItemCopyWith<$Res>  {
  factory $MaterialItemCopyWith(MaterialItem value, $Res Function(MaterialItem) _then) = _$MaterialItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? specification,@JsonKey(fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson) double? stockQuantity,@JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson) double? minStockQuantity,@JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson) int? defaultSupplier,@JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson) int? leadTimeDays,@JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson) bool? needCutting,@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class _$MaterialItemCopyWithImpl<$Res>
    implements $MaterialItemCopyWith<$Res> {
  _$MaterialItemCopyWithImpl(this._self, this._then);

  final MaterialItem _self;
  final $Res Function(MaterialItem) _then;

/// Create a copy of MaterialItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? specification = freezed,Object? unit = freezed,Object? unitPrice = freezed,Object? stockQuantity = freezed,Object? minStockQuantity = freezed,Object? defaultSupplier = freezed,Object? leadTimeDays = freezed,Object? needCutting = freezed,Object? isActive = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,specification: freezed == specification ? _self.specification : specification // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,stockQuantity: freezed == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as double?,minStockQuantity: freezed == minStockQuantity ? _self.minStockQuantity : minStockQuantity // ignore: cast_nullable_to_non_nullable
as double?,defaultSupplier: freezed == defaultSupplier ? _self.defaultSupplier : defaultSupplier // ignore: cast_nullable_to_non_nullable
as int?,leadTimeDays: freezed == leadTimeDays ? _self.leadTimeDays : leadTimeDays // ignore: cast_nullable_to_non_nullable
as int?,needCutting: freezed == needCutting ? _self.needCutting : needCutting // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaterialItem].
extension MaterialItemPatterns on MaterialItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialItem value)  $default,){
final _that = this;
switch (_that) {
case _MaterialItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialItem value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? specification, @JsonKey(fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)  double? stockQuantity, @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)  double? minStockQuantity, @JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson)  int? defaultSupplier, @JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson)  int? leadTimeDays, @JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson)  bool? needCutting, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)  bool? isActive, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialItem() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.specification,_that.unit,_that.unitPrice,_that.stockQuantity,_that.minStockQuantity,_that.defaultSupplier,_that.leadTimeDays,_that.needCutting,_that.isActive,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? specification, @JsonKey(fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)  double? stockQuantity, @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)  double? minStockQuantity, @JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson)  int? defaultSupplier, @JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson)  int? leadTimeDays, @JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson)  bool? needCutting, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)  bool? isActive, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)  $default,) {final _that = this;
switch (_that) {
case _MaterialItem():
return $default(_that.id,_that.code,_that.name,_that.specification,_that.unit,_that.unitPrice,_that.stockQuantity,_that.minStockQuantity,_that.defaultSupplier,_that.leadTimeDays,_that.needCutting,_that.isActive,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? specification, @JsonKey(fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson)  double? stockQuantity, @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson)  double? minStockQuantity, @JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson)  int? defaultSupplier, @JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson)  int? leadTimeDays, @JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson)  bool? needCutting, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)  bool? isActive, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _MaterialItem() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.specification,_that.unit,_that.unitPrice,_that.stockQuantity,_that.minStockQuantity,_that.defaultSupplier,_that.leadTimeDays,_that.needCutting,_that.isActive,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialItem implements MaterialItem {
  const _MaterialItem({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(fromJson: _stringFromJson) required this.code, @JsonKey(fromJson: _stringFromJson) required this.name, @JsonKey(fromJson: _stringOrNullFromJson) this.specification, @JsonKey(fromJson: _stringOrNullFromJson) this.unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) this.unitPrice, @JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson) this.stockQuantity, @JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson) this.minStockQuantity, @JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson) this.defaultSupplier, @JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson) this.leadTimeDays, @JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson) this.needCutting, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) this.isActive, @JsonKey(fromJson: _stringOrNullFromJson) this.notes});
  factory _MaterialItem.fromJson(Map<String, dynamic> json) => _$MaterialItemFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(fromJson: _stringFromJson) final  String code;
@override@JsonKey(fromJson: _stringFromJson) final  String name;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? specification;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? unit;
@override@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) final  double? unitPrice;
@override@JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson) final  double? stockQuantity;
@override@JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson) final  double? minStockQuantity;
@override@JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson) final  int? defaultSupplier;
@override@JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson) final  int? leadTimeDays;
@override@JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson) final  bool? needCutting;
@override@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) final  bool? isActive;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;

/// Create a copy of MaterialItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialItemCopyWith<_MaterialItem> get copyWith => __$MaterialItemCopyWithImpl<_MaterialItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialItem&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.specification, specification) || other.specification == specification)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.minStockQuantity, minStockQuantity) || other.minStockQuantity == minStockQuantity)&&(identical(other.defaultSupplier, defaultSupplier) || other.defaultSupplier == defaultSupplier)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.needCutting, needCutting) || other.needCutting == needCutting)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,specification,unit,unitPrice,stockQuantity,minStockQuantity,defaultSupplier,leadTimeDays,needCutting,isActive,notes);

@override
String toString() {
  return 'MaterialItem(id: $id, code: $code, name: $name, specification: $specification, unit: $unit, unitPrice: $unitPrice, stockQuantity: $stockQuantity, minStockQuantity: $minStockQuantity, defaultSupplier: $defaultSupplier, leadTimeDays: $leadTimeDays, needCutting: $needCutting, isActive: $isActive, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$MaterialItemCopyWith<$Res> implements $MaterialItemCopyWith<$Res> {
  factory _$MaterialItemCopyWith(_MaterialItem value, $Res Function(_MaterialItem) _then) = __$MaterialItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? specification,@JsonKey(fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'stock_quantity', fromJson: _doubleOrNullFromJson) double? stockQuantity,@JsonKey(name: 'min_stock_quantity', fromJson: _doubleOrNullFromJson) double? minStockQuantity,@JsonKey(name: 'default_supplier', fromJson: _intOrNullFromJson) int? defaultSupplier,@JsonKey(name: 'lead_time_days', fromJson: _intOrNullFromJson) int? leadTimeDays,@JsonKey(name: 'need_cutting', fromJson: _boolOrNullFromJson) bool? needCutting,@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class __$MaterialItemCopyWithImpl<$Res>
    implements _$MaterialItemCopyWith<$Res> {
  __$MaterialItemCopyWithImpl(this._self, this._then);

  final _MaterialItem _self;
  final $Res Function(_MaterialItem) _then;

/// Create a copy of MaterialItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? specification = freezed,Object? unit = freezed,Object? unitPrice = freezed,Object? stockQuantity = freezed,Object? minStockQuantity = freezed,Object? defaultSupplier = freezed,Object? leadTimeDays = freezed,Object? needCutting = freezed,Object? isActive = freezed,Object? notes = freezed,}) {
  return _then(_MaterialItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,specification: freezed == specification ? _self.specification : specification // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,stockQuantity: freezed == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as double?,minStockQuantity: freezed == minStockQuantity ? _self.minStockQuantity : minStockQuantity // ignore: cast_nullable_to_non_nullable
as double?,defaultSupplier: freezed == defaultSupplier ? _self.defaultSupplier : defaultSupplier // ignore: cast_nullable_to_non_nullable
as int?,leadTimeDays: freezed == leadTimeDays ? _self.leadTimeDays : leadTimeDays // ignore: cast_nullable_to_non_nullable
as int?,needCutting: freezed == needCutting ? _self.needCutting : needCutting // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
