// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)
  String? get workContent => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)
  String? get taskType => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)
  String? get taskTypeDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)
  int? get assignedDepartmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)
  String? get assignedDepartmentName => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)
  int? get assignedOperatorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)
  String? get assignedOperatorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)
  double? get productionQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)
  double? get quantityCompleted => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'work_order_id',
      readValue: _readWorkOrderId,
      fromJson: _intOrNullFromJson)
  int? get workOrderId => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'process_name',
      readValue: _readProcessName,
      fromJson: _stringOrNullFromJson)
  String? get processName => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'process_id',
      readValue: _readProcessId,
      fromJson: _intOrNullFromJson)
  int? get processId => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'priority_display',
      readValue: _readPriorityDisplay,
      fromJson: _stringOrNullFromJson)
  String? get priorityDisplay => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'delivery_date',
      readValue: _readDeliveryDate,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)
      String? workContent,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)
      String? taskType,
      @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)
      String? taskTypeDisplay,
      @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)
      int? assignedDepartmentId,
      @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)
      String? assignedDepartmentName,
      @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)
      int? assignedOperatorId,
      @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)
      String? assignedOperatorName,
      @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)
      double? productionQuantity,
      @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)
      double? quantityCompleted,
      @JsonKey(
          name: 'work_order_id',
          readValue: _readWorkOrderId,
          fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(
          name: 'customer_name',
          readValue: _readCustomerName,
          fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(
          name: 'process_name',
          readValue: _readProcessName,
          fromJson: _stringOrNullFromJson)
      String? processName,
      @JsonKey(
          name: 'process_id',
          readValue: _readProcessId,
          fromJson: _intOrNullFromJson)
      int? processId,
      @JsonKey(
          name: 'priority_display',
          readValue: _readPriorityDisplay,
          fromJson: _stringOrNullFromJson)
      String? priorityDisplay,
      @JsonKey(
          name: 'delivery_date',
          readValue: _readDeliveryDate,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workContent = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? taskType = freezed,
    Object? taskTypeDisplay = freezed,
    Object? assignedDepartmentId = freezed,
    Object? assignedDepartmentName = freezed,
    Object? assignedOperatorId = freezed,
    Object? assignedOperatorName = freezed,
    Object? productionQuantity = freezed,
    Object? quantityCompleted = freezed,
    Object? workOrderId = freezed,
    Object? workOrderNumber = freezed,
    Object? customerName = freezed,
    Object? processName = freezed,
    Object? processId = freezed,
    Object? priorityDisplay = freezed,
    Object? deliveryDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workContent: freezed == workContent
          ? _value.workContent
          : workContent // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as String?,
      taskTypeDisplay: freezed == taskTypeDisplay
          ? _value.taskTypeDisplay
          : taskTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedDepartmentId: freezed == assignedDepartmentId
          ? _value.assignedDepartmentId
          : assignedDepartmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedDepartmentName: freezed == assignedDepartmentName
          ? _value.assignedDepartmentName
          : assignedDepartmentName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedOperatorId: freezed == assignedOperatorId
          ? _value.assignedOperatorId
          : assignedOperatorId // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedOperatorName: freezed == assignedOperatorName
          ? _value.assignedOperatorName
          : assignedOperatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      productionQuantity: freezed == productionQuantity
          ? _value.productionQuantity
          : productionQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      quantityCompleted: freezed == quantityCompleted
          ? _value.quantityCompleted
          : quantityCompleted // ignore: cast_nullable_to_non_nullable
              as double?,
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
      processName: freezed == processName
          ? _value.processName
          : processName // ignore: cast_nullable_to_non_nullable
              as String?,
      processId: freezed == processId
          ? _value.processId
          : processId // ignore: cast_nullable_to_non_nullable
              as int?,
      priorityDisplay: freezed == priorityDisplay
          ? _value.priorityDisplay
          : priorityDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)
      String? workContent,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)
      String? taskType,
      @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)
      String? taskTypeDisplay,
      @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)
      int? assignedDepartmentId,
      @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)
      String? assignedDepartmentName,
      @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)
      int? assignedOperatorId,
      @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)
      String? assignedOperatorName,
      @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)
      double? productionQuantity,
      @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)
      double? quantityCompleted,
      @JsonKey(
          name: 'work_order_id',
          readValue: _readWorkOrderId,
          fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(
          name: 'customer_name',
          readValue: _readCustomerName,
          fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(
          name: 'process_name',
          readValue: _readProcessName,
          fromJson: _stringOrNullFromJson)
      String? processName,
      @JsonKey(
          name: 'process_id',
          readValue: _readProcessId,
          fromJson: _intOrNullFromJson)
      int? processId,
      @JsonKey(
          name: 'priority_display',
          readValue: _readPriorityDisplay,
          fromJson: _stringOrNullFromJson)
      String? priorityDisplay,
      @JsonKey(
          name: 'delivery_date',
          readValue: _readDeliveryDate,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? deliveryDate});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workContent = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? taskType = freezed,
    Object? taskTypeDisplay = freezed,
    Object? assignedDepartmentId = freezed,
    Object? assignedDepartmentName = freezed,
    Object? assignedOperatorId = freezed,
    Object? assignedOperatorName = freezed,
    Object? productionQuantity = freezed,
    Object? quantityCompleted = freezed,
    Object? workOrderId = freezed,
    Object? workOrderNumber = freezed,
    Object? customerName = freezed,
    Object? processName = freezed,
    Object? processId = freezed,
    Object? priorityDisplay = freezed,
    Object? deliveryDate = freezed,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workContent: freezed == workContent
          ? _value.workContent
          : workContent // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as String?,
      taskTypeDisplay: freezed == taskTypeDisplay
          ? _value.taskTypeDisplay
          : taskTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedDepartmentId: freezed == assignedDepartmentId
          ? _value.assignedDepartmentId
          : assignedDepartmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedDepartmentName: freezed == assignedDepartmentName
          ? _value.assignedDepartmentName
          : assignedDepartmentName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedOperatorId: freezed == assignedOperatorId
          ? _value.assignedOperatorId
          : assignedOperatorId // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedOperatorName: freezed == assignedOperatorName
          ? _value.assignedOperatorName
          : assignedOperatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      productionQuantity: freezed == productionQuantity
          ? _value.productionQuantity
          : productionQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      quantityCompleted: freezed == quantityCompleted
          ? _value.quantityCompleted
          : quantityCompleted // ignore: cast_nullable_to_non_nullable
              as double?,
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
      processName: freezed == processName
          ? _value.processName
          : processName // ignore: cast_nullable_to_non_nullable
              as String?,
      processId: freezed == processId
          ? _value.processId
          : processId // ignore: cast_nullable_to_non_nullable
              as int?,
      priorityDisplay: freezed == priorityDisplay
          ? _value.priorityDisplay
          : priorityDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryDate: freezed == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)
      this.workContent,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)
      this.taskType,
      @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)
      this.taskTypeDisplay,
      @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)
      this.assignedDepartmentId,
      @JsonKey(
          name: 'assigned_department_name', fromJson: _stringOrNullFromJson)
      this.assignedDepartmentName,
      @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)
      this.assignedOperatorId,
      @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)
      this.assignedOperatorName,
      @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)
      this.productionQuantity,
      @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)
      this.quantityCompleted,
      @JsonKey(
          name: 'work_order_id',
          readValue: _readWorkOrderId,
          fromJson: _intOrNullFromJson)
      this.workOrderId,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(
          name: 'customer_name',
          readValue: _readCustomerName,
          fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(
          name: 'process_name',
          readValue: _readProcessName,
          fromJson: _stringOrNullFromJson)
      this.processName,
      @JsonKey(
          name: 'process_id',
          readValue: _readProcessId,
          fromJson: _intOrNullFromJson)
      this.processId,
      @JsonKey(
          name: 'priority_display',
          readValue: _readPriorityDisplay,
          fromJson: _stringOrNullFromJson)
      this.priorityDisplay,
      @JsonKey(
          name: 'delivery_date',
          readValue: _readDeliveryDate,
          fromJson: _dateTimeOrNullFromJson)
      this.deliveryDate});

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)
  final String? workContent;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)
  final String? taskType;
  @override
  @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)
  final String? taskTypeDisplay;
  @override
  @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)
  final int? assignedDepartmentId;
  @override
  @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)
  final String? assignedDepartmentName;
  @override
  @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)
  final int? assignedOperatorId;
  @override
  @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)
  final String? assignedOperatorName;
  @override
  @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)
  final double? productionQuantity;
  @override
  @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)
  final double? quantityCompleted;
  @override
  @JsonKey(
      name: 'work_order_id',
      readValue: _readWorkOrderId,
      fromJson: _intOrNullFromJson)
  final int? workOrderId;
  @override
  @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(
      name: 'process_name',
      readValue: _readProcessName,
      fromJson: _stringOrNullFromJson)
  final String? processName;
  @override
  @JsonKey(
      name: 'process_id',
      readValue: _readProcessId,
      fromJson: _intOrNullFromJson)
  final int? processId;
  @override
  @JsonKey(
      name: 'priority_display',
      readValue: _readPriorityDisplay,
      fromJson: _stringOrNullFromJson)
  final String? priorityDisplay;
  @override
  @JsonKey(
      name: 'delivery_date',
      readValue: _readDeliveryDate,
      fromJson: _dateTimeOrNullFromJson)
  final DateTime? deliveryDate;

  @override
  String toString() {
    return 'Task(id: $id, workContent: $workContent, status: $status, statusDisplay: $statusDisplay, taskType: $taskType, taskTypeDisplay: $taskTypeDisplay, assignedDepartmentId: $assignedDepartmentId, assignedDepartmentName: $assignedDepartmentName, assignedOperatorId: $assignedOperatorId, assignedOperatorName: $assignedOperatorName, productionQuantity: $productionQuantity, quantityCompleted: $quantityCompleted, workOrderId: $workOrderId, workOrderNumber: $workOrderNumber, customerName: $customerName, processName: $processName, processId: $processId, priorityDisplay: $priorityDisplay, deliveryDate: $deliveryDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workContent, workContent) ||
                other.workContent == workContent) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.taskTypeDisplay, taskTypeDisplay) ||
                other.taskTypeDisplay == taskTypeDisplay) &&
            (identical(other.assignedDepartmentId, assignedDepartmentId) ||
                other.assignedDepartmentId == assignedDepartmentId) &&
            (identical(other.assignedDepartmentName, assignedDepartmentName) ||
                other.assignedDepartmentName == assignedDepartmentName) &&
            (identical(other.assignedOperatorId, assignedOperatorId) ||
                other.assignedOperatorId == assignedOperatorId) &&
            (identical(other.assignedOperatorName, assignedOperatorName) ||
                other.assignedOperatorName == assignedOperatorName) &&
            (identical(other.productionQuantity, productionQuantity) ||
                other.productionQuantity == productionQuantity) &&
            (identical(other.quantityCompleted, quantityCompleted) ||
                other.quantityCompleted == quantityCompleted) &&
            (identical(other.workOrderId, workOrderId) ||
                other.workOrderId == workOrderId) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.processName, processName) ||
                other.processName == processName) &&
            (identical(other.processId, processId) ||
                other.processId == processId) &&
            (identical(other.priorityDisplay, priorityDisplay) ||
                other.priorityDisplay == priorityDisplay) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        workContent,
        status,
        statusDisplay,
        taskType,
        taskTypeDisplay,
        assignedDepartmentId,
        assignedDepartmentName,
        assignedOperatorId,
        assignedOperatorName,
        productionQuantity,
        quantityCompleted,
        workOrderId,
        workOrderNumber,
        customerName,
        processName,
        processId,
        priorityDisplay,
        deliveryDate
      ]);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  const factory _Task(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)
      final String? workContent,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)
      final String? taskType,
      @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)
      final String? taskTypeDisplay,
      @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)
      final int? assignedDepartmentId,
      @JsonKey(
          name: 'assigned_department_name', fromJson: _stringOrNullFromJson)
      final String? assignedDepartmentName,
      @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)
      final int? assignedOperatorId,
      @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)
      final String? assignedOperatorName,
      @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)
      final double? productionQuantity,
      @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)
      final double? quantityCompleted,
      @JsonKey(
          name: 'work_order_id',
          readValue: _readWorkOrderId,
          fromJson: _intOrNullFromJson)
      final int? workOrderId,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      final String? workOrderNumber,
      @JsonKey(
          name: 'customer_name',
          readValue: _readCustomerName,
          fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(
          name: 'process_name',
          readValue: _readProcessName,
          fromJson: _stringOrNullFromJson)
      final String? processName,
      @JsonKey(
          name: 'process_id',
          readValue: _readProcessId,
          fromJson: _intOrNullFromJson)
      final int? processId,
      @JsonKey(
          name: 'priority_display',
          readValue: _readPriorityDisplay,
          fromJson: _stringOrNullFromJson)
      final String? priorityDisplay,
      @JsonKey(
          name: 'delivery_date',
          readValue: _readDeliveryDate,
          fromJson: _dateTimeOrNullFromJson)
      final DateTime? deliveryDate}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'work_content', fromJson: _stringOrNullFromJson)
  String? get workContent;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'task_type', fromJson: _stringOrNullFromJson)
  String? get taskType;
  @override
  @JsonKey(name: 'task_type_display', fromJson: _stringOrNullFromJson)
  String? get taskTypeDisplay;
  @override
  @JsonKey(name: 'assigned_department', fromJson: _intOrNullFromJson)
  int? get assignedDepartmentId;
  @override
  @JsonKey(name: 'assigned_department_name', fromJson: _stringOrNullFromJson)
  String? get assignedDepartmentName;
  @override
  @JsonKey(name: 'assigned_operator', fromJson: _intOrNullFromJson)
  int? get assignedOperatorId;
  @override
  @JsonKey(name: 'assigned_operator_name', fromJson: _stringOrNullFromJson)
  String? get assignedOperatorName;
  @override
  @JsonKey(name: 'production_quantity', fromJson: _doubleOrNullFromJson)
  double? get productionQuantity;
  @override
  @JsonKey(name: 'quantity_completed', fromJson: _doubleOrNullFromJson)
  double? get quantityCompleted;
  @override
  @JsonKey(
      name: 'work_order_id',
      readValue: _readWorkOrderId,
      fromJson: _intOrNullFromJson)
  int? get workOrderId;
  @override
  @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(
      name: 'process_name',
      readValue: _readProcessName,
      fromJson: _stringOrNullFromJson)
  String? get processName;
  @override
  @JsonKey(
      name: 'process_id',
      readValue: _readProcessId,
      fromJson: _intOrNullFromJson)
  int? get processId;
  @override
  @JsonKey(
      name: 'priority_display',
      readValue: _readPriorityDisplay,
      fromJson: _stringOrNullFromJson)
  String? get priorityDisplay;
  @override
  @JsonKey(
      name: 'delivery_date',
      readValue: _readDeliveryDate,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get deliveryDate;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
