// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseOrderDetail {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'order_number', fromJson: _stringFromJson) String get orderNumber;@JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) int? get supplierId;@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) String? get supplierName;@JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson) String? get supplierContact;@JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson) String? get supplierPhone;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? get approvalStatus;@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? get approvalStatusDisplay;@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? get totalAmount;@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) String? get submittedByName;@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) DateTime? get submittedAt;@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) String? get approvedByName;@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) DateTime? get approvedAt;@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? get workOrderId;@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson) DateTime? get expectedDate;@JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson) DateTime? get orderedDate;@JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson) DateTime? get actualReceivedDate;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) String? get rejectionReason;@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) DateTime? get updatedAt;@JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson) List<PurchaseOrderItemDetail> get items;
/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderDetailCopyWith<PurchaseOrderDetail> get copyWith => _$PurchaseOrderDetailCopyWithImpl<PurchaseOrderDetail>(this as PurchaseOrderDetail, _$identity);

  /// Serializes this PurchaseOrderDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierContact, supplierContact) || other.supplierContact == supplierContact)&&(identical(other.supplierPhone, supplierPhone) || other.supplierPhone == supplierPhone)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvalStatusDisplay, approvalStatusDisplay) || other.approvalStatusDisplay == approvalStatusDisplay)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.submittedByName, submittedByName) || other.submittedByName == submittedByName)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.expectedDate, expectedDate) || other.expectedDate == expectedDate)&&(identical(other.orderedDate, orderedDate) || other.orderedDate == orderedDate)&&(identical(other.actualReceivedDate, actualReceivedDate) || other.actualReceivedDate == actualReceivedDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,supplierId,supplierName,supplierContact,supplierPhone,status,statusDisplay,approvalStatus,approvalStatusDisplay,totalAmount,submittedByName,submittedAt,approvedByName,approvedAt,workOrderId,workOrderNumber,expectedDate,orderedDate,actualReceivedDate,notes,rejectionReason,createdAt,updatedAt,const DeepCollectionEquality().hash(items)]);

