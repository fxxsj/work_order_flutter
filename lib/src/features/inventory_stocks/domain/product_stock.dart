import 'package:work_order_app/src/core/utils/parse_utils.dart';

class ProductStock {
  const ProductStock({
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
  final int? minStockLevel;
  final String? location;
  final DateTime? productionDate;
  final double? unitCost;
  final double? totalValue;
  final bool? isLowStock;
  final DateTime? expiryDate;
  final int? daysUntilExpiry;
  final DateTime? createdAt;
  final String? notes;

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      id: toInt(json['id']) ?? 0,
      productName: toStringOrNull(json['product_name']),
      productCode: toStringOrNull(json['product_code']),
      batchNo: toStringOrNull(json['batch_no']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      quantity: _toDouble(json['quantity']),
      reservedQuantity: _toDouble(json['reserved_quantity']),
      availableQuantity: _toDouble(json['available_quantity']),
      minStockLevel: toInt(json['min_stock_level']),
      location: toStringOrNull(json['location']),
      productionDate: toDateTime(json['production_date']),
      unitCost: _toDouble(json['unit_cost']),
      totalValue: _toDouble(json['total_value']),
      isLowStock:
          json['is_low_stock'] == null ? null : json['is_low_stock'] == true,
      expiryDate: toDateTime(json['expiry_date']),
      daysUntilExpiry: toInt(json['days_until_expiry']),
      createdAt: toDateTime(json['created_at']),
      notes: toStringOrNull(json['notes']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
