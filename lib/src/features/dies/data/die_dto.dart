import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';

class DieDto {
  DieDto({
    required this.id,
    this.code,
    required this.name,
    this.dieType,
    this.dieTypeDisplay,
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
  final String? dieType;
  final String? dieTypeDisplay;
  final String? size;
  final String? material;
  final String? thickness;
  final bool confirmed;
  final List<DieProduct> products;
  final String? notes;
  final DateTime? createdAt;

  factory DieDto.fromJson(Map<String, dynamic> json) {
    final products = <DieProduct>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          final productId = toInt(item['product']) ?? toInt(item['id']) ?? 0;
          final productName = item['product_name']?.toString() ?? item['name']?.toString() ?? '';
          products.add(
            DieProduct(
              productId: productId,
              productName: productName,
              quantity: toInt(item['quantity']),
              relationType: toStringOrNull(item['relation_type']),
            ),
          );
        }
      }
    }

    return DieDto(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      dieType: toStringOrNull(json['die_type']),
      dieTypeDisplay: toStringOrNull(json['die_type_display']),
      size: toStringOrNull(json['size']),
      material: toStringOrNull(json['material']),
      thickness: toStringOrNull(json['thickness']),
      confirmed: json['confirmed'] == true,
      products: products,
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
    );
  }

  factory DieDto.fromEntity(Die entity) {
    return DieDto(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      dieType: entity.dieType,
      dieTypeDisplay: entity.dieTypeDisplay,
      size: entity.size,
      material: entity.material,
      thickness: entity.thickness,
      confirmed: entity.confirmed,
      products: entity.products,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  Die toEntity() {
    return Die(
      id: id,
      code: code,
      name: name,
      dieType: dieType,
      dieTypeDisplay: dieTypeDisplay,
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
      'die_type': dieType,
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
            'relation_type': item.relationType ?? 'exclusive',
          },
        )
        .toList();
    return payload;
  }
}

class DiePageDto {
  const DiePageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<DieDto> items;
  final int total;
  final int page;
  final int pageSize;
}
