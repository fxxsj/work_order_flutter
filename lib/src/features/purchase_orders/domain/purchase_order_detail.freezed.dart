// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PurchaseOrderDetail _$PurchaseOrderDetailFromJson(Map<String, dynamic> json) {
  return _PurchaseOrderDetail.fromJson(json);
}

/// @nodoc
mixin _$PurchaseOrderDetail {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson)
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
  String? get supplierContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
  String? get supplierPhone => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
  double? get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
  String? get submittedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
  String? get approvedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  int? get workOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get expectedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get actualReceivedDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
  String? get rejectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
  List<PurchaseOrderItemDetail> get items => throw _privateConstructorUsedError;

  /// Serializes this PurchaseOrderDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseOrderDetailCopyWith<PurchaseOrderDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderDetailCopyWith<$Res> {
  factory $PurchaseOrderDetailCopyWith(
          PurchaseOrderDetail value, $Res Function(PurchaseOrderDetail) then) =
      _$PurchaseOrderDetailCopyWithImpl<$Res, PurchaseOrderDetail>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) int? supplierId,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      String? supplierName,
      @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
      String? supplierContact,
      @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
      String? supplierPhone,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      String? submittedByName,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? submittedAt,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      String? approvedByName,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? approvedAt,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? expectedDate,
      @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderedDate,
      @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? actualReceivedDate,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      String? rejectionReason,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? updatedAt,
      @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
      List<PurchaseOrderItemDetail> items});
}

/// @nodoc
class _$PurchaseOrderDetailCopyWithImpl<$Res, $Val extends PurchaseOrderDetail>
    implements $PurchaseOrderDetailCopyWith<$Res> {
  _$PurchaseOrderDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? supplierContact = freezed,
    Object? supplierPhone = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? totalAmount = freezed,
    Object? submittedByName = freezed,
    Object? submittedAt = freezed,
    Object? approvedByName = freezed,
    Object? approvedAt = freezed,
    Object? workOrderId = freezed,
    Object? workOrderNumber = freezed,
    Object? expectedDate = freezed,
    Object? orderedDate = freezed,
    Object? actualReceivedDate = freezed,
    Object? notes = freezed,
    Object? rejectionReason = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierContact: freezed == supplierContact
          ? _value.supplierContact
          : supplierContact // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierPhone: freezed == supplierPhone
          ? _value.supplierPhone
          : supplierPhone // ignore: cast_nullable_to_non_nullable
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
      submittedByName: freezed == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      workOrderId: freezed == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedDate: freezed == expectedDate
          ? _value.expectedDate
          : expectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderedDate: freezed == orderedDate
          ? _value.orderedDate
          : orderedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualReceivedDate: freezed == actualReceivedDate
          ? _value.actualReceivedDate
          : actualReceivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PurchaseOrderItemDetail>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseOrderDetailImplCopyWith<$Res>
    implements $PurchaseOrderDetailCopyWith<$Res> {
  factory _$$PurchaseOrderDetailImplCopyWith(_$PurchaseOrderDetailImpl value,
          $Res Function(_$PurchaseOrderDetailImpl) then) =
      __$$PurchaseOrderDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      String orderNumber,
      @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) int? supplierId,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      String? supplierName,
      @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
      String? supplierContact,
      @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
      String? supplierPhone,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      String? submittedByName,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? submittedAt,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      String? approvedByName,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? approvedAt,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? expectedDate,
      @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? orderedDate,
      @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? actualReceivedDate,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      String? rejectionReason,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? updatedAt,
      @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
      List<PurchaseOrderItemDetail> items});
}

