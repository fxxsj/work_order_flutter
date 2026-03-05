import 'package:work_order_app/src/core/utils/parse_utils.dart';

class ProductGroup {
  const ProductGroup({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.isActive,
    this.itemsCount,
  });

  final int id;
  final String code;
  final String name;
  final String? description;
  final bool? isActive;
  final int? itemsCount;

  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    return ProductGroup(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: toStringOrNull(json['description']),
      isActive: json['is_active'] == null ? null : json['is_active'] == true,
      itemsCount: items is List ? items.length : toInt(json['items_count']),
    );
  }
}
