import 'package:work_order_app/src/core/utils/parse_utils.dart';

class Payment {
  const Payment({
    required this.id,
    this.paymentNumber,
    this.workOrderNumber,
    this.customerName,
    this.amount,
    this.status,
    this.statusDisplay,
    this.paymentDate,
  });

  final int id;
  final String? paymentNumber;
  final String? workOrderNumber;
  final String? customerName;
  final double? amount;
  final String? status;
  final String? statusDisplay;
  final DateTime? paymentDate;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: toInt(json['id']) ?? 0,
      paymentNumber: toStringOrNull(json['payment_number']) ?? toStringOrNull(json['number']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      customerName: toStringOrNull(json['customer_name']),
      amount: _toDouble(json['amount'] ?? json['total_amount']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      paymentDate: toDateTime(json['payment_date'] ?? json['created_at']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
