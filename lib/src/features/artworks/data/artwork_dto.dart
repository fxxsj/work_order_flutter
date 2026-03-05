import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';

class ArtworkDto {
  ArtworkDto({
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
    this.notes,
    this.createdAt,
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
  final String? notes;
  final DateTime? createdAt;
  final List<int> dieIds;
  final List<int> foilingPlateIds;
  final List<int> embossingPlateIds;

  factory ArtworkDto.fromJson(Map<String, dynamic> json) {
    final products = <ArtworkProduct>[];
    final rawProducts = json['products'];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          final productId = toInt(item['product']) ?? toInt(item['id']) ?? 0;
          final productName = item['product_name']?.toString() ?? item['name']?.toString() ?? '';
          products.add(
            ArtworkProduct(
              productId: productId,
              productName: productName,
              impositionQuantity: toInt(item['imposition_quantity']),
            ),
          );
        }
      }
    }

    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      if (value == null) return const [];
      return [value.toString()];
    }

    List<int> parseIdList(dynamic value) {
      if (value is! List) return const [];
      final ids = <int>[];
      for (final item in value) {
        int? id;
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          id = toInt(map['id']) ?? toInt(map['pk']) ?? toInt(map['value']);
        } else {
          id = toInt(item);
        }
        if (id != null && id > 0) {
          ids.add(id);
        }
      }
      return ids;
    }

    return ArtworkDto(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      baseCode: toStringOrNull(json['base_code']),
      version: toInt(json['version']),
      name: json['name']?.toString() ?? '',
      colorDisplay: toStringOrNull(json['color_display']),
      cmykColors: parseStringList(json['cmyk_colors']),
      otherColors: parseStringList(json['other_colors']),
      impositionSize: toStringOrNull(json['imposition_size']),
      confirmed: json['confirmed'] == true,
      confirmedByName: toStringOrNull(json['confirmed_by_name']),
      confirmedAt: toDateTime(json['confirmed_at']),
      dieCodes: parseStringList(json['die_codes']),
      dieNames: parseStringList(json['die_names']),
      foilingPlateCodes: parseStringList(json['foiling_plate_codes']),
      foilingPlateNames: parseStringList(json['foiling_plate_names']),
      embossingPlateCodes: parseStringList(json['embossing_plate_codes']),
      embossingPlateNames: parseStringList(json['embossing_plate_names']),
      products: products,
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
      dieIds: parseIdList(json['dies']),
      foilingPlateIds: parseIdList(json['foiling_plates']),
      embossingPlateIds: parseIdList(json['embossing_plates']),
    );
  }

  factory ArtworkDto.fromEntity(Artwork entity) {
    return ArtworkDto(
      id: entity.id,
      code: entity.code,
      baseCode: entity.baseCode,
      version: entity.version,
      name: entity.name,
      colorDisplay: entity.colorDisplay,
      cmykColors: entity.cmykColors,
      otherColors: entity.otherColors,
      impositionSize: entity.impositionSize,
      confirmed: entity.confirmed,
      confirmedByName: entity.confirmedByName,
      confirmedAt: entity.confirmedAt,
      dieCodes: entity.dieCodes,
      dieNames: entity.dieNames,
      foilingPlateCodes: entity.foilingPlateCodes,
      foilingPlateNames: entity.foilingPlateNames,
      embossingPlateCodes: entity.embossingPlateCodes,
      embossingPlateNames: entity.embossingPlateNames,
      products: entity.products,
      notes: entity.notes,
      createdAt: entity.createdAt,
      dieIds: entity.dieIds,
      foilingPlateIds: entity.foilingPlateIds,
      embossingPlateIds: entity.embossingPlateIds,
    );
  }

  Artwork toEntity() {
    return Artwork(
      id: id,
      code: code,
      baseCode: baseCode,
      version: version,
      name: name,
      colorDisplay: colorDisplay,
      cmykColors: cmykColors,
      otherColors: otherColors,
      impositionSize: impositionSize,
      confirmed: confirmed,
      confirmedByName: confirmedByName,
      confirmedAt: confirmedAt,
      dieCodes: dieCodes,
      dieNames: dieNames,
      foilingPlateCodes: foilingPlateCodes,
      foilingPlateNames: foilingPlateNames,
      embossingPlateCodes: embossingPlateCodes,
      embossingPlateNames: embossingPlateNames,
      products: products,
      notes: notes,
      createdAt: createdAt,
      dieIds: dieIds,
      foilingPlateIds: foilingPlateIds,
      embossingPlateIds: embossingPlateIds,
    );
  }

  Map<String, dynamic> toPayload() {
    final payload = <String, dynamic>{
      'name': name.trim(),
      'cmyk_colors': cmykColors,
      'other_colors': otherColors,
      'imposition_size': impositionSize?.trim(),
      'notes': notes?.trim(),
      'dies': dieIds,
      'foiling_plates': foilingPlateIds,
      'embossing_plates': embossingPlateIds,
    };
    final trimmedBaseCode = baseCode?.trim() ?? '';
    if (trimmedBaseCode.isNotEmpty) {
      payload['base_code'] = trimmedBaseCode;
    }
    payload['products_data'] = products
        .where((item) => item.productId > 0)
        .map(
          (item) => {
            'product': item.productId,
            'imposition_quantity': item.impositionQuantity ?? 1,
          },
        )
        .toList();
    return payload;
  }
}

class ArtworkPageDto {
  const ArtworkPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<ArtworkDto> items;
  final int total;
  final int page;
  final int pageSize;
}
