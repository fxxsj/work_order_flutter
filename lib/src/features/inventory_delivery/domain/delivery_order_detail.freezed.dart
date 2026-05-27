// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryOrderDetail {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'order_number', fromJson: _stringFromJson) String get orderNumber;@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? get salesOrderId;@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? get salesOrderNumber;@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? get customerId;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? get deliveryDate;@JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson) String? get receiverName;@JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson) String? get receiverPhone;@JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson) String? get deliveryAddress;@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) String? get logisticsCompany;@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) String? get trackingNumber;@JsonKey(fromJson: _doubleOrNullFromJson) double? get freight;@JsonKey(name: 'package_count', fromJson: _intOrNullFromJson) int? get packageCount;@JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson) double? get packageWeight;@JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson) DateTime? get receivedDate;@JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson) String? get receivedNotes;@JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson) String? get receiverSignatureUrl;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) int? get invoiceCount;@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> get invoiceNumbers;@JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson) List<DeliveryOrderItem> get items;@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) String? get exceptionResolution;@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) String? get exceptionResolutionDisplay;@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) String? get exceptionResolutionNotes;@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) bool? get exceptionClosed;
/// Create a copy of DeliveryOrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryOrderDetailCopyWith<DeliveryOrderDetail> get copyWith => _$DeliveryOrderDetailCopyWithImpl<DeliveryOrderDetail>(this as DeliveryOrderDetail, _$identity);

  /// Serializes this DeliveryOrderDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryOrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.receiverPhone, receiverPhone) || other.receiverPhone == receiverPhone)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.logisticsCompany, logisticsCompany) || other.logisticsCompany == logisticsCompany)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.freight, freight) || other.freight == freight)&&(identical(other.packageCount, packageCount) || other.packageCount == packageCount)&&(identical(other.packageWeight, packageWeight) || other.packageWeight == packageWeight)&&(identical(other.receivedDate, receivedDate) || other.receivedDate == receivedDate)&&(identical(other.receivedNotes, receivedNotes) || other.receivedNotes == receivedNotes)&&(identical(other.receiverSignatureUrl, receiverSignatureUrl) || other.receiverSignatureUrl == receiverSignatureUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.invoiceCount, invoiceCount) || other.invoiceCount == invoiceCount)&&const DeepCollectionEquality().equals(other.invoiceNumbers, invoiceNumbers)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.exceptionResolution, exceptionResolution) || other.exceptionResolution == exceptionResolution)&&(identical(other.exceptionResolutionDisplay, exceptionResolutionDisplay) || other.exceptionResolutionDisplay == exceptionResolutionDisplay)&&(identical(other.exceptionResolutionNotes, exceptionResolutionNotes) || other.exceptionResolutionNotes == exceptionResolutionNotes)&&(identical(other.exceptionClosed, exceptionClosed) || other.exceptionClosed == exceptionClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,salesOrderId,salesOrderNumber,customerId,customerName,status,statusDisplay,deliveryDate,receiverName,receiverPhone,deliveryAddress,logisticsCompany,trackingNumber,freight,packageCount,packageWeight,receivedDate,receivedNotes,receiverSignatureUrl,notes,invoiceCount,const DeepCollectionEquality().hash(invoiceNumbers),const DeepCollectionEquality().hash(items),exceptionResolution,exceptionResolutionDisplay,exceptionResolutionNotes,exceptionClosed]);

@override
String toString() {
  return 'DeliveryOrderDetail(id: $id, orderNumber: $orderNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, customerId: $customerId, customerName: $customerName, status: $status, statusDisplay: $statusDisplay, deliveryDate: $deliveryDate, receiverName: $receiverName, receiverPhone: $receiverPhone, deliveryAddress: $deliveryAddress, logisticsCompany: $logisticsCompany, trackingNumber: $trackingNumber, freight: $freight, packageCount: $packageCount, packageWeight: $packageWeight, receivedDate: $receivedDate, receivedNotes: $receivedNotes, receiverSignatureUrl: $receiverSignatureUrl, notes: $notes, invoiceCount: $invoiceCount, invoiceNumbers: $invoiceNumbers, items: $items, exceptionResolution: $exceptionResolution, exceptionResolutionDisplay: $exceptionResolutionDisplay, exceptionResolutionNotes: $exceptionResolutionNotes, exceptionClosed: $exceptionClosed)';
}


}

