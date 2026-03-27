// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeliveryOrder _$DeliveryOrderFromJson(Map<String, dynamic> json) {
  return _DeliveryOrder.fromJson(json);
}

/// @nodoc
mixin _$DeliveryOrder {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson, name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'customer_id',
      readValue: _readCustomerId,
      fromJson: _intOrNullFromJson)
  int? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'sales_order_id',
      readValue: _readSalesOrderId,
      fromJson: _intOrNullFromJson)
  int? get salesOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  int? get itemsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
  double? get totalQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
  int? get invoiceCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
  String? get logisticsCompany => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
  String? get trackingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
  String? get exceptionResolution => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
  String? get exceptionResolutionDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
  String? get exceptionResolutionNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
  bool? get exceptionClosed => throw _privateConstructorUsedError;

  /// Serializes this DeliveryOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryOrderCopyWith<DeliveryOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryOrderCopyWith<$Res> {
  factory $DeliveryOrderCopyWith(
          DeliveryOrder value, $Res Function(DeliveryOrder) then) =
      _$DeliveryOrderCopyWithImpl<$Res, DeliveryOrder>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson, name: 'order_number')
      String orderNumber,
      @JsonKey(
          name: 'customer_id',
          readValue: _readCustomerId,
          fromJson: _intOrNullFromJson)
      int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(
          name: 'sales_order_id',
          readValue: _readSalesOrderId,
          fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      int? itemsCount,
      @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
      double? totalQuantity,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      int? invoiceCount,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      String? logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      String? trackingNumber,
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
class _$DeliveryOrderCopyWithImpl<$Res, $Val extends DeliveryOrder>
    implements $DeliveryOrderCopyWith<$Res> {
  _$DeliveryOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? deliveryDate = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? itemsCount = freezed,
    Object? totalQuantity = freezed,
    Object? invoiceCount = freezed,
    Object? logisticsCompany = freezed,
    Object? trackingNumber = freezed,
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
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalQuantity: freezed == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      invoiceCount: freezed == invoiceCount
          ? _value.invoiceCount
          : invoiceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      logisticsCompany: freezed == logisticsCompany
          ? _value.logisticsCompany
          : logisticsCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$DeliveryOrderImplCopyWith<$Res>
    implements $DeliveryOrderCopyWith<$Res> {
  factory _$$DeliveryOrderImplCopyWith(
          _$DeliveryOrderImpl value, $Res Function(_$DeliveryOrderImpl) then) =
      __$$DeliveryOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson, name: 'order_number')
      String orderNumber,
      @JsonKey(
          name: 'customer_id',
          readValue: _readCustomerId,
          fromJson: _intOrNullFromJson)
      int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(
          name: 'sales_order_id',
          readValue: _readSalesOrderId,
          fromJson: _intOrNullFromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      int? itemsCount,
      @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
      double? totalQuantity,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      int? invoiceCount,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      String? logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      String? trackingNumber,
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
class __$$DeliveryOrderImplCopyWithImpl<$Res>
    extends _$DeliveryOrderCopyWithImpl<$Res, _$DeliveryOrderImpl>
    implements _$$DeliveryOrderImplCopyWith<$Res> {
  __$$DeliveryOrderImplCopyWithImpl(
      _$DeliveryOrderImpl _value, $Res Function(_$DeliveryOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
    Object? deliveryDate = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? itemsCount = freezed,
    Object? totalQuantity = freezed,
    Object? invoiceCount = freezed,
    Object? logisticsCompany = freezed,
    Object? trackingNumber = freezed,
    Object? exceptionResolution = freezed,
    Object? exceptionResolutionDisplay = freezed,
    Object? exceptionResolutionNotes = freezed,
    Object? exceptionClosed = freezed,
  }) {
    return _then(_$DeliveryOrderImpl(
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
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalQuantity: freezed == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      invoiceCount: freezed == invoiceCount
          ? _value.invoiceCount
          : invoiceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      logisticsCompany: freezed == logisticsCompany
          ? _value.logisticsCompany
          : logisticsCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$DeliveryOrderImpl implements _DeliveryOrder {
  const _$DeliveryOrderImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(fromJson: _stringFromJson, name: 'order_number')
      required this.orderNumber,
      @JsonKey(
          name: 'customer_id',
          readValue: _readCustomerId,
          fromJson: _intOrNullFromJson)
      this.customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(
          name: 'sales_order_id',
          readValue: _readSalesOrderId,
          fromJson: _intOrNullFromJson)
      this.salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      this.salesOrderNumber,
      @JsonKey(
          name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      this.deliveryDate,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(
          name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      this.itemsCount,
      @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
      this.totalQuantity,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      this.invoiceCount,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      this.logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      this.trackingNumber,
      @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
      this.exceptionResolution,
      @JsonKey(
          name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
      this.exceptionResolutionDisplay,
      @JsonKey(
          name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
      this.exceptionResolutionNotes,
      @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
      this.exceptionClosed});

  factory _$DeliveryOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryOrderImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(fromJson: _stringFromJson, name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey(
      name: 'customer_id',
      readValue: _readCustomerId,
      fromJson: _intOrNullFromJson)
  final int? customerId;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(
      name: 'sales_order_id',
      readValue: _readSalesOrderId,
      fromJson: _intOrNullFromJson)
  final int? salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  final String? salesOrderNumber;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? deliveryDate;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  final int? itemsCount;
  @override
  @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
  final double? totalQuantity;
  @override
  @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
  final int? invoiceCount;
  @override
  @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
  final String? logisticsCompany;
  @override
  @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
  final String? trackingNumber;
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
    return 'DeliveryOrder(id: $id, orderNumber: $orderNumber, customerId: $customerId, customerName: $customerName, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber, deliveryDate: $deliveryDate, status: $status, statusDisplay: $statusDisplay, itemsCount: $itemsCount, totalQuantity: $totalQuantity, invoiceCount: $invoiceCount, logisticsCompany: $logisticsCompany, trackingNumber: $trackingNumber, exceptionResolution: $exceptionResolution, exceptionResolutionDisplay: $exceptionResolutionDisplay, exceptionResolutionNotes: $exceptionResolutionNotes, exceptionClosed: $exceptionClosed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.salesOrderId, salesOrderId) ||
                other.salesOrderId == salesOrderId) &&
            (identical(other.salesOrderNumber, salesOrderNumber) ||
                other.salesOrderNumber == salesOrderNumber) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.invoiceCount, invoiceCount) ||
                other.invoiceCount == invoiceCount) &&
            (identical(other.logisticsCompany, logisticsCompany) ||
                other.logisticsCompany == logisticsCompany) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      customerId,
      customerName,
      salesOrderId,
      salesOrderNumber,
      deliveryDate,
      status,
      statusDisplay,
      itemsCount,
      totalQuantity,
      invoiceCount,
      logisticsCompany,
      trackingNumber,
      exceptionResolution,
      exceptionResolutionDisplay,
      exceptionResolutionNotes,
      exceptionClosed);

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryOrderImplCopyWith<_$DeliveryOrderImpl> get copyWith =>
      __$$DeliveryOrderImplCopyWithImpl<_$DeliveryOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryOrderImplToJson(
      this,
    );
  }
}

abstract class _DeliveryOrder implements DeliveryOrder {
  const factory _DeliveryOrder(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(fromJson: _stringFromJson, name: 'order_number')
      required final String orderNumber,
      @JsonKey(
          name: 'customer_id',
          readValue: _readCustomerId,
          fromJson: _intOrNullFromJson)
      final int? customerId,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(
          name: 'sales_order_id',
          readValue: _readSalesOrderId,
          fromJson: _intOrNullFromJson)
      final int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      final String? salesOrderNumber,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? deliveryDate,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      final int? itemsCount,
      @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
      final double? totalQuantity,
      @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
      final int? invoiceCount,
      @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
      final String? logisticsCompany,
      @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
      final String? trackingNumber,
      @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
      final String? exceptionResolution,
      @JsonKey(
          name: 'exception_resolution_display', fromJson: _stringOrNullFromJson)
      final String? exceptionResolutionDisplay,
      @JsonKey(
          name: 'exception_resolution_notes', fromJson: _stringOrNullFromJson)
      final String? exceptionResolutionNotes,
      @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
      final bool? exceptionClosed}) = _$DeliveryOrderImpl;

  factory _DeliveryOrder.fromJson(Map<String, dynamic> json) =
      _$DeliveryOrderImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(fromJson: _stringFromJson, name: 'order_number')
  String get orderNumber;
  @override
  @JsonKey(
      name: 'customer_id',
      readValue: _readCustomerId,
      fromJson: _intOrNullFromJson)
  int? get customerId;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(
      name: 'sales_order_id',
      readValue: _readSalesOrderId,
      fromJson: _intOrNullFromJson)
  int? get salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  int? get itemsCount;
  @override
  @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
  double? get totalQuantity;
  @override
  @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
  int? get invoiceCount;
  @override
  @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
  String? get logisticsCompany;
  @override
  @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
  String? get trackingNumber;
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

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryOrderImplCopyWith<_$DeliveryOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
