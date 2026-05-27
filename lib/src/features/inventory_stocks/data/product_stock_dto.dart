import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';

class ProductStockDto {
  const ProductStockDto({
    required this.id,
    this.productName,
    this.productCode,
    this.batchNo,
    this.workOrderNumber,
    this.status,
    this.statusDisplay,
    this.quantity,
    this.reservedQuantity,
    this.availableQuantity,
    this.minStockLevel,
    this.location,
    this.productionDate,
    this.unitCost,
    this.totalValue,
    this.isLowStock,
    this.expiryDate,
    this.daysUntilExpiry,
    this.createdAt,
    this.notes,
  });

  final int id;
  final String? productName;
  final String? productCode;
  final String? batchNo;
  final String? workOrderNumber;
  final String? status;
  final String? statusDisplay;
  final double? quantity;
  final double? reservedQuantity;
  final double? availableQuantity;
  final double? minStockLevel;
  final String? location;
  final DateTime? productionDate;
  final double? unitCost;
  final double? totalValue;
  final bool? isLowStock;
  final DateTime? expiryDate;
  final int? daysUntilExpiry;
  final DateTime? createdAt;
  final String? notes;

  factory ProductStockDto.fromJson(Map<String, dynamic> json) {
    return ProductStock.fromJson(json).toDto();
  }

  ProductStock toEntity() {
    return ProductStock(
      id: id,
      productName: productName,
      productCode: productCode,
      batchNo: batchNo,
      workOrderNumber: workOrderNumber,
      status: status,
      statusDisplay: statusDisplay,
      quantity: quantity,
      reservedQuantity: reservedQuantity,
      availableQuantity: availableQuantity,
      minStockLevel: minStockLevel,
      location: location,
      productionDate: productionDate,
      unitCost: unitCost,
      totalValue: totalValue,
      isLowStock: isLowStock,
      expiryDate: expiryDate,
      daysUntilExpiry: daysUntilExpiry,
      createdAt: createdAt,
      notes: notes,
    );
  }
}

extension ProductStockMapper on ProductStock {
  ProductStockDto toDto() {
    return ProductStockDto(
      id: id,
      productName: productName,
      productCode: productCode,
      batchNo: batchNo,
      workOrderNumber: workOrderNumber,
      status: status,
      statusDisplay: statusDisplay,
      quantity: quantity,
      reservedQuantity: reservedQuantity,
      availableQuantity: availableQuantity,
      minStockLevel: minStockLevel,
      location: location,
      productionDate: productionDate,
      unitCost: unitCost,
      totalValue: totalValue,
      isLowStock: isLowStock,
      expiryDate: expiryDate,
      daysUntilExpiry: daysUntilExpiry,
      createdAt: createdAt,
      notes: notes,
    );
  }
}

class ProductStockPageDto {
  const ProductStockPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<ProductStockDto> items;
  final int total;
  final int page;
  final int pageSize;
}
