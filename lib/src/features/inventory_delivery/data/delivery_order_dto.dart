import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order.dart';

class DeliveryOrderDto {
  const DeliveryOrderDto({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.customerName,
    this.salesOrderId,
    this.salesOrderNumber,
    this.deliveryDate,
    this.status,
    this.statusDisplay,
    this.itemsCount,
    this.totalQuantity,
    this.invoiceCount,
    this.logisticsCompany,
    this.trackingNumber,
    this.exceptionResolution,
    this.exceptionResolutionDisplay,
    this.exceptionResolutionNotes,
    this.exceptionClosed,
  });

  final int id;
  final String orderNumber;
  final int? customerId;
  final String? customerName;
  final int? salesOrderId;
  final String? salesOrderNumber;
  final DateTime? deliveryDate;
  final String? status;
  final String? statusDisplay;
  final int? itemsCount;
  final double? totalQuantity;
  final int? invoiceCount;
  final String? logisticsCompany;
  final String? trackingNumber;
  final String? exceptionResolution;
  final String? exceptionResolutionDisplay;
  final String? exceptionResolutionNotes;
  final bool? exceptionClosed;

  factory DeliveryOrderDto.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder.fromJson(json).toDto();
  }

  DeliveryOrder toEntity() {
    return DeliveryOrder(
      id: id,
      orderNumber: orderNumber,
      customerId: customerId,
      customerName: customerName,
      salesOrderId: salesOrderId,
      salesOrderNumber: salesOrderNumber,
      deliveryDate: deliveryDate,
      status: status,
      statusDisplay: statusDisplay,
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      invoiceCount: invoiceCount,
      logisticsCompany: logisticsCompany,
      trackingNumber: trackingNumber,
      exceptionResolution: exceptionResolution,
      exceptionResolutionDisplay: exceptionResolutionDisplay,
      exceptionResolutionNotes: exceptionResolutionNotes,
      exceptionClosed: exceptionClosed,
    );
  }
}

extension DeliveryOrderMapper on DeliveryOrder {
  DeliveryOrderDto toDto() {
    return DeliveryOrderDto(
      id: id,
      orderNumber: orderNumber,
      customerId: customerId,
      customerName: customerName,
      salesOrderId: salesOrderId,
      salesOrderNumber: salesOrderNumber,
      deliveryDate: deliveryDate,
      status: status,
      statusDisplay: statusDisplay,
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      invoiceCount: invoiceCount,
      logisticsCompany: logisticsCompany,
      trackingNumber: trackingNumber,
      exceptionResolution: exceptionResolution,
      exceptionResolutionDisplay: exceptionResolutionDisplay,
      exceptionResolutionNotes: exceptionResolutionNotes,
      exceptionClosed: exceptionClosed,
    );
  }
}

class DeliveryOrderPageDto {
  const DeliveryOrderPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<DeliveryOrderDto> items;
  final int total;
  final int page;
  final int pageSize;
}