@override
String toString() {
  return 'PurchaseOrderDetail(id: $id, orderNumber: $orderNumber, supplierId: $supplierId, supplierName: $supplierName, supplierContact: $supplierContact, supplierPhone: $supplierPhone, status: $status, statusDisplay: $statusDisplay, approvalStatus: $approvalStatus, approvalStatusDisplay: $approvalStatusDisplay, totalAmount: $totalAmount, submittedByName: $submittedByName, submittedAt: $submittedAt, approvedByName: $approvedByName, approvedAt: $approvedAt, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, expectedDate: $expectedDate, orderedDate: $orderedDate, actualReceivedDate: $actualReceivedDate, notes: $notes, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderDetailCopyWith<$Res>  {
  factory $PurchaseOrderDetailCopyWith(PurchaseOrderDetail value, $Res Function(PurchaseOrderDetail) _then) = _$PurchaseOrderDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) int? supplierId,@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) String? supplierName,@JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson) String? supplierContact,@JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson) String? supplierPhone,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? approvalStatus,@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? approvalStatusDisplay,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) String? submittedByName,@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) DateTime? submittedAt,@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) String? approvedByName,@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) DateTime? approvedAt,@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson) DateTime? expectedDate,@JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderedDate,@JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson) DateTime? actualReceivedDate,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) String? rejectionReason,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) DateTime? updatedAt,@JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson) List<PurchaseOrderItemDetail> items
});




}
/// @nodoc
class _$PurchaseOrderDetailCopyWithImpl<$Res>
    implements $PurchaseOrderDetailCopyWith<$Res> {
  _$PurchaseOrderDetailCopyWithImpl(this._self, this._then);

  final PurchaseOrderDetail _self;
  final $Res Function(PurchaseOrderDetail) _then;

/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? supplierId = freezed,Object? supplierName = freezed,Object? supplierContact = freezed,Object? supplierPhone = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? approvalStatus = freezed,Object? approvalStatusDisplay = freezed,Object? totalAmount = freezed,Object? submittedByName = freezed,Object? submittedAt = freezed,Object? approvedByName = freezed,Object? approvedAt = freezed,Object? workOrderId = freezed,Object? workOrderNumber = freezed,Object? expectedDate = freezed,Object? orderedDate = freezed,Object? actualReceivedDate = freezed,Object? notes = freezed,Object? rejectionReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as int?,supplierName: freezed == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String?,supplierContact: freezed == supplierContact ? _self.supplierContact : supplierContact // ignore: cast_nullable_to_non_nullable
as String?,supplierPhone: freezed == supplierPhone ? _self.supplierPhone : supplierPhone // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,approvalStatusDisplay: freezed == approvalStatusDisplay ? _self.approvalStatusDisplay : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,submittedByName: freezed == submittedByName ? _self.submittedByName : submittedByName // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,expectedDate: freezed == expectedDate ? _self.expectedDate : expectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,orderedDate: freezed == orderedDate ? _self.orderedDate : orderedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,actualReceivedDate: freezed == actualReceivedDate ? _self.actualReceivedDate : actualReceivedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseOrderItemDetail>,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrderDetail].
extension PurchaseOrderDetailPatterns on PurchaseOrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson)  int? supplierId, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)  String? supplierName, @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)  String? supplierContact, @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)  String? supplierPhone, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)  String? submittedByName, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)  DateTime? submittedAt, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)  String? approvedByName, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)  DateTime? approvedAt, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)  DateTime? expectedDate, @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderedDate, @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)  DateTime? actualReceivedDate, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)  String? rejectionReason, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)  DateTime? updatedAt, @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)  List<PurchaseOrderItemDetail> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.supplierId,_that.supplierName,_that.supplierContact,_that.supplierPhone,_that.status,_that.statusDisplay,_that.approvalStatus,_that.approvalStatusDisplay,_that.totalAmount,_that.submittedByName,_that.submittedAt,_that.approvedByName,_that.approvedAt,_that.workOrderId,_that.workOrderNumber,_that.expectedDate,_that.orderedDate,_that.actualReceivedDate,_that.notes,_that.rejectionReason,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson)  int? supplierId, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)  String? supplierName, @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)  String? supplierContact, @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)  String? supplierPhone, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)  String? submittedByName, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)  DateTime? submittedAt, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)  String? approvedByName, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)  DateTime? approvedAt, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)  DateTime? expectedDate, @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderedDate, @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)  DateTime? actualReceivedDate, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)  String? rejectionReason, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)  DateTime? updatedAt, @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)  List<PurchaseOrderItemDetail> items)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderDetail():
return $default(_that.id,_that.orderNumber,_that.supplierId,_that.supplierName,_that.supplierContact,_that.supplierPhone,_that.status,_that.statusDisplay,_that.approvalStatus,_that.approvalStatusDisplay,_that.totalAmount,_that.submittedByName,_that.submittedAt,_that.approvedByName,_that.approvedAt,_that.workOrderId,_that.workOrderNumber,_that.expectedDate,_that.orderedDate,_that.actualReceivedDate,_that.notes,_that.rejectionReason,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'order_number', fromJson: _stringFromJson)  String orderNumber, @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson)  int? supplierId, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)  String? supplierName, @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)  String? supplierContact, @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)  String? supplierPhone, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)  String? approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)  String? approvalStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)  String? submittedByName, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)  DateTime? submittedAt, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)  String? approvedByName, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)  DateTime? approvedAt, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)  DateTime? expectedDate, @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)  DateTime? orderedDate, @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)  DateTime? actualReceivedDate, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)  String? rejectionReason, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)  DateTime? updatedAt, @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)  List<PurchaseOrderItemDetail> items)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderDetail() when $default != null:
return $default(_that.id,_that.orderNumber,_that.supplierId,_that.supplierName,_that.supplierContact,_that.supplierPhone,_that.status,_that.statusDisplay,_that.approvalStatus,_that.approvalStatusDisplay,_that.totalAmount,_that.submittedByName,_that.submittedAt,_that.approvedByName,_that.approvedAt,_that.workOrderId,_that.workOrderNumber,_that.expectedDate,_that.orderedDate,_that.actualReceivedDate,_that.notes,_that.rejectionReason,_that.createdAt,_that.updatedAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrderDetail implements PurchaseOrderDetail {
  const _PurchaseOrderDetail({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'order_number', fromJson: _stringFromJson) required this.orderNumber, @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) this.supplierId, @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) this.supplierName, @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson) this.supplierContact, @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson) this.supplierPhone, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) this.approvalStatus, @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) this.approvalStatusDisplay, @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) this.totalAmount, @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) this.submittedByName, @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) this.submittedAt, @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) this.approvedByName, @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) this.approvedAt, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) this.workOrderId, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson) this.expectedDate, @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson) this.orderedDate, @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson) this.actualReceivedDate, @JsonKey(fromJson: _stringOrNullFromJson) this.notes, @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) this.rejectionReason, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) this.updatedAt, @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson) final  List<PurchaseOrderItemDetail> items = const <PurchaseOrderItemDetail>[]}): _items = items;
  factory _PurchaseOrderDetail.fromJson(Map<String, dynamic> json) => _$PurchaseOrderDetailFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'order_number', fromJson: _stringFromJson) final  String orderNumber;
