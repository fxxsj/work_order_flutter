// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesOrderDetail {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'order_number', fromJson: _stringFromJson) String get orderNumber;@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? get customerId;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson) String? get customerContact;@JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson) String? get customerPhone;@JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson) String? get customerAddress;@JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson) String? get contractNumber;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? get approvalStatus;@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? get approvalStatusDisplay;@JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson) String? get approvalComment;@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) String? get rejectionReason;@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) String? get paymentStatus;@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) String? get paymentStatusDisplay;@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? get orderDate;@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? get deliveryDate;@JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? get actualDeliveryDate;@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? get subtotal;@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? get taxRate;@JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson) double? get taxAmount;@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) double? get discountAmount;@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? get totalAmount;@JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson) double? get depositAmount;@JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson) double? get paidAmount;@JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson) DateTime? get paymentDate;@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) String? get contactPerson;@JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson) String? get contactPhone;@JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson) String? get shippingAddress;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;@JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson) int? get paymentCount;@JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson) int? get pendingPaymentPlanCount;@JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson) double? get pendingPaymentPlanAmount;@JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson) double? get unpaidAmount;@JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson) List<String> get workOrderNumbers;@JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson) List<String> get deliveryOrderNumbers;@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> get invoiceNumbers;@JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> get workOrderSummaries;@JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> get deliveryOrderSummaries;@JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> get invoiceSummaries;@JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson) List<SalesOrderItem> get items;
/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderDetailCopyWith<SalesOrderDetail> get copyWith => _$SalesOrderDetailCopyWithImpl<SalesOrderDetail>(this as SalesOrderDetail, _$identity);

  /// Serializes this SalesOrderDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerContact, customerContact) || other.customerContact == customerContact)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerAddress, customerAddress) || other.customerAddress == customerAddress)&&(identical(other.contractNumber, contractNumber) || other.contractNumber == contractNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvalStatusDisplay, approvalStatusDisplay) || other.approvalStatusDisplay == approvalStatusDisplay)&&(identical(other.approvalComment, approvalComment) || other.approvalComment == approvalComment)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentStatusDisplay, paymentStatusDisplay) || other.paymentStatusDisplay == paymentStatusDisplay)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.actualDeliveryDate, actualDeliveryDate) || other.actualDeliveryDate == actualDeliveryDate)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.depositAmount, depositAmount) || other.depositAmount == depositAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentCount, paymentCount) || other.paymentCount == paymentCount)&&(identical(other.pendingPaymentPlanCount, pendingPaymentPlanCount) || other.pendingPaymentPlanCount == pendingPaymentPlanCount)&&(identical(other.pendingPaymentPlanAmount, pendingPaymentPlanAmount) || other.pendingPaymentPlanAmount == pendingPaymentPlanAmount)&&(identical(other.unpaidAmount, unpaidAmount) || other.unpaidAmount == unpaidAmount)&&const DeepCollectionEquality().equals(other.workOrderNumbers, workOrderNumbers)&&const DeepCollectionEquality().equals(other.deliveryOrderNumbers, deliveryOrderNumbers)&&const DeepCollectionEquality().equals(other.invoiceNumbers, invoiceNumbers)&&const DeepCollectionEquality().equals(other.workOrderSummaries, workOrderSummaries)&&const DeepCollectionEquality().equals(other.deliveryOrderSummaries, deliveryOrderSummaries)&&const DeepCollectionEquality().equals(other.invoiceSummaries, invoiceSummaries)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,customerId,customerName,customerContact,customerPhone,customerAddress,contractNumber,status,statusDisplay,approvalStatus,approvalStatusDisplay,approvalComment,rejectionReason,paymentStatus,paymentStatusDisplay,orderDate,deliveryDate,actualDeliveryDate,subtotal,taxRate,taxAmount,discountAmount,totalAmount,depositAmount,paidAmount,paymentDate,contactPerson,contactPhone,shippingAddress,notes,paymentCount,pendingPaymentPlanCount,pendingPaymentPlanAmount,unpaidAmount,const DeepCollectionEquality().hash(workOrderNumbers),const DeepCollectionEquality().hash(deliveryOrderNumbers),const DeepCollectionEquality().hash(invoiceNumbers),const DeepCollectionEquality().hash(workOrderSummaries),const DeepCollectionEquality().hash(deliveryOrderSummaries),const DeepCollectionEquality().hash(invoiceSummaries),const DeepCollectionEquality().hash(items)]);

