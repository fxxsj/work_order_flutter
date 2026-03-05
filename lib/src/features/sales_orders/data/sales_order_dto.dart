import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';

class SalesOrderDto {
  const SalesOrderDto({
    required this.id,
    required this.orderNumber,
    this.customerName,
    this.customerCode,
    this.status,
    this.statusDisplay,
    this.paymentStatus,
    this.paymentStatusDisplay,
    this.totalAmount,
    this.orderDate,
    this.deliveryDate,
    this.itemsCount,
  });

  final int id;
  final String orderNumber;
  final String? customerName;
  final String? customerCode;
  final String? status;
  final String? statusDisplay;
  final String? paymentStatus;
  final String? paymentStatusDisplay;
  final double? totalAmount;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final int? itemsCount;

  factory SalesOrderDto.fromJson(Map<String, dynamic> json) {
    return SalesOrder.fromJson(json).toDto();
  }

  SalesOrder toEntity() {
    return SalesOrder(
      id: id,
      orderNumber: orderNumber,
      customerName: customerName,
      customerCode: customerCode,
      status: status,
      statusDisplay: statusDisplay,
      paymentStatus: paymentStatus,
      paymentStatusDisplay: paymentStatusDisplay,
      totalAmount: totalAmount,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      itemsCount: itemsCount,
    );
  }
}

extension SalesOrderMapper on SalesOrder {
  SalesOrderDto toDto() {
    return SalesOrderDto(
      id: id,
      orderNumber: orderNumber,
      customerName: customerName,
      customerCode: customerCode,
      status: status,
      statusDisplay: statusDisplay,
      paymentStatus: paymentStatus,
      paymentStatusDisplay: paymentStatusDisplay,
      totalAmount: totalAmount,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      itemsCount: itemsCount,
    );
  }
}

class SalesOrderPageDto {
  const SalesOrderPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<SalesOrderDto> items;
  final int total;
  final int page;
  final int pageSize;
}
