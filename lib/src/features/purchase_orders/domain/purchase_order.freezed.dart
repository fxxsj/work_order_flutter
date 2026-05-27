// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseOrder {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'order_number', fromJson: _stringFromJson) String get orderNumber;@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) String? get supplierName;@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) String? get supplierCode;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? get totalAmount;@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? get itemsCount;@JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson) double? get receivedProgress;@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? get orderDate;@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) String? get submittedByName;@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) String? get approvedByName;@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? get createdAt;@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) DateTime? get submittedAt;@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) DateTime? get approvedAt;
/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderCopyWith<PurchaseOrder> get copyWith => _$PurchaseOrderCopyWithImpl<PurchaseOrder>(this as PurchaseOrder, _$identity);

  /// Serializes this PurchaseOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierCode, supplierCode) || other.supplierCode == supplierCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.receivedProgress, receivedProgress) || other.receivedProgress == receivedProgress)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.submittedByName, submittedByName) || other.submittedByName == submittedByName)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,supplierName,supplierCode,status,statusDisplay,totalAmount,itemsCount,receivedProgress,workOrderNumber,orderDate,submittedByName,approvedByName,createdAt,submittedAt,approvedAt);

@override
String toString() {
  return 'PurchaseOrder(id: $id, orderNumber: $orderNumber, supplierName: $supplierName, supplierCode: $supplierCode, status: $status, statusDisplay: $statusDisplay, totalAmount: $totalAmount, itemsCount: $itemsCount, receivedProgress: $receivedProgress, workOrderNumber: $workOrderNumber, orderDate: $orderDate, submittedByName: $submittedByName, approvedByName: $approvedByName, createdAt: $createdAt, submittedAt: $submittedAt, approvedAt: $approvedAt)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderCopyWith<$Res>  {
  factory $PurchaseOrderCopyWith(PurchaseOrder value, $Res Function(PurchaseOrder) _then) = _$PurchaseOrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) String? supplierName,@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) String? supplierCode,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,@JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson) double? receivedProgress,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) String? submittedByName,@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) String? approvedByName,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) DateTime? submittedAt,@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) DateTime? approvedAt
});




}
/// @nodoc
class _$PurchaseOrderCopyWithImpl<$Res>
    implements $PurchaseOrderCopyWith<$Res> {
  _$PurchaseOrderCopyWithImpl(this._self, this._then);

  final PurchaseOrder _self;
  final $Res Function(PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? supplierName = freezed,Object? supplierCode = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? totalAmount = freezed,Object? itemsCount = freezed,Object? receivedProgress = freezed,Object? workOrderNumber = freezed,Object? orderDate = freezed,Object? submittedByName = freezed,Object? approvedByName = freezed,Object? createdAt = freezed,Object? submittedAt = freezed,Object? approvedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,supplierName: freezed == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String?,supplierCode: freezed == supplierCode ? _self.supplierCode : supplierCode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,receivedProgress: freezed == receivedProgress ? _self.receivedProgress : receivedProgress // ignore: cast_nullable_to_non_nullable
as double?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedByName: freezed == submittedByName ? _self.submittedByName : submittedByName // ignore: cast_nullable_to_non_nullable
as String?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrder].
extension PurchaseOrderPatterns on PurchaseOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrder value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)  String? supplierName, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)  String? supplierCode, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)  double? receivedProgress, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)  String? submittedByName, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)  String? approvedByName, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)  DateTime? submittedAt, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)  DateTime? approvedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.supplierName,_that.supplierCode,_that.status,_that.statusDisplay,_that.totalAmount,_that.itemsCount,_that.receivedProgress,_that.workOrderNumber,_that.orderDate,_that.submittedByName,_that.approvedByName,_that.createdAt,_that.submittedAt,_that.approvedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)  String? supplierName, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)  String? supplierCode, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)  double? receivedProgress, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)  String? submittedByName, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)  String? approvedByName, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)  DateTime? submittedAt, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)  DateTime? approvedAt)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder():
return $default(_that.id,_that.orderNumber,_that.supplierName,_that.supplierCode,_that.status,_that.statusDisplay,_that.totalAmount,_that.itemsCount,_that.receivedProgress,_that.workOrderNumber,_that.orderDate,_that.submittedByName,_that.approvedByName,_that.createdAt,_that.submittedAt,_that.approvedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)  String? supplierName, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)  String? supplierCode, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)  double? receivedProgress, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)  String? submittedByName, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)  String? approvedByName, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)  DateTime? submittedAt, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)  DateTime? approvedAt)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.supplierName,_that.supplierCode,_that.status,_that.statusDisplay,_that.totalAmount,_that.itemsCount,_that.receivedProgress,_that.workOrderNumber,_that.orderDate,_that.submittedByName,_that.approvedByName,_that.createdAt,_that.submittedAt,_that.approvedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrder implements PurchaseOrder {
  const _PurchaseOrder({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'order_number', fromJson: _stringFromJson) required this.orderNumber, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) this.supplierName, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) this.supplierCode, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) this.totalAmount, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) this.itemsCount, @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson) this.receivedProgress, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) this.orderDate, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) this.submittedByName, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) this.approvedByName, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) this.createdAt, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) this.submittedAt, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) this.approvedAt});
  factory _PurchaseOrder.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'order_number', fromJson: _stringFromJson) final  String orderNumber;