@override
String toString() {
  return 'SalesOrderDetail(id: $id, orderNumber: $orderNumber, customerId: $customerId, customerName: $customerName, customerContact: $customerContact, customerPhone: $customerPhone, customerAddress: $customerAddress, contractNumber: $contractNumber, status: $status, statusDisplay: $statusDisplay, approvalStatus: $approvalStatus, approvalStatusDisplay: $approvalStatusDisplay, approvalComment: $approvalComment, rejectionReason: $rejectionReason, paymentStatus: $paymentStatus, paymentStatusDisplay: $paymentStatusDisplay, orderDate: $orderDate, deliveryDate: $deliveryDate, actualDeliveryDate: $actualDeliveryDate, subtotal: $subtotal, taxRate: $taxRate, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, depositAmount: $depositAmount, paidAmount: $paidAmount, paymentDate: $paymentDate, contactPerson: $contactPerson, contactPhone: $contactPhone, shippingAddress: $shippingAddress, notes: $notes, paymentCount: $paymentCount, pendingPaymentPlanCount: $pendingPaymentPlanCount, pendingPaymentPlanAmount: $pendingPaymentPlanAmount, unpaidAmount: $unpaidAmount, workOrderNumbers: $workOrderNumbers, deliveryOrderNumbers: $deliveryOrderNumbers, invoiceNumbers: $invoiceNumbers, workOrderSummaries: $workOrderSummaries, deliveryOrderSummaries: $deliveryOrderSummaries, invoiceSummaries: $invoiceSummaries, items: $items)';
}


}

