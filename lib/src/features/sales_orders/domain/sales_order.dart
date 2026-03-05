import 'package:work_order_app/src/core/utils/parse_utils.dart';

class SalesOrder {
  const SalesOrder({
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

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      customerName: toStringOrNull(json['customer_name']),
      customerCode: toStringOrNull(json['customer_code']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      paymentStatus: toStringOrNull(json['payment_status']),
      paymentStatusDisplay: toStringOrNull(json['payment_status_display']),
      totalAmount: _toDouble(json['total_amount']),
      orderDate: toDateTime(json['order_date']),
      deliveryDate: toDateTime(json['delivery_date']),
      itemsCount: toInt(json['items_count']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
