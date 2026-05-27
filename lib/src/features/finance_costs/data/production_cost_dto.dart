import 'package:work_order_app/src/features/finance_costs/domain/production_cost.dart';

class ProductionCostDto {
  const ProductionCostDto({
    required this.id,
    this.workOrderNumber,
    this.customerName,
    this.productName,
    this.period,
    this.materialCost,
    this.laborCost,
    this.equipmentCost,
    this.overheadCost,
    this.totalCost,
    this.standardCost,
    this.variance,
    this.varianceRate,
    this.varianceRateFormatted,
    this.calculatedByName,
    this.notes,
    this.calculatedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? workOrderNumber;
  final String? customerName;
  final String? productName;
  final String? period;
  final double? materialCost;
  final double? laborCost;
  final double? equipmentCost;
  final double? overheadCost;
  final double? totalCost;
  final double? standardCost;
  final double? variance;
  final double? varianceRate;
  final String? varianceRateFormatted;
  final String? calculatedByName;
  final String? notes;
  final DateTime? calculatedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProductionCostDto.fromJson(Map<String, dynamic> json) {
    return ProductionCost.fromJson(json).toDto();
  }

  ProductionCost toEntity() {
    return ProductionCost(
      id: id,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      productName: productName,
      period: period,
      materialCost: materialCost,
      laborCost: laborCost,
      equipmentCost: equipmentCost,
      overheadCost: overheadCost,
      totalCost: totalCost,
      standardCost: standardCost,
      variance: variance,
      varianceRate: varianceRate,
      varianceRateFormatted: varianceRateFormatted,
      calculatedByName: calculatedByName,
      notes: notes,
      calculatedAt: calculatedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension ProductionCostMapper on ProductionCost {
  ProductionCostDto toDto() {
    return ProductionCostDto(
      id: id,
      workOrderNumber: workOrderNumber,
      customerName: customerName,
      productName: productName,
      period: period,
      materialCost: materialCost,
      laborCost: laborCost,
      equipmentCost: equipmentCost,
      overheadCost: overheadCost,
      totalCost: totalCost,
      standardCost: standardCost,
      variance: variance,
      varianceRate: varianceRate,
      varianceRateFormatted: varianceRateFormatted,
      calculatedByName: calculatedByName,
      notes: notes,
      calculatedAt: calculatedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