/// @nodoc
abstract mixin class $SalesOrderDetailCopyWith<$Res>  {
  factory $SalesOrderDetailCopyWith(SalesOrderDetail value, $Res Function(SalesOrderDetail) _then) = _$SalesOrderDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson) String? customerContact,@JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson) String? customerPhone,@JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson) String? customerAddress,@JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson) String? contractNumber,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? approvalStatus,@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? approvalStatusDisplay,@JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson) String? approvalComment,@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) String? rejectionReason,@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) String? paymentStatus,@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) String? paymentStatusDisplay,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? actualDeliveryDate,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? taxRate,@JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson) double? taxAmount,@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) double? discountAmount,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson) double? depositAmount,@JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson) double? paidAmount,@JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson) DateTime? paymentDate,@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) String? contactPerson,@JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson) String? contactPhone,@JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson) String? shippingAddress,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson) int? paymentCount,@JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson) int? pendingPaymentPlanCount,@JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson) double? pendingPaymentPlanAmount,@JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson) double? unpaidAmount,@JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson) List<String> workOrderNumbers,@JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson) List<String> deliveryOrderNumbers,@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> invoiceNumbers,@JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> workOrderSummaries,@JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> deliveryOrderSummaries,@JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> invoiceSummaries,@JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson) List<SalesOrderItem> items
});




}
/// @nodoc
class _$SalesOrderDetailCopyWithImpl<$Res>
    implements $SalesOrderDetailCopyWith<$Res> {
  _$SalesOrderDetailCopyWithImpl(this._self, this._then);

  final SalesOrderDetail _self;
  final $Res Function(SalesOrderDetail) _then;

/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = freezed,Object? customerName = freezed,Object? customerContact = freezed,Object? customerPhone = freezed,Object? customerAddress = freezed,Object? contractNumber = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? approvalStatus = freezed,Object? approvalStatusDisplay = freezed,Object? approvalComment = freezed,Object? rejectionReason = freezed,Object? paymentStatus = freezed,Object? paymentStatusDisplay = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? actualDeliveryDate = freezed,Object? subtotal = freezed,Object? taxRate = freezed,Object? taxAmount = freezed,Object? discountAmount = freezed,Object? totalAmount = freezed,Object? depositAmount = freezed,Object? paidAmount = freezed,Object? paymentDate = freezed,Object? contactPerson = freezed,Object? contactPhone = freezed,Object? shippingAddress = freezed,Object? notes = freezed,Object? paymentCount = freezed,Object? pendingPaymentPlanCount = freezed,Object? pendingPaymentPlanAmount = freezed,Object? unpaidAmount = freezed,Object? workOrderNumbers = null,Object? deliveryOrderNumbers = null,Object? invoiceNumbers = null,Object? workOrderSummaries = null,Object? deliveryOrderSummaries = null,Object? invoiceSummaries = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerContact: freezed == customerContact ? _self.customerContact : customerContact // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,customerAddress: freezed == customerAddress ? _self.customerAddress : customerAddress // ignore: cast_nullable_to_non_nullable
as String?,contractNumber: freezed == contractNumber ? _self.contractNumber : contractNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,approvalStatusDisplay: freezed == approvalStatusDisplay ? _self.approvalStatusDisplay : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,approvalComment: freezed == approvalComment ? _self.approvalComment : approvalComment // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentStatusDisplay: freezed == paymentStatusDisplay ? _self.paymentStatusDisplay : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,actualDeliveryDate: freezed == actualDeliveryDate ? _self.actualDeliveryDate : actualDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double?,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,depositAmount: freezed == depositAmount ? _self.depositAmount : depositAmount // ignore: cast_nullable_to_non_nullable
as double?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double?,paymentDate: freezed == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paymentCount: freezed == paymentCount ? _self.paymentCount : paymentCount // ignore: cast_nullable_to_non_nullable
as int?,pendingPaymentPlanCount: freezed == pendingPaymentPlanCount ? _self.pendingPaymentPlanCount : pendingPaymentPlanCount // ignore: cast_nullable_to_non_nullable
as int?,pendingPaymentPlanAmount: freezed == pendingPaymentPlanAmount ? _self.pendingPaymentPlanAmount : pendingPaymentPlanAmount // ignore: cast_nullable_to_non_nullable
as double?,unpaidAmount: freezed == unpaidAmount ? _self.unpaidAmount : unpaidAmount // ignore: cast_nullable_to_non_nullable
as double?,workOrderNumbers: null == workOrderNumbers ? _self.workOrderNumbers : workOrderNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,deliveryOrderNumbers: null == deliveryOrderNumbers ? _self.deliveryOrderNumbers : deliveryOrderNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,invoiceNumbers: null == invoiceNumbers ? _self.invoiceNumbers : invoiceNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,workOrderSummaries: null == workOrderSummaries ? _self.workOrderSummaries : workOrderSummaries // ignore: cast_nullable_to_non_nullable
as List<TraceabilitySummaryItem>,deliveryOrderSummaries: null == deliveryOrderSummaries ? _self.deliveryOrderSummaries : deliveryOrderSummaries // ignore: cast_nullable_to_non_nullable
as List<TraceabilitySummaryItem>,invoiceSummaries: null == invoiceSummaries ? _self.invoiceSummaries : invoiceSummaries // ignore: cast_nullable_to_non_nullable
as List<TraceabilitySummaryItem>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrderDetail].
extension SalesOrderDetailPatterns on SalesOrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)  String? customerContact, @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)  String? customerPhone, @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)  String? customerAddress, @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)  String? contractNumber, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)  String? approvalComment, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)  String? rejectionReason, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)  String? paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)  String? paymentStatusDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? actualDeliveryDate, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)  double? taxRate, @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)  double? taxAmount, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)  double? discountAmount, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)  double? depositAmount, @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)  double? paidAmount, @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)  DateTime? paymentDate, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)  String? contactPhone, @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)  String? shippingAddress, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)  int? paymentCount, @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)  int? pendingPaymentPlanCount, @JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)  double? pendingPaymentPlanAmount, @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)  double? unpaidAmount, @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)  List<String> workOrderNumbers, @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)  List<String> deliveryOrderNumbers, @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)  List<String> invoiceNumbers, @JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> workOrderSummaries, @JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> deliveryOrderSummaries, @JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> invoiceSummaries, @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)  List<SalesOrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customerName,_that.customerContact,_that.customerPhone,_that.customerAddress,_that.contractNumber,_that.status,_that.statusDisplay,_that.approvalStatus,_that.approvalStatusDisplay,_that.approvalComment,_that.rejectionReason,_that.paymentStatus,_that.paymentStatusDisplay,_that.orderDate,_that.deliveryDate,_that.actualDeliveryDate,_that.subtotal,_that.taxRate,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.depositAmount,_that.paidAmount,_that.paymentDate,_that.contactPerson,_that.contactPhone,_that.shippingAddress,_that.notes,_that.paymentCount,_that.pendingPaymentPlanCount,_that.pendingPaymentPlanAmount,_that.unpaidAmount,_that.workOrderNumbers,_that.deliveryOrderNumbers,_that.invoiceNumbers,_that.workOrderSummaries,_that.deliveryOrderSummaries,_that.invoiceSummaries,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)  String? customerContact, @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)  String? customerPhone, @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)  String? customerAddress, @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)  String? contractNumber, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)  String? approvalComment, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)  String? rejectionReason, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)  String? paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)  String? paymentStatusDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? actualDeliveryDate, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)  double? taxRate, @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)  double? taxAmount, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)  double? discountAmount, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)  double? depositAmount, @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)  double? paidAmount, @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)  DateTime? paymentDate, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)  String? contactPhone, @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)  String? shippingAddress, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)  int? paymentCount, @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)  int? pendingPaymentPlanCount, @JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)  double? pendingPaymentPlanAmount, @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)  double? unpaidAmount, @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)  List<String> workOrderNumbers, @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)  List<String> deliveryOrderNumbers, @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)  List<String> invoiceNumbers, @JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> workOrderSummaries, @JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> deliveryOrderSummaries, @JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> invoiceSummaries, @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)  List<SalesOrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderDetail():
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customerName,_that.customerContact,_that.customerPhone,_that.customerAddress,_that.contractNumber,_that.status,_that.statusDisplay,_that.approvalStatus,_that.approvalStatusDisplay,_that.approvalComment,_that.rejectionReason,_that.paymentStatus,_that.paymentStatusDisplay,_that.orderDate,_that.deliveryDate,_that.actualDeliveryDate,_that.subtotal,_that.taxRate,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.depositAmount,_that.paidAmount,_that.paymentDate,_that.contactPerson,_that.contactPhone,_that.shippingAddress,_that.notes,_that.paymentCount,_that.pendingPaymentPlanCount,_that.pendingPaymentPlanAmount,_that.unpaidAmount,_that.workOrderNumbers,_that.deliveryOrderNumbers,_that.invoiceNumbers,_that.workOrderSummaries,_that.deliveryOrderSummaries,_that.invoiceSummaries,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)  int? customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)  String? customerContact, @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)  String? customerPhone, @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)  String? customerAddress, @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)  String? contractNumber, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)  String? approvalComment, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)  String? rejectionReason, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)  String? paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)  String? paymentStatusDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate, @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)  DateTime? actualDeliveryDate, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)  double? taxRate, @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)  double? taxAmount, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)  double? discountAmount, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)  double? depositAmount, @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)  double? paidAmount, @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)  DateTime? paymentDate, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)  String? contactPhone, @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)  String? shippingAddress, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)  int? paymentCount, @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)  int? pendingPaymentPlanCount, @JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)  double? pendingPaymentPlanAmount, @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)  double? unpaidAmount, @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)  List<String> workOrderNumbers, @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)  List<String> deliveryOrderNumbers, @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)  List<String> invoiceNumbers, @JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> workOrderSummaries, @JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> deliveryOrderSummaries, @JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson)  List<TraceabilitySummaryItem> invoiceSummaries, @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)  List<SalesOrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.customerId,_that.customerName,_that.customerContact,_that.customerPhone,_that.customerAddress,_that.contractNumber,_that.status,_that.statusDisplay,_that.approvalStatus,_that.approvalStatusDisplay,_that.approvalComment,_that.rejectionReason,_that.paymentStatus,_that.paymentStatusDisplay,_that.orderDate,_that.deliveryDate,_that.actualDeliveryDate,_that.subtotal,_that.taxRate,_that.taxAmount,_that.discountAmount,_that.totalAmount,_that.depositAmount,_that.paidAmount,_that.paymentDate,_that.contactPerson,_that.contactPhone,_that.shippingAddress,_that.notes,_that.paymentCount,_that.pendingPaymentPlanCount,_that.pendingPaymentPlanAmount,_that.unpaidAmount,_that.workOrderNumbers,_that.deliveryOrderNumbers,_that.invoiceNumbers,_that.workOrderSummaries,_that.deliveryOrderSummaries,_that.invoiceSummaries,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrderDetail implements SalesOrderDetail {
  const _SalesOrderDetail({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'order_number', fromJson: _stringFromJson) required this.orderNumber, @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) this.customerId, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson) this.customerContact, @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson) this.customerPhone, @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson) this.customerAddress, @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson) this.contractNumber, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) this.approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) this.approvalStatusDisplay, @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson) this.approvalComment, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) this.rejectionReason, @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) this.paymentStatus, @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) this.paymentStatusDisplay, @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) this.orderDate, @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) this.deliveryDate, @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson) this.actualDeliveryDate, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) this.taxRate, @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson) this.taxAmount, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) this.discountAmount, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) this.totalAmount, @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson) this.depositAmount, @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson) this.paidAmount, @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson) this.paymentDate, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) this.contactPerson, @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson) this.contactPhone, @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson) this.shippingAddress, @JsonKey(fromJson: _stringOrNullFromJson) this.notes, @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson) this.paymentCount, @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson) this.pendingPaymentPlanCount, @JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson) this.pendingPaymentPlanAmount, @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson) this.unpaidAmount, @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson) final  List<String> workOrderNumbers = const <String>[], @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson) final  List<String> deliveryOrderNumbers = const <String>[], @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) final  List<String> invoiceNumbers = const <String>[], @JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) final  List<TraceabilitySummaryItem> workOrderSummaries = const <TraceabilitySummaryItem>[], @JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) final  List<TraceabilitySummaryItem> deliveryOrderSummaries = const <TraceabilitySummaryItem>[], @JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) final  List<TraceabilitySummaryItem> invoiceSummaries = const <TraceabilitySummaryItem>[], @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson) final  List<SalesOrderItem> items = const <SalesOrderItem>[]}): _workOrderNumbers = workOrderNumbers,_deliveryOrderNumbers = deliveryOrderNumbers,_invoiceNumbers = invoiceNumbers,_workOrderSummaries = workOrderSummaries,_deliveryOrderSummaries = deliveryOrderSummaries,_invoiceSummaries = invoiceSummaries,_items = items;
  factory _SalesOrderDetail.fromJson(Map<String, dynamic> json) => _$SalesOrderDetailFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'order_number', fromJson: _stringFromJson) final  String orderNumber;