/// @nodoc
abstract mixin class $DeliveryOrderDetailCopyWith<$Res>  {
  factory $DeliveryOrderDetailCopyWith(DeliveryOrderDetail value, $Res Function(DeliveryOrderDetail) _then) = _$DeliveryOrderDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson) String? receiverName,@JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson) String? receiverPhone,@JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson) String? deliveryAddress,@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) String? logisticsCompany,@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) String? trackingNumber,@JsonKey(fromJson: _doubleOrNullFromJson) double? freight,@JsonKey(name: 'package_count', fromJson: _intOrNullFromJson) int? packageCount,@JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson) double? packageWeight,@JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson) DateTime? receivedDate,@JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson) String? receivedNotes,@JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson) String? receiverSignatureUrl,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) int? invoiceCount,@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> invoiceNumbers,@JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson) List<DeliveryOrderItem> items,@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) String? exceptionResolution,@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) String? exceptionResolutionDisplay,@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) String? exceptionResolutionNotes,@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) bool? exceptionClosed
});




}
/// @nodoc
class _$DeliveryOrderDetailCopyWithImpl<$Res>
    implements $DeliveryOrderDetailCopyWith<$Res> {
  _$DeliveryOrderDetailCopyWithImpl(this._self, this._then);

  final DeliveryOrderDetail _self;
  final $Res Function(DeliveryOrderDetail) _then;

/// Create a copy of DeliveryOrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? deliveryDate = freezed,Object? receiverName = freezed,Object? receiverPhone = freezed,Object? deliveryAddress = freezed,Object? logisticsCompany = freezed,Object? trackingNumber = freezed,Object? freight = freezed,Object? packageCount = freezed,Object? packageWeight = freezed,Object? receivedDate = freezed,Object? receivedNotes = freezed,Object? receiverSignatureUrl = freezed,Object? notes = freezed,Object? invoiceCount = freezed,Object? invoiceNumbers = null,Object? items = null,Object? exceptionResolution = freezed,Object? exceptionResolutionDisplay = freezed,Object? exceptionResolutionNotes = freezed,Object? exceptionClosed = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,receiverPhone: freezed == receiverPhone ? _self.receiverPhone : receiverPhone // ignore: cast_nullable_to_non_nullable
as String?,deliveryAddress: freezed == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String?,logisticsCompany: freezed == logisticsCompany ? _self.logisticsCompany : logisticsCompany // ignore: cast_nullable_to_non_nullable
as String?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,freight: freezed == freight ? _self.freight : freight // ignore: cast_nullable_to_non_nullable
as double?,packageCount: freezed == packageCount ? _self.packageCount : packageCount // ignore: cast_nullable_to_non_nullable
as int?,packageWeight: freezed == packageWeight ? _self.packageWeight : packageWeight // ignore: cast_nullable_to_non_nullable
as double?,receivedDate: freezed == receivedDate ? _self.receivedDate : receivedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedNotes: freezed == receivedNotes ? _self.receivedNotes : receivedNotes // ignore: cast_nullable_to_non_nullable
as String?,receiverSignatureUrl: freezed == receiverSignatureUrl ? _self.receiverSignatureUrl : receiverSignatureUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,invoiceCount: freezed == invoiceCount ? _self.invoiceCount : invoiceCount // ignore: cast_nullable_to_non_nullable
as int?,invoiceNumbers: null == invoiceNumbers ? _self.invoiceNumbers : invoiceNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DeliveryOrderItem>,exceptionResolution: freezed == exceptionResolution ? _self.exceptionResolution : exceptionResolution // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionDisplay: freezed == exceptionResolutionDisplay ? _self.exceptionResolutionDisplay : exceptionResolutionDisplay // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionNotes: freezed == exceptionResolutionNotes ? _self.exceptionResolutionNotes : exceptionResolutionNotes // ignore: cast_nullable_to_non_nullable
as String?,exceptionClosed: freezed == exceptionClosed ? _self.exceptionClosed : exceptionClosed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryOrderDetail].
extension DeliveryOrderDetailPatterns on DeliveryOrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryOrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryOrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryOrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryOrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryOrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryOrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)  String? receiverName, @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)  String? receiverPhone, @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)  String? deliveryAddress, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)  String? logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)  String? trackingNumber, @JsonKey(fromJson: _doubleOrNullFromJson)  double? freight, @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)  int? packageCount, @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)  double? packageWeight, @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)  DateTime? receivedDate, @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)  String? receivedNotes, @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)  String? receiverSignatureUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)  int? invoiceCount, @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)  List<String> invoiceNumbers, @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)  List<DeliveryOrderItem> items, @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)  String? exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)  String? exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)  String? exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)  bool? exceptionClosed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryOrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.salesOrderId,_that.salesOrderNumber,_that.customerId,_that.customerName,_that.status,_that.statusDisplay,_that.deliveryDate,_that.receiverName,_that.receiverPhone,_that.deliveryAddress,_that.logisticsCompany,_that.trackingNumber,_that.freight,_that.packageCount,_that.packageWeight,_that.receivedDate,_that.receivedNotes,_that.receiverSignatureUrl,_that.notes,_that.invoiceCount,_that.invoiceNumbers,_that.items,_that.exceptionResolution,_that.exceptionResolutionDisplay,_that.exceptionResolutionNotes,_that.exceptionClosed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)  String? receiverName, @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)  String? receiverPhone, @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)  String? deliveryAddress, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)  String? logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)  String? trackingNumber, @JsonKey(fromJson: _doubleOrNullFromJson)  double? freight, @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)  int? packageCount, @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)  double? packageWeight, @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)  DateTime? receivedDate, @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)  String? receivedNotes, @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)  String? receiverSignatureUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)  int? invoiceCount, @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)  List<String> invoiceNumbers, @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)  List<DeliveryOrderItem> items, @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)  String? exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)  String? exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)  String? exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)  bool? exceptionClosed)  $default,) {final _that = this;
switch (_that) {
case _DeliveryOrderDetail():
return $default(_that.id,_that.orderNumber,_that.salesOrderId,_that.salesOrderNumber,_that.customerId,_that.customerName,_that.status,_that.statusDisplay,_that.deliveryDate,_that.receiverName,_that.receiverPhone,_that.deliveryAddress,_that.logisticsCompany,_that.trackingNumber,_that.freight,_that.packageCount,_that.packageWeight,_that.receivedDate,_that.receivedNotes,_that.receiverSignatureUrl,_that.notes,_that.invoiceCount,_that.invoiceNumbers,_that.items,_that.exceptionResolution,_that.exceptionResolutionDisplay,_that.exceptionResolutionNotes,_that.exceptionClosed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)  String? receiverName, @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)  String? receiverPhone, @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)  String? deliveryAddress, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)  String? logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)  String? trackingNumber, @JsonKey(fromJson: _doubleOrNullFromJson)  double? freight, @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)  int? packageCount, @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)  double? packageWeight, @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)  DateTime? receivedDate, @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)  String? receivedNotes, @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)  String? receiverSignatureUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)  int? invoiceCount, @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)  List<String> invoiceNumbers, @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)  List<DeliveryOrderItem> items, @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)  String? exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)  String? exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)  String? exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)  bool? exceptionClosed)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryOrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.salesOrderId,_that.salesOrderNumber,_that.customerId,_that.customerName,_that.status,_that.statusDisplay,_that.deliveryDate,_that.receiverName,_that.receiverPhone,_that.deliveryAddress,_that.logisticsCompany,_that.trackingNumber,_that.freight,_that.packageCount,_that.packageWeight,_that.receivedDate,_that.receivedNotes,_that.receiverSignatureUrl,_that.notes,_that.invoiceCount,_that.invoiceNumbers,_that.items,_that.exceptionResolution,_that.exceptionResolutionDisplay,_that.exceptionResolutionNotes,_that.exceptionClosed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryOrderDetail implements DeliveryOrderDetail {
  const _DeliveryOrderDetail({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'order_number', fromJson: _stringFromJson) required this.orderNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) this.salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) this.salesOrderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) this.customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) this.deliveryDate, @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson) this.receiverName, @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson) this.receiverPhone, @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson) this.deliveryAddress, @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) this.logisticsCompany, @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) this.trackingNumber, @JsonKey(fromJson: _doubleOrNullFromJson) this.freight, @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson) this.packageCount, @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson) this.packageWeight, @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson) this.receivedDate, @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson) this.receivedNotes, @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson) this.receiverSignatureUrl, @JsonKey(fromJson: _stringOrNullFromJson) this.notes, @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) this.invoiceCount, @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) final  List<String> invoiceNumbers = const <String>[], @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson) final  List<DeliveryOrderItem> items = const <DeliveryOrderItem>[], @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) this.exceptionResolution, @JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) this.exceptionResolutionDisplay, @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) this.exceptionResolutionNotes, @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) this.exceptionClosed}): _invoiceNumbers = invoiceNumbers,_items = items;
  factory _DeliveryOrderDetail.fromJson(Map<String, dynamic> json) => _$DeliveryOrderDetailFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'order_number', fromJson: _stringFromJson) final  String orderNumber;
