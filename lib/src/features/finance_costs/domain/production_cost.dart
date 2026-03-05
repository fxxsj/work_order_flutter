import 'package:work_order_app/src/core/utils/parse_utils.dart';

class ProductionCost {
  const ProductionCost({
    required this.id,
    this.workOrderNumber,
    this.totalCost,
    this.status,
    this.statusDisplay,
    this.calculatedAt,
  });

  final int id;
  final String? workOrderNumber;
  final double? totalCost;
  final String? status;
  final String? statusDisplay;
  final DateTime? calculatedAt;

  factory ProductionCost.fromJson(Map<String, dynamic> json) {
    return ProductionCost(
      id: toInt(json['id']) ?? 0,
      workOrderNumber: toStringOrNull(json['work_order_number']),
      totalCost: _toDouble(json['total_cost'] ?? json['amount']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      calculatedAt: toDateTime(json['updated_at'] ?? json['calculated_at']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