@override@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) final  int? customerId;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson) final  String? customerContact;
@override@JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson) final  String? customerPhone;
@override@JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson) final  String? customerAddress;
@override@JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson) final  String? contractNumber;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) final  String? approvalStatus;
@override@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) final  String? approvalStatusDisplay;
@override@JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson) final  String? approvalComment;
@override@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) final  String? rejectionReason;
@override@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) final  String? paymentStatus;
@override@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) final  String? paymentStatusDisplay;
@override@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? orderDate;
@override@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? deliveryDate;
@override@JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? actualDeliveryDate;
@override@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) final  double? subtotal;
@override@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) final  double? taxRate;
@override@JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson) final  double? taxAmount;
@override@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) final  double? discountAmount;
@override@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) final  double? totalAmount;
@override@JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson) final  double? depositAmount;
@override@JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson) final  double? paidAmount;
@override@JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? paymentDate;
@override@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) final  String? contactPerson;
@override@JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson) final  String? contactPhone;
@override@JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson) final  String? shippingAddress;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;
@override@JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson) final  int? paymentCount;
@override@JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson) final  int? pendingPaymentPlanCount;
@override@JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson) final  double? pendingPaymentPlanAmount;
@override@JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson) final  double? unpaidAmount;
 final  List<String> _workOrderNumbers;
