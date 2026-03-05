import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order.dart';

class PurchaseOrderDto {
  const PurchaseOrderDto({
    required this.id,
    required this.orderNumber,
    this.supplierName,
    this.supplierCode,
    this.status,
    this.statusDisplay,
    this.totalAmount,
    this.itemsCount,
    this.receivedProgress,
    this.workOrderNumber,
    this.orderDate,
  });

  final int id;
  final String orderNumber;
  final String? supplierName;
  final String? supplierCode;
  final String? status;
  final String? statusDisplay;
  final double? totalAmount;
  final int? itemsCount;
  final double? receivedProgress;
  final String? workOrderNumber;
  final DateTime? orderDate;

  factory PurchaseOrderDto.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder.fromJson(json).toDto();
  }

  PurchaseOrder toEntity() {
    return PurchaseOrder(
      id: id,
      orderNumber: orderNumber,
      supplierName: supplierName,
      supplierCode: supplierCode,
      status: status,
      statusDisplay: statusDisplay,
      totalAmount: totalAmount,
      itemsCount: itemsCount,
      receivedProgress: receivedProgress,
      workOrderNumber: workOrderNumber,
      orderDate: orderDate,
    );
  }
}

extension PurchaseOrderMapper on PurchaseOrder {
  PurchaseOrderDto toDto() {
    return PurchaseOrderDto(
      id: id,
      orderNumber: orderNumber,
      supplierName: supplierName,
      supplierCode: supplierCode,
      status: status,
      statusDisplay: statusDisplay,
      totalAmount: totalAmount,
      itemsCount: itemsCount,
      receivedProgress: receivedProgress,
      workOrderNumber: workOrderNumber,
      orderDate: orderDate,
    );
  }
}

class PurchaseOrderPageDto {
  const PurchaseOrderPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<PurchaseOrderDto> items;
  final int total;
  final int page;
  final int pageSize;
}
