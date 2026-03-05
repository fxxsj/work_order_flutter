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

  factory Die.fromJson(Map<String, dynamic> json) {
    return Die(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      dieType: toStringOrNull(json['dieType']),
      dieTypeDisplay: toStringOrNull(json['dieTypeDisplay']),
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