/// @nodoc
class __$$PurchaseOrderDetailImplCopyWithImpl<$Res>
    extends _$PurchaseOrderDetailCopyWithImpl<$Res, _$PurchaseOrderDetailImpl>
    implements _$$PurchaseOrderDetailImplCopyWith<$Res> {
  __$$PurchaseOrderDetailImplCopyWithImpl(_$PurchaseOrderDetailImpl _value,
      $Res Function(_$PurchaseOrderDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? supplierContact = freezed,
    Object? supplierPhone = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? totalAmount = freezed,
    Object? submittedByName = freezed,
    Object? submittedAt = freezed,
    Object? approvedByName = freezed,
    Object? approvedAt = freezed,
    Object? workOrderId = freezed,
    Object? workOrderNumber = freezed,
    Object? expectedDate = freezed,
    Object? orderedDate = freezed,
    Object? actualReceivedDate = freezed,
    Object? notes = freezed,
    Object? rejectionReason = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? items = null,
  }) {
    return _then(_$PurchaseOrderDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierContact: freezed == supplierContact
          ? _value.supplierContact
          : supplierContact // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierPhone: freezed == supplierPhone
          ? _value.supplierPhone
          : supplierPhone // ignore: cast_nullable_to_non_nullable
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
      submittedByName: freezed == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      workOrderId: freezed == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedDate: freezed == expectedDate
          ? _value.expectedDate
          : expectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderedDate: freezed == orderedDate
          ? _value.orderedDate
          : orderedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualReceivedDate: freezed == actualReceivedDate
          ? _value.actualReceivedDate
          : actualReceivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PurchaseOrderItemDetail>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseOrderDetailImpl implements _PurchaseOrderDetail {
  const _$PurchaseOrderDetailImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required this.orderNumber,
      @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) this.supplierId,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      this.supplierName,
      @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
      this.supplierContact,
      @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
      this.supplierPhone,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      this.totalAmount,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      this.submittedByName,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      this.submittedAt,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      this.approvedByName,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      this.approvedAt,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      this.workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
      this.expectedDate,
      @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
      this.orderedDate,
      @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
      this.actualReceivedDate,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      this.rejectionReason,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
      this.updatedAt,
      @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
      final List<PurchaseOrderItemDetail> items =
          const <PurchaseOrderItemDetail>[]})
      : _items = items;

  factory _$PurchaseOrderDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseOrderDetailImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  final String orderNumber;
  @override
  @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson)
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
  final String? supplierName;
  @override
  @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
  final String? supplierContact;
  @override
  @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
  final String? supplierPhone;
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
  @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
  final String? submittedByName;
  @override
  @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? submittedAt;
  @override
  @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
  final String? approvedByName;
  @override
  @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? approvedAt;
  @override
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  final int? workOrderId;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? expectedDate;
  @override
  @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? orderedDate;
  @override
  @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? actualReceivedDate;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;
  @override
  @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
  final String? rejectionReason;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? updatedAt;
  final List<PurchaseOrderItemDetail> _items;
  @override
  @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
  List<PurchaseOrderItemDetail> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PurchaseOrderDetail(id: $id, orderNumber: $orderNumber, supplierId: $supplierId, supplierName: $supplierName, supplierContact: $supplierContact, supplierPhone: $supplierPhone, status: $status, statusDisplay: $statusDisplay, totalAmount: $totalAmount, submittedByName: $submittedByName, submittedAt: $submittedAt, approvedByName: $approvedByName, approvedAt: $approvedAt, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, expectedDate: $expectedDate, orderedDate: $orderedDate, actualReceivedDate: $actualReceivedDate, notes: $notes, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.supplierContact, supplierContact) ||
                other.supplierContact == supplierContact) &&
            (identical(other.supplierPhone, supplierPhone) ||
                other.supplierPhone == supplierPhone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.submittedByName, submittedByName) ||
                other.submittedByName == submittedByName) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.approvedByName, approvedByName) ||
                other.approvedByName == approvedByName) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.workOrderId, workOrderId) ||
                other.workOrderId == workOrderId) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.expectedDate, expectedDate) ||
                other.expectedDate == expectedDate) &&
            (identical(other.orderedDate, orderedDate) ||
                other.orderedDate == orderedDate) &&
            (identical(other.actualReceivedDate, actualReceivedDate) ||
                other.actualReceivedDate == actualReceivedDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        supplierId,
        supplierName,
        supplierContact,
        supplierPhone,
        status,
        statusDisplay,
        totalAmount,
        submittedByName,
        submittedAt,
        approvedByName,
        approvedAt,
        workOrderId,
        workOrderNumber,
        expectedDate,
        orderedDate,
        actualReceivedDate,
        notes,
        rejectionReason,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of PurchaseOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderDetailImplCopyWith<_$PurchaseOrderDetailImpl> get copyWith =>
      __$$PurchaseOrderDetailImplCopyWithImpl<_$PurchaseOrderDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseOrderDetailImplToJson(
      this,
    );
  }
}

