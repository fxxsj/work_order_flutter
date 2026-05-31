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

class EmbossingPlateImage {
  const EmbossingPlateImage({
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

class EmbossingPlate {
  const EmbossingPlate({
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

  factory EmbossingPlate.fromJson(Map<String, dynamic> json) {
    // Parse embossing plate products
    final plateProducts = <EmbossingPlateProduct>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          plateProducts.add(EmbossingPlateProduct(
            productId: toInt(item['product']) ?? toInt(item['id']) ?? 0,
            productName: item['product_name']?.toString() ?? item['name']?.toString() ?? '',
            quantity: toInt(item['quantity']),
          ));
        }
      }
    }

    // Parse embossing plate images
    final plateImages = <EmbossingPlateImage>[];
    final rawImages = json['images'];
    if (rawImages is List) {
      for (final item in rawImages) {
        if (item is Map) {
          plateImages.add(EmbossingPlateImage(
            id: toInt(item['id']) ?? 0,
            imageUrl: toStringOrNull(item['image']) ?? '',
            sortOrder: toInt(item['sort_order']) ?? 0,
            description: toStringOrNull(item['description']),
            createdAt: toDateTime(item['created_at']),
          ));
        }
      }
    }

    return EmbossingPlate(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      name: json['name']?.toString() ?? '',
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
