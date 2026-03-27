// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatementImpl _$$StatementImplFromJson(Map<String, dynamic> json) =>
    _$StatementImpl(
      id: _intFromJson(json['id']),
      statementNumber:
          _stringOrNullFromJson(_readStatementNumber(json, 'statement_number')),
      statementType: _stringOrNullFromJson(json['statement_type']),
      statementTypeDisplay:
          _stringOrNullFromJson(json['statement_type_display']),
      partnerName: _stringOrNullFromJson(json['partner_name']),
      customerName:
          _stringOrNullFromJson(_readCustomerName(json, 'customer_name')),
      periodStart:
          _dateTimeOrNullFromJson(_readPeriodStart(json, 'period_start')),
      periodEnd: _dateTimeOrNullFromJson(_readPeriodEnd(json, 'period_end')),
      totalAmount:
          _doubleOrNullFromJson(_readTotalAmount(json, 'total_amount')),
      debitAmount:
          _doubleOrNullFromJson(_readDebitAmount(json, 'debit_amount')),
      creditAmount:
          _doubleOrNullFromJson(_readCreditAmount(json, 'credit_amount')),
      closingBalance:
          _doubleOrNullFromJson(_readClosingBalance(json, 'closing_balance')),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      followUpText: _stringOrNullFromJson(json['follow_up_text']),
      confirmedByName: _stringOrNullFromJson(json['confirmed_by_name']),
      confirmedAt: _dateTimeOrNullFromJson(json['confirmed_at']),
      confirmationNotes: _stringOrNullFromJson(
          _readConfirmationNotes(json, 'confirmation_notes')),
    );

Map<String, dynamic> _$$StatementImplToJson(_$StatementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statement_number': instance.statementNumber,
      'statement_type': instance.statementType,
      'statement_type_display': instance.statementTypeDisplay,
      'partner_name': instance.partnerName,
      'customer_name': instance.customerName,
      'period_start': instance.periodStart?.toIso8601String(),
      'period_end': instance.periodEnd?.toIso8601String(),
      'total_amount': instance.totalAmount,
      'debit_amount': instance.debitAmount,
      'credit_amount': instance.creditAmount,
      'closing_balance': instance.closingBalance,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'follow_up_text': instance.followUpText,
      'confirmed_by_name': instance.confirmedByName,
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'confirmation_notes': instance.confirmationNotes,
    };
