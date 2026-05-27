// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryOrder {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(fromJson: _stringFromJson, name: 'order_number') String get orderNumber;@JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson) int? get customerId;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson) int? get salesOrderId;@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? get salesOrderNumber;@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? get deliveryDate;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? get itemsCount;@JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson) double? get totalQuantity;@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) int? get invoiceCount;@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) String? get logisticsCompany;@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) String? get trackingNumber;@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) String? get exceptionResolution;@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) String? get exceptionResolutionDisplay;@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) String? get exceptionResolutionNotes;@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) bool? get exceptionClosed;
/// Create a copy of DeliveryOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryOrderCopyWith<DeliveryOrder> get copyWith => _$DeliveryOrderCopyWithImpl<DeliveryOrder>(this as DeliveryOrder, _$identity);

  /// Serializes this DeliveryOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.invoiceCount, invoiceCount) || other.invoiceCount == invoiceCount)&&(identical(other.logisticsCompany, logisticsCompany) || other.logisticsCompany == logisticsCompany)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.exceptionResolution, exceptionResolution) || other.exceptionResolution == exceptionResolution)&&(identical(other.exceptionResolutionDisplay, exceptionResolutionDisplay) || other.exceptionResolutionDisplay == exceptionResolutionDisplay)&&(identical(other.exceptionResolutionNotes, exceptionResolutionNotes) || other.exceptionResolutionNotes == exceptionResolutionNotes)&&(identical(other.exceptionClosed, exceptionClosed) || other.exceptionClosed == exceptionClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,customerId,customerName,salesOrderId,salesOrderNumber,deliveryDate,status,statusDisplay,itemsCount,totalQuantity,invoiceCount,logisticsCompany,trackingNumber,exceptionResolution,exceptionResolutionDisplay,exceptionResolutionNotes,exceptionClosed);

@override
String toString() {
  return 'DeliveryOrder(id: $id, orderNumber: $orderNumber, customerId: $customerId, customerName: $customerName, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, deliveryDate: $deliveryDate, status: $status, statusDisplay: $statusDisplay, itemsCount: $itemsCount, totalQuantity: $totalQuantity, invoiceCount: $invoiceCount, logisticsCompany: $logisticsCompany, trackingNumber: $trackingNumber, exceptionResolution: $exceptionResolution, exceptionResolutionDisplay: $exceptionResolutionDisplay, exceptionResolutionNotes: $exceptionResolutionNotes, exceptionClosed: $exceptionClosed)';
}


}