@override@JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) final  int? supplierId;
@override@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) final  String? supplierName;
@override@JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson) final  String? supplierContact;
@override@JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson) final  String? supplierPhone;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) final  String? approvalStatus;
@override@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) final  String? approvalStatusDisplay;
@override@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) final  double? totalAmount;
@override@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) final  String? submittedByName;
@override@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? submittedAt;
@override@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) final  String? approvedByName;
@override@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? approvedAt;
@override@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) final  int? workOrderId;
@override@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? expectedDate;
@override@JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? orderedDate;
@override@JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? actualReceivedDate;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;
@override@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) final  String? rejectionReason;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? updatedAt;
 final  List<PurchaseOrderItemDetail> _items;
@override@JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson) List<PurchaseOrderItemDetail> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderDetailCopyWith<_PurchaseOrderDetail> get copyWith => __$PurchaseOrderDetailCopyWithImpl<_PurchaseOrderDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrderDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierContact, supplierContact) || other.supplierContact == supplierContact)&&(identical(other.supplierPhone, supplierPhone) || other.supplierPhone == supplierPhone)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvalStatusDisplay, approvalStatusDisplay) || other.approvalStatusDisplay == approvalStatusDisplay)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.submittedByName, submittedByName) || other.submittedByName == submittedByName)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.expectedDate, expectedDate) || other.expectedDate == expectedDate)&&(identical(other.orderedDate, orderedDate) || other.orderedDate == orderedDate)&&(identical(other.actualReceivedDate, actualReceivedDate) || other.actualReceivedDate == actualReceivedDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,supplierId,supplierName,supplierContact,supplierPhone,status,statusDisplay,approvalStatus,approvalStatusDisplay,totalAmount,submittedByName,submittedAt,approvedByName,approvedAt,workOrderId,workOrderNumber,expectedDate,orderedDate,actualReceivedDate,notes,rejectionReason,createdAt,updatedAt,const DeepCollectionEquality().hash(_items)]);

