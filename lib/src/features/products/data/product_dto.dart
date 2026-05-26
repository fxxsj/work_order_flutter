import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';

class ProductDto {
  const ProductDto({
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
    this.availableGroupStock,
    this.groupItems = const [],
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
  final int? stockQuantity;
  final int? minStockQuantity;
  final String? description;
  final bool? isActive;
  final List<int> defaultProcessIds;
  final List<ProductMaterialItem> defaultMaterials;
  final List<ProductImage> images;
  final int? availableGroupStock;
  final List<GroupItem> groupItems;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    final processes = json['default_processes'];
    final processIds = processes is List
        ? processes.map((item) => toInt(item)).whereType<int>().toList()
        : const <int>[];
    final materials = json['default_materials'];
    final materialItems = materials is List
        ? materials
            .whereType<Map>()
            .map((item) =>
                ProductMaterialItem.fromJson(Map<String, dynamic>.from(item)))
            .toList()
        : const <ProductMaterialItem>[];
    final images = json['images'];
    final imageItems = images is List
        ? images.whereType<Map>().map((item) {
            final map = Map<String, dynamic>.from(item);
            return ProductImage(
              id: toInt(map['id']) ?? 0,
              imageUrl: toStringOrNull(map['image']) ?? '',
              sortOrder: toInt(map['sort_order']) ?? 0,
              description: toStringOrNull(map['description']),
              createdAt: toDateTime(map['created_at']),
            );
          }).toList()
        : const <ProductImage>[];
    final groupItems = json['group_items'];
    final groupItemList = groupItems is List
        ? groupItems
            .whereType<Map>()
            .map((item) => GroupItem.fromJson(Map<String, dynamic>.from(item)))
            .toList()
        : const <GroupItem>[];
    return ProductDto(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      productType: toStringOrNull(json['product_type']),
      productTypeDisplay: toStringOrNull(json['product_type_display']),
      productGroupId: toInt(json['product_group']),
      productGroupName: toStringOrNull(json['product_group_name']),
      productGroupCode: toStringOrNull(json['product_group_code']),
      specification: toStringOrNull(json['specification']),
      unit: toStringOrNull(json['unit']),
      unitPrice: _toDouble(json['unit_price']),
      stockQuantity: toInt(json['stock_quantity']),
      minStockQuantity: toInt(json['min_stock_quantity']),
      description: toStringOrNull(json['description']),
      isActive: json['is_active'] == null ? null : json['is_active'] == true,
      defaultProcessIds: processIds,
      defaultMaterials: materialItems,
      images: imageItems,
      availableGroupStock: toInt(json['available_group_stock']),
      groupItems: groupItemList,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'code': code,
      'name': name,
      if (productType != null) 'product_type': productType,
      if (productGroupId != null || productType == 'single')
        'product_group': productGroupId,
      if (specification != null) 'specification': specification,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (minStockQuantity != null) 'min_stock_quantity': minStockQuantity,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      'default_processes': defaultProcessIds,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      code: code,
      name: name,
      productType: productType,
      productTypeDisplay: productTypeDisplay,
      productGroupId: productGroupId,
      productGroupName: productGroupName,
      productGroupCode: productGroupCode,
      specification: specification,
      unit: unit,
      unitPrice: unitPrice,
      stockQuantity: stockQuantity,
      minStockQuantity: minStockQuantity,
      description: description,
      isActive: isActive,
      defaultProcessIds: defaultProcessIds,
      defaultMaterials: defaultMaterials,
      images: images,
      availableGroupStock: availableGroupStock,
      groupItems: groupItems,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

extension ProductMapper on Product {
  ProductDto toDto() {
    return ProductDto(
      id: id,
      code: code,
      name: name,
      productType: productType,
      productTypeDisplay: productTypeDisplay,
      productGroupId: productGroupId,
      productGroupName: productGroupName,
      productGroupCode: productGroupCode,
      specification: specification,
      unit: unit,
      unitPrice: unitPrice,
      stockQuantity: stockQuantity,
      minStockQuantity: minStockQuantity,
      description: description,
      isActive: isActive,
      defaultProcessIds: defaultProcessIds,
      defaultMaterials: defaultMaterials,
      images: images,
      availableGroupStock: availableGroupStock,
      groupItems: groupItems,
    );
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