@override@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) final  int? salesOrderId;
@override@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) final  String? salesOrderNumber;
@override@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) final  int? customerId;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? deliveryDate;
@override@JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson) final  String? receiverName;
@override@JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson) final  String? receiverPhone;
@override@JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson) final  String? deliveryAddress;
@override@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) final  String? logisticsCompany;
@override@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) final  String? trackingNumber;
@override@JsonKey(fromJson: _doubleOrNullFromJson) final  double? freight;
@override@JsonKey(name: 'package_count', fromJson: _intOrNullFromJson) final  int? packageCount;
@override@JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson) final  double? packageWeight;
@override@JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? receivedDate;
@override@JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson) final  String? receivedNotes;
@override@JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson) final  String? receiverSignatureUrl;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;
@override@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) final  int? invoiceCount;
 final  List<String> _invoiceNumbers;
@override@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> get invoiceNumbers {
  if (_invoiceNumbers is EqualUnmodifiableListView) return _invoiceNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoiceNumbers);
}

 final  List<DeliveryOrderItem> _items;
@override@JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson) List<DeliveryOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) final  String? exceptionResolution;
@override@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) final  String? exceptionResolutionDisplay;
@override@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) final  String? exceptionResolutionNotes;
@override@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) final  bool? exceptionClosed;

