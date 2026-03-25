import 'package:work_order_app/src/core/utils/parse_utils.dart';

class Payment {
  const Payment({
    required this.id,
    this.paymentNumber,
    this.salesOrderId,
    this.salesOrderNumber,
    this.invoiceId,
    this.invoiceNumber,
    this.workOrderNumber,
    this.customerName,
    this.amount,
    this.paymentMethod,
    this.paymentMethodDisplay,
    this.appliedAmount,
    this.remainingAmount,
    this.status,
    this.statusDisplay,
    this.paymentDate,
  });

  final int id;
  final String? paymentNumber;
  final int? salesOrderId;
  final String? salesOrderNumber;
  final int? invoiceId;
  final String? invoiceNumber;
  final String? workOrderNumber;
  final String? customerName;
  final double? amount;
  final String? paymentMethod;
  final String? paymentMethodDisplay;
  final double? appliedAmount;
  final double? remainingAmount;
  final String? status;
  final String? statusDisplay;
  final DateTime? paymentDate;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: toInt(json['id']) ?? 0,
      paymentNumber: toStringOrNull(json['payment_number']) ??
          toStringOrNull(json['number']),
      salesOrderId: toInt(json['sales_order']),
      salesOrderNumber: toStringOrNull(json['sales_order_number']),
      invoiceId: toInt(json['invoice']),
      invoiceNumber: toStringOrNull(json['invoice_number']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      customerName: toStringOrNull(json['customer_name']),
      amount: _toDouble(json['amount'] ?? json['total_amount']),
      paymentMethod: toStringOrNull(json['payment_method']),
      paymentMethodDisplay: toStringOrNull(json['payment_method_display']),
      appliedAmount: _toDouble(json['applied_amount']),
      remainingAmount: _toDouble(json['remaining_amount']),
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
