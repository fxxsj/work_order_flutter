// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: _intFromJson(json['id']),
      workContent: _stringOrNullFromJson(json['work_content']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      taskType: _stringOrNullFromJson(json['task_type']),
      taskTypeDisplay: _stringOrNullFromJson(json['task_type_display']),
      assignedDepartmentId: _intOrNullFromJson(json['assigned_department']),
      assignedDepartmentName:
          _stringOrNullFromJson(json['assigned_department_name']),
      assignedOperatorId: _intOrNullFromJson(json['assigned_operator']),
      assignedOperatorName:
          _stringOrNullFromJson(json['assigned_operator_name']),
      productionQuantity: _doubleOrNullFromJson(json['production_quantity']),
      quantityCompleted: _doubleOrNullFromJson(json['quantity_completed']),
      workOrderId: _intOrNullFromJson(_readWorkOrderId(json, 'work_order_id')),
      workOrderNumber: _stringOrNullFromJson(
          _readWorkOrderNumber(json, 'work_order_number')),
      customerName:
          _stringOrNullFromJson(_readCustomerName(json, 'customer_name')),
      processName:
          _stringOrNullFromJson(_readProcessName(json, 'process_name')),
      processId: _intOrNullFromJson(_readProcessId(json, 'process_id')),
      priorityDisplay:
          _stringOrNullFromJson(_readPriorityDisplay(json, 'priority_display')),
      deliveryDate:
          _dateTimeOrNullFromJson(_readDeliveryDate(json, 'delivery_date')),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'work_content': instance.workContent,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'task_type': instance.taskType,
      'task_type_display': instance.taskTypeDisplay,
      'assigned_department': instance.assignedDepartmentId,
      'assigned_department_name': instance.assignedDepartmentName,
      'assigned_operator': instance.assignedOperatorId,
      'assigned_operator_name': instance.assignedOperatorName,
      'production_quantity': instance.productionQuantity,
      'quantity_completed': instance.quantityCompleted,
      'work_order_id': instance.workOrderId,
      'work_order_number': instance.workOrderNumber,
      'customer_name': instance.customerName,
      'process_name': instance.processName,
      'process_id': instance.processId,
      'priority_display': instance.priorityDisplay,
      'delivery_date': instance.deliveryDate?.toIso8601String(),
    };
