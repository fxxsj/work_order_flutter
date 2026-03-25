import 'package:work_order_app/src/core/utils/parse_utils.dart';

class DeliveryOrder {
  const DeliveryOrder({
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

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      customerId: toInt(json['customer_id'] ?? json['customer']),
      customerName: toStringOrNull(json['customer_name']),
      salesOrderId: toInt(json['sales_order_id'] ?? json['sales_order']),
      salesOrderNumber: toStringOrNull(json['sales_order_number']),
      deliveryDate: toDateTime(json['delivery_date']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      itemsCount: toInt(json['items_count']),
      totalQuantity: _toDouble(json['total_quantity']),
      invoiceCount: toInt(json['invoice_count']),
      logisticsCompany: toStringOrNull(json['logistics_company']),
      trackingNumber: toStringOrNull(json['tracking_number']),
      exceptionResolution: toStringOrNull(json['exception_resolution']),
      exceptionResolutionDisplay:
          toStringOrNull(json['exception_resolution_display']),
      exceptionResolutionNotes:
          toStringOrNull(json['exception_resolution_notes']),
      exceptionClosed: _toBool(json['exception_closed']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static bool? _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().trim().toLowerCase();
    if (text == 'true' || text == '1') return true;
    if (text == 'false' || text == '0') return false;
    return null;
  }
}
