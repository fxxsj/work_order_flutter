// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductStock {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? get productName;@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? get productCode;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? get batchNo;@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(fromJson: _doubleOrNullFromJson) double? get quantity;@JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson) double? get reservedQuantity;@JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson) double? get availableQuantity;@JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson) int? get minStockLevel;@JsonKey(fromJson: _stringOrNullFromJson) String? get location;@JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson) DateTime? get productionDate;@JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson) double? get unitCost;@JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson) double? get totalValue;@JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson) bool? get isLowStock;@JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson) DateTime? get expiryDate;@JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson) int? get daysUntilExpiry;@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? get createdAt;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;
/// Create a copy of ProductStock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductStockCopyWith<ProductStock> get copyWith => _$ProductStockCopyWithImpl<ProductStock>(this as ProductStock, _$identity);

  /// Serializes this ProductStock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductStock&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productCode, productCode) || other.productCode == productCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reservedQuantity, reservedQuantity) || other.reservedQuantity == reservedQuantity)&&(identical(other.availableQuantity, availableQuantity) || other.availableQuantity == availableQuantity)&&(identical(other.minStockLevel, minStockLevel) || other.minStockLevel == minStockLevel)&&(identical(other.location, location) || other.location == location)&&(identical(other.productionDate, productionDate) || other.productionDate == productionDate)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.daysUntilExpiry, daysUntilExpiry) || other.daysUntilExpiry == daysUntilExpiry)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,productName,productCode,customerName,batchNo,workOrderNumber,status,statusDisplay,quantity,reservedQuantity,availableQuantity,minStockLevel,location,productionDate,unitCost,totalValue,isLowStock,expiryDate,daysUntilExpiry,createdAt,notes]);

