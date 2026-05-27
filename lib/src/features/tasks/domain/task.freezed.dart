// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson) String? get workContent;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson) String? get taskType;@JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson) String? get taskTypeDisplay;@JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson) int? get assignedDepartmentId;@JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson) String? get assignedDepartmentName;@JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson) int? get assignedOperatorId;@JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson) String? get assignedOperatorName;@JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson) double? get productionQuantity;@JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson) double? get quantityCompleted;@JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson) int? get workOrderId;@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson) String? get processName;@JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson) int? get processId;@JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson) String? get priorityDisplay;@JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson) DateTime? get deliveryDate;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.workContent, workContent) || other.workContent == workContent)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.taskTypeDisplay, taskTypeDisplay) || other.taskTypeDisplay == taskTypeDisplay)&&(identical(other.assignedDepartmentId, assignedDepartmentId) || other.assignedDepartmentId == assignedDepartmentId)&&(identical(other.assignedDepartmentName, assignedDepartmentName) || other.assignedDepartmentName == assignedDepartmentName)&&(identical(other.assignedOperatorId, assignedOperatorId) || other.assignedOperatorId == assignedOperatorId)&&(identical(other.assignedOperatorName, assignedOperatorName) || other.assignedOperatorName == assignedOperatorName)&&(identical(other.productionQuantity, productionQuantity) || other.productionQuantity == productionQuantity)&&(identical(other.quantityCompleted, quantityCompleted) || other.quantityCompleted == quantityCompleted)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.processName, processName) || other.processName == processName)&&(identical(other.processId, processId) || other.processId == processId)&&(identical(other.priorityDisplay, priorityDisplay) || other.priorityDisplay == priorityDisplay)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,workContent,status,statusDisplay,taskType,taskTypeDisplay,assignedDepartmentId,assignedDepartmentName,assignedOperatorId,assignedOperatorName,productionQuantity,quantityCompleted,workOrderId,workOrderNumber,customerName,processName,processId,priorityDisplay,deliveryDate]);

