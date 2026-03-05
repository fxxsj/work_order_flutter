import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';

class InvoiceDto {
  const InvoiceDto({
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
      status: status,
      statusDisplay: statusDisplay,
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
      status: status,
      statusDisplay: statusDisplay,
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
