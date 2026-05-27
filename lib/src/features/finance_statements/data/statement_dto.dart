import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';

class StatementDto {
  const StatementDto({
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
    this.followUpText,
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
  final String? followUpText;
  final String? confirmedByName;
  final DateTime? confirmedAt;
  final String? confirmationNotes;

  factory StatementDto.fromJson(Map<String, dynamic> json) {
    return Statement.fromJson(json).toDto();
  }

  Statement toEntity() {
    return Statement(
      id: id,
      statementNumber: statementNumber,
      statementType: statementType,
      statementTypeDisplay: statementTypeDisplay,
      partnerName: partnerName,
      customerName: customerName,
      periodStart: periodStart,
      periodEnd: periodEnd,
      totalAmount: totalAmount,
      debitAmount: debitAmount,
      creditAmount: creditAmount,
      closingBalance: closingBalance,
      status: status,
      statusDisplay: statusDisplay,
      followUpText: followUpText,
      confirmedByName: confirmedByName,
      confirmedAt: confirmedAt,
      confirmationNotes: confirmationNotes,
    );
  }
}

extension StatementMapper on Statement {
  StatementDto toDto() {
    return StatementDto(
      id: id,
      statementNumber: statementNumber,
      statementType: statementType,
      statementTypeDisplay: statementTypeDisplay,
      partnerName: partnerName,
      customerName: customerName,
      periodStart: periodStart,
      periodEnd: periodEnd,
      totalAmount: totalAmount,
      debitAmount: debitAmount,
      creditAmount: creditAmount,
      closingBalance: closingBalance,
      status: status,
      statusDisplay: statusDisplay,
      followUpText: followUpText,
      confirmedByName: confirmedByName,
      confirmedAt: confirmedAt,
      confirmationNotes: confirmationNotes,
    );
  }
}

class StatementPageDto {
  const StatementPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<StatementDto> items;
  final int total;
  final int page;
  final int pageSize;
}
