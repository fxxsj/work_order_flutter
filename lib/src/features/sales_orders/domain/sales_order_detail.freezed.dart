// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalesOrderDetail _$SalesOrderDetailFromJson(Map<String, dynamic> json) {
  return _SalesOrderDetail.fromJson(json);
}

/// @nodoc
mixin _$SalesOrderDetail {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
  int? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
  String? get customerContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
  String? get customerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
  String? get customerAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
  String? get contractNumber => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
  String? get approvalComment => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
  String? get rejectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
  String? get paymentStatusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get actualDeliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
  double? get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
  double? get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
  double? get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  double? get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
  double? get depositAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
  double? get paidAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get paymentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
  String? get contactPerson => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
  String? get contactPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
  String? get shippingAddress => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
  int? get paymentCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
  int? get pendingPaymentPlanCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)
  double? get pendingPaymentPlanAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
  double? get unpaidAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
  List<String> get workOrderNumbers => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
  List<String> get deliveryOrderNumbers => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
  List<String> get invoiceNumbers => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'work_order_summaries',
      readValue: _readWorkOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get workOrderSummaries =>
      throw _privateConstructorUsedError;
  @JsonKey(
      name: 'delivery_order_summaries',
      readValue: _readDeliveryOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get deliveryOrderSummaries =>
      throw _privateConstructorUsedError;
  @JsonKey(
      name: 'invoice_summaries',
      readValue: _readInvoiceSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get invoiceSummaries =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)
  List<SalesOrderItem> get items => throw _privateConstructorUsedError;

  /// Serializes this SalesOrderDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesOrderDetailCopyWith<SalesOrderDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesOrderDetailCopyWith<$Res> {
  factory $SalesOrderDetailCopyWith(
          SalesOrderDetail value, $Res Function(SalesOrderDetail) then) =
      _$SalesOrderDetailCopyWithImpl<$Res, SalesOrderDetail>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
      String? customerContact,
      @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
      String? customerPhone,
      @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
      String? customerAddress,
      @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
      String? contractNumber,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
      String? approvalComment,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      String? rejectionReason,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      String? paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      String? paymentStatusDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? actualDeliveryDate,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
      double? taxRate,
      @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
      double? taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      double? discountAmount,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
      double? depositAmount,
      @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
      double? paidAmount,
      @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? paymentDate,
      @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
      String? contactPerson,
      @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
      String? contactPhone,
      @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
      String? shippingAddress,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
      int? paymentCount,
      @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
      int? pendingPaymentPlanCount,
      @JsonKey(
          name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)
      double? pendingPaymentPlanAmount,
      @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
      double? unpaidAmount,
      @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
      List<String> workOrderNumbers,
      @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
      List<String> deliveryOrderNumbers,
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      List<String> invoiceNumbers,
      @JsonKey(
          name: 'work_order_summaries',
          readValue: _readWorkOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      List<TraceabilitySummaryItem> workOrderSummaries,
      @JsonKey(
          name: 'delivery_order_summaries',
          readValue: _readDeliveryOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      List<TraceabilitySummaryItem> deliveryOrderSummaries,
      @JsonKey(
          name: 'invoice_summaries',
          readValue: _readInvoiceSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      List<TraceabilitySummaryItem> invoiceSummaries,
      @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)
      List<SalesOrderItem> items});
}

