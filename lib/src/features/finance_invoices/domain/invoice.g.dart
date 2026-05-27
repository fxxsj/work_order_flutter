// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: _intFromJson(json['id']),
  invoiceNumber: _stringOrNullFromJson(
    _readInvoiceNumber(json, 'invoice_number'),
  ),
  salesOrderId: _intOrNullFromJson(json['sales_order']),
  salesOrderNumber: _stringOrNullFromJson(json['sales_order_number']),
  workOrderId: _intOrNullFromJson(json['work_order']),
  workOrderNumber: _stringOrNullFromJson(json['work_order_number']),
  customerName: _stringOrNullFromJson(json['customer_name']),
  invoiceType: _stringOrNullFromJson(json['invoice_type']),
  invoiceTypeDisplay: _stringOrNullFromJson(json['invoice_type_display']),
  amount: _doubleOrNullFromJson(_readAmount(json, 'amount')),
  paymentReceivedAmount: _doubleOrNullFromJson(json['payment_received_amount']),
  paymentRemainingAmount: _doubleOrNullFromJson(
    json['payment_remaining_amount'],
  ),
  attachmentUrl: _stringOrNullFromJson(json['attachment']),
  status: _stringOrNullFromJson(json['status']),
  statusDisplay: _stringOrNullFromJson(json['status_display']),
  followUpText: _stringOrNullFromJson(json['follow_up_text']),
  issueDate: _dateTimeOrNullFromJson(_readIssueDate(json, 'issue_date')),
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'invoice_number': instance.invoiceNumber,
  'sales_order': instance.salesOrderId,
  'sales_order_number': instance.salesOrderNumber,
  'work_order': instance.workOrderId,
  'work_order_number': instance.workOrderNumber,
  'customer_name': instance.customerName,
  'invoice_type': instance.invoiceType,
  'invoice_type_display': instance.invoiceTypeDisplay,
  'amount': instance.amount,
  'payment_received_amount': instance.paymentReceivedAmount,
  'payment_remaining_amount': instance.paymentRemainingAmount,
  'attachment': instance.attachmentUrl,
  'status': instance.status,
  'status_display': instance.statusDisplay,
  'follow_up_text': instance.followUpText,
  'issue_date': instance.issueDate?.toIso8601String(),
};
