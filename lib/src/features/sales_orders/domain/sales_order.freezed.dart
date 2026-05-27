// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesOrder {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'order_number', fromJson: _stringFromJson) String get orderNumber;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson) String? get customerCode;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) String? get paymentStatus;@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) String? get paymentStatusDisplay;@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? get totalAmount;@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? get orderDate;@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? get deliveryDate;@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? get itemsCount;@JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson) int? get workOrderCount;
/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderCopyWith<SalesOrder> get copyWith => _$SalesOrderCopyWithImpl<SalesOrder>(this as SalesOrder, _$identity);

  /// Serializes this SalesOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerCode, customerCode) || other.customerCode == customerCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentStatusDisplay, paymentStatusDisplay) || other.paymentStatusDisplay == paymentStatusDisplay)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.workOrderCount, workOrderCount) || other.workOrderCount == workOrderCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,customerName,customerCode,status,statusDisplay,paymentStatus,paymentStatusDisplay,totalAmount,orderDate,deliveryDate,itemsCount,workOrderCount);

@override
String toString() {
  return 'SalesOrder(id: $id, orderNumber: $orderNumber, customerName: $customerName, customerCode: $customerCode, status: $status, statusDisplay: $statusDisplay, paymentStatus: $paymentStatus, paymentStatusDisplay: $paymentStatusDisplay, totalAmount: $totalAmount, orderDate: $orderDate, deliveryDate: $deliveryDate, itemsCount: $itemsCount, workOrderCount: $workOrderCount)';
}


}

/// @nodoc
abstract mixin class $SalesOrderCopyWith<$Res>  {
  factory $SalesOrderCopyWith(SalesOrder value, $Res Function(SalesOrder) _then) = _$SalesOrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson) String? customerCode,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) String? paymentStatus,@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) String? paymentStatusDisplay,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,@JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson) int? workOrderCount
});




}
/// @nodoc
class _$SalesOrderCopyWithImpl<$Res>
    implements $SalesOrderCopyWith<$Res> {
  _$SalesOrderCopyWithImpl(this._self, this._then);

  final SalesOrder _self;
  final $Res Function(SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? customerName = freezed,Object? customerCode = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? paymentStatus = freezed,Object? paymentStatusDisplay = freezed,Object? totalAmount = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? itemsCount = freezed,Object? workOrderCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerCode: freezed == customerCode ? _self.customerCode : customerCode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentStatusDisplay: freezed == paymentStatusDisplay ? _self.paymentStatusDisplay : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,workOrderCount: freezed == workOrderCount ? _self.workOrderCount : workOrderCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrder].
extension SalesOrderPatterns on SalesOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrder value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrder value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)  String? customerCode, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)  String? paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)  String? paymentStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)  int? workOrderCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerName,_that.customerCode,_that.status,_that.statusDisplay,_that.paymentStatus,_that.paymentStatusDisplay,_that.totalAmount,_that.orderDate,_that.deliveryDate,_that.itemsCount,_that.workOrderCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)  String? customerCode, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)  String? paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)  String? paymentStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)  int? workOrderCount)  $default,) {final _that = this;
switch (_that) {
case _SalesOrder():
return $default(_that.id,_that.orderNumber,_that.customerName,_that.customerCode,_that.status,_that.statusDisplay,_that.paymentStatus,_that.paymentStatusDisplay,_that.totalAmount,_that.orderDate,_that.deliveryDate,_that.itemsCount,_that.workOrderCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)  String? customerCode, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)  String? paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)  String? paymentStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)  int? workOrderCount)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerName,_that.customerCode,_that.status,_that.statusDisplay,_that.paymentStatus,_that.paymentStatusDisplay,_that.totalAmount,_that.orderDate,_that.deliveryDate,_that.itemsCount,_that.workOrderCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrder implements SalesOrder {
  const _SalesOrder({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'order_number', fromJson: _stringFromJson) required this.orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson) this.customerCode, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) this.paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) this.paymentStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) this.totalAmount, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) this.orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) this.deliveryDate, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) this.itemsCount, @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson) this.workOrderCount});
  factory _SalesOrder.fromJson(Map<String, dynamic> json) => _$SalesOrderFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'order_number', fromJson: _stringFromJson) final  String orderNumber;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson) final  String? customerCode;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) final  String? paymentStatus;
@override@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) final  String? paymentStatusDisplay;
@override@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) final  double? totalAmount;
@override@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? orderDate;
@override@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? deliveryDate;
@override@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) final  int? itemsCount;
@override@JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson) final  int? workOrderCount;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderCopyWith<_SalesOrder> get copyWith => __$SalesOrderCopyWithImpl<_SalesOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerCode, customerCode) || other.customerCode == customerCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentStatusDisplay, paymentStatusDisplay) || other.paymentStatusDisplay == paymentStatusDisplay)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.workOrderCount, workOrderCount) || other.workOrderCount == workOrderCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,customerName,customerCode,status,statusDisplay,paymentStatus,paymentStatusDisplay,totalAmount,orderDate,deliveryDate,itemsCount,workOrderCount);

@override
String toString() {
  return 'SalesOrder(id: $id, orderNumber: $orderNumber, customerName: $customerName, customerCode: $customerCode, status: $status, statusDisplay: $statusDisplay, paymentStatus: $paymentStatus, paymentStatusDisplay: $paymentStatusDisplay, totalAmount: $totalAmount, orderDate: $orderDate, deliveryDate: $deliveryDate, itemsCount: $itemsCount, workOrderCount: $workOrderCount)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderCopyWith<$Res> implements $SalesOrderCopyWith<$Res> {
  factory _$SalesOrderCopyWith(_SalesOrder value, $Res Function(_SalesOrder) _then) = __$SalesOrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson) String? customerCode,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) String? paymentStatus,@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) String? paymentStatusDisplay,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,@JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson) int? workOrderCount
});




}
/// @nodoc
class __$SalesOrderCopyWithImpl<$Res>
    implements _$SalesOrderCopyWith<$Res> {
  __$SalesOrderCopyWithImpl(this._self, this._then);

  final _SalesOrder _self;
  final $Res Function(_SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? customerName = freezed,Object? customerCode = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? paymentStatus = freezed,Object? paymentStatusDisplay = freezed,Object? totalAmount = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? itemsCount = freezed,Object? workOrderCount = freezed,}) {
  return _then(_SalesOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerCode: freezed == customerCode ? _self.customerCode : customerCode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentStatusDisplay: freezed == paymentStatusDisplay ? _self.paymentStatusDisplay : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,workOrderCount: freezed == workOrderCount ? _self.workOrderCount : workOrderCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
