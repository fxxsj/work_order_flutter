import 'package:work_order_app/src/core/utils/parse_utils.dart';

class Task {
  const Task({
    required this.id,
    this.workContent,
    this.status,
    this.statusDisplay,
    this.taskType,
    this.taskTypeDisplay,
    this.assignedDepartmentName,
    this.assignedOperatorName,
    this.productionQuantity,
    this.quantityCompleted,
    this.workOrderId,
    this.workOrderNumber,
    this.processName,
    this.priorityDisplay,
    this.deliveryDate,
  });

  final int id;
  final String? workContent;
  final String? status;
  final String? statusDisplay;
  final String? taskType;
  final String? taskTypeDisplay;
  final String? assignedDepartmentName;
  final String? assignedOperatorName;
  final double? productionQuantity;
  final double? quantityCompleted;
  final int? workOrderId;
  final String? workOrderNumber;
  final String? processName;
  final String? priorityDisplay;
  final DateTime? deliveryDate;

  factory Task.fromJson(Map<String, dynamic> json) {
    final workOrderProcessInfo = json['work_order_process_info'];
    final workOrderInfo = workOrderProcessInfo is Map ? workOrderProcessInfo['work_order'] : null;
    final processInfo = workOrderProcessInfo is Map ? workOrderProcessInfo['process'] : null;

    return Task(
      id: toInt(json['id']) ?? 0,
      workContent: toStringOrNull(json['work_content']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      taskType: toStringOrNull(json['task_type']),
      taskTypeDisplay: toStringOrNull(json['task_type_display']),
      assignedDepartmentName: toStringOrNull(json['assigned_department_name']),
      assignedOperatorName: toStringOrNull(json['assigned_operator_name']),
      productionQuantity: _toDouble(json['production_quantity']),
      quantityCompleted: _toDouble(json['quantity_completed']),
      workOrderId: workOrderInfo is Map ? toInt(workOrderInfo['id']) : null,
      workOrderNumber: workOrderInfo is Map ? toStringOrNull(workOrderInfo['order_number']) : null,
      priorityDisplay: workOrderInfo is Map ? toStringOrNull(workOrderInfo['priority_display']) : null,
      deliveryDate: workOrderInfo is Map ? toDateTime(workOrderInfo['delivery_date']) : null,
      processName: processInfo is Map ? toStringOrNull(processInfo['name']) : null,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
