import 'package:work_order_app/src/core/utils/parse_utils.dart';

class ArtworkProduct {
  const ArtworkProduct({
    required this.productId,
    required this.productName,
    this.impositionQuantity,
  });

  final int productId;
  final String productName;
  final int? impositionQuantity;
}

class ArtworkImage {
  const ArtworkImage({
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

/// 图稿领域模型。
class Artwork {
  const Artwork({
    required this.id,
    this.code,
    this.baseCode,
    this.version,
    required this.name,
    this.colorDisplay,
    this.cmykColors = const [],
    this.otherColors = const [],
    this.impositionSize,
    this.confirmed = false,
    this.confirmedByName,
    this.confirmedAt,
    this.dieCodes = const [],
    this.dieNames = const [],
    this.foilingPlateCodes = const [],
    this.foilingPlateNames = const [],
    this.embossingPlateCodes = const [],
    this.embossingPlateNames = const [],
    this.products = const [],
    this.images = const [],
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.dieIds = const [],
    this.foilingPlateIds = const [],
    this.embossingPlateIds = const [],
  });

  final int id;
  final String? code;
  final String? baseCode;
  final int? version;
  final String name;
  final String? colorDisplay;
  final List<String> cmykColors;
  final List<String> otherColors;
  final String? impositionSize;
  final bool confirmed;
  final String? confirmedByName;
  final DateTime? confirmedAt;
  final List<String> dieCodes;
  final List<String> dieNames;
  final List<String> foilingPlateCodes;
  final List<String> foilingPlateNames;
  final List<String> embossingPlateCodes;
  final List<String> embossingPlateNames;
  final List<ArtworkProduct> products;
  final List<ArtworkImage> images;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<int> dieIds;
  final List<int> foilingPlateIds;
  final List<int> embossingPlateIds;

  String get fullCode {
    if (code != null && code!.trim().isNotEmpty) {
      return code!.trim();
    }
    final base = baseCode?.trim() ?? '';
    final ver = version ?? 1;
    if (base.isEmpty) return '';
    return ver > 1 ? '$base-v$ver' : base;
  }

  factory Artwork.fromJson(Map<String, dynamic> json) {
    final cmyk = json['cmykColors'];
    final other = json['otherColors'];

    // Parse artwork products
    final artworkProducts = <ArtworkProduct>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          final productId = toInt(item['product']) ?? toInt(item['id']) ?? 0;
          final productName =
              item['product_name']?.toString() ??
              item['name']?.toString() ??
              '';
          artworkProducts.add(
            ArtworkProduct(
              productId: productId,
              productName: productName,
              impositionQuantity: toInt(item['imposition_quantity']),
            ),
          );
        }
      }
    }

    // Parse ID lists (supports both int arrays and object arrays)
    List<int> parseIdList(dynamic value) {
      if (value is! List) return const [];
      final ids = <int>[];
      for (final item in value) {
        int? id;
        if (item is Map) {
          id = toInt(item['id']) ?? toInt(item['pk']) ?? toInt(item['value']);
        } else {
          id = toInt(item);
        }
        if (id != null && id > 0) {
          ids.add(id);
        }
      }
      return ids;
    }

    return Artwork(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      baseCode: toStringOrNull(json['baseCode']),
      version: toInt(json['version']),
      name: json['name']?.toString() ?? '',
      colorDisplay: toStringOrNull(json['colorDisplay']),
      cmykColors: cmyk is List
          ? cmyk.map((e) => e.toString()).toList()
          : const [],
      otherColors: other is List
          ? other.map((e) => e.toString()).toList()
          : const [],
      impositionSize: toStringOrNull(json['impositionSize']),
      confirmed: json['confirmed'] == true,
      confirmedByName: toStringOrNull(json['confirmedByName']),
      confirmedAt: toDateTime(json['confirmedAt']),
      dieCodes: (json['dieCodes'] is List)
          ? List<String>.from(json['dieCodes'].whereType<String>())
          : const [],
      dieNames: (json['dieNames'] is List)
          ? List<String>.from(json['dieNames'].whereType<String>())
          : const [],
      foilingPlateCodes: (json['foilingPlateCodes'] is List)
          ? List<String>.from(json['foilingPlateCodes'].whereType<String>())
          : const [],
      foilingPlateNames: (json['foilingPlateNames'] is List)
          ? List<String>.from(json['foilingPlateNames'].whereType<String>())
          : const [],
      embossingPlateCodes: (json['embossingPlateCodes'] is List)
          ? List<String>.from(json['embossingPlateCodes'].whereType<String>())
          : const [],
      embossingPlateNames: (json['embossingPlateNames'] is List)
          ? List<String>.from(json['embossingPlateNames'].whereType<String>())
          : const [],
      products: artworkProducts,
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['createdAt']),
      updatedAt: toDateTime(json['updatedAt']),
      dieIds: parseIdList(json['dies']),
      foilingPlateIds: parseIdList(json['foiling_plates']),
      embossingPlateIds: parseIdList(json['embossing_plates']),
    );
  }
}
