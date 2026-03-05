import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';

class ProductGroupDto {
  const ProductGroupDto({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.isActive,
    this.itemsCount,
  });

  final int id;
  final String code;
  final String name;
  final String? description;
  final bool? isActive;
  final int? itemsCount;

  factory ProductGroupDto.fromJson(Map<String, dynamic> json) {
    return ProductGroup.fromJson(json).toDto();
  }

  ProductGroup toEntity() {
    return ProductGroup(
      id: id,
      code: code,
      name: name,
      description: description,
      isActive: isActive,
      itemsCount: itemsCount,
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
