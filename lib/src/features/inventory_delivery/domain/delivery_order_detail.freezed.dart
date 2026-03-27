// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeliveryOrderDetail _$DeliveryOrderDetailFromJson(Map<String, dynamic> json) {
  return _DeliveryOrderDetail.fromJson(json);
}

/// @nodoc
mixin _$DeliveryOrderDetail {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  int? get salesOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
  int? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
  String? get receiverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
  String? get receiverPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
  String? get deliveryAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
  String? get logisticsCompany => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
  String? get trackingNumber => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get freight => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
  int? get packageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
  double? get packageWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get receivedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
  String? get receivedNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
  String? get receiverSignatureUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
  int? get invoiceCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
  List<String> get invoiceNumbers => throw _privateConstructorUsedError;
  @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
  List<DeliveryOrderItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
  String? get exceptionResolution => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
  String? get exceptionResolutionDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
  String? get exceptionResolutionNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
  bool? get exceptionClosed => throw _privateConstructorUsedError;

  /// Serializes this DeliveryOrderDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryOrderDetailCopyWith<DeliveryOrderDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryOrderDetailCopyWith<$Res> {
  factory $DeliveryOrderDetailCopyWith(
          DeliveryOrderDetail value, $Res Function(DeliveryOrderDetail) then) =
      _$DeliveryOrderDetailCopyWithImpl<$Res, DeliveryOrderDetail>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
      String? receiverName,
      @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
      String? receiverPhone,
      @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
      String? deliveryAddress,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      String? logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      String? trackingNumber,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? freight,
      @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
      int? packageCount,
      @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
      double? packageWeight,
      @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? receivedDate,
      @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
      String? receivedNotes,
      @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
      String? receiverSignatureUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      int? invoiceCount,
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      List<String> invoiceNumbers,
      @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
      List<DeliveryOrderItem> items,
      @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
      String? exceptionResolution,
      @JsonKey(
          name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
      String? exceptionResolutionDisplay,
      @JsonKey(
          name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
      String? exceptionResolutionNotes,
      @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
      bool? exceptionClosed});
}

