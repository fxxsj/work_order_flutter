import 'package:work_order_app/src/core/utils/parse_utils.dart';

class Statement {
  const Statement({
    required this.id,
    this.statementNumber,
    this.customerName,
    this.periodStart,
    this.periodEnd,
    this.totalAmount,
    this.status,
    this.statusDisplay,
  });

  final int id;
  final String? statementNumber;
  final String? customerName;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final double? totalAmount;
  final String? status;
  final String? statusDisplay;

  factory Statement.fromJson(Map<String, dynamic> json) {
    return Statement(
      id: toInt(json['id']) ?? 0,
      statementNumber: toStringOrNull(json['statement_number']) ?? toStringOrNull(json['number']),
      customerName: toStringOrNull(json['customer_name']),
      periodStart: toDateTime(json['period_start'] ?? json['start_date']),
      periodEnd: toDateTime(json['period_end'] ?? json['end_date']),
      totalAmount: _toDouble(json['total_amount'] ?? json['amount']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