@override@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) final  String? supplierName;
@override@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) final  String? supplierCode;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) final  double? totalAmount;
@override@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) final  int? itemsCount;
@override@JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson) final  double? receivedProgress;
@override@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? orderDate;
@override@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) final  String? submittedByName;
@override@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) final  String? approvedByName;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? submittedAt;
@override@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? approvedAt;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderCopyWith<_PurchaseOrder> get copyWith => __$PurchaseOrderCopyWithImpl<_PurchaseOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierCode, supplierCode) || other.supplierCode == supplierCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.receivedProgress, receivedProgress) || other.receivedProgress == receivedProgress)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.submittedByName, submittedByName) || other.submittedByName == submittedByName)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,supplierName,supplierCode,status,statusDisplay,totalAmount,itemsCount,receivedProgress,workOrderNumber,orderDate,submittedByName,approvedByName,createdAt,submittedAt,approvedAt);

@override
String toString() {
  return 'PurchaseOrder(id: $id, orderNumber: $orderNumber, supplierName: $supplierName, supplierCode: $supplierCode, status: $status, statusDisplay: $statusDisplay, totalAmount: $totalAmount, itemsCount: $itemsCount, receivedProgress: $receivedProgress, workOrderNumber: $workOrderNumber, orderDate: $orderDate, submittedByName: $submittedByName, approvedByName: $approvedByName, createdAt: $createdAt, submittedAt: $submittedAt, approvedAt: $approvedAt)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderCopyWith<$Res> implements $PurchaseOrderCopyWith<$Res> {
  factory _$PurchaseOrderCopyWith(_PurchaseOrder value, $Res Function(_PurchaseOrder) _then) = __$PurchaseOrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) String? supplierName,@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) String? supplierCode,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,@JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson) double? receivedProgress,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) String? submittedByName,@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) String? approvedByName,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) DateTime? submittedAt,@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) DateTime? approvedAt
});




}
/// @nodoc
class __$PurchaseOrderCopyWithImpl<$Res>
    implements _$PurchaseOrderCopyWith<$Res> {
  __$PurchaseOrderCopyWithImpl(this._self, this._then);

  final _PurchaseOrder _self;
  final $Res Function(_PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? supplierName = freezed,Object? supplierCode = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? totalAmount = freezed,Object? itemsCount = freezed,Object? receivedProgress = freezed,Object? workOrderNumber = freezed,Object? orderDate = freezed,Object? submittedByName = freezed,Object? approvedByName = freezed,Object? createdAt = freezed,Object? submittedAt = freezed,Object? approvedAt = freezed,}) {
  return _then(_PurchaseOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,supplierName: freezed == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String?,supplierCode: freezed == supplierCode ? _self.supplierCode : supplierCode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,receivedProgress: freezed == receivedProgress ? _self.receivedProgress : receivedProgress // ignore: cast_nullable_to_non_nullable
as double?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedByName: freezed == submittedByName ? _self.submittedByName : submittedByName // ignore: cast_nullable_to_non_nullable
as String?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
