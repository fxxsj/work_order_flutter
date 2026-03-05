import 'package:work_order_app/src/core/utils/parse_utils.dart';

class WorkOrder {
  const WorkOrder({
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

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      customerName: toStringOrNull(json['customer_name']),
      salespersonName: toStringOrNull(json['salesperson_name']),
      productName: toStringOrNull(json['product_name']),
      quantity: _toDouble(json['quantity']),
      unit: toStringOrNull(json['unit']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      priority: toStringOrNull(json['priority']),
      priorityDisplay: toStringOrNull(json['priority_display']),
      orderDate: toDateTime(json['order_date']),
      deliveryDate: toDateTime(json['delivery_date']),
      totalAmount: _toDouble(json['total_amount']),
      approvalStatus: toStringOrNull(json['approval_status']),
      approvalStatusDisplay: toStringOrNull(json['approval_status_display']),
      managerName: toStringOrNull(json['manager_name']),
      progressPercentage: toInt(json['progress_percentage']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
