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

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? get productName;@JsonKey(fromJson: _stringOrNullFromJson) String? get period;@JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson) double? get materialCost;@JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson) double? get laborCost;@JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson) double? get equipmentCost;@JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson) double? get overheadCost;@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) double? get totalCost;@JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson) double? get standardCost;@JsonKey(fromJson: _doubleOrNullFromJson) double? get variance;@JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson) double? get varianceRate;@JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson) String? get varianceRateFormatted;@JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson) String? get calculatedByName;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) DateTime? get calculatedAt;@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) DateTime? get updatedAt;
/// Create a copy of ProductionCost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionCostCopyWith<ProductionCost> get copyWith => _$ProductionCostCopyWithImpl<ProductionCost>(this as ProductionCost, _$identity);

  /// Serializes this ProductionCost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionCost&&(identical(other.id, id) || other.id == id)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.period, period) || other.period == period)&&(identical(other.materialCost, materialCost) || other.materialCost == materialCost)&&(identical(other.laborCost, laborCost) || other.laborCost == laborCost)&&(identical(other.equipmentCost, equipmentCost) || other.equipmentCost == equipmentCost)&&(identical(other.overheadCost, overheadCost) || other.overheadCost == overheadCost)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.standardCost, standardCost) || other.standardCost == standardCost)&&(identical(other.variance, variance) || other.variance == variance)&&(identical(other.varianceRate, varianceRate) || other.varianceRate == varianceRate)&&(identical(other.varianceRateFormatted, varianceRateFormatted) || other.varianceRateFormatted == varianceRateFormatted)&&(identical(other.calculatedByName, calculatedByName) || other.calculatedByName == calculatedByName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,workOrderNumber,customerName,productName,period,materialCost,laborCost,equipmentCost,overheadCost,totalCost,standardCost,variance,varianceRate,varianceRateFormatted,calculatedByName,notes,calculatedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'ProductionCost(id: $id, workOrderNumber: $workOrderNumber, customerName: $customerName, productName: $productName, period: $period, materialCost: $materialCost, laborCost: $laborCost, equipmentCost: $equipmentCost, overheadCost: $overheadCost, totalCost: $totalCost, standardCost: $standardCost, variance: $variance, varianceRate: $varianceRate, varianceRateFormatted: $varianceRateFormatted, calculatedByName: $calculatedByName, notes: $notes, calculatedAt: $calculatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductionCostCopyWith<$Res>  {
  factory $ProductionCostCopyWith(ProductionCost value, $Res Function(ProductionCost) _then) = _$ProductionCostCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(fromJson: _stringOrNullFromJson) String? period,@JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson) double? materialCost,@JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson) double? laborCost,@JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson) double? equipmentCost,@JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson) double? overheadCost,@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) double? totalCost,@JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson) double? standardCost,@JsonKey(fromJson: _doubleOrNullFromJson) double? variance,@JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson) double? varianceRate,@JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson) String? varianceRateFormatted,@JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson) String? calculatedByName,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) DateTime? calculatedAt,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) DateTime? updatedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? productName = freezed,Object? period = freezed,Object? materialCost = freezed,Object? laborCost = freezed,Object? equipmentCost = freezed,Object? overheadCost = freezed,Object? totalCost = freezed,Object? standardCost = freezed,Object? variance = freezed,Object? varianceRate = freezed,Object? varianceRateFormatted = freezed,Object? calculatedByName = freezed,Object? notes = freezed,Object? calculatedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,materialCost: freezed == materialCost ? _self.materialCost : materialCost // ignore: cast_nullable_to_non_nullable
