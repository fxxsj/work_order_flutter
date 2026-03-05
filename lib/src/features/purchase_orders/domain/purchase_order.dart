import 'package:work_order_app/src/core/utils/parse_utils.dart';

class PurchaseOrder {
  const PurchaseOrder({
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

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      supplierName: toStringOrNull(json['supplier_name']),
      supplierCode: toStringOrNull(json['supplier_code']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      totalAmount: _toDouble(json['total_amount']),
      itemsCount: toInt(json['items_count']),
      receivedProgress: _toDouble(json['received_progress']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      orderDate: toDateTime(json['order_date']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