@override
String toString() {
  return 'ProductStock(id: $id, productName: $productName, productCode: $productCode, customerName: $customerName, batchNo: $batchNo, workOrderNumber: $workOrderNumber, status: $status, statusDisplay: $statusDisplay, quantity: $quantity, reservedQuantity: $reservedQuantity, availableQuantity: $availableQuantity, minStockLevel: $minStockLevel, location: $location, productionDate: $productionDate, unitCost: $unitCost, totalValue: $totalValue, isLowStock: $isLowStock, expiryDate: $expiryDate, daysUntilExpiry: $daysUntilExpiry, createdAt: $createdAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ProductStockCopyWith<$Res>  {
  factory $ProductStockCopyWith(ProductStock value, $Res Function(ProductStock) _then) = _$ProductStockCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? productCode,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? batchNo,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,@JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson) double? reservedQuantity,@JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson) double? availableQuantity,@JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson) int? minStockLevel,@JsonKey(fromJson: _stringOrNullFromJson) String? location,@JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson) DateTime? productionDate,@JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson) double? unitCost,@JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson) double? totalValue,@JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson) bool? isLowStock,@JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson) DateTime? expiryDate,@JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson) int? daysUntilExpiry,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class _$ProductStockCopyWithImpl<$Res>
    implements $ProductStockCopyWith<$Res> {
  _$ProductStockCopyWithImpl(this._self, this._then);

  final ProductStock _self;
  final $Res Function(ProductStock) _then;

/// Create a copy of ProductStock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = freezed,Object? productCode = freezed,Object? customerName = freezed,Object? batchNo = freezed,Object? workOrderNumber = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? quantity = freezed,Object? reservedQuantity = freezed,Object? availableQuantity = freezed,Object? minStockLevel = freezed,Object? location = freezed,Object? productionDate = freezed,Object? unitCost = freezed,Object? totalValue = freezed,Object? isLowStock = freezed,Object? expiryDate = freezed,Object? daysUntilExpiry = freezed,Object? createdAt = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productCode: freezed == productCode ? _self.productCode : productCode // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,reservedQuantity: freezed == reservedQuantity ? _self.reservedQuantity : reservedQuantity // ignore: cast_nullable_to_non_nullable
as double?,availableQuantity: freezed == availableQuantity ? _self.availableQuantity : availableQuantity // ignore: cast_nullable_to_non_nullable
as double?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,productionDate: freezed == productionDate ? _self.productionDate : productionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,unitCost: freezed == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double?,totalValue: freezed == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as double?,isLowStock: freezed == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysUntilExpiry: freezed == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductStock].
extension ProductStockPatterns on ProductStock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductStock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductStock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductStock value)  $default,){
final _that = this;
switch (_that) {
case _ProductStock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductStock value)?  $default,){
final _that = this;
switch (_that) {
case _ProductStock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)  String? batchNo, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)  double? reservedQuantity, @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)  double? availableQuantity, @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)  int? minStockLevel, @JsonKey(fromJson: _stringOrNullFromJson)  String? location, @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)  DateTime? productionDate, @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)  double? unitCost, @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)  double? totalValue, @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)  bool? isLowStock, @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)  DateTime? expiryDate, @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)  int? daysUntilExpiry, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductStock() when $default != null:
return $default(_that.id,_that.productName,_that.productCode,_that.customerName,_that.batchNo,_that.workOrderNumber,_that.status,_that.statusDisplay,_that.quantity,_that.reservedQuantity,_that.availableQuantity,_that.minStockLevel,_that.location,_that.productionDate,_that.unitCost,_that.totalValue,_that.isLowStock,_that.expiryDate,_that.daysUntilExpiry,_that.createdAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)  String? batchNo, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)  double? reservedQuantity, @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)  double? availableQuantity, @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)  int? minStockLevel, @JsonKey(fromJson: _stringOrNullFromJson)  String? location, @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)  DateTime? productionDate, @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)  double? unitCost, @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)  double? totalValue, @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)  bool? isLowStock, @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)  DateTime? expiryDate, @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)  int? daysUntilExpiry, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ProductStock():
return $default(_that.id,_that.productName,_that.productCode,_that.customerName,_that.batchNo,_that.workOrderNumber,_that.status,_that.statusDisplay,_that.quantity,_that.reservedQuantity,_that.availableQuantity,_that.minStockLevel,_that.location,_that.productionDate,_that.unitCost,_that.totalValue,_that.isLowStock,_that.expiryDate,_that.daysUntilExpiry,_that.createdAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)  String? batchNo, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)  double? reservedQuantity, @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)  double? availableQuantity, @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)  int? minStockLevel, @JsonKey(fromJson: _stringOrNullFromJson)  String? location, @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)  DateTime? productionDate, @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)  double? unitCost, @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)  double? totalValue, @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)  bool? isLowStock, @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)  DateTime? expiryDate, @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)  int? daysUntilExpiry, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ProductStock() when $default != null:
return $default(_that.id,_that.productName,_that.productCode,_that.customerName,_that.batchNo,_that.workOrderNumber,_that.status,_that.statusDisplay,_that.quantity,_that.reservedQuantity,_that.availableQuantity,_that.minStockLevel,_that.location,_that.productionDate,_that.unitCost,_that.totalValue,_that.isLowStock,_that.expiryDate,_that.daysUntilExpiry,_that.createdAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductStock implements ProductStock {
  const _ProductStock({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) this.productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) this.productCode, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) this.batchNo, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(fromJson: _doubleOrNullFromJson) this.quantity, @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson) this.reservedQuantity, @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson) this.availableQuantity, @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson) this.minStockLevel, @JsonKey(fromJson: _stringOrNullFromJson) this.location, @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson) this.productionDate, @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson) this.unitCost, @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson) this.totalValue, @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson) this.isLowStock, @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson) this.expiryDate, @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson) this.daysUntilExpiry, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) this.createdAt, @JsonKey(fromJson: _stringOrNullFromJson) this.notes});
  factory _ProductStock.fromJson(Map<String, dynamic> json) => _$ProductStockFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) final  String? productName;
@override@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) final  String? productCode;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) final  String? batchNo;
@override@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(fromJson: _doubleOrNullFromJson) final  double? quantity;
@override@JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson) final  double? reservedQuantity;
@override@JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson) final  double? availableQuantity;
@override@JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson) final  int? minStockLevel;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? location;
@override@JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? productionDate;
@override@JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson) final  double? unitCost;
@override@JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson) final  double? totalValue;
@override@JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson) final  bool? isLowStock;
@override@JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? expiryDate;
@override@JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson) final  int? daysUntilExpiry;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;

