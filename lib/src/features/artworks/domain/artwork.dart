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
    return Artwork(
      id: toInt(json['id']) ?? 0,
      code: toStringOrNull(json['code']),
      baseCode: toStringOrNull(json['baseCode']),
      version: toInt(json['version']),
      name: json['name']?.toString() ?? '',
      colorDisplay: toStringOrNull(json['colorDisplay']),
      cmykColors: cmyk is List ? cmyk.map((e) => e.toString()).toList() : const [],
      otherColors: other is List ? other.map((e) => e.toString()).toList() : const [],
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
      products: const [],
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['createdAt']),
      dieIds: const [],
      foilingPlateIds: const [],
      embossingPlateIds: const [],
    );
  }
}
