// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    @JsonKey(fromJson: _intFromJson) required int id,
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
      fromJson: _intOrNullFromJson,
    )
    int? workOrderId,
    @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson,
    )
    String? workOrderNumber,
    @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson,
    )
    String? customerName,
    @JsonKey(
      name: 'process_name',
      readValue: _readProcessName,
      fromJson: _stringOrNullFromJson,
    )
    String? processName,
    @JsonKey(
      name: 'priority_display',
      readValue: _readPriorityDisplay,
      fromJson: _stringOrNullFromJson,
    )
    String? priorityDisplay,
    @JsonKey(
      name: 'delivery_date',
      readValue: _readDeliveryDate,
      fromJson: _dateTimeOrNullFromJson,
    )
    DateTime? deliveryDate,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

double? _doubleOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

Object? _readWorkOrderId(Map json, String key) {
  return json[key] ?? _workOrderInfo(json)?['id'];
}

Object? _readWorkOrderNumber(Map json, String key) {
  return json[key] ?? _workOrderInfo(json)?['order_number'];
}

Object? _readCustomerName(Map json, String key) {
  return json[key] ?? _workOrderInfo(json)?['customer_name'];
}

Object? _readProcessName(Map json, String key) {
  return json[key] ?? _processInfo(json)?['name'];
}

Object? _readPriorityDisplay(Map json, String key) {
  return json[key] ?? _workOrderInfo(json)?['priority_display'];
}

Object? _readDeliveryDate(Map json, String key) {
  return json[key] ?? _workOrderInfo(json)?['delivery_date'];
}

Map? _workOrderInfo(Map json) {
  final workOrderProcessInfo = json['work_order_process_info'];
  if (workOrderProcessInfo is! Map) return null;
  final workOrderInfo = workOrderProcessInfo['work_order'];
  return workOrderInfo is Map ? workOrderInfo : null;
}

Map? _processInfo(Map json) {
  final workOrderProcessInfo = json['work_order_process_info'];
  if (workOrderProcessInfo is! Map) return null;
  final processInfo = workOrderProcessInfo['process'];
  return processInfo is Map ? processInfo : null;
}
