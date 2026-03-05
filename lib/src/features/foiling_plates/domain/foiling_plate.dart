import 'package:work_order_app/src/core/utils/parse_utils.dart';

class FoilingPlateProduct {
  const FoilingPlateProduct({
    required this.productId,
    required this.productName,
    this.quantity,
  });

  final int productId;
  final String productName;
  final int? quantity;
}

class FoilingPlate {
  const FoilingPlate({
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

  factory FoilingPlate.fromJson(Map<String, dynamic> json) {
    return FoilingPlate(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      foilingType: toStringOrNull(json['foilingType']),
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
