// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductGroup {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(fromJson: _stringFromJson) String get code;@JsonKey(fromJson: _stringFromJson) String get name;@JsonKey(fromJson: _stringOrNullFromJson) String? get description;@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? get isActive;@JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson) int? get itemsCount;
/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductGroupCopyWith<ProductGroup> get copyWith => _$ProductGroupCopyWithImpl<ProductGroup>(this as ProductGroup, _$identity);

  /// Serializes this ProductGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,description,isActive,itemsCount);

@override
String toString() {
  return 'ProductGroup(id: $id, code: $code, name: $name, description: $description, isActive: $isActive, itemsCount: $itemsCount)';
}


}

/// @nodoc
abstract mixin class $ProductGroupCopyWith<$Res>  {
  factory $ProductGroupCopyWith(ProductGroup value, $Res Function(ProductGroup) _then) = _$ProductGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? description,@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,@JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson) int? itemsCount
});




}
/// @nodoc
class _$ProductGroupCopyWithImpl<$Res>
    implements $ProductGroupCopyWith<$Res> {
  _$ProductGroupCopyWithImpl(this._self, this._then);

  final ProductGroup _self;
  final $Res Function(ProductGroup) _then;

/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? isActive = freezed,Object? itemsCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductGroup].
extension ProductGroupPatterns on ProductGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductGroup value)  $default,){
final _that = this;
switch (_that) {
case _ProductGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductGroup value)?  $default,){
final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)  bool? isActive, @JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson)  int? itemsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.isActive,_that.itemsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)  bool? isActive, @JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson)  int? itemsCount)  $default,) {final _that = this;
switch (_that) {
case _ProductGroup():
return $default(_that.id,_that.code,_that.name,_that.description,_that.isActive,_that.itemsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String code, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? description, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson)  bool? isActive, @JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson)  int? itemsCount)?  $default,) {final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.isActive,_that.itemsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductGroup implements ProductGroup {
  const _ProductGroup({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(fromJson: _stringFromJson) required this.code, @JsonKey(fromJson: _stringFromJson) required this.name, @JsonKey(fromJson: _stringOrNullFromJson) this.description, @JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) this.isActive, @JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson) this.itemsCount});
  factory _ProductGroup.fromJson(Map<String, dynamic> json) => _$ProductGroupFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(fromJson: _stringFromJson) final  String code;
@override@JsonKey(fromJson: _stringFromJson) final  String name;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? description;
@override@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) final  bool? isActive;
@override@JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson) final  int? itemsCount;

/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductGroupCopyWith<_ProductGroup> get copyWith => __$ProductGroupCopyWithImpl<_ProductGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,description,isActive,itemsCount);

@override
String toString() {
  return 'ProductGroup(id: $id, code: $code, name: $name, description: $description, isActive: $isActive, itemsCount: $itemsCount)';
}


}

/// @nodoc
abstract mixin class _$ProductGroupCopyWith<$Res> implements $ProductGroupCopyWith<$Res> {
  factory _$ProductGroupCopyWith(_ProductGroup value, $Res Function(_ProductGroup) _then) = __$ProductGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String code,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? description,@JsonKey(name: 'is_active', fromJson: _boolOrNullFromJson) bool? isActive,@JsonKey(name: 'items_count', readValue: _readItemsCount, fromJson: _intOrNullFromJson) int? itemsCount
});




}
/// @nodoc
class __$ProductGroupCopyWithImpl<$Res>
    implements _$ProductGroupCopyWith<$Res> {
  __$ProductGroupCopyWithImpl(this._self, this._then);

  final _ProductGroup _self;
  final $Res Function(_ProductGroup) _then;

/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? isActive = freezed,Object? itemsCount = freezed,}) {
  return _then(_ProductGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