@override
String toString() {
  return 'PurchaseOrderDetail(id: $id, orderNumber: $orderNumber, supplierId: $supplierId, supplierName: $supplierName, supplierContact: $supplierContact, supplierPhone: $supplierPhone, status: $status, statusDisplay: $statusDisplay, approvalStatus: $approvalStatus, approvalStatusDisplay: $approvalStatusDisplay, totalAmount: $totalAmount, submittedByName: $submittedByName, submittedAt: $submittedAt, approvedByName: $approvedByName, approvedAt: $approvedAt, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, expectedDate: $expectedDate, orderedDate: $orderedDate, actualReceivedDate: $actualReceivedDate, notes: $notes, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderDetailCopyWith<$Res> implements $PurchaseOrderDetailCopyWith<$Res> {
  factory _$PurchaseOrderDetailCopyWith(_PurchaseOrderDetail value, $Res Function(_PurchaseOrderDetail) _then) = __$PurchaseOrderDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'order_number', fromJson: _stringFromJson) String orderNumber,@JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) int? supplierId,@JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson) String? supplierName,@JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson) String? supplierContact,@JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson) String? supplierPhone,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson) String? approvalStatus,@JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson) String? approvalStatusDisplay,@JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson) String? submittedByName,@JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson) DateTime? submittedAt,@JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson) String? approvedByName,@JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson) DateTime? approvedAt,@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson) DateTime? expectedDate,@JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson) DateTime? orderedDate,@JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson) DateTime? actualReceivedDate,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson) String? rejectionReason,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson) DateTime? updatedAt,@JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson) List<PurchaseOrderItemDetail> items
});




}
/// @nodoc
class __$PurchaseOrderDetailCopyWithImpl<$Res>
    implements _$PurchaseOrderDetailCopyWith<$Res> {
  __$PurchaseOrderDetailCopyWithImpl(this._self, this._then);

  final _PurchaseOrderDetail _self;
  final $Res Function(_PurchaseOrderDetail) _then;

/// Create a copy of PurchaseOrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? supplierId = freezed,Object? supplierName = freezed,Object? supplierContact = freezed,Object? supplierPhone = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? approvalStatus = freezed,Object? approvalStatusDisplay = freezed,Object? totalAmount = freezed,Object? submittedByName = freezed,Object? submittedAt = freezed,Object? approvedByName = freezed,Object? approvedAt = freezed,Object? workOrderId = freezed,Object? workOrderNumber = freezed,Object? expectedDate = freezed,Object? orderedDate = freezed,Object? actualReceivedDate = freezed,Object? notes = freezed,Object? rejectionReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
  return _then(_PurchaseOrderDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as int?,supplierName: freezed == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String?,supplierContact: freezed == supplierContact ? _self.supplierContact : supplierContact // ignore: cast_nullable_to_non_nullable
as String?,supplierPhone: freezed == supplierPhone ? _self.supplierPhone : supplierPhone // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,approvalStatusDisplay: freezed == approvalStatusDisplay ? _self.approvalStatusDisplay : approvalStatusDisplay // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,submittedByName: freezed == submittedByName ? _self.submittedByName : submittedByName // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,expectedDate: freezed == expectedDate ? _self.expectedDate : expectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,orderedDate: freezed == orderedDate ? _self.orderedDate : orderedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,actualReceivedDate: freezed == actualReceivedDate ? _self.actualReceivedDate : actualReceivedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseOrderItemDetail>,
  ));
}


}


/// @nodoc
mixin _$PurchaseOrderItemDetail {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'material', fromJson: _intOrNullFromJson) int? get materialId;@JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson) String? get materialName;@JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson) String? get materialCode;@JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson) String? get materialSpecification;@JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson) String? get materialUnit;@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) String? get supplierCode;@JsonKey(fromJson: _doubleOrNullFromJson) double? get quantity;@JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson) double? get receivedQuantity;@JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson) double? get remainingQuantity;@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? get unitPrice;@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? get subtotal;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;@JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson) int? get workOrderMaterialId;
/// Create a copy of PurchaseOrderItemDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderItemDetailCopyWith<PurchaseOrderItemDetail> get copyWith => _$PurchaseOrderItemDetailCopyWithImpl<PurchaseOrderItemDetail>(this as PurchaseOrderItemDetail, _$identity);

  /// Serializes this PurchaseOrderItemDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrderItemDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.materialId, materialId) || other.materialId == materialId)&&(identical(other.materialName, materialName) || other.materialName == materialName)&&(identical(other.materialCode, materialCode) || other.materialCode == materialCode)&&(identical(other.materialSpecification, materialSpecification) || other.materialSpecification == materialSpecification)&&(identical(other.materialUnit, materialUnit) || other.materialUnit == materialUnit)&&(identical(other.supplierCode, supplierCode) || other.supplierCode == supplierCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.receivedQuantity, receivedQuantity) || other.receivedQuantity == receivedQuantity)&&(identical(other.remainingQuantity, remainingQuantity) || other.remainingQuantity == remainingQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.workOrderMaterialId, workOrderMaterialId) || other.workOrderMaterialId == workOrderMaterialId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,materialId,materialName,materialCode,materialSpecification,materialUnit,supplierCode,quantity,receivedQuantity,remainingQuantity,unitPrice,subtotal,status,statusDisplay,notes,workOrderMaterialId);

