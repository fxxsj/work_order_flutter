// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
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
    @JsonKey(name: 'quantity_defective', fromJson: _doubleOrNullFromJson)
    double? quantityDefective,
    @JsonKey(name: 'auto_calculate_quantity', fromJson: _boolOrNullFromJson)
    bool? autoCalculateQuantity,
    @JsonKey(name: 'production_requirements', fromJson: _stringOrNullFromJson)
    String? productionRequirements,
    @JsonKey(name: 'material_purchase_status', fromJson: _stringOrNullFromJson)
    String? materialPurchaseStatus,
    @JsonKey(name: 'is_draft', fromJson: _boolOrNullFromJson) bool? isDraft,
    @JsonKey(name: 'is_subtask', fromJson: _boolOrNullFromJson) bool? isSubtask,
    @JsonKey(name: 'subtasks_count', fromJson: _intOrNullFromJson)
    int? subtasksCount,
    @JsonKey(name: 'parent_task_id', fromJson: _intOrNullFromJson)
    int? parentTaskId,
    @JsonKey(fromJson: _intOrNullFromJson) int? version,
    @JsonKey(name: 'artwork_code', fromJson: _stringOrNullFromJson)
    String? artworkCode,
    @JsonKey(name: 'artwork_name', fromJson: _stringOrNullFromJson)
    String? artworkName,
    @JsonKey(name: 'die_code', fromJson: _stringOrNullFromJson) String? dieCode,
    @JsonKey(name: 'die_name', fromJson: _stringOrNullFromJson) String? dieName,
    @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
    String? productCode,
    @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
    String? productName,
    @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
    String? materialCode,
    @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
    String? materialName,
    @JsonKey(name: 'material_size', fromJson: _stringOrNullFromJson)
    String? materialSize,
    @JsonKey(name: 'material_usage', fromJson: _stringOrNullFromJson)
    String? materialUsage,
    @JsonKey(name: 'foiling_plate_code', fromJson: _stringOrNullFromJson)
    String? foilingPlateCode,
    @JsonKey(name: 'foiling_plate_name', fromJson: _stringOrNullFromJson)
    String? foilingPlateName,
    @JsonKey(name: 'embossing_plate_code', fromJson: _stringOrNullFromJson)
    String? embossingPlateCode,
    @JsonKey(name: 'embossing_plate_name', fromJson: _stringOrNullFromJson)
    String? embossingPlateName,
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
      name: 'process_id',
      readValue: _readProcessId,
      fromJson: _intOrNullFromJson,
    )
    int? processId,
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
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? updatedAt,
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

bool? _boolOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is bool) return value;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1' || text == 'yes') return true;
  if (text == 'false' || text == '0' || text == 'no') return false;
  return null;
}

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

Object? _readProcessId(Map json, String key) {
  return json[key] ?? _processInfo(json)?['id'];
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
