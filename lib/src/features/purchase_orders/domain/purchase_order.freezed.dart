// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PurchaseOrder _$PurchaseOrderFromJson(Map<String, dynamic> json) {
  return _PurchaseOrder.fromJson(json);
}

/// @nodoc
mixin _$PurchaseOrder {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
  String? get supplierCode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  double? get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  int? get itemsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
  double? get receivedProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
  String? get submittedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
  String? get approvedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get approvedAt => throw _privateConstructorUsedError;

  /// Serializes this PurchaseOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseOrderCopyWith<PurchaseOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderCopyWith<$Res> {
  factory $PurchaseOrderCopyWith(
          PurchaseOrder value, $Res Function(PurchaseOrder) then) =
      _$PurchaseOrderCopyWithImpl<$Res, PurchaseOrder>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      String? supplierName,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      String? supplierCode,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      int? itemsCount,
      @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
      double? receivedProgress,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      String? submittedByName,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      String? approvedByName,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? submittedAt,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? approvedAt});
}

/// @nodoc
class _$PurchaseOrderCopyWithImpl<$Res, $Val extends PurchaseOrder>
    implements $PurchaseOrderCopyWith<$Res> {
  _$PurchaseOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? supplierName = freezed,
    Object? supplierCode = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? totalAmount = freezed,
    Object? itemsCount = freezed,
    Object? receivedProgress = freezed,
    Object? workOrderNumber = freezed,
    Object? orderDate = freezed,
    Object? submittedByName = freezed,
    Object? approvedByName = freezed,
    Object? createdAt = freezed,
    Object? submittedAt = freezed,
    Object? approvedAt = freezed,
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
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierCode: freezed == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      receivedProgress: freezed == receivedProgress
          ? _value.receivedProgress
          : receivedProgress // ignore: cast_nullable_to_non_nullable
              as double?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      submittedByName: freezed == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseOrderImplCopyWith<$Res>
    implements $PurchaseOrderCopyWith<$Res> {
  factory _$$PurchaseOrderImplCopyWith(
          _$PurchaseOrderImpl value, $Res Function(_$PurchaseOrderImpl) then) =
      __$$PurchaseOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      String? supplierName,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      String? supplierCode,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      int? itemsCount,
      @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
      double? receivedProgress,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderDate,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      String? submittedByName,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      String? approvedByName,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? submittedAt,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? approvedAt});
}

/// @nodoc
class __$$PurchaseOrderImplCopyWithImpl<$Res>
    extends _$PurchaseOrderCopyWithImpl<$Res, _$PurchaseOrderImpl>
    implements _$$PurchaseOrderImplCopyWith<$Res> {
  __$$PurchaseOrderImplCopyWithImpl(
      _$PurchaseOrderImpl _value, $Res Function(_$PurchaseOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? supplierName = freezed,
    Object? supplierCode = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? totalAmount = freezed,
    Object? itemsCount = freezed,
    Object? receivedProgress = freezed,
    Object? workOrderNumber = freezed,
    Object? orderDate = freezed,
    Object? submittedByName = freezed,
    Object? approvedByName = freezed,
    Object? createdAt = freezed,
    Object? submittedAt = freezed,
    Object? approvedAt = freezed,
  }) {
    return _then(_$PurchaseOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierCode: freezed == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      itemsCount: freezed == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      receivedProgress: freezed == receivedProgress
          ? _value.receivedProgress
          : receivedProgress // ignore: cast_nullable_to_non_nullable
              as double?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDate: freezed == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      submittedByName: freezed == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseOrderImpl implements _PurchaseOrder {
  const _$PurchaseOrderImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required this.orderNumber,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      this.supplierName,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      this.supplierCode,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      this.totalAmount,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      this.itemsCount,
      @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
      this.receivedProgress,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      this.orderDate,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      this.submittedByName,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      this.approvedByName,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      this.createdAt,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      this.submittedAt,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      this.approvedAt});

  factory _$PurchaseOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseOrderImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  final String orderNumber;
  @override
  @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
  final String? supplierName;
  @override
  @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
  final String? supplierCode;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  final double? totalAmount;
  @override
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  final int? itemsCount;
  @override
  @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
  final double? receivedProgress;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? orderDate;
  @override
  @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
  final String? submittedByName;
  @override
  @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
  final String? approvedByName;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? submittedAt;
  @override
  @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? approvedAt;

  @override
  String toString() {
    return 'PurchaseOrder(id: $id, orderNumber: $orderNumber, supplierName: $supplierName, supplierCode: $supplierCode, status: $status, statusDisplay: $statusDisplay, totalAmount: $totalAmount, itemsCount: $itemsCount, receivedProgress: $receivedProgress, workOrderNumber: $workOrderNumber, orderDate: $orderDate, submittedByName: $submittedByName, approvedByName: $approvedByName, createdAt: $createdAt, submittedAt: $submittedAt, approvedAt: $approvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.supplierCode, supplierCode) ||
                other.supplierCode == supplierCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.receivedProgress, receivedProgress) ||
                other.receivedProgress == receivedProgress) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.submittedByName, submittedByName) ||
                other.submittedByName == submittedByName) &&
            (identical(other.approvedByName, approvedByName) ||
                other.approvedByName == approvedByName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      supplierName,
      supplierCode,
      status,
      statusDisplay,
      totalAmount,
      itemsCount,
      receivedProgress,
      workOrderNumber,
      orderDate,
      submittedByName,
      approvedByName,
      createdAt,
      submittedAt,
      approvedAt);

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderImplCopyWith<_$PurchaseOrderImpl> get copyWith =>
      __$$PurchaseOrderImplCopyWithImpl<_$PurchaseOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseOrderImplToJson(
      this,
    );
  }
}

abstract class _PurchaseOrder implements PurchaseOrder {
  const factory _PurchaseOrder(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required final String orderNumber,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      final String? supplierName,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      final String? supplierCode,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      final double? totalAmount,
      @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
      final int? itemsCount,
      @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
      final double? receivedProgress,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      final String? workOrderNumber,
      @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? orderDate,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      final String? submittedByName,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      final String? approvedByName,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? submittedAt,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? approvedAt}) = _$PurchaseOrderImpl;

  factory _PurchaseOrder.fromJson(Map<String, dynamic> json) =
      _$PurchaseOrderImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber;
  @override
  @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
  String? get supplierName;
  @override
  @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
  String? get supplierCode;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  double? get totalAmount;
  @override
  @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson)
  int? get itemsCount;
  @override
  @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
  double? get receivedProgress;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderDate;
  @override
  @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
  String? get submittedByName;
  @override
  @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
  String? get approvedByName;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get submittedAt;
  @override
  @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get approvedAt;

  /// Create a copy of PurchaseOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseOrderImplCopyWith<_$PurchaseOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
