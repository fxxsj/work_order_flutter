import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';

class InvoiceDto {
  const InvoiceDto({
    required this.id,
    this.invoiceNumber,
    this.workOrderNumber,
    this.customerName,
    this.amount,
    this.paymentReceivedAmount,
    this.paymentRemainingAmount,
    this.status,
    this.statusDisplay,
    this.followUpText,
    this.issueDate,
  });

  final int id;
  final String? invoiceNumber;
  final String? workOrderNumber;
  final String? customerName;
  final double? amount;
  final double? paymentReceivedAmount;
  final double? paymentRemainingAmount;
  final String? status;
  final String? statusDisplay;
  final String? followUpText;
  final DateTime? issueDate;

  factory InvoiceDto.fromJson(Map<String, dynamic> json) {
    return Invoice.fromJson(json).toDto();
  }

  Invoice toEntity() {
    return Invoice(
      id: id,
      invoiceNumber: invoiceNumber,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      amount: amount,
      paymentReceivedAmount: paymentReceivedAmount,
      paymentRemainingAmount: paymentRemainingAmount,
      status: status,
      statusDisplay: statusDisplay,
      followUpText: followUpText,
      issueDate: issueDate,
    );
  }
}

extension InvoiceMapper on Invoice {
  InvoiceDto toDto() {
    return InvoiceDto(
      id: id,
      invoiceNumber: invoiceNumber,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      amount: amount,
      paymentReceivedAmount: paymentReceivedAmount,
      paymentRemainingAmount: paymentRemainingAmount,
      status: status,
      statusDisplay: statusDisplay,
      followUpText: followUpText,
      issueDate: issueDate,
    );
  }
}

class InvoicePageDto {
  const InvoicePageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<InvoiceDto> items;
  final int total;
  final int page;
  final int pageSize;
}
