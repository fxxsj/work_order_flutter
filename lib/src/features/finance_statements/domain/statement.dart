// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'statement.freezed.dart';
part 'statement.g.dart';

@freezed
class Statement with _$Statement {
  const factory Statement({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(
      name: 'statement_number',
      readValue: _readStatementNumber,
      fromJson: _stringOrNullFromJson,
    )
    String? statementNumber,
    @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
    String? statementType,
    @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)
    String? statementTypeDisplay,
    @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
    String? partnerName,
    @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson,
    )
    String? customerName,
    @JsonKey(
      name: 'period_start',
      readValue: _readPeriodStart,
      fromJson: _dateTimeOrNullFromJson,
    )
    DateTime? periodStart,
    @JsonKey(
      name: 'period_end',
      readValue: _readPeriodEnd,
      fromJson: _dateTimeOrNullFromJson,
    )
    DateTime? periodEnd,
    @JsonKey(
      name: 'total_amount',
      readValue: _readTotalAmount,
      fromJson: _doubleOrNullFromJson,
    )
    double? totalAmount,
    @JsonKey(
      name: 'debit_amount',
      readValue: _readDebitAmount,
      fromJson: _doubleOrNullFromJson,
    )
    double? debitAmount,
    @JsonKey(
      name: 'credit_amount',
      readValue: _readCreditAmount,
      fromJson: _doubleOrNullFromJson,
    )
    double? creditAmount,
    @JsonKey(
      name: 'closing_balance',
      readValue: _readClosingBalance,
      fromJson: _doubleOrNullFromJson,
    )
    double? closingBalance,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
    String? followUpText,
    @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
    String? confirmedByName,
    @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? confirmedAt,
    @JsonKey(
      name: 'confirmation_notes',
      readValue: _readConfirmationNotes,
      fromJson: _stringOrNullFromJson,
    )
    String? confirmationNotes,
  }) = _Statement;

  factory Statement.fromJson(Map<String, dynamic> json) =>
      _$StatementFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

double? _doubleOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

Object? _readStatementNumber(Map json, String key) {
  return json[key] ?? json['number'];
}

Object? _readCustomerName(Map json, String key) {
  return json['partner_name'] ?? json[key] ?? json['supplier_name'];
}

Object? _readPeriodStart(Map json, String key) {
  return json[key] ?? json['start_date'];
}

Object? _readPeriodEnd(Map json, String key) {
  return json[key] ?? json['end_date'];
}

Object? _readTotalAmount(Map json, String key) {
  return json[key] ?? json['amount'];
}

Object? _readDebitAmount(Map json, String key) {
  return json[key] ?? json['total_debit'];
}

Object? _readCreditAmount(Map json, String key) {
  return json[key] ?? json['total_credit'];
}

Object? _readClosingBalance(Map json, String key) {
  return json[key] ?? json['closing_amount'];
}

Object? _readConfirmationNotes(Map json, String key) {
  return json[key] ?? json['confirm_notes'];
}
