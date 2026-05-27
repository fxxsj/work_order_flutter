import 'package:work_order_app/src/features/materials/domain/material.dart';

class MaterialDto {
  const MaterialDto({
    required this.id,
    required this.code,
    required this.name,
    this.specification,
    this.unit,
    this.unitPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.defaultSupplier,
    this.leadTimeDays,
    this.needCutting,
    this.isActive,
    this.notes,
  });

  final int id;
  final String code;
  final String name;
  final String? specification;
  final String? unit;
  final double? unitPrice;
  final double? stockQuantity;
  final double? minStockQuantity;
  final int? defaultSupplier;
  final int? leadTimeDays;
  final bool? needCutting;
  final bool? isActive;
  final String? notes;

  factory MaterialDto.fromJson(Map<String, dynamic> json) {
    return MaterialItem.fromJson(json).toDto();
  }

  Map<String, dynamic> toPayload() {
    return {
      'code': code,
      'name': name,
      if (specification != null) 'specification': specification,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (minStockQuantity != null) 'min_stock_quantity': minStockQuantity,
      if (defaultSupplier != null) 'default_supplier': defaultSupplier,
      if (leadTimeDays != null) 'lead_time_days': leadTimeDays,
      if (needCutting != null) 'need_cutting': needCutting,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
    };
  }

  MaterialItem toEntity() {
    return MaterialItem(
      id: id,
      code: code,
      name: name,
      specification: specification,
      unit: unit,
      unitPrice: unitPrice,
      stockQuantity: stockQuantity,
      minStockQuantity: minStockQuantity,
      defaultSupplier: defaultSupplier,
      leadTimeDays: leadTimeDays,
      needCutting: needCutting,
      isActive: isActive,
      notes: notes,
    );
  }
}

extension MaterialMapper on MaterialItem {
  MaterialDto toDto() {
    return MaterialDto(
      id: id,
      code: code,
      name: name,
      specification: specification,
      unit: unit,
      unitPrice: unitPrice,
      stockQuantity: stockQuantity,
      minStockQuantity: minStockQuantity,
      defaultSupplier: defaultSupplier,
      leadTimeDays: leadTimeDays,
      needCutting: needCutting,
      isActive: isActive,
      notes: notes,
    );
  }
}