/// @nodoc
class _$SalesOrderDetailCopyWithImpl<$Res, $Val extends SalesOrderDetail>
    implements $SalesOrderDetailCopyWith<$Res> {
  _$SalesOrderDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerContact = freezed,
    Object? customerPhone = freezed,
    Object? customerAddress = freezed,
    Object? contractNumber = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? approvalComment = freezed,
    Object? rejectionReason = freezed,
    Object? paymentStatus = freezed,
    Object? paymentStatusDisplay = freezed,
    Object? orderDate = freezed,
    Object? deliveryDate = freezed,
    Object? actualDeliveryDate = freezed,
    Object? subtotal = freezed,
    Object? taxRate = freezed,
    Object? taxAmount = freezed,
    Object? discountAmount = freezed,
    Object? totalAmount = freezed,
    Object? depositAmount = freezed,
    Object? paidAmount = freezed,
    Object? paymentDate = freezed,
    Object? contactPerson = freezed,
    Object? contactPhone = freezed,
    Object? shippingAddress = freezed,
    Object? notes = freezed,
    Object? paymentCount = freezed,
    Object? pendingPaymentPlanCount = freezed,
    Object? pendingPaymentPlanAmount = freezed,
    Object? unpaidAmount = freezed,
    Object? workOrderNumbers = null,
    Object? deliveryOrderNumbers = null,
    Object? invoiceNumbers = null,
    Object? workOrderSummaries = null,
    Object? deliveryOrderSummaries = null,
    Object? invoiceSummaries = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerContact: freezed == customerContact
          ? _value.customerContact
          : customerContact // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerAddress: freezed == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      contractNumber: freezed == contractNumber
          ? _value.contractNumber
          : contractNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      approvalComment: freezed == approvalComment
          ? _value.approvalComment
          : approvalComment // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatusDisplay: freezed == paymentStatusDisplay
          ? _value.paymentStatusDisplay
          : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDeliveryDate: freezed == actualDeliveryDate
          ? _value.actualDeliveryDate
          : actualDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double?,
      taxAmount: freezed == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      depositAmount: freezed == depositAmount
          ? _value.depositAmount
          : depositAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAmount: freezed == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentCount: freezed == paymentCount
          ? _value.paymentCount
          : paymentCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pendingPaymentPlanCount: freezed == pendingPaymentPlanCount
          ? _value.pendingPaymentPlanCount
          : pendingPaymentPlanCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pendingPaymentPlanAmount: freezed == pendingPaymentPlanAmount
          ? _value.pendingPaymentPlanAmount
          : pendingPaymentPlanAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      unpaidAmount: freezed == unpaidAmount
          ? _value.unpaidAmount
          : unpaidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      workOrderNumbers: null == workOrderNumbers
          ? _value.workOrderNumbers
          : workOrderNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deliveryOrderNumbers: null == deliveryOrderNumbers
          ? _value.deliveryOrderNumbers
          : deliveryOrderNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      invoiceNumbers: null == invoiceNumbers
          ? _value.invoiceNumbers
          : invoiceNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      workOrderSummaries: null == workOrderSummaries
          ? _value.workOrderSummaries
          : workOrderSummaries // ignore: cast_nullable_to_non_nullable
              as List<TraceabilitySummaryItem>,
      deliveryOrderSummaries: null == deliveryOrderSummaries
          ? _value.deliveryOrderSummaries
          : deliveryOrderSummaries // ignore: cast_nullable_to_non_nullable
              as List<TraceabilitySummaryItem>,
      invoiceSummaries: null == invoiceSummaries
          ? _value.invoiceSummaries
          : invoiceSummaries // ignore: cast_nullable_to_non_nullable
              as List<TraceabilitySummaryItem>,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SalesOrderItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesOrderDetailImplCopyWith<$Res>
    implements $SalesOrderDetailCopyWith<$Res> {
  factory _$$SalesOrderDetailImplCopyWith(_$SalesOrderDetailImpl value,
          $Res Function(_$SalesOrderDetailImpl) then) =
      __$$SalesOrderDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
      String? customerContact,
      @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
      String? customerPhone,
      @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
      String? customerAddress,
      @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
      String? contractNumber,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
      String? approvalComment,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      String? rejectionReason,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      String? paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      String? paymentStatusDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? actualDeliveryDate,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
      double? taxRate,
      @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
      double? taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      double? discountAmount,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
      double? depositAmount,
      @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
      double? paidAmount,
      @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? paymentDate,
      @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
      String? contactPerson,
      @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
      String? contactPhone,
      @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
      String? shippingAddress,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
      int? paymentCount,
      @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
      int? pendingPaymentPlanCount,
      @JsonKey(
          name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)
      double? pendingPaymentPlanAmount,
      @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
      double? unpaidAmount,
      @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
      List<String> workOrderNumbers,
      @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
      List<String> deliveryOrderNumbers,
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      List<String> invoiceNumbers,
      @JsonKey(
          name: 'work_order_summaries',
          readValue: _readWorkOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      List<TraceabilitySummaryItem> workOrderSummaries,
      @JsonKey(
          name: 'delivery_order_summaries',
          readValue: _readDeliveryOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      List<TraceabilitySummaryItem> deliveryOrderSummaries,
      @JsonKey(
          name: 'invoice_summaries',
          readValue: _readInvoiceSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      List<TraceabilitySummaryItem> invoiceSummaries,
      @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)
      List<SalesOrderItem> items});
}

/// @nodoc
class __$$SalesOrderDetailImplCopyWithImpl<$Res>
    extends _$SalesOrderDetailCopyWithImpl<$Res, _$SalesOrderDetailImpl>
    implements _$$SalesOrderDetailImplCopyWith<$Res> {
  __$$SalesOrderDetailImplCopyWithImpl(_$SalesOrderDetailImpl _value,
      $Res Function(_$SalesOrderDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? customerContact = freezed,
    Object? customerPhone = freezed,
    Object? customerAddress = freezed,
    Object? contractNumber = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? approvalComment = freezed,
    Object? rejectionReason = freezed,
    Object? paymentStatus = freezed,
    Object? paymentStatusDisplay = freezed,
    Object? orderDate = freezed,
    Object? deliveryDate = freezed,
    Object? actualDeliveryDate = freezed,
    Object? subtotal = freezed,
    Object? taxRate = freezed,
    Object? taxAmount = freezed,
    Object? discountAmount = freezed,
    Object? totalAmount = freezed,
    Object? depositAmount = freezed,
    Object? paidAmount = freezed,
    Object? paymentDate = freezed,
    Object? contactPerson = freezed,
    Object? contactPhone = freezed,
    Object? shippingAddress = freezed,
    Object? notes = freezed,
    Object? paymentCount = freezed,
    Object? pendingPaymentPlanCount = freezed,
    Object? pendingPaymentPlanAmount = freezed,
    Object? unpaidAmount = freezed,
    Object? workOrderNumbers = null,
    Object? deliveryOrderNumbers = null,
    Object? invoiceNumbers = null,
    Object? workOrderSummaries = null,
    Object? deliveryOrderSummaries = null,
    Object? invoiceSummaries = null,
    Object? items = null,
  }) {
    return _then(_$SalesOrderDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerContact: freezed == customerContact
          ? _value.customerContact
          : customerContact // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerAddress: freezed == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      contractNumber: freezed == contractNumber
          ? _value.contractNumber
          : contractNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      approvalComment: freezed == approvalComment
          ? _value.approvalComment
          : approvalComment // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatusDisplay: freezed == paymentStatusDisplay
          ? _value.paymentStatusDisplay
          : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDeliveryDate: freezed == actualDeliveryDate
          ? _value.actualDeliveryDate
          : actualDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double?,
      taxAmount: freezed == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      depositAmount: freezed == depositAmount
          ? _value.depositAmount
          : depositAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAmount: freezed == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentCount: freezed == paymentCount
          ? _value.paymentCount
          : paymentCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pendingPaymentPlanCount: freezed == pendingPaymentPlanCount
          ? _value.pendingPaymentPlanCount
          : pendingPaymentPlanCount // ignore: cast_nullable_to_non_nullable
              as int?,
      pendingPaymentPlanAmount: freezed == pendingPaymentPlanAmount
          ? _value.pendingPaymentPlanAmount
          : pendingPaymentPlanAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      unpaidAmount: freezed == unpaidAmount
          ? _value.unpaidAmount
          : unpaidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      workOrderNumbers: null == workOrderNumbers
          ? _value._workOrderNumbers
          : workOrderNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deliveryOrderNumbers: null == deliveryOrderNumbers
          ? _value._deliveryOrderNumbers
          : deliveryOrderNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      invoiceNumbers: null == invoiceNumbers
          ? _value._invoiceNumbers
          : invoiceNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      workOrderSummaries: null == workOrderSummaries
          ? _value._workOrderSummaries
          : workOrderSummaries // ignore: cast_nullable_to_non_nullable
              as List<TraceabilitySummaryItem>,
      deliveryOrderSummaries: null == deliveryOrderSummaries
          ? _value._deliveryOrderSummaries
          : deliveryOrderSummaries // ignore: cast_nullable_to_non_nullable
              as List<TraceabilitySummaryItem>,
      invoiceSummaries: null == invoiceSummaries
          ? _value._invoiceSummaries
          : invoiceSummaries // ignore: cast_nullable_to_non_nullable
              as List<TraceabilitySummaryItem>,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SalesOrderItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesOrderDetailImpl implements _SalesOrderDetail {
  const _$SalesOrderDetailImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required this.orderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) this.customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
      this.customerContact,
      @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
      this.customerPhone,
      @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
      this.customerAddress,
      @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
      this.contractNumber,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
      this.approvalComment,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      this.rejectionReason,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      this.paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      this.paymentStatusDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      this.orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      this.deliveryDate,
      @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
      this.actualDeliveryDate,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) this.taxRate,
      @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
      this.taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      this.discountAmount,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      this.totalAmount,
      @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
      this.depositAmount,
      @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
      this.paidAmount,
      @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
      this.paymentDate,
      @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
      this.contactPerson,
      @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
      this.contactPhone,
      @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
      this.shippingAddress,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes,
      @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
      this.paymentCount,
      @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
      this.pendingPaymentPlanCount,
      @JsonKey(
          name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)
      this.pendingPaymentPlanAmount,
      @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
      this.unpaidAmount,
      @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
      final List<String> workOrderNumbers = const <String>[],
      @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
      final List<String> deliveryOrderNumbers = const <String>[],
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      final List<String> invoiceNumbers = const <String>[],
      @JsonKey(
          name: 'work_order_summaries',
          readValue: _readWorkOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      final List<TraceabilitySummaryItem> workOrderSummaries =
          const <TraceabilitySummaryItem>[],
      @JsonKey(
          name: 'delivery_order_summaries',
          readValue: _readDeliveryOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      final List<TraceabilitySummaryItem> deliveryOrderSummaries =
          const <TraceabilitySummaryItem>[],
      @JsonKey(
          name: 'invoice_summaries',
          readValue: _readInvoiceSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      final List<TraceabilitySummaryItem> invoiceSummaries = const <TraceabilitySummaryItem>[],
      @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson) final List<SalesOrderItem> items = const <SalesOrderItem>[]})
      : _workOrderNumbers = workOrderNumbers,
        _deliveryOrderNumbers = deliveryOrderNumbers,
        _invoiceNumbers = invoiceNumbers,
        _workOrderSummaries = workOrderSummaries,
        _deliveryOrderSummaries = deliveryOrderSummaries,
        _invoiceSummaries = invoiceSummaries,
        _items = items;

  factory _$SalesOrderDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesOrderDetailImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  final String orderNumber;
  @override
  @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
  final int? customerId;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
  final String? customerContact;
  @override
  @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
  final String? customerPhone;
  @override
  @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
  final String? customerAddress;
  @override
  @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
  final String? contractNumber;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
  final String? approvalComment;
  @override
  @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
  final String? rejectionReason;
  @override
  @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
  final String? paymentStatus;
  @override
  @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
  final String? paymentStatusDisplay;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? orderDate;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? deliveryDate;
  @override
  @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? actualDeliveryDate;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  final double? subtotal;
  @override
  @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
  final double? taxRate;
  @override
  @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
  final double? taxAmount;
  @override
  @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
  final double? discountAmount;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  final double? totalAmount;
  @override
  @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
  final double? depositAmount;
  @override
  @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
  final double? paidAmount;
  @override
  @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? paymentDate;
  @override
  @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
  final String? contactPerson;
  @override
  @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
  final String? contactPhone;
  @override
  @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
  final String? shippingAddress;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;
  @override
  @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
  final int? paymentCount;
  @override
  @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
  final int? pendingPaymentPlanCount;
  @override
  @JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)
  final double? pendingPaymentPlanAmount;
  @override
  @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
  final double? unpaidAmount;
  final List<String> _workOrderNumbers;
  @override
  @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
  List<String> get workOrderNumbers {
    if (_workOrderNumbers is EqualUnmodifiableListView)
      return _workOrderNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workOrderNumbers);
  }

  final List<String> _deliveryOrderNumbers;
  @override
  @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
  List<String> get deliveryOrderNumbers {
    if (_deliveryOrderNumbers is EqualUnmodifiableListView)
      return _deliveryOrderNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveryOrderNumbers);
  }

  final List<String> _invoiceNumbers;
  @override
  @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
  List<String> get invoiceNumbers {
    if (_invoiceNumbers is EqualUnmodifiableListView) return _invoiceNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoiceNumbers);
  }

  final List<TraceabilitySummaryItem> _workOrderSummaries;
  @override
  @JsonKey(
      name: 'work_order_summaries',
      readValue: _readWorkOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get workOrderSummaries {
    if (_workOrderSummaries is EqualUnmodifiableListView)
      return _workOrderSummaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workOrderSummaries);
  }

  final List<TraceabilitySummaryItem> _deliveryOrderSummaries;
  @override
  @JsonKey(
      name: 'delivery_order_summaries',
      readValue: _readDeliveryOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get deliveryOrderSummaries {
    if (_deliveryOrderSummaries is EqualUnmodifiableListView)
      return _deliveryOrderSummaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveryOrderSummaries);
  }

  final List<TraceabilitySummaryItem> _invoiceSummaries;
  @override
  @JsonKey(
      name: 'invoice_summaries',
      readValue: _readInvoiceSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get invoiceSummaries {
    if (_invoiceSummaries is EqualUnmodifiableListView)
      return _invoiceSummaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoiceSummaries);
  }

  final List<SalesOrderItem> _items;
  @override
  @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)
  List<SalesOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'SalesOrderDetail(id: $id, orderNumber: $orderNumber, customerId: $customerId, customerName: $customerName, customerContact: $customerContact, customerPhone: $customerPhone, customerAddress: $customerAddress, contractNumber: $contractNumber, status: $status, statusDisplay: $statusDisplay, approvalComment: $approvalComment, rejectionReason: $rejectionReason, paymentStatus: $paymentStatus, paymentStatusDisplay: $paymentStatusDisplay, orderDate: $orderDate, deliveryDate: $deliveryDate, actualDeliveryDate: $actualDeliveryDate, subtotal: $subtotal, taxRate: $taxRate, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, depositAmount: $depositAmount, paidAmount: $paidAmount, paymentDate: $paymentDate, contactPerson: $contactPerson, contactPhone: $contactPhone, shippingAddress: $shippingAddress, notes: $notes, paymentCount: $paymentCount, pendingPaymentPlanCount: $pendingPaymentPlanCount, pendingPaymentPlanAmount: $pendingPaymentPlanAmount, unpaidAmount: $unpaidAmount, workOrderNumbers: $workOrderNumbers, deliveryOrderNumbers: $deliveryOrderNumbers, invoiceNumbers: $invoiceNumbers, workOrderSummaries: $workOrderSummaries, deliveryOrderSummaries: $deliveryOrderSummaries, invoiceSummaries: $invoiceSummaries, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesOrderDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerContact, customerContact) ||
                other.customerContact == customerContact) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.contractNumber, contractNumber) ||
                other.contractNumber == contractNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.approvalComment, approvalComment) ||
                other.approvalComment == approvalComment) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentStatusDisplay, paymentStatusDisplay) ||
                other.paymentStatusDisplay == paymentStatusDisplay) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.actualDeliveryDate, actualDeliveryDate) ||
                other.actualDeliveryDate == actualDeliveryDate) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.depositAmount, depositAmount) ||
                other.depositAmount == depositAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.contactPerson, contactPerson) ||
                other.contactPerson == contactPerson) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.paymentCount, paymentCount) ||
                other.paymentCount == paymentCount) &&
            (identical(
                    other.pendingPaymentPlanCount, pendingPaymentPlanCount) ||
                other.pendingPaymentPlanCount == pendingPaymentPlanCount) &&
            (identical(
                    other.pendingPaymentPlanAmount, pendingPaymentPlanAmount) ||
                other.pendingPaymentPlanAmount == pendingPaymentPlanAmount) &&
            (identical(other.unpaidAmount, unpaidAmount) ||
                other.unpaidAmount == unpaidAmount) &&
            const DeepCollectionEquality()
                .equals(other._workOrderNumbers, _workOrderNumbers) &&
            const DeepCollectionEquality()
                .equals(other._deliveryOrderNumbers, _deliveryOrderNumbers) &&
            const DeepCollectionEquality()
                .equals(other._invoiceNumbers, _invoiceNumbers) &&
            const DeepCollectionEquality()
                .equals(other._workOrderSummaries, _workOrderSummaries) &&
            const DeepCollectionEquality().equals(
                other._deliveryOrderSummaries, _deliveryOrderSummaries) &&
            const DeepCollectionEquality()
                .equals(other._invoiceSummaries, _invoiceSummaries) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        customerId,
        customerName,
        customerContact,
        customerPhone,
        customerAddress,
        contractNumber,
        status,
        statusDisplay,
        approvalComment,
        rejectionReason,
        paymentStatus,
        paymentStatusDisplay,
        orderDate,
        deliveryDate,
        actualDeliveryDate,
        subtotal,
        taxRate,
        taxAmount,
        discountAmount,
        totalAmount,
        depositAmount,
        paidAmount,
        paymentDate,
        contactPerson,
        contactPhone,
        shippingAddress,
        notes,
        paymentCount,
        pendingPaymentPlanCount,
        pendingPaymentPlanAmount,
        unpaidAmount,
        const DeepCollectionEquality().hash(_workOrderNumbers),
        const DeepCollectionEquality().hash(_deliveryOrderNumbers),
        const DeepCollectionEquality().hash(_invoiceNumbers),
        const DeepCollectionEquality().hash(_workOrderSummaries),
        const DeepCollectionEquality().hash(_deliveryOrderSummaries),
        const DeepCollectionEquality().hash(_invoiceSummaries),
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of SalesOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesOrderDetailImplCopyWith<_$SalesOrderDetailImpl> get copyWith =>
      __$$SalesOrderDetailImplCopyWithImpl<_$SalesOrderDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesOrderDetailImplToJson(
      this,
    );
  }
}