@override@JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson) List<String> get workOrderNumbers {
  if (_workOrderNumbers is EqualUnmodifiableListView) return _workOrderNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workOrderNumbers);
}

 final  List<String> _deliveryOrderNumbers;
@override@JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson) List<String> get deliveryOrderNumbers {
  if (_deliveryOrderNumbers is EqualUnmodifiableListView) return _deliveryOrderNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deliveryOrderNumbers);
}

 final  List<String> _invoiceNumbers;
@override@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> get invoiceNumbers {
  if (_invoiceNumbers is EqualUnmodifiableListView) return _invoiceNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoiceNumbers);
}

 final  List<TraceabilitySummaryItem> _workOrderSummaries;
@override@JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> get workOrderSummaries {
  if (_workOrderSummaries is EqualUnmodifiableListView) return _workOrderSummaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workOrderSummaries);
}

 final  List<TraceabilitySummaryItem> _deliveryOrderSummaries;
@override@JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> get deliveryOrderSummaries {
  if (_deliveryOrderSummaries is EqualUnmodifiableListView) return _deliveryOrderSummaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deliveryOrderSummaries);
}

 final  List<TraceabilitySummaryItem> _invoiceSummaries;
@override@JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> get invoiceSummaries {
  if (_invoiceSummaries is EqualUnmodifiableListView) return _invoiceSummaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoiceSummaries);
}

 final  List<SalesOrderItem> _items;
@override@JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson) List<SalesOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderDetailCopyWith<_SalesOrderDetail> get copyWith => __$SalesOrderDetailCopyWithImpl<_SalesOrderDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerContact, customerContact) || other.customerContact == customerContact)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerAddress, customerAddress) || other.customerAddress == customerAddress)&&(identical(other.contractNumber, contractNumber) || other.contractNumber == contractNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvalStatusDisplay, approvalStatusDisplay) || other.approvalStatusDisplay == approvalStatusDisplay)&&(identical(other.approvalComment, approvalComment) || other.approvalComment == approvalComment)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentStatusDisplay, paymentStatusDisplay) || other.paymentStatusDisplay == paymentStatusDisplay)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.actualDeliveryDate, actualDeliveryDate) || other.actualDeliveryDate == actualDeliveryDate)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.depositAmount, depositAmount) || other.depositAmount == depositAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentCount, paymentCount) || other.paymentCount == paymentCount)&&(identical(other.pendingPaymentPlanCount, pendingPaymentPlanCount) || other.pendingPaymentPlanCount == pendingPaymentPlanCount)&&(identical(other.pendingPaymentPlanAmount, pendingPaymentPlanAmount) || other.pendingPaymentPlanAmount == pendingPaymentPlanAmount)&&(identical(other.unpaidAmount, unpaidAmount) || other.unpaidAmount == unpaidAmount)&&const DeepCollectionEquality().equals(other._workOrderNumbers, _workOrderNumbers)&&const DeepCollectionEquality().equals(other._deliveryOrderNumbers, _deliveryOrderNumbers)&&const DeepCollectionEquality().equals(other._invoiceNumbers, _invoiceNumbers)&&const DeepCollectionEquality().equals(other._workOrderSummaries, _workOrderSummaries)&&const DeepCollectionEquality().equals(other._deliveryOrderSummaries, _deliveryOrderSummaries)&&const DeepCollectionEquality().equals(other._invoiceSummaries, _invoiceSummaries)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,customerId,customerName,customerContact,customerPhone,customerAddress,contractNumber,status,statusDisplay,approvalStatus,approvalStatusDisplay,approvalComment,rejectionReason,paymentStatus,paymentStatusDisplay,orderDate,deliveryDate,actualDeliveryDate,subtotal,taxRate,taxAmount,discountAmount,totalAmount,depositAmount,paidAmount,paymentDate,contactPerson,contactPhone,shippingAddress,notes,paymentCount,pendingPaymentPlanCount,pendingPaymentPlanAmount,unpaidAmount,const DeepCollectionEquality().hash(_workOrderNumbers),const DeepCollectionEquality().hash(_deliveryOrderNumbers),const DeepCollectionEquality().hash(_invoiceNumbers),const DeepCollectionEquality().hash(_workOrderSummaries),const DeepCollectionEquality().hash(_deliveryOrderSummaries),const DeepCollectionEquality().hash(_invoiceSummaries),const DeepCollectionEquality().hash(_items)]);

