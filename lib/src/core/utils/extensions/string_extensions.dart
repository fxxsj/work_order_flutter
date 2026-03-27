final RegExp _emailPattern = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
final RegExp _phonePattern = RegExp(r'^1[3-9]\d{9}$');

extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  bool get isValidEmail => _emailPattern.hasMatch(trim());

  bool get isValidPhone => _phonePattern.hasMatch(trim());

  String? get nullIfBlank {
    final normalized = trim();
    return normalized.isEmpty ? null : normalized;
  }

  String get capitalized {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
