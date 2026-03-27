// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalesOrder _$SalesOrderFromJson(Map<String, dynamic> json) {
  return _SalesOrder.fromJson(json);
}

/// @nodoc
mixin _$SalesOrder {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
  String? get customerCode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
  String? get paymentStatusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  double? get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  int? get itemsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
  int? get workOrderCount => throw _privateConstructorUsedError;

  /// Serializes this SalesOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesOrderCopyWith<SalesOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesOrderCopyWith<$Res> {
  factory $SalesOrderCopyWith(
          SalesOrder value, $Res Function(SalesOrder) then) =
      _$SalesOrderCopyWithImpl<$Res, SalesOrder>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
      String? customerCode,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      String? paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      String? paymentStatusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      int? itemsCount,
      @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
      int? workOrderCount});
}

/// @nodoc
class _$SalesOrderCopyWithImpl<$Res, $Val extends SalesOrder>
    implements $SalesOrderCopyWith<$Res> {
  _$SalesOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? customerCode = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? paymentStatus = freezed,
    Object? paymentStatusDisplay = freezed,
    Object? totalAmount = freezed,
    Object? orderDate = freezed,
    Object? deliveryDate = freezed,
    Object? itemsCount = freezed,
    Object? workOrderCount = freezed,
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
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerCode: freezed == customerCode
          ? _value.customerCode
          : customerCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatusDisplay: freezed == paymentStatusDisplay
          ? _value.paymentStatusDisplay
          : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      workOrderCount: freezed == workOrderCount
          ? _value.workOrderCount
          : workOrderCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesOrderImplCopyWith<$Res>
    implements $SalesOrderCopyWith<$Res> {
  factory _$$SalesOrderImplCopyWith(
          _$SalesOrderImpl value, $Res Function(_$SalesOrderImpl) then) =
      __$$SalesOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
      String? customerCode,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      String? paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      String? paymentStatusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      int? itemsCount,
      @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
      int? workOrderCount});
}

/// @nodoc
class __$$SalesOrderImplCopyWithImpl<$Res>
    extends _$SalesOrderCopyWithImpl<$Res, _$SalesOrderImpl>
    implements _$$SalesOrderImplCopyWith<$Res> {
  __$$SalesOrderImplCopyWithImpl(
      _$SalesOrderImpl _value, $Res Function(_$SalesOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? customerCode = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? paymentStatus = freezed,
    Object? paymentStatusDisplay = freezed,
    Object? totalAmount = freezed,
    Object? orderDate = freezed,
    Object? deliveryDate = freezed,
    Object? itemsCount = freezed,
    Object? workOrderCount = freezed,
  }) {
    return _then(_$SalesOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerCode: freezed == customerCode
          ? _value.customerCode
          : customerCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatusDisplay: freezed == paymentStatusDisplay
          ? _value.paymentStatusDisplay
          : paymentStatusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      workOrderCount: freezed == workOrderCount
          ? _value.workOrderCount
          : workOrderCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesOrderImpl implements _SalesOrder {
  const _$SalesOrderImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required this.orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
      this.customerCode,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      this.paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      this.paymentStatusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      this.totalAmount,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      this.orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      this.deliveryDate,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      this.itemsCount,
      @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
      this.workOrderCount});

  factory _$SalesOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesOrderImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  final String orderNumber;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
  final String? customerCode;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
  final String? paymentStatus;
  @override
  @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
  final String? paymentStatusDisplay;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  final double? totalAmount;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? orderDate;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? deliveryDate;
  @override
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  final int? itemsCount;
  @override
  @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
  final int? workOrderCount;

  @override
  String toString() {
    return 'SalesOrder(id: $id, orderNumber: $orderNumber, customerName: $customerName, customerCode: $customerCode, status: $status, statusDisplay: $statusDisplay, paymentStatus: $paymentStatus, paymentStatusDisplay: $paymentStatusDisplay, totalAmount: $totalAmount, orderDate: $orderDate, deliveryDate: $deliveryDate, itemsCount: $itemsCount, workOrderCount: $workOrderCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentStatusDisplay, paymentStatusDisplay) ||
                other.paymentStatusDisplay == paymentStatusDisplay) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.workOrderCount, workOrderCount) ||
                other.workOrderCount == workOrderCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      customerName,
      customerCode,
      status,
      statusDisplay,
      paymentStatus,
      paymentStatusDisplay,
      totalAmount,
      orderDate,
      deliveryDate,
      itemsCount,
      workOrderCount);

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesOrderImplCopyWith<_$SalesOrderImpl> get copyWith =>
      __$$SalesOrderImplCopyWithImpl<_$SalesOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesOrderImplToJson(
      this,
    );
  }
}

abstract class _SalesOrder implements SalesOrder {
  const factory _SalesOrder(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required final String orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
      final String? customerCode,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
      final String? paymentStatus,
      @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
      final String? paymentStatusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      final double? totalAmount,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? deliveryDate,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      final int? itemsCount,
      @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
      final int? workOrderCount}) = _$SalesOrderImpl;

  factory _SalesOrder.fromJson(Map<String, dynamic> json) =
      _$SalesOrderImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
  String? get customerCode;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
  String? get paymentStatus;
  @override
  @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
  String? get paymentStatusDisplay;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  double? get totalAmount;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate;
  @override
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  int? get itemsCount;
  @override
  @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
  int? get workOrderCount;

  /// Create a copy of SalesOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesOrderImplCopyWith<_$SalesOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