@override
String toString() {
  return 'Task(id: $id, workContent: $workContent, status: $status, statusDisplay: $statusDisplay, taskType: $taskType, taskTypeDisplay: $taskTypeDisplay, assignedDepartmentId: $assignedDepartmentId, assignedDepartmentName: $assignedDepartmentName, assignedOperatorId: $assignedOperatorId, assignedOperatorName: $assignedOperatorName, productionQuantity: $productionQuantity, quantityCompleted: $quantityCompleted, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, customerName: $customerName, processName: $processName, processId: $processId, priorityDisplay: $priorityDisplay, deliveryDate: $deliveryDate)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson) String? workContent,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson) String? taskType,@JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson) String? taskTypeDisplay,@JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson) int? assignedDepartmentId,@JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson) String? assignedDepartmentName,@JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson) int? assignedOperatorId,@JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson) String? assignedOperatorName,@JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson) double? productionQuantity,@JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson) double? quantityCompleted,@JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson) String? processName,@JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson) int? processId,@JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson) String? priorityDisplay,@JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workContent = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? taskType = freezed,Object? taskTypeDisplay = freezed,Object? assignedDepartmentId = freezed,Object? assignedDepartmentName = freezed,Object? assignedOperatorId = freezed,Object? assignedOperatorName = freezed,Object? productionQuantity = freezed,Object? quantityCompleted = freezed,Object? workOrderId = freezed,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? processName = freezed,Object? processId = freezed,Object? priorityDisplay = freezed,Object? deliveryDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workContent: freezed == workContent ? _self.workContent : workContent // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,taskTypeDisplay: freezed == taskTypeDisplay ? _self.taskTypeDisplay : taskTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,assignedDepartmentId: freezed == assignedDepartmentId ? _self.assignedDepartmentId : assignedDepartmentId // ignore: cast_nullable_to_non_nullable
as int?,assignedDepartmentName: freezed == assignedDepartmentName ? _self.assignedDepartmentName : assignedDepartmentName // ignore: cast_nullable_to_non_nullable
as String?,assignedOperatorId: freezed == assignedOperatorId ? _self.assignedOperatorId : assignedOperatorId // ignore: cast_nullable_to_non_nullable
as int?,assignedOperatorName: freezed == assignedOperatorName ? _self.assignedOperatorName : assignedOperatorName // ignore: cast_nullable_to_non_nullable
as String?,productionQuantity: freezed == productionQuantity ? _self.productionQuantity : productionQuantity // ignore: cast_nullable_to_non_nullable
as double?,quantityCompleted: freezed == quantityCompleted ? _self.quantityCompleted : quantityCompleted // ignore: cast_nullable_to_non_nullable
as double?,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,processName: freezed == processName ? _self.processName : processName // ignore: cast_nullable_to_non_nullable
as String?,processId: freezed == processId ? _self.processId : processId // ignore: cast_nullable_to_non_nullable
as int?,priorityDisplay: freezed == priorityDisplay ? _self.priorityDisplay : priorityDisplay // ignore: cast_nullable_to_non_nullable
as String?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)  String? workContent, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)  String? taskType, @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)  String? taskTypeDisplay, @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)  int? assignedDepartmentId, @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)  String? assignedDepartmentName, @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)  int? assignedOperatorId, @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)  String? assignedOperatorName, @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)  double? productionQuantity, @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)  double? quantityCompleted, @JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson)  String? processName, @JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson)  int? processId, @JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson)  String? priorityDisplay, @JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.workContent,_that.status,_that.statusDisplay,_that.taskType,_that.taskTypeDisplay,_that.assignedDepartmentId,_that.assignedDepartmentName,_that.assignedOperatorId,_that.assignedOperatorName,_that.productionQuantity,_that.quantityCompleted,_that.workOrderId,_that.workOrderNumber,_that.customerName,_that.processName,_that.processId,_that.priorityDisplay,_that.deliveryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)  String? workContent, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)  String? taskType, @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)  String? taskTypeDisplay, @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)  int? assignedDepartmentId, @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)  String? assignedDepartmentName, @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)  int? assignedOperatorId, @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)  String? assignedOperatorName, @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)  double? productionQuantity, @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)  double? quantityCompleted, @JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson)  String? processName, @JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson)  int? processId, @JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson)  String? priorityDisplay, @JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.workContent,_that.status,_that.statusDisplay,_that.taskType,_that.taskTypeDisplay,_that.assignedDepartmentId,_that.assignedDepartmentName,_that.assignedOperatorId,_that.assignedOperatorName,_that.productionQuantity,_that.quantityCompleted,_that.workOrderId,_that.workOrderNumber,_that.customerName,_that.processName,_that.processId,_that.priorityDisplay,_that.deliveryDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)  String? workContent, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)  String? taskType, @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)  String? taskTypeDisplay, @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)  int? assignedDepartmentId, @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)  String? assignedDepartmentName, @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)  int? assignedOperatorId, @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)  String? assignedOperatorName, @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)  double? productionQuantity, @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)  double? quantityCompleted, @JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson)  String? processName, @JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson)  int? processId, @JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson)  String? priorityDisplay, @JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson)  DateTime? deliveryDate)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.workContent,_that.status,_that.statusDisplay,_that.taskType,_that.taskTypeDisplay,_that.assignedDepartmentId,_that.assignedDepartmentName,_that.assignedOperatorId,_that.assignedOperatorName,_that.productionQuantity,_that.quantityCompleted,_that.workOrderId,_that.workOrderNumber,_that.customerName,_that.processName,_that.processId,_that.priorityDisplay,_that.deliveryDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task implements Task {
  const _Task({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson) this.workContent, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson) this.taskType, @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson) this.taskTypeDisplay, @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson) this.assignedDepartmentId, @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson) this.assignedDepartmentName, @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson) this.assignedOperatorId, @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson) this.assignedOperatorName, @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson) this.productionQuantity, @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson) this.quantityCompleted, @JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson) this.workOrderId, @JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson) this.processName, @JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson) this.processId, @JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson) this.priorityDisplay, @JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson) this.deliveryDate});
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson) final  String? workContent;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson) final  String? taskType;
@override@JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson) final  String? taskTypeDisplay;
@override@JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson) final  int? assignedDepartmentId;
@override@JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson) final  String? assignedDepartmentName;
@override@JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson) final  int? assignedOperatorId;
@override@JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson) final  String? assignedOperatorName;
@override@JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson) final  double? productionQuantity;
@override@JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson) final  double? quantityCompleted;
@override@JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson) final  int? workOrderId;
@override@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson) final  String? processName;
@override@JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson) final  int? processId;
@override@JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson) final  String? priorityDisplay;
@override@JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson) final  DateTime? deliveryDate;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.workContent, workContent) || other.workContent == workContent)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.taskTypeDisplay, taskTypeDisplay) || other.taskTypeDisplay == taskTypeDisplay)&&(identical(other.assignedDepartmentId, assignedDepartmentId) || other.assignedDepartmentId == assignedDepartmentId)&&(identical(other.assignedDepartmentName, assignedDepartmentName) || other.assignedDepartmentName == assignedDepartmentName)&&(identical(other.assignedOperatorId, assignedOperatorId) || other.assignedOperatorId == assignedOperatorId)&&(identical(other.assignedOperatorName, assignedOperatorName) || other.assignedOperatorName == assignedOperatorName)&&(identical(other.productionQuantity, productionQuantity) || other.productionQuantity == productionQuantity)&&(identical(other.quantityCompleted, quantityCompleted) || other.quantityCompleted == quantityCompleted)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.processName, processName) || other.processName == processName)&&(identical(other.processId, processId) || other.processId == processId)&&(identical(other.priorityDisplay, priorityDisplay) || other.priorityDisplay == priorityDisplay)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,workContent,status,statusDisplay,taskType,taskTypeDisplay,assignedDepartmentId,assignedDepartmentName,assignedOperatorId,assignedOperatorName,productionQuantity,quantityCompleted,workOrderId,workOrderNumber,customerName,processName,processId,priorityDisplay,deliveryDate]);