/// @nodoc
class _$DeliveryOrderDetailCopyWithImpl<$Res, $Val extends DeliveryOrderDetail>
    implements $DeliveryOrderDetailCopyWith<$Res> {
  _$DeliveryOrderDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? deliveryDate = freezed,
    Object? receiverName = freezed,
    Object? receiverPhone = freezed,
    Object? deliveryAddress = freezed,
    Object? logisticsCompany = freezed,
    Object? trackingNumber = freezed,
    Object? freight = freezed,
    Object? packageCount = freezed,
    Object? packageWeight = freezed,
    Object? receivedDate = freezed,
    Object? receivedNotes = freezed,
    Object? receiverSignatureUrl = freezed,
    Object? notes = freezed,
    Object? invoiceCount = freezed,
    Object? invoiceNumbers = null,
    Object? items = null,
    Object? exceptionResolution = freezed,
    Object? exceptionResolutionDisplay = freezed,
    Object? exceptionResolutionNotes = freezed,
    Object? exceptionClosed = freezed,
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
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receiverName: freezed == receiverName
          ? _value.receiverName
          : receiverName // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverPhone: freezed == receiverPhone
          ? _value.receiverPhone
          : receiverPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryAddress: freezed == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      logisticsCompany: freezed == logisticsCompany
          ? _value.logisticsCompany
          : logisticsCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      freight: freezed == freight
          ? _value.freight
          : freight // ignore: cast_nullable_to_non_nullable
              as double?,
      packageCount: freezed == packageCount
          ? _value.packageCount
          : packageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      packageWeight: freezed == packageWeight
          ? _value.packageWeight
          : packageWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      receivedDate: freezed == receivedDate
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receivedNotes: freezed == receivedNotes
          ? _value.receivedNotes
          : receivedNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverSignatureUrl: freezed == receiverSignatureUrl
          ? _value.receiverSignatureUrl
          : receiverSignatureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceCount: freezed == invoiceCount
          ? _value.invoiceCount
          : invoiceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumbers: null == invoiceNumbers
          ? _value.invoiceNumbers
          : invoiceNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<DeliveryOrderItem>,
      exceptionResolution: freezed == exceptionResolution
          ? _value.exceptionResolution
          : exceptionResolution // ignore: cast_nullable_to_non_nullable
              as String?,
      exceptionResolutionDisplay: freezed == exceptionResolutionDisplay
          ? _value.exceptionResolutionDisplay
          : exceptionResolutionDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      exceptionResolutionNotes: freezed == exceptionResolutionNotes
          ? _value.exceptionResolutionNotes
          : exceptionResolutionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      exceptionClosed: freezed == exceptionClosed
          ? _value.exceptionClosed
          : exceptionClosed // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryOrderDetailImplCopyWith<$Res>
    implements $DeliveryOrderDetailCopyWith<$Res> {
  factory _$$DeliveryOrderDetailImplCopyWith(_$DeliveryOrderDetailImpl value,
          $Res Function(_$DeliveryOrderDetailImpl) then) =
      __$$DeliveryOrderDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
      String? receiverName,
      @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
      String? receiverPhone,
      @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
      String? deliveryAddress,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      String? logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      String? trackingNumber,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? freight,
      @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
      int? packageCount,
      @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
      double? packageWeight,
      @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? receivedDate,
      @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
      String? receivedNotes,
      @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
      String? receiverSignatureUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      int? invoiceCount,
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      List<String> invoiceNumbers,
      @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
      List<DeliveryOrderItem> items,
      @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
      String? exceptionResolution,
      @JsonKey(
          name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
      String? exceptionResolutionDisplay,
      @JsonKey(
          name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
      String? exceptionResolutionNotes,
      @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
      bool? exceptionClosed});
}

/// @nodoc
class __$$DeliveryOrderDetailImplCopyWithImpl<$Res>
    extends _$DeliveryOrderDetailCopyWithImpl<$Res, _$DeliveryOrderDetailImpl>
    implements _$$DeliveryOrderDetailImplCopyWith<$Res> {
  __$$DeliveryOrderDetailImplCopyWithImpl(_$DeliveryOrderDetailImpl _value,
      $Res Function(_$DeliveryOrderDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliveryOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? deliveryDate = freezed,
    Object? receiverName = freezed,
    Object? receiverPhone = freezed,
    Object? deliveryAddress = freezed,
    Object? logisticsCompany = freezed,
    Object? trackingNumber = freezed,
    Object? freight = freezed,
    Object? packageCount = freezed,
    Object? packageWeight = freezed,
    Object? receivedDate = freezed,
    Object? receivedNotes = freezed,
    Object? receiverSignatureUrl = freezed,
    Object? notes = freezed,
    Object? invoiceCount = freezed,
    Object? invoiceNumbers = null,
    Object? items = null,
    Object? exceptionResolution = freezed,
    Object? exceptionResolutionDisplay = freezed,
    Object? exceptionResolutionNotes = freezed,
    Object? exceptionClosed = freezed,
  }) {
    return _then(_$DeliveryOrderDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receiverName: freezed == receiverName
          ? _value.receiverName
          : receiverName // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverPhone: freezed == receiverPhone
          ? _value.receiverPhone
          : receiverPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryAddress: freezed == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      logisticsCompany: freezed == logisticsCompany
          ? _value.logisticsCompany
          : logisticsCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      freight: freezed == freight
          ? _value.freight
          : freight // ignore: cast_nullable_to_non_nullable
              as double?,
      packageCount: freezed == packageCount
          ? _value.packageCount
          : packageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      packageWeight: freezed == packageWeight
          ? _value.packageWeight
          : packageWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      receivedDate: freezed == receivedDate
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receivedNotes: freezed == receivedNotes
          ? _value.receivedNotes
          : receivedNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverSignatureUrl: freezed == receiverSignatureUrl
          ? _value.receiverSignatureUrl
          : receiverSignatureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceCount: freezed == invoiceCount
          ? _value.invoiceCount
          : invoiceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumbers: null == invoiceNumbers
          ? _value._invoiceNumbers
          : invoiceNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<DeliveryOrderItem>,
      exceptionResolution: freezed == exceptionResolution
          ? _value.exceptionResolution
          : exceptionResolution // ignore: cast_nullable_to_non_nullable
              as String?,
      exceptionResolutionDisplay: freezed == exceptionResolutionDisplay
          ? _value.exceptionResolutionDisplay
          : exceptionResolutionDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      exceptionResolutionNotes: freezed == exceptionResolutionNotes
          ? _value.exceptionResolutionNotes
          : exceptionResolutionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      exceptionClosed: freezed == exceptionClosed
          ? _value.exceptionClosed
          : exceptionClosed // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryOrderDetailImpl implements _DeliveryOrderDetail {
  const _$DeliveryOrderDetailImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required this.orderNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      this.salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      this.salesOrderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) this.customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      this.deliveryDate,
      @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
      this.receiverName,
      @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
      this.receiverPhone,
      @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
      this.deliveryAddress,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      this.logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      this.trackingNumber,
      @JsonKey(fromJson: _doubleOrNullFromJson) this.freight,
      @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
      this.packageCount,
      @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
      this.packageWeight,
      @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
      this.receivedDate,
      @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
      this.receivedNotes,
      @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
      this.receiverSignatureUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      this.invoiceCount,
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      final List<String> invoiceNumbers = const <String>[],
      @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
      final List<DeliveryOrderItem> items = const <DeliveryOrderItem>[],
      @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
      this.exceptionResolution,
      @JsonKey(
          name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
      this.exceptionResolutionDisplay,
      @JsonKey(
          name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
      this.exceptionResolutionNotes,
      @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
      this.exceptionClosed})
      : _invoiceNumbers = invoiceNumbers,
        _items = items;

  factory _$DeliveryOrderDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryOrderDetailImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  final String orderNumber;
  @override
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  final int? salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  final String? salesOrderNumber;
  @override
  @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
  final int? customerId;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? deliveryDate;
  @override
  @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
  final String? receiverName;
  @override
  @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
  final String? receiverPhone;
  @override
  @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
  final String? deliveryAddress;
  @override
  @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
  final String? logisticsCompany;
  @override
  @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
  final String? trackingNumber;
  @override
  @JsonKey(fromJson: _doubleOrNullFromJson)
  final double? freight;
  @override
  @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
  final int? packageCount;
  @override
  @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
  final double? packageWeight;
  @override
  @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? receivedDate;
  @override
  @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
  final String? receivedNotes;
  @override
  @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
  final String? receiverSignatureUrl;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;
  @override
  @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
  final int? invoiceCount;
  final List<String> _invoiceNumbers;
  @override
  @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
  List<String> get invoiceNumbers {
    if (_invoiceNumbers is EqualUnmodifiableListView) return _invoiceNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoiceNumbers);
  }

  final List<DeliveryOrderItem> _items;
  @override
  @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
  List<DeliveryOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
  final String? exceptionResolution;
  @override
  @JsonKey(
      name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
  final String? exceptionResolutionDisplay;
  @override
  @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
  final String? exceptionResolutionNotes;
  @override
  @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
  final bool? exceptionClosed;

  @override
  String toString() {
    return 'DeliveryOrderDetail(id: $id, orderNumber: $orderNumber, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, customerId: $customerId, customerName: $customerName, status: $status, statusDisplay: $statusDisplay, deliveryDate: $deliveryDate, receiverName: $receiverName, receiverPhone: $receiverPhone, deliveryAddress: $deliveryAddress, logisticsCompany: $logisticsCompany, trackingNumber: $trackingNumber, freight: $freight, packageCount: $packageCount, packageWeight: $packageWeight, receivedDate: $receivedDate, receivedNotes: $receivedNotes, receiverSignatureUrl: $receiverSignatureUrl, notes: $notes, invoiceCount: $invoiceCount, invoiceNumbers: $invoiceNumbers, items: $items, exceptionResolution: $exceptionResolution, exceptionResolutionDisplay: $exceptionResolutionDisplay, exceptionResolutionNotes: $exceptionResolutionNotes, exceptionClosed: $exceptionClosed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryOrderDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.salesOrderId, salesOrderId) ||
                other.salesOrderId == salesOrderId) &&
            (identical(other.salesOrderNumber, salesOrderNumber) ||
                other.salesOrderNumber == salesOrderNumber) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.receiverName, receiverName) ||
                other.receiverName == receiverName) &&
            (identical(other.receiverPhone, receiverPhone) ||
                other.receiverPhone == receiverPhone) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.logisticsCompany, logisticsCompany) ||
                other.logisticsCompany == logisticsCompany) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.freight, freight) || other.freight == freight) &&
            (identical(other.packageCount, packageCount) ||
                other.packageCount == packageCount) &&
            (identical(other.packageWeight, packageWeight) ||
                other.packageWeight == packageWeight) &&
            (identical(other.receivedDate, receivedDate) ||
                other.receivedDate == receivedDate) &&
            (identical(other.receivedNotes, receivedNotes) ||
                other.receivedNotes == receivedNotes) &&
            (identical(other.receiverSignatureUrl, receiverSignatureUrl) ||
                other.receiverSignatureUrl == receiverSignatureUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.invoiceCount, invoiceCount) ||
                other.invoiceCount == invoiceCount) &&
            const DeepCollectionEquality()
                .equals(other._invoiceNumbers, _invoiceNumbers) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.exceptionResolution, exceptionResolution) ||
                other.exceptionResolution == exceptionResolution) &&
            (identical(other.exceptionResolutionDisplay,
                    exceptionResolutionDisplay) ||
                other.exceptionResolutionDisplay ==
                    exceptionResolutionDisplay) &&
            (identical(
                    other.exceptionResolutionNotes, exceptionResolutionNotes) ||
                other.exceptionResolutionNotes == exceptionResolutionNotes) &&
            (identical(other.exceptionClosed, exceptionClosed) ||
                other.exceptionClosed == exceptionClosed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        salesOrderId,
        salesOrderNumber,
        customerId,
        customerName,
        status,
        statusDisplay,
        deliveryDate,
        receiverName,
        receiverPhone,
        deliveryAddress,
        logisticsCompany,
        trackingNumber,
        freight,
        packageCount,
        packageWeight,
        receivedDate,
        receivedNotes,
        receiverSignatureUrl,
        notes,
        invoiceCount,
        const DeepCollectionEquality().hash(_invoiceNumbers),
        const DeepCollectionEquality().hash(_items),
        exceptionResolution,
        exceptionResolutionDisplay,
        exceptionResolutionNotes,
        exceptionClosed
      ]);

  /// Create a copy of DeliveryOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryOrderDetailImplCopyWith<_$DeliveryOrderDetailImpl> get copyWith =>
      __$$DeliveryOrderDetailImplCopyWithImpl<_$DeliveryOrderDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryOrderDetailImplToJson(
      this,
    );
  }
}

