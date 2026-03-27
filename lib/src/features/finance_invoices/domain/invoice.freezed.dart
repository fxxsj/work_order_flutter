// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'invoice_number',
      readValue: _readInvoiceNumber,
      fromJson: _stringOrNullFromJson)
  String? get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  int? get salesOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  int? get workOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
  String? get invoiceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
  String? get invoiceTypeDisplay => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
  double? get paymentReceivedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
  double? get paymentRemainingAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
  String? get attachmentUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
  String? get followUpText => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'issue_date',
      readValue: _readIssueDate,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get issueDate => throw _privateConstructorUsedError;

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'invoice_number',
          readValue: _readInvoiceNumber,
          fromJson: _stringOrNullFromJson)
      String? invoiceNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
      String? invoiceType,
      @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
      String? invoiceTypeDisplay,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      double? amount,
      @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
      double? paymentReceivedAmount,
      @JsonKey(
          name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
      double? paymentRemainingAmount,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      String? attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      String? followUpText,
      @JsonKey(
          name: 'issue_date',
          readValue: _readIssueDate,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? issueDate});
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? workOrderId = freezed,
    Object? workOrderNumber = freezed,
    Object? customerName = freezed,
    Object? invoiceType = freezed,
    Object? invoiceTypeDisplay = freezed,
    Object? amount = freezed,
    Object? paymentReceivedAmount = freezed,
    Object? paymentRemainingAmount = freezed,
    Object? attachmentUrl = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? followUpText = freezed,
    Object? issueDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderId: freezed == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceType: freezed == invoiceType
          ? _value.invoiceType
          : invoiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceTypeDisplay: freezed == invoiceTypeDisplay
          ? _value.invoiceTypeDisplay
          : invoiceTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentReceivedAmount: freezed == paymentReceivedAmount
          ? _value.paymentReceivedAmount
          : paymentReceivedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentRemainingAmount: freezed == paymentRemainingAmount
          ? _value.paymentRemainingAmount
          : paymentRemainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
          _$InvoiceImpl value, $Res Function(_$InvoiceImpl) then) =
      __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'invoice_number',
          readValue: _readInvoiceNumber,
          fromJson: _stringOrNullFromJson)
      String? invoiceNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
      String? invoiceType,
      @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
      String? invoiceTypeDisplay,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      double? amount,
      @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
      double? paymentReceivedAmount,
      @JsonKey(
          name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
      double? paymentRemainingAmount,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      String? attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      String? followUpText,
      @JsonKey(
          name: 'issue_date',
          readValue: _readIssueDate,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? issueDate});
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
      _$InvoiceImpl _value, $Res Function(_$InvoiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? workOrderId = freezed,
    Object? workOrderNumber = freezed,
    Object? customerName = freezed,
    Object? invoiceType = freezed,
    Object? invoiceTypeDisplay = freezed,
    Object? amount = freezed,
    Object? paymentReceivedAmount = freezed,
    Object? paymentRemainingAmount = freezed,
    Object? attachmentUrl = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? followUpText = freezed,
    Object? issueDate = freezed,
  }) {
    return _then(_$InvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderId: freezed == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceType: freezed == invoiceType
          ? _value.invoiceType
          : invoiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceTypeDisplay: freezed == invoiceTypeDisplay
          ? _value.invoiceTypeDisplay
          : invoiceTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentReceivedAmount: freezed == paymentReceivedAmount
          ? _value.paymentReceivedAmount
          : paymentReceivedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentRemainingAmount: freezed == paymentRemainingAmount
          ? _value.paymentRemainingAmount
          : paymentRemainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceImpl implements _Invoice {
  const _$InvoiceImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(
          name: 'invoice_number',
          readValue: _readInvoiceNumber,
          fromJson: _stringOrNullFromJson)
      this.invoiceNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      this.salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      this.salesOrderNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      this.workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
      this.invoiceType,
      @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
      this.invoiceTypeDisplay,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      this.amount,
      @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
      this.paymentReceivedAmount,
      @JsonKey(
          name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
      this.paymentRemainingAmount,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      this.attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      this.followUpText,
      @JsonKey(
          name: 'issue_date',
          readValue: _readIssueDate,
          fromJson: _dateTimeOrNullFromJson)
      this.issueDate});

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(
      name: 'invoice_number',
      readValue: _readInvoiceNumber,
      fromJson: _stringOrNullFromJson)
  final String? invoiceNumber;
  @override
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  final int? salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  final String? salesOrderNumber;
  @override
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  final int? workOrderId;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
  final String? invoiceType;
  @override
  @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
  final String? invoiceTypeDisplay;
  @override
  @JsonKey(
      name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)
  final double? amount;
  @override
  @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
  final double? paymentReceivedAmount;
  @override
  @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
  final double? paymentRemainingAmount;
  @override
  @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
  final String? attachmentUrl;
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
      name: 'issue_date',
      readValue: _readIssueDate,
      fromJson: _dateTimeOrNullFromJson)
  final DateTime? issueDate;

  @override
  String toString() {
    return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, customerName: $customerName, invoiceType: $invoiceType, invoiceTypeDisplay: $invoiceTypeDisplay, amount: $amount, paymentReceivedAmount: $paymentReceivedAmount, paymentRemainingAmount: $paymentRemainingAmount, attachmentUrl: $attachmentUrl, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, issueDate: $issueDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.salesOrderId, salesOrderId) ||
                other.salesOrderId == salesOrderId) &&
            (identical(other.salesOrderNumber, salesOrderNumber) ||
                other.salesOrderNumber == salesOrderNumber) &&
            (identical(other.workOrderId, workOrderId) ||
                other.workOrderId == workOrderId) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.invoiceType, invoiceType) ||
                other.invoiceType == invoiceType) &&
            (identical(other.invoiceTypeDisplay, invoiceTypeDisplay) ||
                other.invoiceTypeDisplay == invoiceTypeDisplay) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentReceivedAmount, paymentReceivedAmount) ||
                other.paymentReceivedAmount == paymentReceivedAmount) &&
            (identical(other.paymentRemainingAmount, paymentRemainingAmount) ||
                other.paymentRemainingAmount == paymentRemainingAmount) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.followUpText, followUpText) ||
                other.followUpText == followUpText) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      invoiceNumber,
      salesOrderId,
      salesOrderNumber,
      workOrderId,
      workOrderNumber,
      customerName,
      invoiceType,
      invoiceTypeDisplay,
      amount,
      paymentReceivedAmount,
      paymentRemainingAmount,
      attachmentUrl,
      status,
      statusDisplay,
      followUpText,
      issueDate);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(
      this,
    );
  }
}

