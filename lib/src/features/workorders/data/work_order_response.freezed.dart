// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkOrderResponse {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'order_number', fromJson: _stringFromJson) String get orderNumber;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson) String? get salespersonName;@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? get productName;@JsonKey(fromJson: _doubleOrNull_fromJson) double? get quantity;@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? get unit;@JsonKey(name: 'status', fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'priority', fromJson: _stringOrNullFromJson) String? get priority;@JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson) String? get priorityDisplay;@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? get orderDate;@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? get deliveryDate;@JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson) double? get totalAmount;@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? get approvalStatus;@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? get approvalStatusDisplay;@JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson) String? get managerName;@JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson) int? get progressPercentage;@JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson) int? get totalTaskCount;@JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson) int? get salesOrderId;@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? get salesOrderNumber;
/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderResponseCopyWith<WorkOrderResponse> get copyWith => _$WorkOrderResponseCopyWithImpl<WorkOrderResponse>(this as WorkOrderResponse, _$identity);

  /// Serializes this WorkOrderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.salespersonName, salespersonName) || other.salespersonName == salespersonName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.priorityDisplay, priorityDisplay) || other.priorityDisplay == priorityDisplay)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvalStatusDisplay, approvalStatusDisplay) || other.approvalStatusDisplay == approvalStatusDisplay)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.totalTaskCount, totalTaskCount) || other.totalTaskCount == totalTaskCount)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,customerName,salespersonName,productName,quantity,unit,status,statusDisplay,priority,priorityDisplay,orderDate,deliveryDate,totalAmount,approvalStatus,approvalStatusDisplay,managerName,progressPercentage,totalTaskCount,salesOrderId,salesOrderNumber]);

@override
String toString() {
  return 'WorkOrderResponse(id: $id, orderNumber: $orderNumber, customerName: $customerName, salespersonName: $salespersonName, productName: $productName, quantity: $quantity, unit: $unit, status: $status, statusDisplay: $statusDisplay, priority: $priority, priorityDisplay: $priorityDisplay, orderDate: $orderDate, deliveryDate: $deliveryDate, totalAmount: $totalAmount, approvalStatus: $approvalStatus, approvalStatusDisplay: $approvalStatusDisplay, managerName: $managerName, progressPercentage: $progressPercentage, totalTaskCount: $totalTaskCount, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber)';
}


}

