import 'package:work_order_app/src/features/finance_costs/domain/production_cost.dart';

class ProductionCostDto {
  const ProductionCostDto({
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

  factory ProductionCostDto.fromJson(Map<String, dynamic> json) {
    return ProductionCost.fromJson(json).toDto();
  }

  ProductionCost toEntity() {
    return ProductionCost(
      id: id,
      workOrderNumber: workOrderNumber,
      totalCost: totalCost,
      status: status,
      statusDisplay: statusDisplay,
      calculatedAt: calculatedAt,
    );
  }
}

extension ProductionCostMapper on ProductionCost {
  ProductionCostDto toDto() {
    return ProductionCostDto(
      id: id,
      workOrderNumber: workOrderNumber,
      totalCost: totalCost,
      status: status,
      statusDisplay: statusDisplay,
      calculatedAt: calculatedAt,
    );
  }
}

class ProductionCostPageDto {
  const ProductionCostPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<ProductionCostDto> items;
  final int total;
  final int page;
  final int pageSize;
}
