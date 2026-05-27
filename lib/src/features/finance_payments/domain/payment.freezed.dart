// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson) String? get paymentNumber;@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? get salesOrderId;@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? get salesOrderNumber;@JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) int? get invoiceId;@JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson) String? get invoiceNumber;@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) double? get amount;@JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson) String? get paymentMethod;@JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson) String? get paymentMethodDisplay;@JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson) double? get appliedAmount;@JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson) double? get remainingAmount;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? get followUpText;@JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson) DateTime? get paymentDate;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.paymentNumber, paymentNumber) || other.paymentNumber == paymentNumber)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentMethodDisplay, paymentMethodDisplay) || other.paymentMethodDisplay == paymentMethodDisplay)&&(identical(other.appliedAmount, appliedAmount) || other.appliedAmount == appliedAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.followUpText, followUpText) || other.followUpText == followUpText)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paymentNumber,salesOrderId,salesOrderNumber,invoiceId,invoiceNumber,workOrderNumber,customerName,amount,paymentMethod,paymentMethodDisplay,appliedAmount,remainingAmount,status,statusDisplay,followUpText,paymentDate);

@override
String toString() {
  return 'Payment(id: $id, paymentNumber: $paymentNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, invoiceId: $invoiceId, invoiceNumber: $invoiceNumber, workOrderNumber: $workOrderNumber, customerName: $customerName, amount: $amount, paymentMethod: $paymentMethod, paymentMethodDisplay: $paymentMethodDisplay, appliedAmount: $appliedAmount, remainingAmount: $remainingAmount, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, paymentDate: $paymentDate)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson) String? paymentNumber,@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) int? invoiceId,@JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson) String? invoiceNumber,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) double? amount,@JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson) String? paymentMethod,@JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson) String? paymentMethodDisplay,@JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson) double? appliedAmount,@JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson) double? remainingAmount,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? followUpText,@JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson) DateTime? paymentDate
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? paymentNumber = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? invoiceId = freezed,Object? invoiceNumber = freezed,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? amount = freezed,Object? paymentMethod = freezed,Object? paymentMethodDisplay = freezed,Object? appliedAmount = freezed,Object? remainingAmount = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? followUpText = freezed,Object? paymentDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,paymentNumber: freezed == paymentNumber ? _self.paymentNumber : paymentNumber // ignore: cast_nullable_to_non_nullable
as String?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as int?,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentMethodDisplay: freezed == paymentMethodDisplay ? _self.paymentMethodDisplay : paymentMethodDisplay // ignore: cast_nullable_to_non_nullable
as String?,appliedAmount: freezed == appliedAmount ? _self.appliedAmount : appliedAmount // ignore: cast_nullable_to_non_nullable
as double?,remainingAmount: freezed == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,followUpText: freezed == followUpText ? _self.followUpText : followUpText // ignore: cast_nullable_to_non_nullable
as String?,paymentDate: freezed == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson)  String? paymentNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson)  int? invoiceId, @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)  String? invoiceNumber, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)  double? amount, @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)  String? paymentMethod, @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)  String? paymentMethodDisplay, @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)  double? appliedAmount, @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)  double? remainingAmount, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson)  DateTime? paymentDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.paymentNumber,_that.salesOrderId,_that.salesOrderNumber,_that.invoiceId,_that.invoiceNumber,_that.workOrderNumber,_that.customerName,_that.amount,_that.paymentMethod,_that.paymentMethodDisplay,_that.appliedAmount,_that.remainingAmount,_that.status,_that.statusDisplay,_that.followUpText,_that.paymentDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson)  String? paymentNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson)  int? invoiceId, @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)  String? invoiceNumber, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)  double? amount, @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)  String? paymentMethod, @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)  String? paymentMethodDisplay, @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)  double? appliedAmount, @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)  double? remainingAmount, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson)  DateTime? paymentDate)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.paymentNumber,_that.salesOrderId,_that.salesOrderNumber,_that.invoiceId,_that.invoiceNumber,_that.workOrderNumber,_that.customerName,_that.amount,_that.paymentMethod,_that.paymentMethodDisplay,_that.appliedAmount,_that.remainingAmount,_that.status,_that.statusDisplay,_that.followUpText,_that.paymentDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson)  String? paymentNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)  int? salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)  String? salesOrderNumber, @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson)  int? invoiceId, @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)  String? invoiceNumber, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)  double? amount, @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)  String? paymentMethod, @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)  String? paymentMethodDisplay, @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)  double? appliedAmount, @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)  double? remainingAmount, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson)  DateTime? paymentDate)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.paymentNumber,_that.salesOrderId,_that.salesOrderNumber,_that.invoiceId,_that.invoiceNumber,_that.workOrderNumber,_that.customerName,_that.amount,_that.paymentMethod,_that.paymentMethodDisplay,_that.appliedAmount,_that.remainingAmount,_that.status,_that.statusDisplay,_that.followUpText,_that.paymentDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson) this.paymentNumber, @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) this.salesOrderId, @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) this.salesOrderNumber, @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) this.invoiceId, @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson) this.invoiceNumber, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) this.amount, @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson) this.paymentMethod, @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson) this.paymentMethodDisplay, @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson) this.appliedAmount, @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson) this.remainingAmount, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) this.followUpText, @JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson) this.paymentDate});
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson) final  String? paymentNumber;
@override@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) final  int? salesOrderId;
@override@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) final  String? salesOrderNumber;
@override@JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) final  int? invoiceId;
@override@JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson) final  String? invoiceNumber;
@override@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) final  double? amount;
@override@JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson) final  String? paymentMethod;
@override@JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson) final  String? paymentMethodDisplay;
@override@JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson) final  double? appliedAmount;
@override@JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson) final  double? remainingAmount;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) final  String? followUpText;
@override@JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson) final  DateTime? paymentDate;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.paymentNumber, paymentNumber) || other.paymentNumber == paymentNumber)&&(identical(other.salesOrderId, salesOrderId) || other.salesOrderId == salesOrderId)&&(identical(other.salesOrderNumber, salesOrderNumber) || other.salesOrderNumber == salesOrderNumber)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentMethodDisplay, paymentMethodDisplay) || other.paymentMethodDisplay == paymentMethodDisplay)&&(identical(other.appliedAmount, appliedAmount) || other.appliedAmount == appliedAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.followUpText, followUpText) || other.followUpText == followUpText)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paymentNumber,salesOrderId,salesOrderNumber,invoiceId,invoiceNumber,workOrderNumber,customerName,amount,paymentMethod,paymentMethodDisplay,appliedAmount,remainingAmount,status,statusDisplay,followUpText,paymentDate);

