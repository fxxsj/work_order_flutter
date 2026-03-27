// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'payment_number',
      readValue: _readPaymentNumber,
      fromJson: _stringOrNullFromJson)
  String? get paymentNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  int? get salesOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson)
  int? get invoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
  String? get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
  String? get paymentMethodDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
  double? get appliedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
  double? get remainingAmount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
  String? get followUpText => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'payment_date',
      readValue: _readPaymentDate,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get paymentDate => throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'payment_number',
          readValue: _readPaymentNumber,
          fromJson: _stringOrNullFromJson)
      String? paymentNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) int? invoiceId,
      @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
      String? invoiceNumber,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      double? amount,
      @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
      String? paymentMethod,
      @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
      String? paymentMethodDisplay,
      @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
      double? appliedAmount,
      @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
      double? remainingAmount,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      String? followUpText,
      @JsonKey(
          name: 'payment_date',
          readValue: _readPaymentDate,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? paymentDate});
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentNumber = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? invoiceId = freezed,
    Object? invoiceNumber = freezed,
    Object? workOrderNumber = freezed,
    Object? customerName = freezed,
    Object? amount = freezed,
    Object? paymentMethod = freezed,
    Object? paymentMethodDisplay = freezed,
    Object? appliedAmount = freezed,
    Object? remainingAmount = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? followUpText = freezed,
    Object? paymentDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      paymentNumber: freezed == paymentNumber
          ? _value.paymentNumber
          : paymentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceId: freezed == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethodDisplay: freezed == paymentMethodDisplay
          ? _value.paymentMethodDisplay
          : paymentMethodDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedAmount: freezed == appliedAmount
          ? _value.appliedAmount
          : appliedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      followUpText: freezed == followUpText
          ? _value.followUpText
          : followUpText // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
          _$PaymentImpl value, $Res Function(_$PaymentImpl) then) =
      __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'payment_number',
          readValue: _readPaymentNumber,
          fromJson: _stringOrNullFromJson)
      String? paymentNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) int? invoiceId,
      @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
      String? invoiceNumber,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      double? amount,
      @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
      String? paymentMethod,
      @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
      String? paymentMethodDisplay,
      @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
      double? appliedAmount,
      @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
      double? remainingAmount,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      String? followUpText,
      @JsonKey(
          name: 'payment_date',
          readValue: _readPaymentDate,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? paymentDate});
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
      _$PaymentImpl _value, $Res Function(_$PaymentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentNumber = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? invoiceId = freezed,
    Object? invoiceNumber = freezed,
    Object? workOrderNumber = freezed,
    Object? customerName = freezed,
    Object? amount = freezed,
    Object? paymentMethod = freezed,
    Object? paymentMethodDisplay = freezed,
    Object? appliedAmount = freezed,
    Object? remainingAmount = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? followUpText = freezed,
    Object? paymentDate = freezed,
  }) {
    return _then(_$PaymentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      paymentNumber: freezed == paymentNumber
          ? _value.paymentNumber
          : paymentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceId: freezed == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethodDisplay: freezed == paymentMethodDisplay
          ? _value.paymentMethodDisplay
          : paymentMethodDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedAmount: freezed == appliedAmount
          ? _value.appliedAmount
          : appliedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      followUpText: freezed == followUpText
          ? _value.followUpText
          : followUpText // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(
          name: 'payment_number',
          readValue: _readPaymentNumber,
          fromJson: _stringOrNullFromJson)
      this.paymentNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      this.salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      this.salesOrderNumber,
      @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) this.invoiceId,
      @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
      this.invoiceNumber,
      @JsonKey(
          name: 'work_order_number', fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      this.amount,
      @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
      this.paymentMethod,
      @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
      this.paymentMethodDisplay,
      @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
      this.appliedAmount,
      @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
      this.remainingAmount,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      this.followUpText,
      @JsonKey(
          name: 'payment_date',
          readValue: _readPaymentDate,
          fromJson: _dateTimeOrNullFromJson)
      this.paymentDate});

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(
      name: 'payment_number',
      readValue: _readPaymentNumber,
      fromJson: _stringOrNullFromJson)
  final String? paymentNumber;
  @override
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  final int? salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  final String? salesOrderNumber;
  @override
  @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson)
  final int? invoiceId;
  @override
  @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
  final String? invoiceNumber;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(
      name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)
  final double? amount;
  @override
  @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
  final String? paymentMethod;
  @override
  @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
  final String? paymentMethodDisplay;
  @override
  @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
  final double? appliedAmount;
  @override
  @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
  final double? remainingAmount;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
  final String? followUpText;
  @override
  @JsonKey(
      name: 'payment_date',
      readValue: _readPaymentDate,
      fromJson: _dateTimeOrNullFromJson)
  final DateTime? paymentDate;

  @override
  String toString() {
    return 'Payment(id: $id, paymentNumber: $paymentNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, invoiceId: $invoiceId, invoiceNumber: $invoiceNumber, workOrderNumber: $workOrderNumber, customerName: $customerName, amount: $amount, paymentMethod: $paymentMethod, paymentMethodDisplay: $paymentMethodDisplay, appliedAmount: $appliedAmount, remainingAmount: $remainingAmount, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, paymentDate: $paymentDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paymentNumber, paymentNumber) ||
                other.paymentNumber == paymentNumber) &&
            (identical(other.salesOrderId, salesOrderId) ||
                other.salesOrderId == salesOrderId) &&
            (identical(other.salesOrderNumber, salesOrderNumber) ||
                other.salesOrderNumber == salesOrderNumber) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentMethodDisplay, paymentMethodDisplay) ||
                other.paymentMethodDisplay == paymentMethodDisplay) &&
            (identical(other.appliedAmount, appliedAmount) ||
                other.appliedAmount == appliedAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.followUpText, followUpText) ||
                other.followUpText == followUpText) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      paymentNumber,
      salesOrderId,
      salesOrderNumber,
      invoiceId,
      invoiceNumber,
      workOrderNumber,
      customerName,
      amount,
      paymentMethod,
      paymentMethodDisplay,
      appliedAmount,
      remainingAmount,
      status,
      statusDisplay,
      followUpText,
      paymentDate);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(
      this,
    );
  }
}

abstract class _Payment implements Payment {
  const factory _Payment(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(
          name: 'payment_number',
          readValue: _readPaymentNumber,
          fromJson: _stringOrNullFromJson)
      final String? paymentNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      final int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      final String? salesOrderNumber,
      @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson)
      final int? invoiceId,
      @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
      final String? invoiceNumber,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      final String? workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      final double? amount,
      @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
      final String? paymentMethod,
      @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
      final String? paymentMethodDisplay,
      @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
      final double? appliedAmount,
      @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
      final double? remainingAmount,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      final String? followUpText,
      @JsonKey(
          name: 'payment_date',
          readValue: _readPaymentDate,
          fromJson: _dateTimeOrNullFromJson)
      final DateTime? paymentDate}) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(
      name: 'payment_number',
      readValue: _readPaymentNumber,
      fromJson: _stringOrNullFromJson)
  String? get paymentNumber;
  @override
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  int? get salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber;
  @override
  @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson)
  int? get invoiceId;
  @override
  @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
  String? get invoiceNumber;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(
      name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)
  double? get amount;
  @override
  @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
  String? get paymentMethod;
  @override
  @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
  String? get paymentMethodDisplay;
  @override
  @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
  double? get appliedAmount;
  @override
  @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
  double? get remainingAmount;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
  String? get followUpText;
  @override
  @JsonKey(
      name: 'payment_date',
      readValue: _readPaymentDate,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get paymentDate;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