abstract class _SalesOrderDetail implements SalesOrderDetail {
  const factory _SalesOrderDetail(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required final String orderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
      final int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
      final String? customerContact,
      @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
      final String? customerPhone,
      @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
      final String? customerAddress,
      @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
      final String? contractNumber,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
      final String? approvalComment,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      final String? rejectionReason,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      final String? paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      final String? paymentStatusDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? deliveryDate,
      @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? actualDeliveryDate,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      final double? subtotal,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
      final double? taxRate,
      @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
      final double? taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      final double? discountAmount,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      final double? totalAmount,
      @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
      final double? depositAmount,
      @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
      final double? paidAmount,
      @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? paymentDate,
      @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
      final String? contactPerson,
      @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
      final String? contactPhone,
      @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
      final String? shippingAddress,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? notes,
      @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
      final int? paymentCount,
      @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
      final int? pendingPaymentPlanCount,
      @JsonKey(
          name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)
      final double? pendingPaymentPlanAmount,
      @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
      final double? unpaidAmount,
      @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
      final List<String> workOrderNumbers,
      @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
      final List<String> deliveryOrderNumbers,
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      final List<String> invoiceNumbers,
      @JsonKey(
          name: 'work_order_summaries',
          readValue: _readWorkOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      final List<TraceabilitySummaryItem> workOrderSummaries,
      @JsonKey(
          name: 'delivery_order_summaries',
          readValue: _readDeliveryOrderSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      final List<TraceabilitySummaryItem> deliveryOrderSummaries,
      @JsonKey(
          name: 'invoice_summaries',
          readValue: _readInvoiceSummaries,
          fromJson: _traceabilitySummaryListFromJson,
          toJson: _traceabilitySummaryListToJson)
      final List<TraceabilitySummaryItem> invoiceSummaries,
      @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)
      final List<SalesOrderItem> items}) = _$SalesOrderDetailImpl;