/// @nodoc
abstract mixin class $WorkOrderResponseCopyWith<$Res>  {
  factory $WorkOrderResponseCopyWith(WorkOrderResponse value, $Res Function(WorkOrderResponse) _then) = _$WorkOrderResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson) String? salespersonName,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(fromJson: _doubleOrNull_fromJson) double? quantity,@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'status', fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'priority', fromJson: _stringOrNullFromJson) String? priority,@JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson) String? priorityDisplay,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson) double? totalAmount,@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? approvalStatus,@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? approvalStatusDisplay,@JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson) String? managerName,@JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson) int? progressPercentage,@JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson) int? totalTaskCount,@JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber
});




}
/// @nodoc
class _$WorkOrderResponseCopyWithImpl<$Res>
    implements $WorkOrderResponseCopyWith<$Res> {
  _$WorkOrderResponseCopyWithImpl(this._self, this._then);

  final WorkOrderResponse _self;
  final $Res Function(WorkOrderResponse) _then;

/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? customerName = freezed,Object? salespersonName = freezed,Object? productName = freezed,Object? quantity = freezed,Object? unit = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? priority = freezed,Object? priorityDisplay = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? totalAmount = freezed,Object? approvalStatus = freezed,Object? approvalStatusDisplay = freezed,Object? managerName = freezed,Object? progressPercentage = freezed,Object? totalTaskCount = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,salespersonName: freezed == salespersonName ? _self.salespersonName : salespersonName // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,priorityDisplay: freezed == priorityDisplay ? _self.priorityDisplay : priorityDisplay // ignore: cast_nullable_to_non_nullable
as String?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,approvalStatusDisplay: freezed == approvalStatusDisplay ? _self.approvalStatusDisplay : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,managerName: freezed == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String?,progressPercentage: freezed == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as int?,totalTaskCount: freezed == totalTaskCount ? _self.totalTaskCount : totalTaskCount // ignore: cast_nullable_to_non_nullable
as int?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkOrderResponse].
extension WorkOrderResponsePatterns on WorkOrderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrderResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)  String? salespersonName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(fromJson: _doubleOrNull_fromJson)  double? quantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'status', fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)  String? priority, @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)  String? priorityDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)  double? totalAmount, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)  String? managerName, @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)  int? progressPercentage, @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)  int? totalTaskCount, @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerName,_that.salespersonName,_that.productName,_that.quantity,_that.unit,_that.status,_that.statusDisplay,_that.priority,_that.priorityDisplay,_that.orderDate,_that.deliveryDate,_that.totalAmount,_that.approvalStatus,_that.approvalStatusDisplay,_that.managerName,_that.progressPercentage,_that.totalTaskCount,_that.salesOrderId,_that.salesOrderNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)  String? salespersonName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(fromJson: _doubleOrNull_fromJson)  double? quantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'status', fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)  String? priority, @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)  String? priorityDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)  double? totalAmount, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)  String? managerName, @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)  int? progressPercentage, @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)  int? totalTaskCount, @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber)  $default,) {final _that = this;
switch (_that) {
case _WorkOrderResponse():
return $default(_that.id,_that.orderNumber,_that.customerName,_that.salespersonName,_that.productName,_that.quantity,_that.unit,_that.status,_that.statusDisplay,_that.priority,_that.priorityDisplay,_that.orderDate,_that.deliveryDate,_that.totalAmount,_that.approvalStatus,_that.approvalStatusDisplay,_that.managerName,_that.progressPercentage,_that.totalTaskCount,_that.salesOrderId,_that.salesOrderNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)  String? salespersonName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(fromJson: _doubleOrNull_fromJson)  double? quantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'status', fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)  String? priority, @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)  String? priorityDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)  double? totalAmount, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)  String? managerName, @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)  int? progressPercentage, @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)  int? totalTaskCount, @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrderResponse() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerName,_that.salespersonName,_that.productName,_that.quantity,_that.unit,_that.status,_that.statusDisplay,_that.priority,_that.priorityDisplay,_that.orderDate,_that.deliveryDate,_that.totalAmount,_that.approvalStatus,_that.approvalStatusDisplay,_that.managerName,_that.progressPercentage,_that.totalTaskCount,_that.salesOrderId,_that.salesOrderNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrderResponse implements WorkOrderResponse {
  const _WorkOrderResponse({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'order_number', fromJson: _stringFromJson) required this.orderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson) this.salespersonName, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) this.productName, @JsonKey(fromJson: _doubleOrNull_fromJson) this.quantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) this.unit, @JsonKey(name: 'status', fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson) this.priority, @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson) this.priorityDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) this.orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) this.deliveryDate, @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson) this.totalAmount, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) this.approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) this.approvalStatusDisplay, @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson) this.managerName, @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson) this.progressPercentage, @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson) this.totalTaskCount, @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson) this.salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) this.salesOrderNumber});
  factory _WorkOrderResponse.fromJson(Map<String, dynamic> json) => _$WorkOrderResponseFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'order_number', fromJson: _stringFromJson) final  String orderNumber;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson) final  String? salespersonName;
