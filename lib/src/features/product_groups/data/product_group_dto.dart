import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class ProductGroupDto {
  const ProductGroupDto({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.isActive,
    this.itemsCount,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String code;
  final String name;
  final String? description;
  final bool? isActive;
  final int? itemsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProductGroupDto.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    return ProductGroupDto(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: toStringOrNull(json['description']),
      isActive: json['is_active'] == null ? null : json['is_active'] == true,
      itemsCount: items is List ? items.length : toInt(json['items_count']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
    };
  }

  ProductGroup toEntity() {
    return ProductGroup(
      id: id,
      code: code,
      name: name,
      description: description,
      isActive: isActive,
      itemsCount: itemsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension ProductGroupMapper on ProductGroup {
  ProductGroupDto toDto() {
    return ProductGroupDto(
      id: id,
      code: code,
      name: name,
      description: description,
      isActive: isActive,
      itemsCount: itemsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class ProductGroupPageDto {
  const ProductGroupPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<ProductGroupDto> items;
  final int total;
  final int page;
  final int pageSize;
}