@override
String toString() {
  return 'SalesOrderDetail(id: $id, orderNumber: $orderNumber, customerId: $customerId, customerName: $customerName, customerContact: $customerContact, customerPhone: $customerPhone, customerAddress: $customerAddress, contractNumber: $contractNumber, status: $status, statusDisplay: $statusDisplay, approvalStatus: $approvalStatus, approvalStatusDisplay: $approvalStatusDisplay, approvalComment: $approvalComment, rejectionReason: $rejectionReason, paymentStatus: $paymentStatus, paymentStatusDisplay: $paymentStatusDisplay, orderDate: $orderDate, deliveryDate: $deliveryDate, actualDeliveryDate: $actualDeliveryDate, subtotal: $subtotal, taxRate: $taxRate, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, depositAmount: $depositAmount, paidAmount: $paidAmount, paymentDate: $paymentDate, contactPerson: $contactPerson, contactPhone: $contactPhone, shippingAddress: $shippingAddress, notes: $notes, paymentCount: $paymentCount, pendingPaymentPlanCount: $pendingPaymentPlanCount, pendingPaymentPlanAmount: $pendingPaymentPlanAmount, unpaidAmount: $unpaidAmount, workOrderNumbers: $workOrderNumbers, deliveryOrderNumbers: $deliveryOrderNumbers, invoiceNumbers: $invoiceNumbers, workOrderSummaries: $workOrderSummaries, deliveryOrderSummaries: $deliveryOrderSummaries, invoiceSummaries: $invoiceSummaries, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderDetailCopyWith<$Res> implements $SalesOrderDetailCopyWith<$Res> {
  factory _$SalesOrderDetailCopyWith(_SalesOrderDetail value, $Res Function(_SalesOrderDetail) _then) = __$SalesOrderDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson) String? customerContact,@JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson) String? customerPhone,@JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson) String? customerAddress,@JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson) String? contractNumber,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? approvalStatus,@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? approvalStatusDisplay,@JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson) String? approvalComment,@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) String? rejectionReason,@JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson) String? paymentStatus,@JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson) String? paymentStatusDisplay,@JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderDate,@JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate,@JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson) DateTime? actualDeliveryDate,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? taxRate,@JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson) double? taxAmount,@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) double? discountAmount,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson) double? depositAmount,@JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson) double? paidAmount,@JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson) DateTime? paymentDate,@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) String? contactPerson,@JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson) String? contactPhone,@JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson) String? shippingAddress,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson) int? paymentCount,@JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson) int? pendingPaymentPlanCount,@JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson) double? pendingPaymentPlanAmount,@JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson) double? unpaidAmount,@JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson) List<String> workOrderNumbers,@JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson) List<String> deliveryOrderNumbers,@JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson) List<String> invoiceNumbers,@JsonKey(name: 'work_order_summaries', readValue: _readWorkOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> workOrderSummaries,@JsonKey(name: 'delivery_order_summaries', readValue: _readDeliveryOrderSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> deliveryOrderSummaries,@JsonKey(name: 'invoice_summaries', readValue: _readInvoiceSummaries, fromJson: _traceabilitySummaryListFromJson, toJson: _traceabilitySummaryListToJson) List<TraceabilitySummaryItem> invoiceSummaries,@JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson) List<SalesOrderItem> items
});




}
/// @nodoc
class __$SalesOrderDetailCopyWithImpl<$Res>
    implements _$SalesOrderDetailCopyWith<$Res> {
  __$SalesOrderDetailCopyWithImpl(this._self, this._then);

  final _SalesOrderDetail _self;
  final $Res Function(_SalesOrderDetail) _then;

/// Create a copy of SalesOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? customerId = freezed,Object? customerName = freezed,Object? customerContact = freezed,Object? customerPhone = freezed,Object? customerAddress = freezed,Object? contractNumber = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? approvalStatus = freezed,Object? approvalStatusDisplay = freezed,Object? approvalComment = freezed,Object? rejectionReason = freezed,Object? paymentStatus = freezed,Object? paymentStatusDisplay = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? actualDeliveryDate = freezed,Object? subtotal = freezed,Object? taxRate = freezed,Object? taxAmount = freezed,Object? discountAmount = freezed,Object? totalAmount = freezed,Object? depositAmount = freezed,Object? paidAmount = freezed,Object? paymentDate = freezed,Object? contactPerson = freezed,Object? contactPhone = freezed,Object? shippingAddress = freezed,Object? notes = freezed,Object? paymentCount = freezed,Object? pendingPaymentPlanCount = freezed,Object? pendingPaymentPlanAmount = freezed,Object? unpaidAmount = freezed,Object? workOrderNumbers = null,Object? deliveryOrderNumbers = null,Object? invoiceNumbers = null,Object? workOrderSummaries = null,Object? deliveryOrderSummaries = null,Object? invoiceSummaries = null,Object? items = null,}) {
  return _then(_SalesOrderDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerContact: freezed == customerContact ? _self.customerContact : customerContact // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,customerAddress: freezed == customerAddress ? _self.customerAddress : customerAddress // ignore: cast_nullable_to_non_nullable
as String?,contractNumber: freezed == contractNumber ? _self.contractNumber : contractNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,approvalStatusDisplay: freezed == approvalStatusDisplay ? _self.approvalStatusDisplay : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,approvalComment: freezed == approvalComment ? _self.approvalComment : approvalComment // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentStatusDisplay: freezed == paymentStatusDisplay ? _self.paymentStatusDisplay : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,actualDeliveryDate: freezed == actualDeliveryDate ? _self.actualDeliveryDate : actualDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double?,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,depositAmount: freezed == depositAmount ? _self.depositAmount : depositAmount // ignore: cast_nullable_to_non_nullable
as double?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double?,paymentDate: freezed == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paymentCount: freezed == paymentCount ? _self.paymentCount : paymentCount // ignore: cast_nullable_to_non_nullable
as int?,pendingPaymentPlanCount: freezed == pendingPaymentPlanCount ? _self.pendingPaymentPlanCount : pendingPaymentPlanCount // ignore: cast_nullable_to_non_nullable
as int?,pendingPaymentPlanAmount: freezed == pendingPaymentPlanAmount ? _self.pendingPaymentPlanAmount : pendingPaymentPlanAmount // ignore: cast_nullable_to_non_nullable
as double?,unpaidAmount: freezed == unpaidAmount ? _self.unpaidAmount : unpaidAmount // ignore: cast_nullable_to_non_nullable
as double?,workOrderNumbers: null == workOrderNumbers ? _self._workOrderNumbers : workOrderNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,deliveryOrderNumbers: null == deliveryOrderNumbers ? _self._deliveryOrderNumbers : deliveryOrderNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,invoiceNumbers: null == invoiceNumbers ? _self._invoiceNumbers : invoiceNumbers // ignore: cast_nullable_to_non_nullable
as List<String>,workOrderSummaries: null == workOrderSummaries ? _self._workOrderSummaries : workOrderSummaries // ignore: cast_nullable_to_non_nullable
as List<TraceabilitySummaryItem>,deliveryOrderSummaries: null == deliveryOrderSummaries ? _self._deliveryOrderSummaries : deliveryOrderSummaries // ignore: cast_nullable_to_non_nullable
as List<TraceabilitySummaryItem>,invoiceSummaries: null == invoiceSummaries ? _self._invoiceSummaries : invoiceSummaries // ignore: cast_nullable_to_non_nullable
as List<TraceabilitySummaryItem>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SalesOrderItem>,
  ));
}


}


