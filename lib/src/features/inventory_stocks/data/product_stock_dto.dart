import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';

class ProductStockDto {
  const ProductStockDto({
    required this.id,
    this.productName,
    this.productCode,
    this.workOrderNumber,
    this.status,
    this.statusDisplay,
    this.quantity,
    this.reservedQuantity,
    this.availableQuantity,
    this.unitCost,
    this.totalValue,
    this.isLowStock,
    this.expiryDate,
  });

  final int id;
  final String? productName;
  final String? productCode;
  final String? workOrderNumber;
  final String? status;
  final String? statusDisplay;
  final double? quantity;
  final double? reservedQuantity;
  final double? availableQuantity;
  final double? unitCost;
  final double? totalValue;
  final bool? isLowStock;
  final DateTime? expiryDate;

  factory ProductStockDto.fromJson(Map<String, dynamic> json) {
    return ProductStock.fromJson(json).toDto();
  }

  ProductStock toEntity() {
    return ProductStock(
      id: id,
      productName: productName,
      productCode: productCode,
      workOrderNumber: workOrderNumber,
      status: status,
      statusDisplay: statusDisplay,
      quantity: quantity,
      reservedQuantity: reservedQuantity,
      availableQuantity: availableQuantity,
      unitCost: unitCost,
      totalValue: totalValue,
      isLowStock: isLowStock,
      expiryDate: expiryDate,
    );
  }
}

extension ProductStockMapper on ProductStock {
  ProductStockDto toDto() {
    return ProductStockDto(
      id: id,
      productName: productName,
      productCode: productCode,
      workOrderNumber: workOrderNumber,
      status: status,
      statusDisplay: statusDisplay,
      quantity: quantity,
      reservedQuantity: reservedQuantity,
      availableQuantity: availableQuantity,
      unitCost: unitCost,
      totalValue: totalValue,
      isLowStock: isLowStock,
      expiryDate: expiryDate,
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