abstract class _PurchaseOrderDetail implements PurchaseOrderDetail {
  const factory _PurchaseOrderDetail(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'order_number', fromJson: _stringFromJson)
      required final String orderNumber,
      @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson)
      final int? supplierId,
      @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
      final String? supplierName,
      @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
      final String? supplierContact,
      @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
      final String? supplierPhone,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
      final double? totalAmount,
      @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
      final String? submittedByName,
      @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? submittedAt,
      @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
      final String? approvedByName,
      @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? approvedAt,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      final int? workOrderId,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      final String? workOrderNumber,
      @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? expectedDate,
      @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? orderedDate,
      @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? actualReceivedDate,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? notes,
      @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
      final String? rejectionReason,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? updatedAt,
      @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
      final List<PurchaseOrderItemDetail> items}) = _$PurchaseOrderDetailImpl;

  factory _PurchaseOrderDetail.fromJson(Map<String, dynamic> json) =
      _$PurchaseOrderDetailImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'order_number', fromJson: _stringFromJson)
  String get orderNumber;
  @override
  @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson)
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
  String? get supplierName;
  @override
  @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
  String? get supplierContact;
  @override
  @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
  String? get supplierPhone;
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
  @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
  String? get submittedByName;
  @override
  @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get submittedAt;
  @override
  @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
  String? get approvedByName;
  @override
  @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get approvedAt;
  @override
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  int? get workOrderId;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get expectedDate;
  @override
  @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get orderedDate;
  @override
  @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get actualReceivedDate;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;
  @override
  @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
  String? get rejectionReason;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
  List<PurchaseOrderItemDetail> get items;

  /// Create a copy of PurchaseOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseOrderDetailImplCopyWith<_$PurchaseOrderDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseOrderItemDetail _$PurchaseOrderItemDetailFromJson(
    Map<String, dynamic> json) {
  return _PurchaseOrderItemDetail.fromJson(json);
}

/// @nodoc
mixin _$PurchaseOrderItemDetail {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'material', fromJson: _intOrNullFromJson)
  int? get materialId => throw _privateConstructorUsedError;
  @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
  String? get materialName => throw _privateConstructorUsedError;
  @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
  String? get materialCode => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'material_unit',
      readValue: _readMaterialUnit,
      fromJson: _stringOrNullFromJson)
  String? get materialUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
  String? get supplierCode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
  double? get receivedQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
  double? get remainingQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
  int? get workOrderMaterialId => throw _privateConstructorUsedError;

  /// Serializes this PurchaseOrderItemDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseOrderItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseOrderItemDetailCopyWith<PurchaseOrderItemDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderItemDetailCopyWith<$Res> {
  factory $PurchaseOrderItemDetailCopyWith(PurchaseOrderItemDetail value,
          $Res Function(PurchaseOrderItemDetail) then) =
      _$PurchaseOrderItemDetailCopyWithImpl<$Res, PurchaseOrderItemDetail>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'material', fromJson: _intOrNullFromJson) int? materialId,
      @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
      String? materialName,
      @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
      String? materialCode,
      @JsonKey(
          name: 'material_unit',
          readValue: _readMaterialUnit,
          fromJson: _stringOrNullFromJson)
      String? materialUnit,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      String? supplierCode,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
      @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
      double? receivedQuantity,
      @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
      double? remainingQuantity,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
      int? workOrderMaterialId});
}