/// @nodoc
mixin _$SalesOrderItem {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? get productId;@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? get productName;@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? get productCode;@JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) int? get quantity;@JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson) double? get deliveredQuantity;@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? get unit;@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? get unitPrice;@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? get taxRate;@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) double? get discountAmount;@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? get subtotal;@JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) String? get notes;
/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderItemCopyWith<SalesOrderItem> get copyWith => _$SalesOrderItemCopyWithImpl<SalesOrderItem>(this as SalesOrderItem, _$identity);

  /// Serializes this SalesOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productCode, productCode) || other.productCode == productCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.deliveredQuantity, deliveredQuantity) || other.deliveredQuantity == deliveredQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,productCode,quantity,deliveredQuantity,unit,unitPrice,taxRate,discountAmount,subtotal,notes);

@override
String toString() {
  return 'SalesOrderItem(id: $id, productId: $productId, productName: $productName, productCode: $productCode, quantity: $quantity, deliveredQuantity: $deliveredQuantity, unit: $unit, unitPrice: $unitPrice, taxRate: $taxRate, discountAmount: $discountAmount, subtotal: $subtotal, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $SalesOrderItemCopyWith<$Res>  {
  factory $SalesOrderItemCopyWith(SalesOrderItem value, $Res Function(SalesOrderItem) _then) = _$SalesOrderItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? productCode,@JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) int? quantity,@JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson) double? deliveredQuantity,@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? taxRate,@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) double? discountAmount,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class _$SalesOrderItemCopyWithImpl<$Res>
    implements $SalesOrderItemCopyWith<$Res> {
  _$SalesOrderItemCopyWithImpl(this._self, this._then);

  final SalesOrderItem _self;
  final $Res Function(SalesOrderItem) _then;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = freezed,Object? productName = freezed,Object? productCode = freezed,Object? quantity = freezed,Object? deliveredQuantity = freezed,Object? unit = freezed,Object? unitPrice = freezed,Object? taxRate = freezed,Object? discountAmount = freezed,Object? subtotal = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productCode: freezed == productCode ? _self.productCode : productCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,deliveredQuantity: freezed == deliveredQuantity ? _self.deliveredQuantity : deliveredQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrderItem].
