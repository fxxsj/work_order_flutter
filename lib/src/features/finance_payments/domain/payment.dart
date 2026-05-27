// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(
      name: 'payment_number',
      readValue: _readPaymentNumber,
      fromJson: _stringOrNullFromJson,
    )
    String? paymentNumber,
    @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
    int? salesOrderId,
    @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
    String? salesOrderNumber,
    @JsonKey(name: 'invoice', fromJson: _intOrNullFromJson) int? invoiceId,
    @JsonKey(name: 'invoice_number', fromJson: _stringOrNullFromJson)
    String? invoiceNumber,
    @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
    String? workOrderNumber,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(
      name: 'amount',
      readValue: _readAmount,
      fromJson: _doubleOrNullFromJson,
    )
    double? amount,
    @JsonKey(name: 'payment_method', fromJson: _stringOrNullFromJson)
    String? paymentMethod,
    @JsonKey(name: 'payment_method_display', fromJson: _stringOrNullFromJson)
    String? paymentMethodDisplay,
    @JsonKey(name: 'applied_amount', fromJson: _doubleOrNullFromJson)
    double? appliedAmount,
    @JsonKey(name: 'remaining_amount', fromJson: _doubleOrNullFromJson)
    double? remainingAmount,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
    String? followUpText,
    @JsonKey(
      name: 'payment_date',
      readValue: _readPaymentDate,
      fromJson: _dateTimeOrNullFromJson,
    )
    DateTime? paymentDate,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
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

Object? _readPaymentNumber(Map json, String key) {
  return json[key] ?? json['number'];
}

Object? _readAmount(Map json, String key) {
  return json[key] ?? json['total_amount'];
}

Object? _readPaymentDate(Map json, String key) {
  return json[key] ?? json['created_at'];
}