/// Create a copy of DeliveryOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryOrderDetailCopyWith<_DeliveryOrderDetail> get copyWith => __$DeliveryOrderDetailCopyWithImpl<_DeliveryOrderDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryOrderDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryOrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.receiverPhone, receiverPhone) || other.receiverPhone == receiverPhone)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.logisticsCompany, logisticsCompany) || other.logisticsCompany == logisticsCompany)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.freight, freight) || other.freight == freight)&&(identical(other.packageCount, packageCount) || other.packageCount == packageCount)&&(identical(other.packageWeight, packageWeight) || other.packageWeight == packageWeight)&&(identical(other.receivedDate, receivedDate) || other.receivedDate == receivedDate)&&(identical(other.receivedNotes, receivedNotes) || other.receivedNotes == receivedNotes)&&(identical(other.receiverSignatureUrl, receiverSignatureUrl) || other.receiverSignatureUrl == receiverSignatureUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.invoiceCount, invoiceCount) || other.invoiceCount == invoiceCount)&&const DeepCollectionEquality().equals(other._invoiceNumbers, _invoiceNumbers)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.exceptionResolution, exceptionResolution) || other.exceptionResolution == exceptionResolution)&&(identical(other.exceptionResolutionDisplay, exceptionResolutionDisplay) || other.exceptionResolutionDisplay == exceptionResolutionDisplay)&&(identical(other.exceptionResolutionNotes, exceptionResolutionNotes) || other.exceptionResolutionNotes == exceptionResolutionNotes)&&(identical(other.exceptionClosed, exceptionClosed) || other.exceptionClosed == exceptionClosed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,salesOrderId,salesOrderNumber,customerId,customerName,status,statusDisplay,deliveryDate,receiverName,receiverPhone,deliveryAddress,logisticsCompany,trackingNumber,freight,packageCount,packageWeight,receivedDate,receivedNotes,receiverSignatureUrl,notes,invoiceCount,const DeepCollectionEquality().hash(_invoiceNumbers),const DeepCollectionEquality().hash(_items),exceptionResolution,exceptionResolutionDisplay,exceptionResolutionNotes,exceptionClosed]);

