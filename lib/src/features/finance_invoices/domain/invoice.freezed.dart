// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Invoice {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson) String? get invoiceNumber;@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? get salesOrderId;@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? get salesOrderNumber;@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? get workOrderId;@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson) String? get invoiceType;@JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson) String? get invoiceTypeDisplay;@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) double? get amount;@JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson) double? get paymentReceivedAmount;@JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson) double? get paymentRemainingAmount;@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) String? get attachmentUrl;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? get followUpText;@JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson) DateTime? get issueDate;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.invoiceType, invoiceType) || other.invoiceType == invoiceType)&&(identical(other.invoiceTypeDisplay, invoiceTypeDisplay) || other.invoiceTypeDisplay == invoiceTypeDisplay)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentReceivedAmount, paymentReceivedAmount) || other.paymentReceivedAmount == paymentReceivedAmount)&&(identical(other.paymentRemainingAmount, paymentRemainingAmount) || other.paymentRemainingAmount == paymentRemainingAmount)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.followUpText, followUpText) || other.followUpText == followUpText)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceNumber,salesOrderId,salesOrderNumber,workOrderId,workOrderNumber,customerName,invoiceType,invoiceTypeDisplay,amount,paymentReceivedAmount,paymentRemainingAmount,attachmentUrl,status,statusDisplay,followUpText,issueDate);

@override
String toString() {
  return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, customerName: $customerName, invoiceType: $invoiceType, invoiceTypeDisplay: $invoiceTypeDisplay, amount: $amount, paymentReceivedAmount: $paymentReceivedAmount, paymentRemainingAmount: $paymentRemainingAmount, attachmentUrl: $attachmentUrl, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, issueDate: $issueDate)';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson) String? invoiceNumber,@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson) String? invoiceType,@JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson) String? invoiceTypeDisplay,@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) double? amount,@JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson) double? paymentReceivedAmount,@JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson) double? paymentRemainingAmount,@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) String? attachmentUrl,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? followUpText,@JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson) DateTime? issueDate
});




}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? invoiceNumber = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? workOrderId = freezed,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? invoiceType = freezed,Object? invoiceTypeDisplay = freezed,Object? amount = freezed,Object? paymentReceivedAmount = freezed,Object? paymentRemainingAmount = freezed,Object? attachmentUrl = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? followUpText = freezed,Object? issueDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,invoiceType: freezed == invoiceType ? _self.invoiceType : invoiceType // ignore: cast_nullable_to_non_nullable
as String?,invoiceTypeDisplay: freezed == invoiceTypeDisplay ? _self.invoiceTypeDisplay : invoiceTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,paymentReceivedAmount: freezed == paymentReceivedAmount ? _self.paymentReceivedAmount : paymentReceivedAmount // ignore: cast_nullable_to_non_nullable
as double?,paymentRemainingAmount: freezed == paymentRemainingAmount ? _self.paymentRemainingAmount : paymentRemainingAmount // ignore: cast_nullable_to_non_nullable
as double?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,followUpText: freezed == followUpText ? _self.followUpText : followUpText // ignore: cast_nullable_to_non_nullable
as String?,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson)  String? invoiceNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)  String? invoiceType, @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)  String? invoiceTypeDisplay, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)  double? amount, @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)  double? paymentReceivedAmount, @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)  double? paymentRemainingAmount, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)  String? attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson)  DateTime? issueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.salesOrderId,_that.salesOrderNumber,_that.workOrderId,_that.workOrderNumber,_that.customerName,_that.invoiceType,_that.invoiceTypeDisplay,_that.amount,_that.paymentReceivedAmount,_that.paymentRemainingAmount,_that.attachmentUrl,_that.status,_that.statusDisplay,_that.followUpText,_that.issueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson)  String? invoiceNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)  String? invoiceType, @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)  String? invoiceTypeDisplay, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)  double? amount, @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)  double? paymentReceivedAmount, @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)  double? paymentRemainingAmount, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)  String? attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson)  DateTime? issueDate)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.invoiceNumber,_that.salesOrderId,_that.salesOrderNumber,_that.workOrderId,_that.workOrderNumber,_that.customerName,_that.invoiceType,_that.invoiceTypeDisplay,_that.amount,_that.paymentReceivedAmount,_that.paymentRemainingAmount,_that.attachmentUrl,_that.status,_that.statusDisplay,_that.followUpText,_that.issueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson)  String? invoiceNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)  String? invoiceType, @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)  String? invoiceTypeDisplay, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)  double? amount, @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)  double? paymentReceivedAmount, @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)  double? paymentRemainingAmount, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)  String? attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson)  DateTime? issueDate)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.salesOrderId,_that.salesOrderNumber,_that.workOrderId,_that.workOrderNumber,_that.customerName,_that.invoiceType,_that.invoiceTypeDisplay,_that.amount,_that.paymentReceivedAmount,_that.paymentRemainingAmount,_that.attachmentUrl,_that.status,_that.statusDisplay,_that.followUpText,_that.issueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invoice implements Invoice {
  const _Invoice({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson) this.invoiceNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) this.salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) this.salesOrderNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) this.workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson) this.invoiceType, @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson) this.invoiceTypeDisplay, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) this.amount, @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson) this.paymentReceivedAmount, @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson) this.paymentRemainingAmount, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) this.attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) this.followUpText, @JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson) this.issueDate});
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson) final  String? invoiceNumber;
@override@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) final  int? salesOrderId;
@override@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) final  String? salesOrderNumber;
@override@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) final  int? workOrderId;
@override@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson) final  String? invoiceType;
@override@JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson) final  String? invoiceTypeDisplay;
@override@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) final  double? amount;
@override@JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson) final  double? paymentReceivedAmount;
@override@JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson) final  double? paymentRemainingAmount;
@override@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) final  String? attachmentUrl;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) final  String? followUpText;
@override@JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson) final  DateTime? issueDate;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.invoiceType, invoiceType) || other.invoiceType == invoiceType)&&(identical(other.invoiceTypeDisplay, invoiceTypeDisplay) || other.invoiceTypeDisplay == invoiceTypeDisplay)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentReceivedAmount, paymentReceivedAmount) || other.paymentReceivedAmount == paymentReceivedAmount)&&(identical(other.paymentRemainingAmount, paymentRemainingAmount) || other.paymentRemainingAmount == paymentRemainingAmount)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.followUpText, followUpText) || other.followUpText == followUpText)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceNumber,salesOrderId,salesOrderNumber,workOrderId,workOrderNumber,customerName,invoiceType,invoiceTypeDisplay,amount,paymentReceivedAmount,paymentRemainingAmount,attachmentUrl,status,statusDisplay,followUpText,issueDate);