@override
String toString() {
  return 'PurchaseOrderItemDetail(id: $id, materialId: $materialId, materialName: $materialName, materialCode: $materialCode, materialSpecification: $materialSpecification, materialUnit: $materialUnit, supplierCode: $supplierCode, quantity: $quantity, receivedQuantity: $receivedQuantity, remainingQuantity: $remainingQuantity, unitPrice: $unitPrice, subtotal: $subtotal, status: $status, statusDisplay: $statusDisplay, notes: $notes, workOrderMaterialId: $workOrderMaterialId)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderItemDetailCopyWith<$Res>  {
  factory $PurchaseOrderItemDetailCopyWith(PurchaseOrderItemDetail value, $Res Function(PurchaseOrderItemDetail) _then) = _$PurchaseOrderItemDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'material', fromJson: _intOrNullFromJson) int? materialId,@JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson) String? materialName,@JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson) String? materialCode,@JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson) String? materialSpecification,@JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson) String? materialUnit,@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) String? supplierCode,@JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,@JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson) double? receivedQuantity,@JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson) double? remainingQuantity,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson) int? workOrderMaterialId
});




}
/// @nodoc
class _$PurchaseOrderItemDetailCopyWithImpl<$Res>
    implements $PurchaseOrderItemDetailCopyWith<$Res> {
  _$PurchaseOrderItemDetailCopyWithImpl(this._self, this._then);

  final PurchaseOrderItemDetail _self;
  final $Res Function(PurchaseOrderItemDetail) _then;

/// Create a copy of PurchaseOrderItemDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? materialId = freezed,Object? materialName = freezed,Object? materialCode = freezed,Object? materialSpecification = freezed,Object? materialUnit = freezed,Object? supplierCode = freezed,Object? quantity = freezed,Object? receivedQuantity = freezed,Object? remainingQuantity = freezed,Object? unitPrice = freezed,Object? subtotal = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? notes = freezed,Object? workOrderMaterialId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,materialId: freezed == materialId ? _self.materialId : materialId // ignore: cast_nullable_to_non_nullable
as int?,materialName: freezed == materialName ? _self.materialName : materialName // ignore: cast_nullable_to_non_nullable
as String?,materialCode: freezed == materialCode ? _self.materialCode : materialCode // ignore: cast_nullable_to_non_nullable
as String?,materialSpecification: freezed == materialSpecification ? _self.materialSpecification : materialSpecification // ignore: cast_nullable_to_non_nullable
as String?,materialUnit: freezed == materialUnit ? _self.materialUnit : materialUnit // ignore: cast_nullable_to_non_nullable
as String?,supplierCode: freezed == supplierCode ? _self.supplierCode : supplierCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,receivedQuantity: freezed == receivedQuantity ? _self.receivedQuantity : receivedQuantity // ignore: cast_nullable_to_non_nullable
as double?,remainingQuantity: freezed == remainingQuantity ? _self.remainingQuantity : remainingQuantity // ignore: cast_nullable_to_non_nullable
as double?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,workOrderMaterialId: freezed == workOrderMaterialId ? _self.workOrderMaterialId : workOrderMaterialId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrderItemDetail].
extension PurchaseOrderItemDetailPatterns on PurchaseOrderItemDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrderItemDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrderItemDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrderItemDetail value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderItemDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrderItemDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrderItemDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'material', fromJson: _intOrNullFromJson)  int? materialId, @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)  String? materialName, @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)  String? materialCode, @JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson)  String? materialSpecification, @JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson)  String? materialUnit, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)  String? supplierCode, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)  double? receivedQuantity, @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)  double? remainingQuantity, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)  int? workOrderMaterialId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrderItemDetail() when $default != null:
return $default(_that.id,_that.materialId,_that.materialName,_that.materialCode,_that.materialSpecification,_that.materialUnit,_that.supplierCode,_that.quantity,_that.receivedQuantity,_that.remainingQuantity,_that.unitPrice,_that.subtotal,_that.status,_that.statusDisplay,_that.notes,_that.workOrderMaterialId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'material', fromJson: _intOrNullFromJson)  int? materialId, @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)  String? materialName, @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)  String? materialCode, @JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson)  String? materialSpecification, @JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson)  String? materialUnit, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)  String? supplierCode, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)  double? receivedQuantity, @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)  double? remainingQuantity, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)  int? workOrderMaterialId)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderItemDetail():
return $default(_that.id,_that.materialId,_that.materialName,_that.materialCode,_that.materialSpecification,_that.materialUnit,_that.supplierCode,_that.quantity,_that.receivedQuantity,_that.remainingQuantity,_that.unitPrice,_that.subtotal,_that.status,_that.statusDisplay,_that.notes,_that.workOrderMaterialId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'material', fromJson: _intOrNullFromJson)  int? materialId, @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)  String? materialName, @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)  String? materialCode, @JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson)  String? materialSpecification, @JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson)  String? materialUnit, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)  String? supplierCode, @JsonKey(fromJson: _doubleOrNullFromJson)  double? quantity, @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)  double? receivedQuantity, @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)  double? remainingQuantity, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)  double? unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)  double? subtotal, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)  int? workOrderMaterialId)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrderItemDetail() when $default != null:
return $default(_that.id,_that.materialId,_that.materialName,_that.materialCode,_that.materialSpecification,_that.materialUnit,_that.supplierCode,_that.quantity,_that.receivedQuantity,_that.remainingQuantity,_that.unitPrice,_that.subtotal,_that.status,_that.statusDisplay,_that.notes,_that.workOrderMaterialId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrderItemDetail implements PurchaseOrderItemDetail {
  const _PurchaseOrderItemDetail({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'material', fromJson: _intOrNullFromJson) this.materialId, @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson) this.materialName, @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson) this.materialCode, @JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson) this.materialSpecification, @JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson) this.materialUnit, @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) this.supplierCode, @JsonKey(fromJson: _doubleOrNullFromJson) this.quantity, @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson) this.receivedQuantity, @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson) this.remainingQuantity, @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) this.unitPrice, @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) this.subtotal, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(fromJson: _stringOrNullFromJson) this.notes, @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson) this.workOrderMaterialId});
  factory _PurchaseOrderItemDetail.fromJson(Map<String, dynamic> json) => _$PurchaseOrderItemDetailFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'material', fromJson: _intOrNullFromJson) final  int? materialId;
