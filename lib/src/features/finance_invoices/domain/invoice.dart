import 'package:work_order_app/src/core/utils/parse_utils.dart';

class Invoice {
  const Invoice({
    required this.id,
    this.invoiceNumber,
    this.workOrderNumber,
    this.customerName,
    this.amount,
    this.status,
    this.statusDisplay,
    this.issueDate,
  });

  final int id;
  final String? invoiceNumber;
  final String? workOrderNumber;
  final String? customerName;
  final double? amount;
  final String? status;
  final String? statusDisplay;
  final DateTime? issueDate;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: toInt(json['id']) ?? 0,
      invoiceNumber: toStringOrNull(json['invoice_number']) ?? toStringOrNull(json['number']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      customerName: toStringOrNull(json['customer_name']),
      amount: _toDouble(json['amount'] ?? json['total_amount']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      issueDate: toDateTime(json['issue_date'] ?? json['created_at']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
