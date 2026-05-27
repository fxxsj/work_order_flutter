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
    this.quantityDefective,
    this.autoCalculateQuantity,
    this.productionRequirements,
    this.materialPurchaseStatus,
    this.isDraft,
    this.isSubtask,
    this.subtasksCount,
    this.parentTaskId,
    this.version,
    this.artworkCode,
    this.artworkName,
    this.dieCode,
    this.dieName,
    this.productCode,
    this.productName,
    this.materialCode,
    this.materialName,
    this.foilingPlateCode,
    this.foilingPlateName,
    this.embossingPlateCode,
    this.embossingPlateName,
    this.workOrderId,
    this.workOrderNumber,
    this.customerName,
    this.processName,
    this.processId,
    this.priorityDisplay,
    this.deliveryDate,
    this.createdAt,
    this.updatedAt,
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
  final double? quantityDefective;
  final bool? autoCalculateQuantity;
  final String? productionRequirements;
  final String? materialPurchaseStatus;
  final bool? isDraft;
  final bool? isSubtask;
  final int? subtasksCount;
  final int? parentTaskId;
  final int? version;
  final String? artworkCode;
  final String? artworkName;
  final String? dieCode;
  final String? dieName;
  final String? productCode;
  final String? productName;
  final String? materialCode;
  final String? materialName;
  final String? foilingPlateCode;
  final String? foilingPlateName;
  final String? embossingPlateCode;
  final String? embossingPlateName;
  final int? workOrderId;
  final String? workOrderNumber;
  final String? customerName;
  final String? processName;
  final int? processId;
  final String? priorityDisplay;
  final DateTime? deliveryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
      quantityDefective: quantityDefective,
      autoCalculateQuantity: autoCalculateQuantity,
      productionRequirements: productionRequirements,
      materialPurchaseStatus: materialPurchaseStatus,
      isDraft: isDraft,
      isSubtask: isSubtask,
      subtasksCount: subtasksCount,
      parentTaskId: parentTaskId,
      version: version,
      artworkCode: artworkCode,
      artworkName: artworkName,
      dieCode: dieCode,
      dieName: dieName,
      productCode: productCode,
      productName: productName,
      materialCode: materialCode,
      materialName: materialName,
      foilingPlateCode: foilingPlateCode,
      foilingPlateName: foilingPlateName,
      embossingPlateCode: embossingPlateCode,
      embossingPlateName: embossingPlateName,
      workOrderId: workOrderId,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      processName: processName,
      processId: processId,
      priorityDisplay: priorityDisplay,
      deliveryDate: deliveryDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
      quantityDefective: quantityDefective,
      autoCalculateQuantity: autoCalculateQuantity,
      productionRequirements: productionRequirements,
      materialPurchaseStatus: materialPurchaseStatus,
      isDraft: isDraft,
      isSubtask: isSubtask,
      subtasksCount: subtasksCount,
      parentTaskId: parentTaskId,
      version: version,
      artworkCode: artworkCode,
      artworkName: artworkName,
      dieCode: dieCode,
      dieName: dieName,
      productCode: productCode,
      productName: productName,
      materialCode: materialCode,
      materialName: materialName,
      foilingPlateCode: foilingPlateCode,
      foilingPlateName: foilingPlateName,
      embossingPlateCode: embossingPlateCode,
      embossingPlateName: embossingPlateName,
      workOrderId: workOrderId,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      processName: processName,
      processId: processId,
      priorityDisplay: priorityDisplay,
      deliveryDate: deliveryDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