@override@JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson) final  String? materialName;
@override@JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson) final  String? materialCode;
@override@JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson) final  String? materialSpecification;
@override@JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson) final  String? materialUnit;
@override@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) final  String? supplierCode;
@override@JsonKey(fromJson: _doubleOrNullFromJson) final  double? quantity;
@override@JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson) final  double? receivedQuantity;
@override@JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson) final  double? remainingQuantity;
@override@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) final  double? unitPrice;
@override@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) final  double? subtotal;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;
@override@JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson) final  int? workOrderMaterialId;

/// Create a copy of PurchaseOrderItemDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderItemDetailCopyWith<_PurchaseOrderItemDetail> get copyWith => __$PurchaseOrderItemDetailCopyWithImpl<_PurchaseOrderItemDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderItemDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrderItemDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.materialId, materialId) || other.materialId == materialId)&&(identical(other.materialName, materialName) || other.materialName == materialName)&&(identical(other.materialCode, materialCode) || other.materialCode == materialCode)&&(identical(other.materialSpecification, materialSpecification) || other.materialSpecification == materialSpecification)&&(identical(other.materialUnit, materialUnit) || other.materialUnit == materialUnit)&&(identical(other.supplierCode, supplierCode) || other.supplierCode == supplierCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.receivedQuantity, receivedQuantity) || other.receivedQuantity == receivedQuantity)&&(identical(other.remainingQuantity, remainingQuantity) || other.remainingQuantity == remainingQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.workOrderMaterialId, workOrderMaterialId) || other.workOrderMaterialId == workOrderMaterialId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,materialId,materialName,materialCode,materialSpecification,materialUnit,supplierCode,quantity,receivedQuantity,remainingQuantity,unitPrice,subtotal,status,statusDisplay,notes,workOrderMaterialId);

