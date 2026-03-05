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