/// @nodoc
abstract mixin class $DeliveryOrderCopyWith<$Res>  {
  factory $DeliveryOrderCopyWith(DeliveryOrder value, $Res Function(DeliveryOrder) _then) = _$DeliveryOrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson, name: 'order_number') String orderNumber,@JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson) int? customerId,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,@JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson) double? totalQuantity,@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) int? invoiceCount,@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) String? logisticsCompany,@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) String? trackingNumber,@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) String? exceptionResolution,@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) String? exceptionResolutionDisplay,@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) String? exceptionResolutionNotes,@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) bool? exceptionClosed
});




}
/// @nodoc
class _$DeliveryOrderCopyWithImpl<$Res>
    implements $DeliveryOrderCopyWith<$Res> {
  _$DeliveryOrderCopyWithImpl(this._self, this._then);

  final DeliveryOrder _self;
  final $Res Function(DeliveryOrder) _then;

/// Create a copy of DeliveryOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = freezed,Object? customerName = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? deliveryDate = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? itemsCount = freezed,Object? totalQuantity = freezed,Object? invoiceCount = freezed,Object? logisticsCompany = freezed,Object? trackingNumber = freezed,Object? exceptionResolution = freezed,Object? exceptionResolutionDisplay = freezed,Object? exceptionResolutionNotes = freezed,Object? exceptionClosed = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,totalQuantity: freezed == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double?,invoiceCount: freezed == invoiceCount ? _self.invoiceCount : invoiceCount // ignore: cast_nullable_to_non_nullable
as int?,logisticsCompany: freezed == logisticsCompany ? _self.logisticsCompany : logisticsCompany // ignore: cast_nullable_to_non_nullable
as String?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolution: freezed == exceptionResolution ? _self.exceptionResolution : exceptionResolution // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionDisplay: freezed == exceptionResolutionDisplay ? _self.exceptionResolutionDisplay : exceptionResolutionDisplay // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionNotes: freezed == exceptionResolutionNotes ? _self.exceptionResolutionNotes : exceptionResolutionNotes // ignore: cast_nullable_to_non_nullable
as String?,exceptionClosed: freezed == exceptionClosed ? _self.exceptionClosed : exceptionClosed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryOrder].
extension DeliveryOrderPatterns on DeliveryOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryOrder value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryOrder value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson, name: 'order_number')  String orderNumber, @JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)  double? totalQuantity, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)  int? invoiceCount, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)  String? logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)  String? trackingNumber, @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)  String? exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)  String? exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)  String? exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)  bool? exceptionClosed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customerName,_that.salesOrderId,_that.salesOrderNumber,_that.deliveryDate,_that.status,_that.statusDisplay,_that.itemsCount,_that.totalQuantity,_that.invoiceCount,_that.logisticsCompany,_that.trackingNumber,_that.exceptionResolution,_that.exceptionResolutionDisplay,_that.exceptionResolutionNotes,_that.exceptionClosed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson, name: 'order_number')  String orderNumber, @JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)  double? totalQuantity, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)  int? invoiceCount, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)  String? logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)  String? trackingNumber, @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)  String? exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)  String? exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)  String? exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)  bool? exceptionClosed)  $default,) {final _that = this;
switch (_that) {
case _DeliveryOrder():
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customerName,_that.salesOrderId,_that.salesOrderNumber,_that.deliveryDate,_that.status,_that.statusDisplay,_that.itemsCount,_that.totalQuantity,_that.invoiceCount,_that.logisticsCompany,_that.trackingNumber,_that.exceptionResolution,_that.exceptionResolutionDisplay,_that.exceptionResolutionNotes,_that.exceptionClosed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson, name: 'order_number')  String orderNumber, @JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)  int? itemsCount, @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)  double? totalQuantity, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)  int? invoiceCount, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)  String? logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)  String? trackingNumber, @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)  String? exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)  String? exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)  String? exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)  bool? exceptionClosed)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customerName,_that.salesOrderId,_that.salesOrderNumber,_that.deliveryDate,_that.status,_that.statusDisplay,_that.itemsCount,_that.totalQuantity,_that.invoiceCount,_that.logisticsCompany,_that.trackingNumber,_that.exceptionResolution,_that.exceptionResolutionDisplay,_that.exceptionResolutionNotes,_that.exceptionClosed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryOrder implements DeliveryOrder {
  const _DeliveryOrder({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(fromJson: _stringFromJson, name: 'order_number') required this.orderNumber, @JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson) this.customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson) this.salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) this.salesOrderNumber, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) this.deliveryDate, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) this.itemsCount, @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson) this.totalQuantity, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) this.invoiceCount, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) this.logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) this.trackingNumber, @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) this.exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) this.exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) this.exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) this.exceptionClosed});
  factory _DeliveryOrder.fromJson(Map<String, dynamic> json) => _$DeliveryOrderFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(fromJson: _stringFromJson, name: 'order_number') final  String orderNumber;
@override@JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson) final  int? customerId;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson) final  int? salesOrderId;
@override@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) final  String? salesOrderNumber;
@override@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? deliveryDate;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) final  int? itemsCount;
@override@JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson) final  double? totalQuantity;
@override@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) final  int? invoiceCount;
@override@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) final  String? logisticsCompany;
@override@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) final  String? trackingNumber;
@override@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) final  String? exceptionResolution;
@override@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) final  String? exceptionResolutionDisplay;
@override@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) final  String? exceptionResolutionNotes;
@override@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) final  bool? exceptionClosed;