@override
String toString() {
  return 'PurchaseOrderItemDetail(id: $id, materialId: $materialId, materialName: $materialName, materialCode: $materialCode, materialSpecification: $materialSpecification, materialUnit: $materialUnit, supplierCode: $supplierCode, quantity: $quantity, receivedQuantity: $receivedQuantity, remainingQuantity: $remainingQuantity, unitPrice: $unitPrice, subtotal: $subtotal, status: $status, statusDisplay: $statusDisplay, notes: $notes, workOrderMaterialId: $workOrderMaterialId)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderItemDetailCopyWith<$Res> implements $PurchaseOrderItemDetailCopyWith<$Res> {
  factory _$PurchaseOrderItemDetailCopyWith(_PurchaseOrderItemDetail value, $Res Function(_PurchaseOrderItemDetail) _then) = __$PurchaseOrderItemDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'material', fromJson: _intOrNullFromJson) int? materialId,@JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson) String? materialName,@JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson) String? materialCode,@JsonKey(name: 'material_specification', fromJson: _stringOrNullFromJson) String? materialSpecification,@JsonKey(name: 'material_unit', readValue: _readMaterialUnit, fromJson: _stringOrNullFromJson) String? materialUnit,@JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson) String? supplierCode,@JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,@JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson) double? receivedQuantity,@JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson) double? remainingQuantity,@JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson) double? unitPrice,@JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson) double? subtotal,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson) int? workOrderMaterialId
});




}
/// @nodoc
class __$PurchaseOrderItemDetailCopyWithImpl<$Res>
    implements _$PurchaseOrderItemDetailCopyWith<$Res> {
  __$PurchaseOrderItemDetailCopyWithImpl(this._self, this._then);

  final _PurchaseOrderItemDetail _self;
  final $Res Function(_PurchaseOrderItemDetail) _then;

/// Create a copy of PurchaseOrderItemDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? materialId = freezed,Object? materialName = freezed,Object? materialCode = freezed,Object? materialSpecification = freezed,Object? materialUnit = freezed,Object? supplierCode = freezed,Object? quantity = freezed,Object? receivedQuantity = freezed,Object? remainingQuantity = freezed,Object? unitPrice = freezed,Object? subtotal = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? notes = freezed,Object? workOrderMaterialId = freezed,}) {
  return _then(_PurchaseOrderItemDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,materialId: freezed == materialId ? _self.materialId : materialId // ignore: cast_nullable_to_non_nullable
as int?,materialName: freezed == materialName ? _self.materialName : materialName // ignore: cast_nullable_to_non_nullable
as String?,materialCode: freezed == materialCode ? _self.materialCode : materialCode // ignore: cast_nullable_to_non_nullable
as String?,materialSpecification: freezed == materialSpecification ? _self.materialSpecification : materialSpecification // ignore: cast_nullable_to_non_nullable
as String?,materialUnit: freezed == materialUnit ? _self.materialUnit : materialUnit // ignore: cast_nullable_to_non_nullable
as String?,supplierCode: freezed == supplierCode ? _self.supplierCode : supplierCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,receivedQuantity: freezed == receivedQuantity ? _self.receivedQuantity : receivedQuantity // ignore: cast_nullable_to_non_nullable
as double?,remainingQuantity: freezed == remainingQuantity ? _self.remainingQuantity : remainingQuantity // ignore: cast_nullable_to_non_nullable
as double?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,workOrderMaterialId: freezed == workOrderMaterialId ? _self.workOrderMaterialId : workOrderMaterialId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
