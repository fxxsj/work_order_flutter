/// Shared JSON parse utilities.
///
/// Eliminates duplication of toInt, toStringOrNull, toDateTime across DTOs
/// and domain models.

/// Safely parse a dynamic value to int.
int? toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

/// Convert a dynamic value to String, returning null if empty or null.
String? toStringOrNull(dynamic value) {
  final text = value?.toString();
  if (text == null || text.trim().isEmpty) return null;
  return text;
}

/// Safely parse a dynamic value to DateTime.
DateTime? toDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