/// Create a copy of DeliveryOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryOrderCopyWith<_DeliveryOrder> get copyWith => __$DeliveryOrderCopyWithImpl<_DeliveryOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.itemsCount, itemsCount) || other.itemsCount == itemsCount)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.invoiceCount, invoiceCount) || other.invoiceCount == invoiceCount)&&(identical(other.logisticsCompany, logisticsCompany) || other.logisticsCompany == logisticsCompany)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.exceptionResolution, exceptionResolution) || other.exceptionResolution == exceptionResolution)&&(identical(other.exceptionResolutionDisplay, exceptionResolutionDisplay) || other.exceptionResolutionDisplay == exceptionResolutionDisplay)&&(identical(other.exceptionResolutionNotes, exceptionResolutionNotes) || other.exceptionResolutionNotes == exceptionResolutionNotes)&&(identical(other.exceptionClosed, exceptionClosed) || other.exceptionClosed == exceptionClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,customerId,customerName,salesOrderId,salesOrderNumber,deliveryDate,status,statusDisplay,itemsCount,totalQuantity,invoiceCount,logisticsCompany,trackingNumber,exceptionResolution,exceptionResolutionDisplay,exceptionResolutionNotes,exceptionClosed);

@override
String toString() {
  return 'DeliveryOrder(id: $id, orderNumber: $orderNumber, customerId: $customerId, customerName: $customerName, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, deliveryDate: $deliveryDate, status: $status, statusDisplay: $statusDisplay, itemsCount: $itemsCount, totalQuantity: $totalQuantity, invoiceCount: $invoiceCount, logisticsCompany: $logisticsCompany, trackingNumber: $trackingNumber, exceptionResolution: $exceptionResolution, exceptionResolutionDisplay: $exceptionResolutionDisplay, exceptionResolutionNotes: $exceptionResolutionNotes, exceptionClosed: $exceptionClosed)';
}


}

/// @nodoc
abstract mixin class _$DeliveryOrderCopyWith<$Res> implements $DeliveryOrderCopyWith<$Res> {
  factory _$DeliveryOrderCopyWith(_DeliveryOrder value, $Res Function(_DeliveryOrder) _then) = __$DeliveryOrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson, name: 'order_number') String orderNumber,@JsonKey(name: 'customer_id', readValue: _readCustomerId, fromJson: _intOrNullFromJson) int? customerId,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'sales_order_id', readValue: _readSalesOrderId, fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,@JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson) double? totalQuantity,@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) int? invoiceCount,@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) String? logisticsCompany,@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) String? trackingNumber,@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) String? exceptionResolution,@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) String? exceptionResolutionDisplay,@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) String? exceptionResolutionNotes,@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) bool? exceptionClosed
});




}
/// @nodoc
class __$DeliveryOrderCopyWithImpl<$Res>
    implements _$DeliveryOrderCopyWith<$Res> {
  __$DeliveryOrderCopyWithImpl(this._self, this._then);

  final _DeliveryOrder _self;
  final $Res Function(_DeliveryOrder) _then;

/// Create a copy of DeliveryOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = freezed,Object? customerName = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? deliveryDate = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? itemsCount = freezed,Object? totalQuantity = freezed,Object? invoiceCount = freezed,Object? logisticsCompany = freezed,Object? trackingNumber = freezed,Object? exceptionResolution = freezed,Object? exceptionResolutionDisplay = freezed,Object? exceptionResolutionNotes = freezed,Object? exceptionClosed = freezed,}) {
  return _then(_DeliveryOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,itemsCount: freezed == itemsCount ? _self.itemsCount : itemsCount // ignore: cast_nullable_to_non_nullable
as int?,totalQuantity: freezed == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double?,invoiceCount: freezed == invoiceCount ? _self.invoiceCount : invoiceCount // ignore: cast_nullable_to_non_nullable
as int?,logisticsCompany: freezed == logisticsCompany ? _self.logisticsCompany : logisticsCompany // ignore: cast_nullable_to_non_nullable
as String?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolution: freezed == exceptionResolution ? _self.exceptionResolution : exceptionResolution // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionDisplay: freezed == exceptionResolutionDisplay ? _self.exceptionResolutionDisplay : exceptionResolutionDisplay // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionNotes: freezed == exceptionResolutionNotes ? _self.exceptionResolutionNotes : exceptionResolutionNotes // ignore: cast_nullable_to_non_nullable
as String?,exceptionClosed: freezed == exceptionClosed ? _self.exceptionClosed : exceptionClosed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