abstract class _DeliveryOrderDetail implements DeliveryOrderDetail {
  const factory _DeliveryOrderDetail(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required final String orderNumber,
      @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
      final int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      final String? salesOrderNumber,
      @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
      final int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? deliveryDate,
      @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
      final String? receiverName,
      @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
      final String? receiverPhone,
      @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
      final String? deliveryAddress,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      final String? logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      final String? trackingNumber,
      @JsonKey(fromJson: _doubleOrNullFromJson) final double? freight,
      @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
      final int? packageCount,
      @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
      final double? packageWeight,
      @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? receivedDate,
      @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
      final String? receivedNotes,
      @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
      final String? receiverSignatureUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? notes,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      final int? invoiceCount,
      @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
      final List<String> invoiceNumbers,
      @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
      final List<DeliveryOrderItem> items,
      @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
      final String? exceptionResolution,
      @JsonKey(
          name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
      final String? exceptionResolutionDisplay,
      @JsonKey(
          name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
      final String? exceptionResolutionNotes,
      @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
      final bool? exceptionClosed}) = _$DeliveryOrderDetailImpl;

  factory _DeliveryOrderDetail.fromJson(Map<String, dynamic> json) =
      _$DeliveryOrderDetailImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber;
  @override
  @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
  int? get salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber;
  @override
  @JsonKey(name: 'customer', fromJson: _intOrNullFromJson)
  int? get customerId;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate;
  @override
  @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
  String? get receiverName;
  @override
  @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
  String? get receiverPhone;
  @override
  @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
  String? get deliveryAddress;
  @override
  @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
  String? get logisticsCompany;
  @override
  @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
  String? get trackingNumber;
  @override
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get freight;
  @override
  @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
  int? get packageCount;
  @override
  @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
  double? get packageWeight;
  @override
  @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get receivedDate;
  @override
  @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
  String? get receivedNotes;
  @override
  @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
  String? get receiverSignatureUrl;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;
  @override
  @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
  int? get invoiceCount;
  @override
  @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
  List<String> get invoiceNumbers;
  @override
  @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
  List<DeliveryOrderItem> get items;
  @override
  @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
  String? get exceptionResolution;
  @override
  @JsonKey(
      name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
  String? get exceptionResolutionDisplay;
  @override
  @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
  String? get exceptionResolutionNotes;
  @override
  @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
  bool? get exceptionClosed;

  /// Create a copy of DeliveryOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryOrderDetailImplCopyWith<_$DeliveryOrderDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryOrderItem _$DeliveryOrderItemFromJson(Map<String, dynamic> json) {
  return _DeliveryOrderItem.fromJson(json);
}

/// @nodoc
mixin _$DeliveryOrderItem {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product', fromJson: _intOrNullFromJson)
  int? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
  String? get productCode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get quantity => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
  String? get stockBatch => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this DeliveryOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryOrderItemCopyWith<DeliveryOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryOrderItemCopyWith<$Res> {
  factory $DeliveryOrderItemCopyWith(
          DeliveryOrderItem value, $Res Function(DeliveryOrderItem) then) =
      _$DeliveryOrderItemCopyWithImpl<$Res, DeliveryOrderItem>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      String? productCode,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
      @JsonKey(fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
      String? stockBatch,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class _$DeliveryOrderItemCopyWithImpl<$Res, $Val extends DeliveryOrderItem>
    implements $DeliveryOrderItemCopyWith<$Res> {
  _$DeliveryOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productCode = freezed,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? subtotal = freezed,
    Object? stockBatch = freezed,
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
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      stockBatch: freezed == stockBatch
          ? _value.stockBatch
          : stockBatch // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryOrderItemImplCopyWith<$Res>
    implements $DeliveryOrderItemCopyWith<$Res> {
  factory _$$DeliveryOrderItemImplCopyWith(_$DeliveryOrderItemImpl value,
          $Res Function(_$DeliveryOrderItemImpl) then) =
      __$$DeliveryOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      String? productCode,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
      @JsonKey(fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
      String? stockBatch,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class __$$DeliveryOrderItemImplCopyWithImpl<$Res>
    extends _$DeliveryOrderItemCopyWithImpl<$Res, _$DeliveryOrderItemImpl>
    implements _$$DeliveryOrderItemImplCopyWith<$Res> {
  __$$DeliveryOrderItemImplCopyWithImpl(_$DeliveryOrderItemImpl _value,
      $Res Function(_$DeliveryOrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliveryOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productCode = freezed,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? unitPrice = freezed,
    Object? subtotal = freezed,
    Object? stockBatch = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$DeliveryOrderItemImpl(
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
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      stockBatch: freezed == stockBatch
          ? _value.stockBatch
          : stockBatch // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryOrderItemImpl implements _DeliveryOrderItem {
  const _$DeliveryOrderItemImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'product', fromJson: _intOrNullFromJson) this.productId,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      this.productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      this.productCode,
      @JsonKey(fromJson: _doubleOrNullFromJson) this.quantity,
      @JsonKey(fromJson: _stringOrNullFromJson) this.unit,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      this.unitPrice,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal,
      @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
      this.stockBatch,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes});

  factory _$DeliveryOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryOrderItemImplFromJson(json);

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
  @JsonKey(fromJson: _doubleOrNullFromJson)
  final double? quantity;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  final double? unitPrice;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  final double? subtotal;
  @override
  @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
  final String? stockBatch;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;

  @override
  String toString() {
    return 'DeliveryOrderItem(id: $id, productId: $productId, productName: $productName, productCode: $productCode, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, subtotal: $subtotal, stockBatch: $stockBatch, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryOrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.stockBatch, stockBatch) ||
                other.stockBatch == stockBatch) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, productId, productName,
      productCode, quantity, unit, unitPrice, subtotal, stockBatch, notes);

  /// Create a copy of DeliveryOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryOrderItemImplCopyWith<_$DeliveryOrderItemImpl> get copyWith =>
      __$$DeliveryOrderItemImplCopyWithImpl<_$DeliveryOrderItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryOrderItemImplToJson(
      this,
    );
  }
}

abstract class _DeliveryOrderItem implements DeliveryOrderItem {
  const factory _DeliveryOrderItem(
          {@JsonKey(fromJson: _intFromJson) required final int id,
          @JsonKey(name: 'product', fromJson: _intOrNullFromJson)
          final int? productId,
          @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
          final String? productName,
          @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
          final String? productCode,
          @JsonKey(fromJson: _doubleOrNullFromJson) final double? quantity,
          @JsonKey(fromJson: _stringOrNullFromJson) final String? unit,
          @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
          final double? unitPrice,
          @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
          final double? subtotal,
          @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
          final String? stockBatch,
          @JsonKey(fromJson: _stringOrNullFromJson) final String? notes}) =
      _$DeliveryOrderItemImpl;

  factory _DeliveryOrderItem.fromJson(Map<String, dynamic> json) =
      _$DeliveryOrderItemImpl.fromJson;

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
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get quantity;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal;
  @override
  @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
  String? get stockBatch;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;

  /// Create a copy of DeliveryOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryOrderItemImplCopyWith<_$DeliveryOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
