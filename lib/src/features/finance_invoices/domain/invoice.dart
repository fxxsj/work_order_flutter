// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(
      name: 'invoice_number',
      readValue: _readInvoiceNumber,
      fromJson: _stringOrNullFromJson,
    )
    String? invoiceNumber,
    @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
    int? salesOrderId,
    @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
    String? salesOrderNumber,
    @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,
    @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
    String? workOrderNumber,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(name: 'invoice_type', fromJson: _stringOrNullFromJson)
    String? invoiceType,
    @JsonKey(name: 'invoice_type_display', fromJson: _stringOrNullFromJson)
    String? invoiceTypeDisplay,
    @JsonKey(
      name: 'amount',
      readValue: _readAmount,
      fromJson: _doubleOrNullFromJson,
    )
    double? amount,
    @JsonKey(name: 'payment_received_amount', fromJson: _doubleOrNullFromJson)
    double? paymentReceivedAmount,
    @JsonKey(name: 'payment_remaining_amount', fromJson: _doubleOrNullFromJson)
    double? paymentRemainingAmount,
    @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
    String? attachmentUrl,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
    String? followUpText,
    @JsonKey(
      name: 'issue_date',
      readValue: _readIssueDate,
      fromJson: _dateTimeOrNullFromJson,
    )
    DateTime? issueDate,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

double? _doubleOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

Object? _readInvoiceNumber(Map json, String key) {
  return json[key] ?? json['number'];
}

Object? _readAmount(Map json, String key) {
  return json[key] ?? json['total_amount'];
}

Object? _readIssueDate(Map json, String key) {
  return json[key] ?? json['created_at'];
}
