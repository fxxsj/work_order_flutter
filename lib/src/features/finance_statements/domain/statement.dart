import 'package:work_order_app/src/core/utils/parse_utils.dart';

class Statement {
  const Statement({
    required this.id,
    this.statementNumber,
    this.statementType,
    this.statementTypeDisplay,
    this.partnerName,
    this.customerName,
    this.periodStart,
    this.periodEnd,
    this.totalAmount,
    this.debitAmount,
    this.creditAmount,
    this.closingBalance,
    this.status,
    this.statusDisplay,
    this.confirmedByName,
    this.confirmedAt,
    this.confirmationNotes,
  });

  final int id;
  final String? statementNumber;
  final String? statementType;
  final String? statementTypeDisplay;
  final String? partnerName;
  final String? customerName;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final double? totalAmount;
  final double? debitAmount;
  final double? creditAmount;
  final double? closingBalance;
  final String? status;
  final String? statusDisplay;
  final String? confirmedByName;
  final DateTime? confirmedAt;
  final String? confirmationNotes;

  factory Statement.fromJson(Map<String, dynamic> json) {
    return Statement(
      id: toInt(json['id']) ?? 0,
      statementNumber: toStringOrNull(json['statement_number']) ??
          toStringOrNull(json['number']),
      statementType: toStringOrNull(json['statement_type']),
      statementTypeDisplay: toStringOrNull(json['statement_type_display']),
      partnerName: toStringOrNull(json['partner_name']),
      customerName: toStringOrNull(json['partner_name']) ??
          toStringOrNull(json['customer_name']) ??
          toStringOrNull(json['supplier_name']),
      periodStart: toDateTime(json['period_start'] ?? json['start_date']),
      periodEnd: toDateTime(json['period_end'] ?? json['end_date']),
      totalAmount: _toDouble(json['total_amount'] ?? json['amount']),
      debitAmount: _toDouble(json['debit_amount'] ?? json['total_debit']),
      creditAmount: _toDouble(json['credit_amount'] ?? json['total_credit']),
      closingBalance:
          _toDouble(json['closing_balance'] ?? json['closing_amount']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      confirmedByName: toStringOrNull(json['confirmed_by_name']),
      confirmedAt: toDateTime(json['confirmed_at']),
      confirmationNotes:
          toStringOrNull(json['confirmation_notes'] ?? json['confirm_notes']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