extension SalesOrderItemPatterns on SalesOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson)  int? productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson)  int? quantity, @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)  double? deliveredQuantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)  double? taxRate, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)  double? discountAmount, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson)  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.productCode,_that.quantity,_that.deliveredQuantity,_that.unit,_that.unitPrice,_that.taxRate,_that.discountAmount,_that.subtotal,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson)  int? productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson)  int? quantity, @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)  double? deliveredQuantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)  double? taxRate, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)  double? discountAmount, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson)  String? notes)  $default,) {final _that = this;
switch (_that) {
case _SalesOrderItem():
return $default(_that.id,_that.productId,_that.productName,_that.productCode,_that.quantity,_that.deliveredQuantity,_that.unit,_that.unitPrice,_that.taxRate,_that.discountAmount,_that.subtotal,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson)  int? productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)  String? productCode, @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson)  int? quantity, @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)  double? deliveredQuantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)  String? unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)  double? taxRate, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)  double? discountAmount, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson)  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrderItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.productCode,_that.quantity,_that.deliveredQuantity,_that.unit,_that.unitPrice,_that.taxRate,_that.discountAmount,_that.subtotal,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrderItem implements SalesOrderItem {
  const _SalesOrderItem({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'product', fromJson: _intOrNullFromJson) this.productId, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) this.productName, @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) this.productCode, @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) this.quantity, @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson) this.deliveredQuantity, @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) this.unit, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) this.unitPrice, @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) this.taxRate, @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) this.discountAmount, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal, @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) this.notes});
  factory _SalesOrderItem.fromJson(Map<String, dynamic> json) => _$SalesOrderItemFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'product', fromJson: _intOrNullFromJson) final  int? productId;
@override@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) final  String? productName;
@override@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) final  String? productCode;
@override@JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) final  int? quantity;
@override@JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson) final  double? deliveredQuantity;
@override@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) final  String? unit;
@override@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) final  double? unitPrice;
@override@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) final  double? taxRate;
@override@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) final  double? discountAmount;
@override@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) final  double? subtotal;
@override@JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) final  String? notes;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderItemCopyWith<_SalesOrderItem> get copyWith => __$SalesOrderItemCopyWithImpl<_SalesOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productCode, productCode) || other.productCode == productCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.deliveredQuantity, deliveredQuantity) || other.deliveredQuantity == deliveredQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,productCode,quantity,deliveredQuantity,unit,unitPrice,taxRate,discountAmount,subtotal,notes);

@override
String toString() {
  return 'SalesOrderItem(id: $id, productId: $productId, productName: $productName, productCode: $productCode, quantity: $quantity, deliveredQuantity: $deliveredQuantity, unit: $unit, unitPrice: $unitPrice, taxRate: $taxRate, discountAmount: $discountAmount, subtotal: $subtotal, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderItemCopyWith<$Res> implements $SalesOrderItemCopyWith<$Res> {
  factory _$SalesOrderItemCopyWith(_SalesOrderItem value, $Res Function(_SalesOrderItem) _then) = __$SalesOrderItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson) String? productCode,@JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) int? quantity,@JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson) double? deliveredQuantity,@JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? taxRate,@JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson) double? discountAmount,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class __$SalesOrderItemCopyWithImpl<$Res>
    implements _$SalesOrderItemCopyWith<$Res> {
  __$SalesOrderItemCopyWithImpl(this._self, this._then);

  final _SalesOrderItem _self;
  final $Res Function(_SalesOrderItem) _then;

/// Create a copy of SalesOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = freezed,Object? productName = freezed,Object? productCode = freezed,Object? quantity = freezed,Object? deliveredQuantity = freezed,Object? unit = freezed,Object? unitPrice = freezed,Object? taxRate = freezed,Object? discountAmount = freezed,Object? subtotal = freezed,Object? notes = freezed,}) {
  return _then(_SalesOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productCode: freezed == productCode ? _self.productCode : productCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,deliveredQuantity: freezed == deliveredQuantity ? _self.deliveredQuantity : deliveredQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,taxRate: freezed == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