@override
String toString() {
  return 'DeliveryOrderDetail(id: $id, orderNumber: $orderNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, customerId: $customerId, customerName: $customerName, status: $status, statusDisplay: $statusDisplay, deliveryDate: $deliveryDate, receiverName: $receiverName, receiverPhone: $receiverPhone, deliveryAddress: $deliveryAddress, logisticsCompany: $logisticsCompany, trackingNumber: $trackingNumber, freight: $freight, packageCount: $packageCount, packageWeight: $packageWeight, receivedDate: $receivedDate, receivedNotes: $receivedNotes, receiverSignatureUrl: $receiverSignatureUrl, notes: $notes, invoiceCount: $invoiceCount, invoiceNumbers: $invoiceNumbers, items: $items, exceptionResolution: $exceptionResolution, exceptionResolutionDisplay: $exceptionResolutionDisplay, exceptionResolutionNotes: $exceptionResolutionNotes, exceptionClosed: $exceptionClosed)';
}


}

/// @nodoc
abstract mixin class _$DeliveryOrderDetailCopyWith<$Res> implements $DeliveryOrderDetailCopyWith<$Res> {
  factory _$DeliveryOrderDetailCopyWith(_DeliveryOrderDetail value, $Res Function(_DeliveryOrderDetail) _then) = __$DeliveryOrderDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson) String? receiverName,@JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson) String? receiverPhone,@JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson) String? deliveryAddress,@JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson) String? logisticsCompany,@JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson) String? trackingNumber,@JsonKey(fromJson: _doubleOrNullFromJson) double? freight,@JsonKey(name: 'package_count', fromJson: _intOrNullFromJson) int? packageCount,@JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson) double? packageWeight,@JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson) DateTime? receivedDate,@JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson) String? receivedNotes,@JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson) String? receiverSignatureUrl,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson) int? invoiceCount,@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> invoiceNumbers,@JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson) List<DeliveryOrderItem> items,@JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson) String? exceptionResolution,@JsonKey(name: 'exception_resolution_display', fromJson: _stringOrNullFromJson) String? exceptionResolutionDisplay,@JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson) String? exceptionResolutionNotes,@JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson) bool? exceptionClosed
});




}
/// @nodoc
class __$DeliveryOrderDetailCopyWithImpl<$Res>
    implements _$DeliveryOrderDetailCopyWith<$Res> {
  __$DeliveryOrderDetailCopyWithImpl(this._self, this._then);

  final _DeliveryOrderDetail _self;
  final $Res Function(_DeliveryOrderDetail) _then;

/// Create a copy of DeliveryOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? deliveryDate = freezed,Object? receiverName = freezed,Object? receiverPhone = freezed,Object? deliveryAddress = freezed,Object? logisticsCompany = freezed,Object? trackingNumber = freezed,Object? freight = freezed,Object? packageCount = freezed,Object? packageWeight = freezed,Object? receivedDate = freezed,Object? receivedNotes = freezed,Object? receiverSignatureUrl = freezed,Object? notes = freezed,Object? invoiceCount = freezed,Object? invoiceNumbers = null,Object? items = null,Object? exceptionResolution = freezed,Object? exceptionResolutionDisplay = freezed,Object? exceptionResolutionNotes = freezed,Object? exceptionClosed = freezed,}) {
  return _then(_DeliveryOrderDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,receiverPhone: freezed == receiverPhone ? _self.receiverPhone : receiverPhone // ignore: cast_nullable_to_non_nullable
as String?,deliveryAddress: freezed == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String?,logisticsCompany: freezed == logisticsCompany ? _self.logisticsCompany : logisticsCompany // ignore: cast_nullable_to_non_nullable
as String?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,freight: freezed == freight ? _self.freight : freight // ignore: cast_nullable_to_non_nullable
as double?,packageCount: freezed == packageCount ? _self.packageCount : packageCount // ignore: cast_nullable_to_non_nullable
as int?,packageWeight: freezed == packageWeight ? _self.packageWeight : packageWeight // ignore: cast_nullable_to_non_nullable
as double?,receivedDate: freezed == receivedDate ? _self.receivedDate : receivedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedNotes: freezed == receivedNotes ? _self.receivedNotes : receivedNotes // ignore: cast_nullable_to_non_nullable
as String?,receiverSignatureUrl: freezed == receiverSignatureUrl ? _self.receiverSignatureUrl : receiverSignatureUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,invoiceCount: freezed == invoiceCount ? _self.invoiceCount : invoiceCount // ignore: cast_nullable_to_non_nullable
as int?,invoiceNumbers: null == invoiceNumbers ? _self._invoiceNumbers : invoiceNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DeliveryOrderItem>,exceptionResolution: freezed == exceptionResolution ? _self.exceptionResolution : exceptionResolution // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionDisplay: freezed == exceptionResolutionDisplay ? _self.exceptionResolutionDisplay : exceptionResolutionDisplay // ignore: cast_nullable_to_non_nullable
as String?,exceptionResolutionNotes: freezed == exceptionResolutionNotes ? _self.exceptionResolutionNotes : exceptionResolutionNotes // ignore: cast_nullable_to_non_nullable
as String?,exceptionClosed: freezed == exceptionClosed ? _self.exceptionClosed : exceptionClosed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$DeliveryOrderItem {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? get productId;@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? get productName;@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? get productCode;@JsonKey(fromJson: _doubleOrNullFromJson) double? get quantity;@JsonKey(fromJson: _stringOrNullFromJson) String? get unit;@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? get unitPrice;@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? get subtotal;@JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson) String? get stockBatch;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;
/// Create a copy of DeliveryOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryOrderItemCopyWith<DeliveryOrderItem> get copyWith => _$DeliveryOrderItemCopyWithImpl<DeliveryOrderItem>(this as DeliveryOrderItem, _$identity);

  /// Serializes this DeliveryOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productCode, productCode) || other.productCode == productCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.stockBatch, stockBatch) || other.stockBatch == stockBatch)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,productCode,quantity,unit,unitPrice,subtotal,stockBatch,notes);

@override
String toString() {
  return 'DeliveryOrderItem(id: $id, productId: $productId, productName: $productName, productCode: $productCode, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, subtotal: $subtotal, stockBatch: $stockBatch, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $DeliveryOrderItemCopyWith<$Res>  {
  factory $DeliveryOrderItemCopyWith(DeliveryOrderItem value, $Res Function(DeliveryOrderItem) _then) = _$DeliveryOrderItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? productCode,@JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,@JsonKey(fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson) String? stockBatch,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class _$DeliveryOrderItemCopyWithImpl<$Res>
    implements $DeliveryOrderItemCopyWith<$Res> {
  _$DeliveryOrderItemCopyWithImpl(this._self, this._then);

  final DeliveryOrderItem _self;
  final $Res Function(DeliveryOrderItem) _then;

/// Create a copy of DeliveryOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = freezed,Object? productName = freezed,Object? productCode = freezed,Object? quantity = freezed,Object? unit = freezed,Object? unitPrice = freezed,Object? subtotal = freezed,Object? stockBatch = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productCode: freezed == productCode ? _self.productCode : productCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,stockBatch: freezed == stockBatch ? _self.stockBatch : stockBatch // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryOrderItem].
extension DeliveryOrderItemPatterns on DeliveryOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson)  int? productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)  String? stockBatch, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryOrderItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.productCode,_that.quantity,_that.unit,_that.unitPrice,_that.subtotal,_that.stockBatch,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson)  int? productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)  String? stockBatch, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)  $default,) {final _that = this;
switch (_that) {
case _DeliveryOrderItem():
return $default(_that.id,_that.productId,_that.productName,_that.productCode,_that.quantity,_that.unit,_that.unitPrice,_that.subtotal,_that.stockBatch,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson)  int? productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)  String? stockBatch, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryOrderItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.productCode,_that.quantity,_that.unit,_that.unitPrice,_that.subtotal,_that.stockBatch,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryOrderItem implements DeliveryOrderItem {
  const _DeliveryOrderItem({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson) this.productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) this.productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) this.productCode, @JsonKey(fromJson: _doubleOrNullFromJson) this.quantity, @JsonKey(fromJson: _stringOrNullFromJson) this.unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) this.unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal, @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson) this.stockBatch, @JsonKey(fromJson: _stringOrNullFromJson) this.notes});
  factory _DeliveryOrderItem.fromJson(Map<String, dynamic> json) => _$DeliveryOrderItemFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'product', fromJson: _intOrNullFromJson) final  int? productId;