/// @nodoc
class _$PurchaseOrderItemDetailCopyWithImpl<$Res,
        $Val extends PurchaseOrderItemDetail>
    implements $PurchaseOrderItemDetailCopyWith<$Res> {
  _$PurchaseOrderItemDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseOrderItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? materialId = freezed,
    Object? materialName = freezed,
    Object? materialCode = freezed,
    Object? materialUnit = freezed,
    Object? supplierCode = freezed,
    Object? quantity = freezed,
    Object? receivedQuantity = freezed,
    Object? remainingQuantity = freezed,
    Object? unitPrice = freezed,
    Object? subtotal = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? notes = freezed,
    Object? workOrderMaterialId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      materialId: freezed == materialId
          ? _value.materialId
          : materialId // ignore: cast_nullable_to_non_nullable
              as int?,
      materialName: freezed == materialName
          ? _value.materialName
          : materialName // ignore: cast_nullable_to_non_nullable
              as String?,
      materialCode: freezed == materialCode
          ? _value.materialCode
          : materialCode // ignore: cast_nullable_to_non_nullable
              as String?,
      materialUnit: freezed == materialUnit
          ? _value.materialUnit
          : materialUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierCode: freezed == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      receivedQuantity: freezed == receivedQuantity
          ? _value.receivedQuantity
          : receivedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQuantity: freezed == remainingQuantity
          ? _value.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderMaterialId: freezed == workOrderMaterialId
          ? _value.workOrderMaterialId
          : workOrderMaterialId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseOrderItemDetailImplCopyWith<$Res>
    implements $PurchaseOrderItemDetailCopyWith<$Res> {
  factory _$$PurchaseOrderItemDetailImplCopyWith(
          _$PurchaseOrderItemDetailImpl value,
          $Res Function(_$PurchaseOrderItemDetailImpl) then) =
      __$$PurchaseOrderItemDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'material', fromJson: _intOrNullFromJson) int? materialId,
      @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
      String? materialName,
      @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
      String? materialCode,
      @JsonKey(
          name: 'material_unit',
          readValue: _readMaterialUnit,
          fromJson: _stringOrNullFromJson)
      String? materialUnit,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      String? supplierCode,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
      @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
      double? receivedQuantity,
      @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
      double? remainingQuantity,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      double? subtotal,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
      @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
      int? workOrderMaterialId});
}

/// @nodoc
class __$$PurchaseOrderItemDetailImplCopyWithImpl<$Res>
    extends _$PurchaseOrderItemDetailCopyWithImpl<$Res,
        _$PurchaseOrderItemDetailImpl>
    implements _$$PurchaseOrderItemDetailImplCopyWith<$Res> {
  __$$PurchaseOrderItemDetailImplCopyWithImpl(
      _$PurchaseOrderItemDetailImpl _value,
      $Res Function(_$PurchaseOrderItemDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOrderItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? materialId = freezed,
    Object? materialName = freezed,
    Object? materialCode = freezed,
    Object? materialUnit = freezed,
    Object? supplierCode = freezed,
    Object? quantity = freezed,
    Object? receivedQuantity = freezed,
    Object? remainingQuantity = freezed,
    Object? unitPrice = freezed,
    Object? subtotal = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? notes = freezed,
    Object? workOrderMaterialId = freezed,
  }) {
    return _then(_$PurchaseOrderItemDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      materialId: freezed == materialId
          ? _value.materialId
          : materialId // ignore: cast_nullable_to_non_nullable
              as int?,
      materialName: freezed == materialName
          ? _value.materialName
          : materialName // ignore: cast_nullable_to_non_nullable
              as String?,
      materialCode: freezed == materialCode
          ? _value.materialCode
          : materialCode // ignore: cast_nullable_to_non_nullable
              as String?,
      materialUnit: freezed == materialUnit
          ? _value.materialUnit
          : materialUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierCode: freezed == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      receivedQuantity: freezed == receivedQuantity
          ? _value.receivedQuantity
          : receivedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQuantity: freezed == remainingQuantity
          ? _value.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderMaterialId: freezed == workOrderMaterialId
          ? _value.workOrderMaterialId
          : workOrderMaterialId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseOrderItemDetailImpl implements _PurchaseOrderItemDetail {
  const _$PurchaseOrderItemDetailImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'material', fromJson: _intOrNullFromJson) this.materialId,
      @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
      this.materialName,
      @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
      this.materialCode,
      @JsonKey(
          name: 'material_unit',
          readValue: _readMaterialUnit,
          fromJson: _stringOrNullFromJson)
      this.materialUnit,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      this.supplierCode,
      @JsonKey(fromJson: _doubleOrNullFromJson) this.quantity,
      @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
      this.receivedQuantity,
      @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
      this.remainingQuantity,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      this.unitPrice,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes,
      @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
      this.workOrderMaterialId});

  factory _$PurchaseOrderItemDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseOrderItemDetailImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'material', fromJson: _intOrNullFromJson)
  final int? materialId;
  @override
  @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
  final String? materialName;
  @override
  @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
  final String? materialCode;
  @override
  @JsonKey(
      name: 'material_unit',
      readValue: _readMaterialUnit,
      fromJson: _stringOrNullFromJson)
  final String? materialUnit;
  @override
  @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
  final String? supplierCode;
  @override
  @JsonKey(fromJson: _doubleOrNullFromJson)
  final double? quantity;
  @override
  @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
  final double? receivedQuantity;
  @override
  @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
  final double? remainingQuantity;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  final double? unitPrice;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  final double? subtotal;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;
  @override
  @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
  final int? workOrderMaterialId;

  @override
  String toString() {
    return 'PurchaseOrderItemDetail(id: $id, materialId: $materialId, materialName: $materialName, materialCode: $materialCode, materialUnit: $materialUnit, supplierCode: $supplierCode, quantity: $quantity, receivedQuantity: $receivedQuantity, remainingQuantity: $remainingQuantity, unitPrice: $unitPrice, subtotal: $subtotal, status: $status, statusDisplay: $statusDisplay, notes: $notes, workOrderMaterialId: $workOrderMaterialId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderItemDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.materialId, materialId) ||
                other.materialId == materialId) &&
            (identical(other.materialName, materialName) ||
                other.materialName == materialName) &&
            (identical(other.materialCode, materialCode) ||
                other.materialCode == materialCode) &&
            (identical(other.materialUnit, materialUnit) ||
                other.materialUnit == materialUnit) &&
            (identical(other.supplierCode, supplierCode) ||
                other.supplierCode == supplierCode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.receivedQuantity, receivedQuantity) ||
                other.receivedQuantity == receivedQuantity) &&
            (identical(other.remainingQuantity, remainingQuantity) ||
                other.remainingQuantity == remainingQuantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.workOrderMaterialId, workOrderMaterialId) ||
                other.workOrderMaterialId == workOrderMaterialId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      materialId,
      materialName,
      materialCode,
      materialUnit,
      supplierCode,
      quantity,
      receivedQuantity,
      remainingQuantity,
      unitPrice,
      subtotal,
      status,
      statusDisplay,
      notes,
      workOrderMaterialId);

  /// Create a copy of PurchaseOrderItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderItemDetailImplCopyWith<_$PurchaseOrderItemDetailImpl>
      get copyWith => __$$PurchaseOrderItemDetailImplCopyWithImpl<
          _$PurchaseOrderItemDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseOrderItemDetailImplToJson(
      this,
    );
  }
}

