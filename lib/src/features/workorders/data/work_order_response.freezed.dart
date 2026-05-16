// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkOrderResponse _$WorkOrderResponseFromJson(Map<String, dynamic> json) {
  return _WorkOrderResponse.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderResponse {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
  String? get salespersonName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleOrNull_fromJson)
  double? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'status', fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)
  String? get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
  String? get priorityDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
  double? get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
  String? get approvalStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
  String? get approvalStatusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
  String? get managerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
  int? get progressPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
  int? get totalTaskCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
  int? get salesOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber => throw _privateConstructorUsedError;

  /// Serializes this WorkOrderResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderResponseCopyWith<WorkOrderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderResponseCopyWith<$Res> {
  factory $WorkOrderResponseCopyWith(
          WorkOrderResponse value, $Res Function(WorkOrderResponse) then) =
      _$WorkOrderResponseCopyWithImpl<$Res, WorkOrderResponse>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
      String? salespersonName,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(fromJson: _doubleOrNull_fromJson) double? quantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'status', fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)
      String? priority,
      @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
      String? priorityDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
      double? totalAmount,
      @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
      String? approvalStatus,
      @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
      String? approvalStatusDisplay,
      @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
      String? managerName,
      @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
      int? progressPercentage,
      @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
      int? totalTaskCount,
      @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber});
}

/// @nodoc
class _$WorkOrderResponseCopyWithImpl<$Res, $Val extends WorkOrderResponse>
    implements $WorkOrderResponseCopyWith<$Res> {
  _$WorkOrderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? salespersonName = freezed,
    Object? productName = freezed,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? priority = freezed,
    Object? priorityDisplay = freezed,
    Object? orderDate = freezed,
    Object? deliveryDate = freezed,
    Object? totalAmount = freezed,
    Object? approvalStatus = freezed,
    Object? approvalStatusDisplay = freezed,
    Object? managerName = freezed,
    Object? progressPercentage = freezed,
    Object? totalTaskCount = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
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
      salespersonName: freezed == salespersonName
          ? _value.salespersonName
          : salespersonName // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      priorityDisplay: freezed == priorityDisplay
          ? _value.priorityDisplay
          : priorityDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      approvalStatus: freezed == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      approvalStatusDisplay: freezed == approvalStatusDisplay
          ? _value.approvalStatusDisplay
          : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      progressPercentage: freezed == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTaskCount: freezed == totalTaskCount
          ? _value.totalTaskCount
          : totalTaskCount // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderResponseImplCopyWith<$Res>
    implements $WorkOrderResponseCopyWith<$Res> {
  factory _$$WorkOrderResponseImplCopyWith(_$WorkOrderResponseImpl value,
          $Res Function(_$WorkOrderResponseImpl) then) =
      __$$WorkOrderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
      String? salespersonName,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(fromJson: _doubleOrNull_fromJson) double? quantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,
      @JsonKey(name: 'status', fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)
      String? priority,
      @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
      String? priorityDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
      double? totalAmount,
      @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
      String? approvalStatus,
      @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
      String? approvalStatusDisplay,
      @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
      String? managerName,
      @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
      int? progressPercentage,
      @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
      int? totalTaskCount,
      @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
      int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      String? salesOrderNumber});
}

