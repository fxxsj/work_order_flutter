import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';

class EmbossingPlateDto {
  EmbossingPlateDto({
    required this.id,
    this.code,
    required this.name,
    this.size,
    this.material,
    this.thickness,
    this.confirmed = false,
    this.confirmedByName,
    this.confirmedAt,
    this.products = const [],
    this.images = const [],
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? code;
  final String name;
  final String? size;
  final String? material;
  final String? thickness;
  final bool confirmed;
  final String? confirmedByName;
  final DateTime? confirmedAt;
  final List<EmbossingPlateProduct> products;
  final List<EmbossingPlateImage> images;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EmbossingPlateDto.fromJson(Map<String, dynamic> json) {
    final products = <EmbossingPlateProduct>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          final productId = toInt(item['product']) ?? toInt(item['id']) ?? 0;
          final productName =
              item['product_name']?.toString() ??
              item['name']?.toString() ??
              '';
          products.add(
            EmbossingPlateProduct(
              productId: productId,
              productName: productName,
              quantity: toInt(item['quantity']),
            ),
          );
        }
      }
    }

    final images = <EmbossingPlateImage>[];
    final rawImages = json['images'];
    if (rawImages is List) {
      for (final item in rawImages) {
        if (item is Map) {
          images.add(
            EmbossingPlateImage(
              id: toInt(item['id']) ?? 0,
              imageUrl: toStringOrNull(item['image']) ?? '',
              sortOrder: toInt(item['sort_order']) ?? 0,
              description: toStringOrNull(item['description']),
              createdAt: toDateTime(item['created_at']),
            ),
          );
        }
      }
    }

    return EmbossingPlateDto(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      size: toStringOrNull(json['size']),
      material: toStringOrNull(json['material']),
      thickness: toStringOrNull(json['thickness']),
      confirmed: json['confirmed'] == true,
      confirmedByName: toStringOrNull(json['confirmed_by_name']),
      confirmedAt: toDateTime(json['confirmed_at']),
      products: products,
      images: images,
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }

  factory EmbossingPlateDto.fromEntity(EmbossingPlate entity) {
    return EmbossingPlateDto(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      size: entity.size,
      material: entity.material,
      thickness: entity.thickness,
      confirmed: entity.confirmed,
      confirmedByName: entity.confirmedByName,
      confirmedAt: entity.confirmedAt,
      products: entity.products,
      images: entity.images,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  EmbossingPlate toEntity() {
    return EmbossingPlate(
      id: id,
      code: code,
      name: name,
      size: size,
      material: material,
      thickness: thickness,
      confirmed: confirmed,
      confirmedByName: confirmedByName,
      confirmedAt: confirmedAt,
      products: products,
      images: images,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toPayload() {
    final payload = <String, dynamic>{
      'name': name.trim(),
      'size': size?.trim(),
      'material': material?.trim(),
      'thickness': thickness?.trim(),
      'notes': notes?.trim(),
    };
    final trimmedCode = code?.trim() ?? '';
    if (trimmedCode.isNotEmpty) {
      payload['code'] = trimmedCode;
    }
    payload['products_data'] = products
        .where((item) => item.productId > 0)
        .map(
          (item) => {'product': item.productId, 'quantity': item.quantity ?? 1},
        )
        .toList();
    return payload;
  }
}

class EmbossingPlatePageDto {
  const EmbossingPlatePageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<EmbossingPlateDto> items;
  final int total;
  final int page;
  final int pageSize;
}