as double?,laborCost: freezed == laborCost ? _self.laborCost : laborCost // ignore: cast_nullable_to_non_nullable
as double?,equipmentCost: freezed == equipmentCost ? _self.equipmentCost : equipmentCost // ignore: cast_nullable_to_non_nullable
as double?,overheadCost: freezed == overheadCost ? _self.overheadCost : overheadCost // ignore: cast_nullable_to_non_nullable
as double?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,standardCost: freezed == standardCost ? _self.standardCost : standardCost // ignore: cast_nullable_to_non_nullable
as double?,variance: freezed == variance ? _self.variance : variance // ignore: cast_nullable_to_non_nullable
as double?,varianceRate: freezed == varianceRate ? _self.varianceRate : varianceRate // ignore: cast_nullable_to_non_nullable
as double?,varianceRateFormatted: freezed == varianceRateFormatted ? _self.varianceRateFormatted : varianceRateFormatted // ignore: cast_nullable_to_non_nullable
as String?,calculatedByName: freezed == calculatedByName ? _self.calculatedByName : calculatedByName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,calculatedAt: freezed == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(fromJson: _stringOrNullFromJson)  String? period, @JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson)  double? materialCost, @JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson)  double? laborCost, @JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson)  double? equipmentCost, @JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson)  double? overheadCost, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson)  double? totalCost, @JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson)  double? standardCost, @JsonKey(fromJson: _doubleOrNullFromJson)  double? variance, @JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson)  double? varianceRate, @JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson)  String? varianceRateFormatted, @JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson)  String? calculatedByName, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson)  DateTime? calculatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionCost() when $default != null:
return $default(_that.id,_that.workOrderNumber,_that.customerName,_that.productName,_that.period,_that.materialCost,_that.laborCost,_that.equipmentCost,_that.overheadCost,_that.totalCost,_that.standardCost,_that.variance,_that.varianceRate,_that.varianceRateFormatted,_that.calculatedByName,_that.notes,_that.calculatedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(fromJson: _stringOrNullFromJson)  String? period, @JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson)  double? materialCost, @JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson)  double? laborCost, @JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson)  double? equipmentCost, @JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson)  double? overheadCost, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson)  double? totalCost, @JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson)  double? standardCost, @JsonKey(fromJson: _doubleOrNullFromJson)  double? variance, @JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson)  double? varianceRate, @JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson)  String? varianceRateFormatted, @JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson)  String? calculatedByName, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson)  DateTime? calculatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductionCost():
return $default(_that.id,_that.workOrderNumber,_that.customerName,_that.productName,_that.period,_that.materialCost,_that.laborCost,_that.equipmentCost,_that.overheadCost,_that.totalCost,_that.standardCost,_that.variance,_that.varianceRate,_that.varianceRateFormatted,_that.calculatedByName,_that.notes,_that.calculatedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(fromJson: _stringOrNullFromJson)  String? period, @JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson)  double? materialCost, @JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson)  double? laborCost, @JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson)  double? equipmentCost, @JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson)  double? overheadCost, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson)  double? totalCost, @JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson)  double? standardCost, @JsonKey(fromJson: _doubleOrNullFromJson)  double? variance, @JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson)  double? varianceRate, @JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson)  String? varianceRateFormatted, @JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson)  String? calculatedByName, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson)  DateTime? calculatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductionCost() when $default != null:
return $default(_that.id,_that.workOrderNumber,_that.customerName,_that.productName,_that.period,_that.materialCost,_that.laborCost,_that.equipmentCost,_that.overheadCost,_that.totalCost,_that.standardCost,_that.variance,_that.varianceRate,_that.varianceRateFormatted,_that.calculatedByName,_that.notes,_that.calculatedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionCost implements ProductionCost {
  const _ProductionCost({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) this.productName, @JsonKey(fromJson: _stringOrNullFromJson) this.period, @JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson) this.materialCost, @JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson) this.laborCost, @JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson) this.equipmentCost, @JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson) this.overheadCost, @JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) this.totalCost, @JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson) this.standardCost, @JsonKey(fromJson: _doubleOrNullFromJson) this.variance, @JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson) this.varianceRate, @JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson) this.varianceRateFormatted, @JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson) this.calculatedByName, @JsonKey(fromJson: _stringOrNullFromJson) this.notes, @JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) this.calculatedAt, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) this.updatedAt});
  factory _ProductionCost.fromJson(Map<String, dynamic> json) => _$ProductionCostFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) final  String? productName;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? period;
