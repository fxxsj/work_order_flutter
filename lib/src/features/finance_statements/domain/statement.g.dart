// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Statement _$StatementFromJson(Map<String, dynamic> json) => _Statement(
  id: _intFromJson(json['id']),
  statementNumber: _stringOrNullFromJson(
    _readStatementNumber(json, 'statement_number'),
  ),
  statementType: _stringOrNullFromJson(json['statement_type']),
  statementTypeDisplay: _stringOrNullFromJson(json['statement_type_display']),
  partnerName: _stringOrNullFromJson(json['partner_name']),
  customerName: _stringOrNullFromJson(_readCustomerName(json, 'customer_name')),
  periodStart: _dateTimeOrNullFromJson(json['start_date']),
  periodEnd: _dateTimeOrNullFromJson(json['end_date']),
  totalAmount: _doubleOrNullFromJson(_readTotalAmount(json, 'total_amount')),
  debitAmount: _doubleOrNullFromJson(json['total_debit']),
  creditAmount: _doubleOrNullFromJson(json['total_credit']),
  closingBalance: _doubleOrNullFromJson(
    _readClosingBalance(json, 'closing_balance'),
  ),
  status: _stringOrNullFromJson(json['status']),
  statusDisplay: _stringOrNullFromJson(json['status_display']),
  followUpText: _stringOrNullFromJson(json['follow_up_text']),
  confirmedByName: _stringOrNullFromJson(json['confirmed_by_name']),
  confirmedAt: _dateTimeOrNullFromJson(json['confirmed_at']),
  confirmationNotes: _stringOrNullFromJson(
    _readConfirmationNotes(json, 'confirmation_notes'),
  ),
);

Map<String, dynamic> _$StatementToJson(_Statement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statement_number': instance.statementNumber,
      'statement_type': instance.statementType,
      'statement_type_display': instance.statementTypeDisplay,
      'partner_name': instance.partnerName,
      'customer_name': instance.customerName,
      'start_date': instance.periodStart?.toIso8601String(),
      'end_date': instance.periodEnd?.toIso8601String(),
      'total_amount': instance.totalAmount,
      'total_debit': instance.debitAmount,
      'total_credit': instance.creditAmount,
      'closing_balance': instance.closingBalance,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'follow_up_text': instance.followUpText,
      'confirmed_by_name': instance.confirmedByName,
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'confirmation_notes': instance.confirmationNotes,
    };