@override
String toString() {
  return 'Payment(id: $id, paymentNumber: $paymentNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, invoiceId: $invoiceId, invoiceNumber: $invoiceNumber, workOrderNumber: $workOrderNumber, customerName: $customerName, amount: $amount, paymentMethod: $paymentMethod, paymentMethodDisplay: $paymentMethodDisplay, appliedAmount: $appliedAmount, remainingAmount: $remainingAmount, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, paymentDate: $paymentDate)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'payment_number', readValue: _readPaymentNumber, fromJson: _stringOrNullFromJson) String? paymentNumber,@JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson) int? salesOrderId,@JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson) String? salesOrderNumber,@JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) int? invoiceId,@JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson) String? invoiceNumber,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson) double? amount,@JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson) String? paymentMethod,@JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson) String? paymentMethodDisplay,@JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson) double? appliedAmount,@JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson) double? remainingAmount,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? followUpText,@JsonKey(name: 'payment_date', readValue: _readPaymentDate, fromJson: _dateTimeOrNullFromJson) DateTime? paymentDate
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? paymentNumber = freezed,Object? salesOrderId = freezed,Object? salesOrderNumber = freezed,Object? invoiceId = freezed,Object? invoiceNumber = freezed,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? amount = freezed,Object? paymentMethod = freezed,Object? paymentMethodDisplay = freezed,Object? appliedAmount = freezed,Object? remainingAmount = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? followUpText = freezed,Object? paymentDate = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,paymentNumber: freezed == paymentNumber ? _self.paymentNumber : paymentNumber // ignore: cast_nullable_to_non_nullable
as String?,salesOrderId: freezed == salesOrderId ? _self.salesOrderId : salesOrderId // ignore: cast_nullable_to_non_nullable
as int?,salesOrderNumber: freezed == salesOrderNumber ? _self.salesOrderNumber : salesOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as int?,invoiceNumber: freezed == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentMethodDisplay: freezed == paymentMethodDisplay ? _self.paymentMethodDisplay : paymentMethodDisplay // ignore: cast_nullable_to_non_nullable
as String?,appliedAmount: freezed == appliedAmount ? _self.appliedAmount : appliedAmount // ignore: cast_nullable_to_non_nullable
as double?,remainingAmount: freezed == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,followUpText: freezed == followUpText ? _self.followUpText : followUpText // ignore: cast_nullable_to_non_nullable
as String?,paymentDate: freezed == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