@override@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) final  String? productName;
@override@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) final  String? productCode;
@override@JsonKey(fromJson: _doubleOrNullFromJson) final  double? quantity;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? unit;
@override@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) final  double? unitPrice;
@override@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) final  double? subtotal;
@override@JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson) final  String? stockBatch;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;

/// Create a copy of DeliveryOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryOrderItemCopyWith<_DeliveryOrderItem> get copyWith => __$DeliveryOrderItemCopyWithImpl<_DeliveryOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productCode, productCode) || other.productCode == productCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.stockBatch, stockBatch) || other.stockBatch == stockBatch)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,productCode,quantity,unit,unitPrice,subtotal,stockBatch,notes);

@override
String toString() {
  return 'DeliveryOrderItem(id: $id, productId: $productId, productName: $productName, productCode: $productCode, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, subtotal: $subtotal, stockBatch: $stockBatch, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$DeliveryOrderItemCopyWith<$Res> implements $DeliveryOrderItemCopyWith<$Res> {
  factory _$DeliveryOrderItemCopyWith(_DeliveryOrderItem value, $Res Function(_DeliveryOrderItem) _then) = __$DeliveryOrderItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? productCode,@JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,@JsonKey(fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson) String? stockBatch,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class __$DeliveryOrderItemCopyWithImpl<$Res>
    implements _$DeliveryOrderItemCopyWith<$Res> {
  __$DeliveryOrderItemCopyWithImpl(this._self, this._then);

  final _DeliveryOrderItem _self;
  final $Res Function(_DeliveryOrderItem) _then;

/// Create a copy of DeliveryOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = freezed,Object? productName = freezed,Object? productCode = freezed,Object? quantity = freezed,Object? unit = freezed,Object? unitPrice = freezed,Object? subtotal = freezed,Object? stockBatch = freezed,Object? notes = freezed,}) {
  return _then(_DeliveryOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productCode: freezed == productCode ? _self.productCode : productCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,stockBatch: freezed == stockBatch ? _self.stockBatch : stockBatch // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