/// @nodoc
class __$$WorkOrderResponseImplCopyWithImpl<$Res>
    extends _$WorkOrderResponseCopyWithImpl<$Res, _$WorkOrderResponseImpl>
    implements _$$WorkOrderResponseImplCopyWith<$Res> {
  __$$WorkOrderResponseImplCopyWithImpl(_$WorkOrderResponseImpl _value,
      $Res Function(_$WorkOrderResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? salespersonName = freezed,
    Object? productName = freezed,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? priority = freezed,
    Object? priorityDisplay = freezed,
    Object? orderDate = freezed,
    Object? deliveryDate = freezed,
    Object? totalAmount = freezed,
    Object? approvalStatus = freezed,
    Object? approvalStatusDisplay = freezed,
    Object? managerName = freezed,
    Object? progressPercentage = freezed,
    Object? totalTaskCount = freezed,
    Object? salesOrderId = freezed,
    Object? salesOrderNumber = freezed,
  }) {
    return _then(_$WorkOrderResponseImpl(
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
      salespersonName: freezed == salespersonName
          ? _value.salespersonName
          : salespersonName // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      priorityDisplay: freezed == priorityDisplay
          ? _value.priorityDisplay
          : priorityDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      approvalStatus: freezed == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      approvalStatusDisplay: freezed == approvalStatusDisplay
          ? _value.approvalStatusDisplay
          : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      progressPercentage: freezed == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTaskCount: freezed == totalTaskCount
          ? _value.totalTaskCount
          : totalTaskCount // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderId: freezed == salesOrderId
          ? _value.salesOrderId
          : salesOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      salesOrderNumber: freezed == salesOrderNumber
          ? _value.salesOrderNumber
          : salesOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderResponseImpl implements _WorkOrderResponse {
  const _$WorkOrderResponseImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required this.orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
      this.salespersonName,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      this.productName,
      @JsonKey(fromJson: _doubleOrNull_fromJson) this.quantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) this.unit,
      @JsonKey(name: 'status', fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson) this.priority,
      @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
      this.priorityDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      this.orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      this.deliveryDate,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
      this.totalAmount,
      @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
      this.approvalStatus,
      @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
      this.approvalStatusDisplay,
      @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
      this.managerName,
      @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
      this.progressPercentage,
      @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
      this.totalTaskCount,
      @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
      this.salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      this.salesOrderNumber});

  factory _$WorkOrderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderResponseImplFromJson(json);

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
  @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
  final String? salespersonName;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  final String? productName;
  @override
  @JsonKey(fromJson: _doubleOrNull_fromJson)
  final double? quantity;
  @override
  @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
  final String? unit;
  @override
  @JsonKey(name: 'status', fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)
  final String? priority;
  @override
  @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
  final String? priorityDisplay;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? orderDate;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? deliveryDate;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
  final double? totalAmount;
  @override
  @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
  final String? approvalStatus;
  @override
  @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
  final String? approvalStatusDisplay;
  @override
  @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
  final String? managerName;
  @override
  @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
  final int? progressPercentage;
  @override
  @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
  final int? totalTaskCount;
  @override
  @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
  final int? salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  final String? salesOrderNumber;

  @override
  String toString() {
    return 'WorkOrderResponse(id: $id, orderNumber: $orderNumber, customerName: $customerName, salespersonName: $salespersonName, productName: $productName, quantity: $quantity, unit: $unit, status: $status, statusDisplay: $statusDisplay, priority: $priority, priorityDisplay: $priorityDisplay, orderDate: $orderDate, deliveryDate: $deliveryDate, totalAmount: $totalAmount, approvalStatus: $approvalStatus, approvalStatusDisplay: $approvalStatusDisplay, managerName: $managerName, progressPercentage: $progressPercentage, totalTaskCount: $totalTaskCount, salesOrderId: $salesOrderId, salesOrderNumber: $salesOrderNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.salespersonName, salespersonName) ||
                other.salespersonName == salespersonName) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.priorityDisplay, priorityDisplay) ||
                other.priorityDisplay == priorityDisplay) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.approvalStatusDisplay, approvalStatusDisplay) ||
                other.approvalStatusDisplay == approvalStatusDisplay) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.totalTaskCount, totalTaskCount) ||
                other.totalTaskCount == totalTaskCount) &&
            (identical(other.salesOrderId, salesOrderId) ||
                other.salesOrderId == salesOrderId) &&
            (identical(other.salesOrderNumber, salesOrderNumber) ||
                other.salesOrderNumber == salesOrderNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        customerName,
        salespersonName,
        productName,
        quantity,
        unit,
        status,
        statusDisplay,
        priority,
        priorityDisplay,
        orderDate,
        deliveryDate,
        totalAmount,
        approvalStatus,
        approvalStatusDisplay,
        managerName,
        progressPercentage,
        totalTaskCount,
        salesOrderId,
        salesOrderNumber
      ]);

  /// Create a copy of WorkOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderResponseImplCopyWith<_$WorkOrderResponseImpl> get copyWith =>
      __$$WorkOrderResponseImplCopyWithImpl<_$WorkOrderResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderResponseImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderResponse implements WorkOrderResponse {
  const factory _WorkOrderResponse(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required final String orderNumber,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
      final String? salespersonName,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      final String? productName,
      @JsonKey(fromJson: _doubleOrNull_fromJson) final double? quantity,
      @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
      final String? unit,
      @JsonKey(name: 'status', fromJson: _stringOrNullFromJson)
      final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)
      final String? priority,
      @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
      final String? priorityDisplay,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? orderDate,
      @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? deliveryDate,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
      final double? totalAmount,
      @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
      final String? approvalStatus,
      @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
      final String? approvalStatusDisplay,
      @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
      final String? managerName,
      @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
      final int? progressPercentage,
      @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
      final int? totalTaskCount,
      @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
      final int? salesOrderId,
      @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
      final String? salesOrderNumber}) = _$WorkOrderResponseImpl;

  factory _WorkOrderResponse.fromJson(Map<String, dynamic> json) =
      _$WorkOrderResponseImpl.fromJson;

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
  @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
  String? get salespersonName;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName;
  @override
  @JsonKey(fromJson: _doubleOrNull_fromJson)
  double? get quantity;
  @override
  @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson)
  String? get unit;
  @override
  @JsonKey(name: 'status', fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson)
  String? get priority;
  @override
  @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
  String? get priorityDisplay;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate;
  @override
  @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
  double? get totalAmount;
  @override
  @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
  String? get approvalStatus;
  @override
  @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
  String? get approvalStatusDisplay;
  @override
  @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
  String? get managerName;
  @override
  @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
  int? get progressPercentage;
  @override
  @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
  int? get totalTaskCount;
  @override
  @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
  int? get salesOrderId;
  @override
  @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
  String? get salesOrderNumber;

  /// Create a copy of WorkOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderResponseImplCopyWith<_$WorkOrderResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
