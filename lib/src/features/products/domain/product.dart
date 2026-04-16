import 'package:work_order_app/src/core/utils/parse_utils.dart';

class ProductOption {
  const ProductOption({
    required this.id,
    required this.name,
    required this.code,
    this.specification,
    this.unit,
    this.unitPrice,
  });

  final int id;
  final String name;
  final String code;
  final String? specification;
  final String? unit;
  final double? unitPrice;

  String get displayLabel => code.isNotEmpty ? '$name ($code)' : name;
}

class ProductMaterialItem {
  const ProductMaterialItem({
    this.id,
    required this.materialId,
    this.materialName,
    this.materialCode,
    this.materialSize,
    this.materialUsage,
    this.needCutting,
    this.notes,
    this.sortOrder,
  });

  final int? id;
  final int materialId;
  final String? materialName;
  final String? materialCode;
  final String? materialSize;
  final String? materialUsage;
  final bool? needCutting;
  final String? notes;
  final int? sortOrder;

  factory ProductMaterialItem.fromJson(Map<String, dynamic> json) {
    return ProductMaterialItem(
      id: toInt(json['id']),
      materialId: toInt(json['material']) ?? 0,
      materialName: toStringOrNull(json['material_name']),
      materialCode: toStringOrNull(json['material_code']),
      materialSize: toStringOrNull(json['material_size']),
      materialUsage: toStringOrNull(json['material_usage']),
      needCutting: json['need_cutting'] == true,
      notes: toStringOrNull(json['notes']),
      sortOrder: toInt(json['sort_order']),
    );
  }
}

class ProductImage {
  const ProductImage({
    required this.id,
    required this.imageUrl,
    this.sortOrder = 0,
    this.description,
    this.createdAt,
  });

  final int id;
  final String imageUrl;
  final int sortOrder;
  final String? description;
  final DateTime? createdAt;
}

class Product {
  const Product({
    required this.id,
    required this.code,
    required this.name,
    this.productType,
    this.productTypeDisplay,
    this.productGroupId,
    this.productGroupName,
    this.productGroupCode,
    this.specification,
    this.unit,
    this.unitPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.description,
    this.isActive,
    this.defaultProcessIds = const [],
    this.defaultMaterials = const [],
    this.images = const [],
  });

  final int id;
  final String code;
  final String name;
  final String? productType;
  final String? productTypeDisplay;
  final int? productGroupId;
  final String? productGroupName;
  final String? productGroupCode;
  final String? specification;
  final String? unit;
  final double? unitPrice;
  final double? stockQuantity;
  final double? minStockQuantity;
  final String? description;
  final bool? isActive;
  final List<int> defaultProcessIds;
  final List<ProductMaterialItem> defaultMaterials;
  final List<ProductImage> images;
}
