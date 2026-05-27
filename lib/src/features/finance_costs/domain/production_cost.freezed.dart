// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_cost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductionCost {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) double? get totalCost;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) DateTime? get calculatedAt;
/// Create a copy of ProductionCost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionCostCopyWith<ProductionCost> get copyWith => _$ProductionCostCopyWithImpl<ProductionCost>(this as ProductionCost, _$identity);

  /// Serializes this ProductionCost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionCost&&(identical(other.id, id) || other.id == id)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workOrderNumber,totalCost,status,statusDisplay,calculatedAt);

@override
String toString() {
  return 'ProductionCost(id: $id, workOrderNumber: $workOrderNumber, totalCost: $totalCost, status: $status, statusDisplay: $statusDisplay, calculatedAt: $calculatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductionCostCopyWith<$Res>  {
  factory $ProductionCostCopyWith(ProductionCost value, $Res Function(ProductionCost) _then) = _$ProductionCostCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) double? totalCost,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) DateTime? calculatedAt
});




}
/// @nodoc
class _$ProductionCostCopyWithImpl<$Res>
    implements $ProductionCostCopyWith<$Res> {
  _$ProductionCostCopyWithImpl(this._self, this._then);

  final ProductionCost _self;
  final $Res Function(ProductionCost) _then;

/// Create a copy of ProductionCost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workOrderNumber = freezed,Object? totalCost = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? calculatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,calculatedAt: freezed == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductionCost].
extension ProductionCostPatterns on ProductionCost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionCost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionCost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionCost value)  $default,){
final _that = this;
switch (_that) {
case _ProductionCost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionCost value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionCost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson)  double? totalCost, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson)  DateTime? calculatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionCost() when $default != null:
return $default(_that.id,_that.workOrderNumber,_that.totalCost,_that.status,_that.statusDisplay,_that.calculatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson)  double? totalCost, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson)  DateTime? calculatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductionCost():
return $default(_that.id,_that.workOrderNumber,_that.totalCost,_that.status,_that.statusDisplay,_that.calculatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson)  double? totalCost, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson)  DateTime? calculatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductionCost() when $default != null:
return $default(_that.id,_that.workOrderNumber,_that.totalCost,_that.status,_that.statusDisplay,_that.calculatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionCost implements ProductionCost {
  const _ProductionCost({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) this.totalCost, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) this.calculatedAt});
  factory _ProductionCost.fromJson(Map<String, dynamic> json) => _$ProductionCostFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) final  double? totalCost;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) final  DateTime? calculatedAt;

/// Create a copy of ProductionCost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionCostCopyWith<_ProductionCost> get copyWith => __$ProductionCostCopyWithImpl<_ProductionCost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionCostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionCost&&(identical(other.id, id) || other.id == id)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workOrderNumber,totalCost,status,statusDisplay,calculatedAt);

@override
String toString() {
  return 'ProductionCost(id: $id, workOrderNumber: $workOrderNumber, totalCost: $totalCost, status: $status, statusDisplay: $statusDisplay, calculatedAt: $calculatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductionCostCopyWith<$Res> implements $ProductionCostCopyWith<$Res> {
  factory _$ProductionCostCopyWith(_ProductionCost value, $Res Function(_ProductionCost) _then) = __$ProductionCostCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) double? totalCost,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) DateTime? calculatedAt
});




}
/// @nodoc
class __$ProductionCostCopyWithImpl<$Res>
    implements _$ProductionCostCopyWith<$Res> {
  __$ProductionCostCopyWithImpl(this._self, this._then);

  final _ProductionCost _self;
  final $Res Function(_ProductionCost) _then;

/// Create a copy of ProductionCost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workOrderNumber = freezed,Object? totalCost = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? calculatedAt = freezed,}) {
  return _then(_ProductionCost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,calculatedAt: freezed == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