abstract class _PurchaseOrderItemDetail implements PurchaseOrderItemDetail {
  const factory _PurchaseOrderItemDetail(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'material', fromJson: _intOrNullFromJson)
      final int? materialId,
      @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
      final String? materialName,
      @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
      final String? materialCode,
      @JsonKey(
          name: 'material_unit',
          readValue: _readMaterialUnit,
          fromJson: _stringOrNullFromJson)
      final String? materialUnit,
      @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
      final String? supplierCode,
      @JsonKey(fromJson: _doubleOrNullFromJson) final double? quantity,
      @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
      final double? receivedQuantity,
      @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
      final double? remainingQuantity,
      @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
      final double? unitPrice,
      @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
      final double? subtotal,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? notes,
      @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
      final int? workOrderMaterialId}) = _$PurchaseOrderItemDetailImpl;

  factory _PurchaseOrderItemDetail.fromJson(Map<String, dynamic> json) =
      _$PurchaseOrderItemDetailImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'material', fromJson: _intOrNullFromJson)
  int? get materialId;
  @override
  @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
  String? get materialName;
  @override
  @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
  String? get materialCode;
  @override
  @JsonKey(
      name: 'material_unit',
      readValue: _readMaterialUnit,
      fromJson: _stringOrNullFromJson)
  String? get materialUnit;
  @override
  @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
  String? get supplierCode;
  @override
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get quantity;
  @override
  @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
  double? get receivedQuantity;
  @override
  @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
  double? get remainingQuantity;
  @override
  @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
  double? get unitPrice;
  @override
  @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
  double? get subtotal;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;
  @override
  @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
  int? get workOrderMaterialId;

  /// Create a copy of PurchaseOrderItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseOrderItemDetailImplCopyWith<_$PurchaseOrderItemDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}