@override@JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson) final  double? materialCost;
@override@JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson) final  double? laborCost;
@override@JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson) final  double? equipmentCost;
@override@JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson) final  double? overheadCost;
@override@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) final  double? totalCost;
@override@JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson) final  double? standardCost;
@override@JsonKey(fromJson: _doubleOrNullFromJson) final  double? variance;
@override@JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson) final  double? varianceRate;
@override@JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson) final  String? varianceRateFormatted;
@override@JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson) final  String? calculatedByName;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;
@override@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) final  DateTime? calculatedAt;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionCost&&(identical(other.id, id) || other.id == id)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.period, period) || other.period == period)&&(identical(other.materialCost, materialCost) || other.materialCost == materialCost)&&(identical(other.laborCost, laborCost) || other.laborCost == laborCost)&&(identical(other.equipmentCost, equipmentCost) || other.equipmentCost == equipmentCost)&&(identical(other.overheadCost, overheadCost) || other.overheadCost == overheadCost)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.standardCost, standardCost) || other.standardCost == standardCost)&&(identical(other.variance, variance) || other.variance == variance)&&(identical(other.varianceRate, varianceRate) || other.varianceRate == varianceRate)&&(identical(other.varianceRateFormatted, varianceRateFormatted) || other.varianceRateFormatted == varianceRateFormatted)&&(identical(other.calculatedByName, calculatedByName) || other.calculatedByName == calculatedByName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,workOrderNumber,customerName,productName,period,materialCost,laborCost,equipmentCost,overheadCost,totalCost,standardCost,variance,varianceRate,varianceRateFormatted,calculatedByName,notes,calculatedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'ProductionCost(id: $id, workOrderNumber: $workOrderNumber, customerName: $customerName, productName: $productName, period: $period, materialCost: $materialCost, laborCost: $laborCost, equipmentCost: $equipmentCost, overheadCost: $overheadCost, totalCost: $totalCost, standardCost: $standardCost, variance: $variance, varianceRate: $varianceRate, varianceRateFormatted: $varianceRateFormatted, calculatedByName: $calculatedByName, notes: $notes, calculatedAt: $calculatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductionCostCopyWith<$Res> implements $ProductionCostCopyWith<$Res> {
  factory _$ProductionCostCopyWith(_ProductionCost value, $Res Function(_ProductionCost) _then) = __$ProductionCostCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(fromJson: _stringOrNullFromJson) String? period,@JsonKey(name: 'material_cost', fromJson: _doubleOrNullFromJson) double? materialCost,@JsonKey(name: 'labor_cost', fromJson: _doubleOrNullFromJson) double? laborCost,@JsonKey(name: 'equipment_cost', fromJson: _doubleOrNullFromJson) double? equipmentCost,@JsonKey(name: 'overhead_cost', fromJson: _doubleOrNullFromJson) double? overheadCost,@JsonKey(name: 'total_cost', readValue: _readTotalCost, fromJson: _doubleOrNullFromJson) double? totalCost,@JsonKey(name: 'standard_cost', fromJson: _doubleOrNullFromJson) double? standardCost,@JsonKey(fromJson: _doubleOrNullFromJson) double? variance,@JsonKey(name: 'variance_rate', fromJson: _doubleOrNullFromJson) double? varianceRate,@JsonKey(name: 'variance_rate_formatted', fromJson: _stringOrNullFromJson) String? varianceRateFormatted,@JsonKey(name: 'calculated_by_name', fromJson: _stringOrNullFromJson) String? calculatedByName,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'calculated_at', readValue: _readCalculatedAt, fromJson: _dateTimeOrNullFromJson) DateTime? calculatedAt,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) DateTime? updatedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? productName = freezed,Object? period = freezed,Object? materialCost = freezed,Object? laborCost = freezed,Object? equipmentCost = freezed,Object? overheadCost = freezed,Object? totalCost = freezed,Object? standardCost = freezed,Object? variance = freezed,Object? varianceRate = freezed,Object? varianceRateFormatted = freezed,Object? calculatedByName = freezed,Object? notes = freezed,Object? calculatedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ProductionCost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,materialCost: freezed == materialCost ? _self.materialCost : materialCost // ignore: cast_nullable_to_non_nullable
as double?,laborCost: freezed == laborCost ? _self.laborCost : laborCost // ignore: cast_nullable_to_non_nullable
as double?,equipmentCost: freezed == equipmentCost ? _self.equipmentCost : equipmentCost // ignore: cast_nullable_to_non_nullable
as double?,overheadCost: freezed == overheadCost ? _self.overheadCost : overheadCost // ignore: cast_nullable_to_non_nullable
as double?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,standardCost: freezed == standardCost ? _self.standardCost : standardCost // ignore: cast_nullable_to_non_nullable
as double?,variance: freezed == variance ? _self.variance : variance // ignore: cast_nullable_to_non_nullable
as double?,varianceRate: freezed == varianceRate ? _self.varianceRate : varianceRate // ignore: cast_nullable_to_non_nullable
as double?,varianceRateFormatted: freezed == varianceRateFormatted ? _self.varianceRateFormatted : varianceRateFormatted // ignore: cast_nullable_to_non_nullable
as String?,calculatedByName: freezed == calculatedByName ? _self.calculatedByName : calculatedByName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,calculatedAt: freezed == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
