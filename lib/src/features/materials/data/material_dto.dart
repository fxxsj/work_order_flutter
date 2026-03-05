import 'package:work_order_app/src/features/materials/domain/material.dart';

class MaterialDto {
  const MaterialDto({
    required this.id,
    required this.code,
    required this.name,
    this.unit,
    this.unitPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.isActive,
  });

  final int id;
  final String code;
  final String name;
  final String? unit;
  final double? unitPrice;
  final double? stockQuantity;
  final double? minStockQuantity;
  final bool? isActive;

  factory MaterialDto.fromJson(Map<String, dynamic> json) {
    return MaterialItem.fromJson(json).toDto();
  }

  MaterialItem toEntity() {
    return MaterialItem(
      id: id,
      code: code,
      name: name,
      unit: unit,
      unitPrice: unitPrice,
      stockQuantity: stockQuantity,
      minStockQuantity: minStockQuantity,
      isActive: isActive,
    );
  }
}

extension MaterialMapper on MaterialItem {
  MaterialDto toDto() {
    return MaterialDto(
      id: id,
      code: code,
      name: name,
      unit: unit,
      unitPrice: unitPrice,
      stockQuantity: stockQuantity,
      minStockQuantity: minStockQuantity,
      isActive: isActive,
    );
  }
}

class MaterialPageDto {
  const MaterialPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<MaterialDto> items;
  final int total;
  final int page;
  final int pageSize;
}