@override
String toString() {
  return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, customerName: $customerName, invoiceType: $invoiceType, invoiceTypeDisplay: $invoiceTypeDisplay, amount: $amount, paymentReceivedAmount: $paymentReceivedAmount, paymentRemainingAmount: $paymentRemainingAmount, attachmentUrl: $attachmentUrl, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, issueDate: $issueDate)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'invoice_number', readValue: _readInvoiceNumber, fromJson: _stringOrNullFromJson) String? invoiceNumber,@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson) String? invoiceType,@JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson) String? invoiceTypeDisplay,@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) double? amount,@JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson) double? paymentReceivedAmount,@JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson) double? paymentRemainingAmount,@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) String? attachmentUrl,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? followUpText,@JsonKey(name: 'issue_date', readValue: _readIssueDate, fromJson: _dateTimeOrNullFromJson) DateTime? issueDate
});




}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? invoiceNumber = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? workOrderId = freezed,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? invoiceType = freezed,Object? invoiceTypeDisplay = freezed,Object? amount = freezed,Object? paymentReceivedAmount = freezed,Object? paymentRemainingAmount = freezed,Object? attachmentUrl = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? followUpText = freezed,Object? issueDate = freezed,}) {
  return _then(_Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,invoiceType: freezed == invoiceType ? _self.invoiceType : invoiceType // ignore: cast_nullable_to_non_nullable
as String?,invoiceTypeDisplay: freezed == invoiceTypeDisplay ? _self.invoiceTypeDisplay : invoiceTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,paymentReceivedAmount: freezed == paymentReceivedAmount ? _self.paymentReceivedAmount : paymentReceivedAmount // ignore: cast_nullable_to_non_nullable
as double?,paymentRemainingAmount: freezed == paymentRemainingAmount ? _self.paymentRemainingAmount : paymentRemainingAmount // ignore: cast_nullable_to_non_nullable
as double?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,followUpText: freezed == followUpText ? _self.followUpText : followUpText // ignore: cast_nullable_to_non_nullable
as String?,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