  factory _SalesOrderDetail.fromJson(Map<String, dynamic> json) =
      _$SalesOrderDetailImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber;
  @override
  @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
  int? get customerId;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
  String? get customerContact;
  @override
  @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
  String? get customerPhone;
  @override
  @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
  String? get customerAddress;
  @override
  @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
  String? get contractNumber;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
  String? get approvalComment;
  @override
  @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
  String? get rejectionReason;
  @override
  @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
  String? get paymentStatus;
  @override
  @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
  String? get paymentStatusDisplay;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate;
  @override
  @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get actualDeliveryDate;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal;
  @override
  @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
  double? get taxRate;
  @override
  @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
  double? get taxAmount;
  @override
  @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
  double? get discountAmount;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  double? get totalAmount;
  @override
  @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
  double? get depositAmount;
  @override
  @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
  double? get paidAmount;
  @override
  @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get paymentDate;
  @override
  @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
  String? get contactPerson;
  @override
  @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
  String? get contactPhone;
  @override
  @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
  String? get shippingAddress;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;
  @override
  @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
  int? get paymentCount;
  @override
  @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
  int? get pendingPaymentPlanCount;
  @override
  @JsonKey(name: 'pending_payment_plan_amount', fromJson: _doubleOrNullFromJson)
  double? get pendingPaymentPlanAmount;
  @override
  @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
  double? get unpaidAmount;
  @override
  @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
  List<String> get workOrderNumbers;
  @override
  @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
  List<String> get deliveryOrderNumbers;
  @override
  @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
  List<String> get invoiceNumbers;
  @override
  @JsonKey(
      name: 'work_order_summaries',
      readValue: _readWorkOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get workOrderSummaries;
  @override
  @JsonKey(
      name: 'delivery_order_summaries',
      readValue: _readDeliveryOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get deliveryOrderSummaries;
  @override
  @JsonKey(
      name: 'invoice_summaries',
      readValue: _readInvoiceSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson)
  List<TraceabilitySummaryItem> get invoiceSummaries;
  @override
  @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)
  List<SalesOrderItem> get items;

  /// Create a copy of SalesOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesOrderDetailImplCopyWith<_$SalesOrderDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalesOrderItem _$SalesOrderItemFromJson(Map<String, dynamic> json) {
  return _SalesOrderItem.fromJson(json);
}

/// @nodoc
mixin _$SalesOrderItem {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product', fromJson: _intOrNullFromJson)
  int? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
  String? get productCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
  double? get deliveredQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
  double? get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
  double? get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SalesOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesOrderItemCopyWith<SalesOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesOrderItemCopyWith<$Res> {
  factory $SalesOrderItemCopyWith(
          SalesOrderItem value, $Res Function(SalesOrderItem) then) =
      _$SalesOrderItemCopyWithImpl<$Res, SalesOrderItem>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      String? productCode,
      @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) int? quantity,
      @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
      double? deliveredQuantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
      double? taxRate,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      double? discountAmount,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class _$SalesOrderItemCopyWithImpl<$Res, $Val extends SalesOrderItem>
    implements $SalesOrderItemCopyWith<$Res> {
  _$SalesOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productCode = freezed,
    Object? quantity = freezed,
    Object? deliveredQuantity = freezed,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? taxRate = freezed,
    Object? discountAmount = freezed,
    Object? subtotal = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productCode: freezed == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      deliveredQuantity: freezed == deliveredQuantity
          ? _value.deliveredQuantity
          : deliveredQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesOrderItemImplCopyWith<$Res>
    implements $SalesOrderItemCopyWith<$Res> {
  factory _$$SalesOrderItemImplCopyWith(_$SalesOrderItemImpl value,
          $Res Function(_$SalesOrderItemImpl) then) =
      __$$SalesOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      String? productCode,
      @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) int? quantity,
      @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
      double? deliveredQuantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
      double? taxRate,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      double? discountAmount,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class __$$SalesOrderItemImplCopyWithImpl<$Res>
    extends _$SalesOrderItemCopyWithImpl<$Res, _$SalesOrderItemImpl>
    implements _$$SalesOrderItemImplCopyWith<$Res> {
  __$$SalesOrderItemImplCopyWithImpl(
      _$SalesOrderItemImpl _value, $Res Function(_$SalesOrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productCode = freezed,
    Object? quantity = freezed,
    Object? deliveredQuantity = freezed,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? taxRate = freezed,
    Object? discountAmount = freezed,
    Object? subtotal = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$SalesOrderItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productCode: freezed == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      deliveredQuantity: freezed == deliveredQuantity
          ? _value.deliveredQuantity
          : deliveredQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesOrderItemImpl implements _SalesOrderItem {
  const _$SalesOrderItemImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'product', fromJson: _intOrNullFromJson) this.productId,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      this.productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      this.productCode,
      @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) this.quantity,
      @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
      this.deliveredQuantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) this.unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      this.unitPrice,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) this.taxRate,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      this.discountAmount,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal,
      @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) this.notes});

  factory _$SalesOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesOrderItemImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'product', fromJson: _intOrNullFromJson)
  final int? productId;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  final String? productName;
  @override
  @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
  final String? productCode;
  @override
  @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson)
  final int? quantity;
  @override
  @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
  final double? deliveredQuantity;
  @override
  @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
  final String? unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  final double? unitPrice;
  @override
  @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
  final double? taxRate;
  @override
  @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
  final double? discountAmount;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  final double? subtotal;
  @override
  @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson)
  final String? notes;

  @override
  String toString() {
    return 'SalesOrderItem(id: $id, productId: $productId, productName: $productName, productCode: $productCode, quantity: $quantity, deliveredQuantity: $deliveredQuantity, unit: $unit, unitPrice: $unitPrice, taxRate: $taxRate, discountAmount: $discountAmount, subtotal: $subtotal, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesOrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.deliveredQuantity, deliveredQuantity) ||
                other.deliveredQuantity == deliveredQuantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      productName,
      productCode,
      quantity,
      deliveredQuantity,
      unit,
      unitPrice,
      taxRate,
      discountAmount,
      subtotal,
      notes);

  /// Create a copy of SalesOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesOrderItemImplCopyWith<_$SalesOrderItemImpl> get copyWith =>
      __$$SalesOrderItemImplCopyWithImpl<_$SalesOrderItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesOrderItemImplToJson(
      this,
    );
  }
}

abstract class _SalesOrderItem implements SalesOrderItem {
  const factory _SalesOrderItem(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'product', fromJson: _intOrNullFromJson)
      final int? productId,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      final String? productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      final String? productCode,
      @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson)
      final int? quantity,
      @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
      final double? deliveredQuantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
      final String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      final double? unitPrice,
      @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
      final double? taxRate,
      @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
      final double? discountAmount,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      final double? subtotal,
      @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson)
      final String? notes}) = _$SalesOrderItemImpl;

  factory _SalesOrderItem.fromJson(Map<String, dynamic> json) =
      _$SalesOrderItemImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'product', fromJson: _intOrNullFromJson)
  int? get productId;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName;
  @override
  @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
  String? get productCode;
  @override
  @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson)
  int? get quantity;
  @override
  @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
  double? get deliveredQuantity;
  @override
  @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
  String? get unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice;
  @override
  @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson)
  double? get taxRate;
  @override
  @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
  double? get discountAmount;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal;
  @override
  @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson)
  String? get notes;

  /// Create a copy of SalesOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesOrderItemImplCopyWith<_$SalesOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