abstract class _Invoice implements Invoice {
  const factory _Invoice(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(
          name: 'invoice_number',
          readValue: _readInvoiceNumber,
          fromJson: _stringOrNullFromJson)
      final String? invoiceNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      final int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      final String? salesOrderNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      final int? workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      final String? workOrderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
      final String? invoiceType,
      @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
      final String? invoiceTypeDisplay,
      @JsonKey(
          name: 'amount',
          readValue: _readAmount,
          fromJson: _doubleOrNullFromJson)
      final double? amount,
      @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
      final double? paymentReceivedAmount,
      @JsonKey(
          name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
      final double? paymentRemainingAmount,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      final String? attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      final String? followUpText,
      @JsonKey(
          name: 'issue_date',
          readValue: _readIssueDate,
          fromJson: _dateTimeOrNullFromJson)
      final DateTime? issueDate}) = _$InvoiceImpl;

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(
      name: 'invoice_number',
      readValue: _readInvoiceNumber,
      fromJson: _stringOrNullFromJson)
  String? get invoiceNumber;
  @override
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  int? get salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber;
  @override
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  int? get workOrderId;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
  String? get invoiceType;
  @override
  @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
  String? get invoiceTypeDisplay;
  @override
  @JsonKey(
      name: 'amount', readValue: _readAmount, fromJson: _doubleOrNullFromJson)
  double? get amount;
  @override
  @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
  double? get paymentReceivedAmount;
  @override
  @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
  double? get paymentRemainingAmount;
  @override
  @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
  String? get attachmentUrl;
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
      name: 'issue_date',
      readValue: _readIssueDate,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get issueDate;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
