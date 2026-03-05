import 'package:work_order_app/src/core/utils/parse_utils.dart';

class MaterialItem {
  const MaterialItem({
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

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      unit: toStringOrNull(json['unit']),
      unitPrice: _toDouble(json['unit_price']),
      stockQuantity: _toDouble(json['stock_quantity']),
      minStockQuantity: _toDouble(json['min_stock_quantity']),
      isActive: json['is_active'] == null ? null : json['is_active'] == true,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
