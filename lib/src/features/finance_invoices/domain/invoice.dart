import 'package:work_order_app/src/core/utils/parse_utils.dart';

class Invoice {
  const Invoice({
    required this.id,
    this.invoiceNumber,
    this.salesOrderId,
    this.salesOrderNumber,
    this.workOrderId,
    this.workOrderNumber,
    this.customerName,
    this.invoiceType,
    this.invoiceTypeDisplay,
    this.amount,
    this.paymentReceivedAmount,
    this.paymentRemainingAmount,
    this.attachmentUrl,
    this.status,
    this.statusDisplay,
    this.followUpText,
    this.issueDate,
  });

  final int id;
  final String? invoiceNumber;
  final int? salesOrderId;
  final String? salesOrderNumber;
  final int? workOrderId;
  final String? workOrderNumber;
  final String? customerName;
  final String? invoiceType;
  final String? invoiceTypeDisplay;
  final double? amount;
  final double? paymentReceivedAmount;
  final double? paymentRemainingAmount;
  final String? attachmentUrl;
  final String? status;
  final String? statusDisplay;
  final String? followUpText;
  final DateTime? issueDate;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: toInt(json['id']) ?? 0,
      invoiceNumber: toStringOrNull(json['invoice_number']) ??
          toStringOrNull(json['number']),
      salesOrderId: toInt(json['sales_order']),
      salesOrderNumber: toStringOrNull(json['sales_order_number']),
      workOrderId: toInt(json['work_order']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      customerName: toStringOrNull(json['customer_name']),
      invoiceType: toStringOrNull(json['invoice_type']),
      invoiceTypeDisplay: toStringOrNull(json['invoice_type_display']),
      amount: _toDouble(json['amount'] ?? json['total_amount']),
      paymentReceivedAmount: _toDouble(json['payment_received_amount']),
      paymentRemainingAmount: _toDouble(json['payment_remaining_amount']),
      attachmentUrl: toStringOrNull(json['attachment']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      followUpText: toStringOrNull(json['follow_up_text']),
      issueDate: toDateTime(json['issue_date'] ?? json['created_at']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
