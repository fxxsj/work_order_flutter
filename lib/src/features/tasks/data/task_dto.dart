import 'package:work_order_app/src/features/tasks/domain/task.dart';

class TaskDto {
  const TaskDto({
    required this.id,
    this.workContent,
    this.status,
    this.statusDisplay,
    this.taskType,
    this.taskTypeDisplay,
    this.assignedDepartmentId,
    this.assignedDepartmentName,
    this.assignedOperatorId,
    this.assignedOperatorName,
    this.productionQuantity,
    this.quantityCompleted,
    this.workOrderId,
    this.workOrderNumber,
    this.customerName,
    this.processName,
    this.processId,
    this.priorityDisplay,
    this.deliveryDate,
  });

  final int id;
  final String? workContent;
  final String? status;
  final String? statusDisplay;
  final String? taskType;
  final String? taskTypeDisplay;
  final int? assignedDepartmentId;
  final String? assignedDepartmentName;
  final int? assignedOperatorId;
  final String? assignedOperatorName;
  final double? productionQuantity;
  final double? quantityCompleted;
  final int? workOrderId;
  final String? workOrderNumber;
  final String? customerName;
  final String? processName;
  final int? processId;
  final String? priorityDisplay;
  final DateTime? deliveryDate;

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return Task.fromJson(json).toDto();
  }

  Task toEntity() {
    return Task(
      id: id,
      workContent: workContent,
      status: status,
      statusDisplay: statusDisplay,
      taskType: taskType,
      taskTypeDisplay: taskTypeDisplay,
      assignedDepartmentId: assignedDepartmentId,
      assignedDepartmentName: assignedDepartmentName,
      assignedOperatorId: assignedOperatorId,
      assignedOperatorName: assignedOperatorName,
      productionQuantity: productionQuantity,
      quantityCompleted: quantityCompleted,
      workOrderId: workOrderId,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      processName: processName,
      processId: processId,
      priorityDisplay: priorityDisplay,
      deliveryDate: deliveryDate,
    );
  }
}

extension TaskMapper on Task {
  TaskDto toDto() {
    return TaskDto(
      id: id,
      workContent: workContent,
      status: status,
      statusDisplay: statusDisplay,
      taskType: taskType,
      taskTypeDisplay: taskTypeDisplay,
      assignedDepartmentId: assignedDepartmentId,
      assignedDepartmentName: assignedDepartmentName,
      assignedOperatorId: assignedOperatorId,
      assignedOperatorName: assignedOperatorName,
      productionQuantity: productionQuantity,
      quantityCompleted: quantityCompleted,
      workOrderId: workOrderId,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      processName: processName,
      processId: processId,
      priorityDisplay: priorityDisplay,
      deliveryDate: deliveryDate,
    );
  }
}

class TaskPageDto {
  const TaskPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<TaskDto> items;
  final int total;
  final int page;
  final int pageSize;
}
