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

class FoilingPlateImage {
  const FoilingPlateImage({
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
  final String? foilingType;
  final String? size;
  final String? material;
  final String? thickness;
  final bool confirmed;
  final String? confirmedByName;
  final DateTime? confirmedAt;
  final List<FoilingPlateProduct> products;
  final List<FoilingPlateImage> images;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FoilingPlate.fromJson(Map<String, dynamic> json) {
    // Parse foiling plate products
    final plateProducts = <FoilingPlateProduct>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          plateProducts.add(
            FoilingPlateProduct(
              productId: toInt(item['product']) ?? toInt(item['id']) ?? 0,
              productName:
                  item['product_name']?.toString() ??
                  item['name']?.toString() ??
                  '',
              quantity: toInt(item['quantity']),
            ),
          );
        }
      }
    }

    // Parse foiling plate images
    final plateImages = <FoilingPlateImage>[];
    final rawImages = json['images'];
    if (rawImages is List) {
      for (final item in rawImages) {
        if (item is Map) {
          plateImages.add(
            FoilingPlateImage(
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

    return FoilingPlate(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
      foilingType: toStringOrNull(json['foiling_type']),
      size: toStringOrNull(json['size']),
      material: toStringOrNull(json['material']),
      thickness: toStringOrNull(json['thickness']),
      confirmed: json['confirmed'] == true,
      confirmedByName: toStringOrNull(json['confirmed_by_name']),
      confirmedAt: toDateTime(json['confirmed_at']),
      products: plateProducts,
      images: plateImages,
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }
}
