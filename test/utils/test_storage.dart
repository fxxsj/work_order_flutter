import 'package:shared_preferences/shared_preferences.dart';

/// Mock AppStorage for testing.
///
/// Usage:
/// ```dart
/// setUpAll(() async {
///   SharedPreferences.setMockInitialValues({});
///   await StoreUtil.init();
/// });
///
/// tearDown(() async {
///   await StoreUtil.cleanAll();
/// });
/// ```
class MockAppStorage {
  final Map<String, dynamic> _storage = {};

  /// Set a mock value.
  void write(String key, dynamic value) {
    _storage[key] = value;
  }

  /// Get a mock value.
  dynamic read(String key) {
    return _storage[key];
  }

  /// Remove a key.
  void remove(String key) {
    _storage.remove(key);
  }

  /// Clear all storage.
  void clear() {
    _storage.clear();
  }

  /// Check if key exists.
  bool containsKey(String key) {
    return _storage.containsKey(key);
  }
}

/// Extension to easily set multiple values.
extension MockAppStorageExt on MockAppStorage {
  void writeMany(Map<String, dynamic> values) {
    _storage.addAll(values);
  }
}