@override
String toString() {
  return 'Task(id: $id, workContent: $workContent, status: $status, statusDisplay: $statusDisplay, taskType: $taskType, taskTypeDisplay: $taskTypeDisplay, assignedDepartmentId: $assignedDepartmentId, assignedDepartmentName: $assignedDepartmentName, assignedOperatorId: $assignedOperatorId, assignedOperatorName: $assignedOperatorName, productionQuantity: $productionQuantity, quantityCompleted: $quantityCompleted, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, customerName: $customerName, processName: $processName, processId: $processId, priorityDisplay: $priorityDisplay, deliveryDate: $deliveryDate)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson) String? workContent,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson) String? taskType,@JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson) String? taskTypeDisplay,@JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson) int? assignedDepartmentId,@JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson) String? assignedDepartmentName,@JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson) int? assignedOperatorId,@JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson) String? assignedOperatorName,@JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson) double? productionQuantity,@JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson) double? quantityCompleted,@JsonKey(name: 'work_order_id', readValue: _readWorkOrderId, fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'work_order_number', readValue: _readWorkOrderNumber, fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'process_name', readValue: _readProcessName, fromJson: _stringOrNullFromJson) String? processName,@JsonKey(name: 'process_id', readValue: _readProcessId, fromJson: _intOrNullFromJson) int? processId,@JsonKey(name: 'priority_display', readValue: _readPriorityDisplay, fromJson: _stringOrNullFromJson) String? priorityDisplay,@JsonKey(name: 'delivery_date', readValue: _readDeliveryDate, fromJson: _dateTimeOrNullFromJson) DateTime? deliveryDate
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workContent = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? taskType = freezed,Object? taskTypeDisplay = freezed,Object? assignedDepartmentId = freezed,Object? assignedDepartmentName = freezed,Object? assignedOperatorId = freezed,Object? assignedOperatorName = freezed,Object? productionQuantity = freezed,Object? quantityCompleted = freezed,Object? workOrderId = freezed,Object? workOrderNumber = freezed,Object? customerName = freezed,Object? processName = freezed,Object? processId = freezed,Object? priorityDisplay = freezed,Object? deliveryDate = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,workContent: freezed == workContent ? _self.workContent : workContent // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,taskTypeDisplay: freezed == taskTypeDisplay ? _self.taskTypeDisplay : taskTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,assignedDepartmentId: freezed == assignedDepartmentId ? _self.assignedDepartmentId : assignedDepartmentId // ignore: cast_nullable_to_non_nullable
as int?,assignedDepartmentName: freezed == assignedDepartmentName ? _self.assignedDepartmentName : assignedDepartmentName // ignore: cast_nullable_to_non_nullable
as String?,assignedOperatorId: freezed == assignedOperatorId ? _self.assignedOperatorId : assignedOperatorId // ignore: cast_nullable_to_non_nullable
as int?,assignedOperatorName: freezed == assignedOperatorName ? _self.assignedOperatorName : assignedOperatorName // ignore: cast_nullable_to_non_nullable
as String?,productionQuantity: freezed == productionQuantity ? _self.productionQuantity : productionQuantity // ignore: cast_nullable_to_non_nullable
as double?,quantityCompleted: freezed == quantityCompleted ? _self.quantityCompleted : quantityCompleted // ignore: cast_nullable_to_non_nullable
as double?,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,processName: freezed == processName ? _self.processName : processName // ignore: cast_nullable_to_non_nullable
as String?,processId: freezed == processId ? _self.processId : processId // ignore: cast_nullable_to_non_nullable
as int?,priorityDisplay: freezed == priorityDisplay ? _self.priorityDisplay : priorityDisplay // ignore: cast_nullable_to_non_nullable
as String?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
