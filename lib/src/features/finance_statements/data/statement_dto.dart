import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';

class StatementDto {
  const StatementDto({
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

  factory StatementDto.fromJson(Map<String, dynamic> json) {
    return Statement.fromJson(json).toDto();
  }

  Statement toEntity() {
    return Statement(
      id: id,
      statementNumber: statementNumber,
      customerName: customerName,
      periodStart: periodStart,
      periodEnd: periodEnd,
      totalAmount: totalAmount,
      status: status,
      statusDisplay: statusDisplay,
    );
  }
}

extension StatementMapper on Statement {
  StatementDto toDto() {
    return StatementDto(
      id: id,
      statementNumber: statementNumber,
      customerName: customerName,
      periodStart: periodStart,
      periodEnd: periodEnd,
      totalAmount: totalAmount,
      status: status,
      statusDisplay: statusDisplay,
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
