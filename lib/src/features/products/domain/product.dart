class ProductOption {
  const ProductOption({
    required this.id,
    required this.name,
    required this.code,
  });

  final int id;
  final String name;
  final String code;

  String get displayLabel => code.isNotEmpty ? '$name ($code)' : name;
}

class Product {
  const Product({
    required this.id,
    required this.code,
    required this.name,
    this.productTypeDisplay,
    this.productGroupName,
    this.specification,
    this.unit,
    this.unitPrice,
    this.stockQuantity,
    this.isActive,
  });

  final int id;
  final String code;
  final String name;
  final String? productTypeDisplay;
  final String? productGroupName;
  final String? specification;
  final String? unit;
  final double? unitPrice;
  final double? stockQuantity;
  final bool? isActive;
}
