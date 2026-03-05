import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

class WorkOrderDto {
  const WorkOrderDto({
    required this.id,
    required this.orderNumber,
    this.customerName,
    this.salespersonName,
    this.productName,
    this.quantity,
    this.unit,
    this.status,
    this.statusDisplay,
    this.priority,
    this.priorityDisplay,
    this.orderDate,
    this.deliveryDate,
    this.totalAmount,
    this.approvalStatus,
    this.approvalStatusDisplay,
    this.managerName,
    this.progressPercentage,
  });

  final int id;
  final String orderNumber;
  final String? customerName;
  final String? salespersonName;
  final String? productName;
  final double? quantity;
  final String? unit;
  final String? status;
  final String? statusDisplay;
  final String? priority;
  final String? priorityDisplay;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final double? totalAmount;
  final String? approvalStatus;
  final String? approvalStatusDisplay;
  final String? managerName;
  final int? progressPercentage;

  factory WorkOrderDto.fromJson(Map<String, dynamic> json) {
    return WorkOrder.fromJson(json).toDto();
  }

  WorkOrder toEntity() {
    return WorkOrder(
      id: id,
      orderNumber: orderNumber,
      customerName: customerName,
      salespersonName: salespersonName,
      productName: productName,
      quantity: quantity,
      unit: unit,
      status: status,
      statusDisplay: statusDisplay,
      priority: priority,
      priorityDisplay: priorityDisplay,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      totalAmount: totalAmount,
      approvalStatus: approvalStatus,
      approvalStatusDisplay: approvalStatusDisplay,
      managerName: managerName,
      progressPercentage: progressPercentage,
    );
  }
}

extension WorkOrderMapper on WorkOrder {
  WorkOrderDto toDto() {
    return WorkOrderDto(
      id: id,
      orderNumber: orderNumber,
      customerName: customerName,
      salespersonName: salespersonName,
      productName: productName,
      quantity: quantity,
      unit: unit,
      status: status,
      statusDisplay: statusDisplay,
      priority: priority,
      priorityDisplay: priorityDisplay,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      totalAmount: totalAmount,
      approvalStatus: approvalStatus,
      approvalStatusDisplay: approvalStatusDisplay,
      managerName: managerName,
      progressPercentage: progressPercentage,
    );
  }
}

class WorkOrderPageDto {
  const WorkOrderPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<WorkOrderDto> items;
  final int total;
  final int page;
  final int pageSize;
}
