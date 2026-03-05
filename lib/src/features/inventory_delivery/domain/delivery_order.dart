import 'package:work_order_app/src/core/utils/parse_utils.dart';

class DeliveryOrder {
  const DeliveryOrder({
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

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      customerName: toStringOrNull(json['customer_name']),
      salesOrderNumber: toStringOrNull(json['sales_order_number']),
      deliveryDate: toDateTime(json['delivery_date']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      itemsCount: toInt(json['items_count']),
      totalQuantity: _toDouble(json['total_quantity']),
      logisticsCompany: toStringOrNull(json['logistics_company']),
      trackingNumber: toStringOrNull(json['tracking_number']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
