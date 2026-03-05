import 'package:work_order_app/src/core/utils/parse_utils.dart';

class EmbossingPlateProduct {
  const EmbossingPlateProduct({
    required this.productId,
    required this.productName,
    this.quantity,
  });

  final int productId;
  final String productName;
  final int? quantity;
}

class EmbossingPlate {
  const EmbossingPlate({
    required this.id,
    this.code,
    required this.name,
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
  final String? size;
  final String? material;
  final String? thickness;
  final bool confirmed;
  final List<EmbossingPlateProduct> products;
  final String? notes;
  final DateTime? createdAt;

  factory EmbossingPlate.fromJson(Map<String, dynamic> json) {
    return EmbossingPlate(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      size: toStringOrNull(json['size']),
      material: toStringOrNull(json['material']),
      thickness: toStringOrNull(json['thickness']),
      confirmed: json['confirmed'] == true,
      products: const [],
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['createdAt']),
    );
  }
}