/// Create a copy of ProductStock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductStockCopyWith<_ProductStock> get copyWith => __$ProductStockCopyWithImpl<_ProductStock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductStockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductStock&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productCode, productCode) || other.productCode == productCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reservedQuantity, reservedQuantity) || other.reservedQuantity == reservedQuantity)&&(identical(other.availableQuantity, availableQuantity) || other.availableQuantity == availableQuantity)&&(identical(other.minStockLevel, minStockLevel) || other.minStockLevel == minStockLevel)&&(identical(other.location, location) || other.location == location)&&(identical(other.productionDate, productionDate) || other.productionDate == productionDate)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.daysUntilExpiry, daysUntilExpiry) || other.daysUntilExpiry == daysUntilExpiry)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,productName,productCode,customerName,batchNo,workOrderNumber,status,statusDisplay,quantity,reservedQuantity,availableQuantity,minStockLevel,location,productionDate,unitCost,totalValue,isLowStock,expiryDate,daysUntilExpiry,createdAt,notes]);

@override
String toString() {
  return 'ProductStock(id: $id, productName: $productName, productCode: $productCode, customerName: $customerName, batchNo: $batchNo, workOrderNumber: $workOrderNumber, status: $status, statusDisplay: $statusDisplay, quantity: $quantity, reservedQuantity: $reservedQuantity, availableQuantity: $availableQuantity, minStockLevel: $minStockLevel, location: $location, productionDate: $productionDate, unitCost: $unitCost, totalValue: $totalValue, isLowStock: $isLowStock, expiryDate: $expiryDate, daysUntilExpiry: $daysUntilExpiry, createdAt: $createdAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ProductStockCopyWith<$Res> implements $ProductStockCopyWith<$Res> {
  factory _$ProductStockCopyWith(_ProductStock value, $Res Function(_ProductStock) _then) = __$ProductStockCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? productCode,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? batchNo,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,@JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson) double? reservedQuantity,@JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson) double? availableQuantity,@JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson) int? minStockLevel,@JsonKey(fromJson: _stringOrNullFromJson) String? location,@JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson) DateTime? productionDate,@JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson) double? unitCost,@JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson) double? totalValue,@JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson) bool? isLowStock,@JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson) DateTime? expiryDate,@JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson) int? daysUntilExpiry,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class __$ProductStockCopyWithImpl<$Res>
    implements _$ProductStockCopyWith<$Res> {
  __$ProductStockCopyWithImpl(this._self, this._then);

  final _ProductStock _self;
  final $Res Function(_ProductStock) _then;

/// Create a copy of ProductStock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = freezed,Object? productCode = freezed,Object? customerName = freezed,Object? batchNo = freezed,Object? workOrderNumber = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? quantity = freezed,Object? reservedQuantity = freezed,Object? availableQuantity = freezed,Object? minStockLevel = freezed,Object? location = freezed,Object? productionDate = freezed,Object? unitCost = freezed,Object? totalValue = freezed,Object? isLowStock = freezed,Object? expiryDate = freezed,Object? daysUntilExpiry = freezed,Object? createdAt = freezed,Object? notes = freezed,}) {
  return _then(_ProductStock(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productCode: freezed == productCode ? _self.productCode : productCode // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,reservedQuantity: freezed == reservedQuantity ? _self.reservedQuantity : reservedQuantity // ignore: cast_nullable_to_non_nullable
as double?,availableQuantity: freezed == availableQuantity ? _self.availableQuantity : availableQuantity // ignore: cast_nullable_to_non_nullable
as double?,minStockLevel: freezed == minStockLevel ? _self.minStockLevel : minStockLevel // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,productionDate: freezed == productionDate ? _self.productionDate : productionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,unitCost: freezed == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as double?,totalValue: freezed == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as double?,isLowStock: freezed == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysUntilExpiry: freezed == daysUntilExpiry ? _self.daysUntilExpiry : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
