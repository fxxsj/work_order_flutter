import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';

class FoilingPlateDto {
  FoilingPlateDto({
    required this.id,
    this.code,
    required this.name,
    this.foilingType,
    this.size,
    this.material,
    this.thickness,
    this.confirmed = false,
    this.products = const [],
    this.notes,
    this.createdAt,
  });

  final int id;
  final String? code;
  final String name;
  final String? foilingType;
  final String? size;
  final String? material;
  final String? thickness;
  final bool confirmed;
  final List<FoilingPlateProduct> products;
  final String? notes;
  final DateTime? createdAt;

  factory FoilingPlateDto.fromJson(Map<String, dynamic> json) {
    final products = <FoilingPlateProduct>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          final productId = toInt(item['product']) ?? toInt(item['id']) ?? 0;
          final productName = item['product_name']?.toString() ?? item['name']?.toString() ?? '';
          products.add(
            FoilingPlateProduct(
              productId: productId,
              productName: productName,
              quantity: toInt(item['quantity']),
            ),
          );
        }
      }
    }

    return FoilingPlateDto(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      foilingType: toStringOrNull(json['foiling_type']),
      size: toStringOrNull(json['size']),
      material: toStringOrNull(json['material']),
      thickness: toStringOrNull(json['thickness']),
      confirmed: json['confirmed'] == true,
      products: products,
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
    );
  }

  factory FoilingPlateDto.fromEntity(FoilingPlate entity) {
    return FoilingPlateDto(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      foilingType: entity.foilingType,
      size: entity.size,
      material: entity.material,
      thickness: entity.thickness,
      confirmed: entity.confirmed,
      products: entity.products,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  FoilingPlate toEntity() {
    return FoilingPlate(
      id: id,
      code: code,
      name: name,
      foilingType: foilingType,
      size: size,
      material: material,
      thickness: thickness,
      confirmed: confirmed,
      products: products,
      notes: notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toPayload() {
    final payload = <String, dynamic>{
      'name': name.trim(),
      'foiling_type': foilingType,
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
          (item) => {
            'product': item.productId,
            'quantity': item.quantity ?? 1,
          },
        )
        .toList();
    return payload;
  }
}

class FoilingPlatePageDto {
  const FoilingPlatePageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<FoilingPlateDto> items;
  final int total;
  final int page;
  final int pageSize;
}
