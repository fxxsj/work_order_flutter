import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductDto {
  const ProductDto({
    required this.id,
    required this.code,
    required this.name,
    this.productTypeDisplay,
    this.productGroupName,
    this.specification,
    this.unit,
    this.unitPrice,
    this.stockQuantity,
    this.isActive,
  });

  final int id;
  final String code;
  final String name;
  final String? productTypeDisplay;
  final String? productGroupName;
  final String? specification;
  final String? unit;
  final double? unitPrice;
  final double? stockQuantity;
  final bool? isActive;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      productTypeDisplay: toStringOrNull(json['product_type_display']),
      productGroupName: toStringOrNull(json['product_group_name']),
      specification: toStringOrNull(json['specification']),
      unit: toStringOrNull(json['unit']),
      unitPrice: _toDouble(json['unit_price']),
      stockQuantity: _toDouble(json['stock_quantity']),
      isActive: json['is_active'] == null ? null : json['is_active'] == true,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      code: code,
      name: name,
      productTypeDisplay: productTypeDisplay,
      productGroupName: productGroupName,
      specification: specification,
      unit: unit,
      unitPrice: unitPrice,
      stockQuantity: stockQuantity,
      isActive: isActive,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class ProductPageDto {
  const ProductPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<ProductDto> items;
  final int total;
  final int page;
  final int pageSize;
}
