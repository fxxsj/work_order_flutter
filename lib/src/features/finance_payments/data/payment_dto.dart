import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';

class PaymentDto {
  const PaymentDto({
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

  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    return Payment.fromJson(json).toDto();
  }

  Payment toEntity() {
    return Payment(
      id: id,
      paymentNumber: paymentNumber,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      amount: amount,
      status: status,
      statusDisplay: statusDisplay,
      paymentDate: paymentDate,
    );
  }
}

extension PaymentMapper on Payment {
  PaymentDto toDto() {
    return PaymentDto(
      id: id,
      paymentNumber: paymentNumber,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      amount: amount,
      status: status,
      statusDisplay: statusDisplay,
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
