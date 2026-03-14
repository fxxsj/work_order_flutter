class GenericRecord {
  const GenericRecord({
    required this.id,
    required this.data,
  });

  final int id;
  final Map<String, dynamic> data;

  String? getString(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  num? getNumber(String key) {
    final value = data[key];
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }

  bool? getBool(String key) {
    final value = data[key];
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return null;
  }

  DateTime? getDateTime(String key) {
    final value = data[key];
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
