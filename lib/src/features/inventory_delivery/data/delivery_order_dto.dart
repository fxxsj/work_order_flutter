import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order.dart';

class DeliveryOrderDto {
  const DeliveryOrderDto({
    required this.id,
    required this.orderNumber,
    this.customerName,
    this.salesOrderNumber,
    this.deliveryDate,
    this.status,
    this.statusDisplay,
    this.itemsCount,
    this.totalQuantity,
    this.logisticsCompany,
    this.trackingNumber,
  });

  final int id;
  final String orderNumber;
  final String? customerName;
  final String? salesOrderNumber;
  final DateTime? deliveryDate;
  final String? status;
  final String? statusDisplay;
  final int? itemsCount;
  final double? totalQuantity;
  final String? logisticsCompany;
  final String? trackingNumber;

  factory DeliveryOrderDto.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder.fromJson(json).toDto();
  }

  DeliveryOrder toEntity() {
    return DeliveryOrder(
      id: id,
      orderNumber: orderNumber,
      customerName: customerName,
      salesOrderNumber: salesOrderNumber,
      deliveryDate: deliveryDate,
      status: status,
      statusDisplay: statusDisplay,
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      logisticsCompany: logisticsCompany,
      trackingNumber: trackingNumber,
    );
  }
}

extension DeliveryOrderMapper on DeliveryOrder {
  DeliveryOrderDto toDto() {
    return DeliveryOrderDto(
      id: id,
      orderNumber: orderNumber,
      customerName: customerName,
      salesOrderNumber: salesOrderNumber,
      deliveryDate: deliveryDate,
      status: status,
      statusDisplay: statusDisplay,
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      logisticsCompany: logisticsCompany,
      trackingNumber: trackingNumber,
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
