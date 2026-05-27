import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';

class PaymentDto {
  const PaymentDto({
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
    this.followUpText,
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
  final String? followUpText;
  final DateTime? paymentDate;

  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    return Payment.fromJson(json).toDto();
  }

  Payment toEntity() {
    return Payment(
      id: id,
      paymentNumber: paymentNumber,
      salesOrderId: salesOrderId,
      salesOrderNumber: salesOrderNumber,
      invoiceId: invoiceId,
      invoiceNumber: invoiceNumber,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      amount: amount,
      paymentMethod: paymentMethod,
      paymentMethodDisplay: paymentMethodDisplay,
      appliedAmount: appliedAmount,
      remainingAmount: remainingAmount,
      status: status,
      statusDisplay: statusDisplay,
      followUpText: followUpText,
      paymentDate: paymentDate,
    );
  }
}

extension PaymentMapper on Payment {
  PaymentDto toDto() {
    return PaymentDto(
      id: id,
      paymentNumber: paymentNumber,
      salesOrderId: salesOrderId,
      salesOrderNumber: salesOrderNumber,
      invoiceId: invoiceId,
      invoiceNumber: invoiceNumber,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      amount: amount,
      paymentMethod: paymentMethod,
      paymentMethodDisplay: paymentMethodDisplay,
      appliedAmount: appliedAmount,
      remainingAmount: remainingAmount,
      status: status,
      statusDisplay: statusDisplay,
      followUpText: followUpText,
      paymentDate: paymentDate,
    );
  }
}

class PaymentPageDto {
  const PaymentPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<PaymentDto> items;
  final int total;
  final int page;
  final int pageSize;
}
