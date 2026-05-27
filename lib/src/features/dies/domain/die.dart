import 'package:work_order_app/src/core/utils/parse_utils.dart';

class DieProduct {
  const DieProduct({
    required this.productId,
    required this.productName,
    this.quantity,
    this.relationType,
  });

  final int productId;
  final String productName;
  final int? quantity;
  final String? relationType;
}

class DieImage {
  const DieImage({
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

class Die {
  const Die({
    required this.id,
    this.code,
    required this.name,
    this.dieType,
    this.dieTypeDisplay,
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
  final String? dieType;
  final String? dieTypeDisplay;
  final String? size;
  final String? material;
  final String? thickness;
  final bool confirmed;
  final String? confirmedByName;
  final DateTime? confirmedAt;
  final List<DieProduct> products;
  final List<DieImage> images;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Die.fromJson(Map<String, dynamic> json) {
    return Die(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      dieType: toStringOrNull(json['die_type']),
      dieTypeDisplay: toStringOrNull(json['die_type_display']),
      size: toStringOrNull(json['size']),
      material: toStringOrNull(json['material']),
      thickness: toStringOrNull(json['thickness']),
      confirmed: json['confirmed'] == true,
      confirmedByName: toStringOrNull(json['confirmed_by_name']),
      confirmedAt: toDateTime(json['confirmed_at']),
      products: const [],
      images: const [],
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }
}
