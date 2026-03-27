// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: _intFromJson(json['id']),
      paymentNumber:
          _stringOrNullFromJson(_readPaymentNumber(json, 'payment_number')),
      salesOrderId: _intOrNullFromJson(json['sales_order']),
      salesOrderNumber: _stringOrNullFromJson(json['sales_order_number']),
      invoiceId: _intOrNullFromJson(json['invoice']),
      invoiceNumber: _stringOrNullFromJson(json['invoice_number']),
      workOrderNumber: _stringOrNullFromJson(json['work_order_number']),
      customerName: _stringOrNullFromJson(json['customer_name']),
      amount: _doubleOrNullFromJson(_readAmount(json, 'amount')),
      paymentMethod: _stringOrNullFromJson(json['payment_method']),
      paymentMethodDisplay:
          _stringOrNullFromJson(json['payment_method_display']),
      appliedAmount: _doubleOrNullFromJson(json['applied_amount']),
      remainingAmount: _doubleOrNullFromJson(json['remaining_amount']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      followUpText: _stringOrNullFromJson(json['follow_up_text']),
      paymentDate:
          _dateTimeOrNullFromJson(_readPaymentDate(json, 'payment_date')),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_number': instance.paymentNumber,
      'sales_order': instance.salesOrderId,
      'sales_order_number': instance.salesOrderNumber,
      'invoice': instance.invoiceId,
      'invoice_number': instance.invoiceNumber,
      'work_order_number': instance.workOrderNumber,
      'customer_name': instance.customerName,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
      'payment_method_display': instance.paymentMethodDisplay,
      'applied_amount': instance.appliedAmount,
      'remaining_amount': instance.remainingAmount,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'follow_up_text': instance.followUpText,
      'payment_date': instance.paymentDate?.toIso8601String(),
    };