@override@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) final  String? productName;
@override@JsonKey(fromJson: _doubleOrNull_fromJson) final  double? quantity;
@override@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) final  String? unit;
@override@JsonKey(name: 'status', fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'priority', fromJson: _stringOrNullFromJson) final  String? priority;
@override@JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson) final  String? priorityDisplay;
@override@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? orderDate;
@override@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? deliveryDate;
@override@JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson) final  double? totalAmount;
@override@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) final  String? approvalStatus;
@override@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) final  String? approvalStatusDisplay;
@override@JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson) final  String? managerName;
@override@JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson) final  int? progressPercentage;
@override@JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson) final  int? totalTaskCount;
@override@JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson) final  int? salesOrderId;
@override@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) final  String? salesOrderNumber;

/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderResponseCopyWith<_WorkOrderResponse> get copyWith => __$WorkOrderResponseCopyWithImpl<_WorkOrderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrderResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.salespersonName, salespersonName) || other.salespersonName == salespersonName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.priorityDisplay, priorityDisplay) || other.priorityDisplay == priorityDisplay)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvalStatusDisplay, approvalStatusDisplay) || other.approvalStatusDisplay == approvalStatusDisplay)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.totalTaskCount, totalTaskCount) || other.totalTaskCount == totalTaskCount)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,customerName,salespersonName,productName,quantity,unit,status,statusDisplay,priority,priorityDisplay,orderDate,deliveryDate,totalAmount,approvalStatus,approvalStatusDisplay,managerName,progressPercentage,totalTaskCount,salesOrderId,salesOrderNumber]);

@override
String toString() {
  return 'WorkOrderResponse(id: $id, orderNumber: $orderNumber, customerName: $customerName, salespersonName: $salespersonName, productName: $productName, quantity: $quantity, unit: $unit, status: $status, statusDisplay: $statusDisplay, priority: $priority, priorityDisplay: $priorityDisplay, orderDate: $orderDate, deliveryDate: $deliveryDate, totalAmount: $totalAmount, approvalStatus: $approvalStatus, approvalStatusDisplay: $approvalStatusDisplay, managerName: $managerName, progressPercentage: $progressPercentage, totalTaskCount: $totalTaskCount, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderResponseCopyWith<$Res> implements $WorkOrderResponseCopyWith<$Res> {
  factory _$WorkOrderResponseCopyWith(_WorkOrderResponse value, $Res Function(_WorkOrderResponse) _then) = __$WorkOrderResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson) String? salespersonName,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(fromJson: _doubleOrNull_fromJson) double? quantity,@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'status', fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'priority', fromJson: _stringOrNullFromJson) String? priority,@JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson) String? priorityDisplay,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson) double? totalAmount,@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? approvalStatus,@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? approvalStatusDisplay,@JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson) String? managerName,@JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson) int? progressPercentage,@JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson) int? totalTaskCount,@JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber
});




}
/// @nodoc
class __$WorkOrderResponseCopyWithImpl<$Res>
    implements _$WorkOrderResponseCopyWith<$Res> {
  __$WorkOrderResponseCopyWithImpl(this._self, this._then);

  final _WorkOrderResponse _self;
  final $Res Function(_WorkOrderResponse) _then;

/// Create a copy of WorkOrderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? customerName = freezed,Object? salespersonName = freezed,Object? productName = freezed,Object? quantity = freezed,Object? unit = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? priority = freezed,Object? priorityDisplay = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? totalAmount = freezed,Object? approvalStatus = freezed,Object? approvalStatusDisplay = freezed,Object? managerName = freezed,Object? progressPercentage = freezed,Object? totalTaskCount = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,}) {
  return _then(_WorkOrderResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,salespersonName: freezed == salespersonName ? _self.salespersonName : salespersonName // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,priorityDisplay: freezed == priorityDisplay ? _self.priorityDisplay : priorityDisplay // ignore: cast_nullable_to_non_nullable
as String?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,approvalStatusDisplay: freezed == approvalStatusDisplay ? _self.approvalStatusDisplay : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,managerName: freezed == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String?,progressPercentage: freezed == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as int?,totalTaskCount: freezed == totalTaskCount ? _self.totalTaskCount : totalTaskCount // ignore: cast_nullable_to_non_nullable
as int?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
