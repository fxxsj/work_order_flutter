import 'package:flutter/foundation.dart';

/// Base ViewModel providing loading, error state management,
/// and safe notification after disposal.
///
/// Replaces the former `AppScaffoldController` (GetX) with a
/// Provider-compatible `ChangeNotifier` base class.
abstract class BaseViewModel extends ChangeNotifier {
  bool _loading = false;
  String? _errorMessage;
  bool _disposed = false;

  /// Whether the view model is currently loading data.
  bool get loading => _loading;

  /// The most recent error message, or null if no error.
  String? get errorMessage => _errorMessage;

  /// Whether an error is present.
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  /// Update loading state and notify listeners.
  @protected
  void setLoading(bool value) {
    _loading = value;
    safeNotify();
  }

  /// Set an error message and notify listeners.
  @protected
  void setError(String? message) {
    _errorMessage = message;
    safeNotify();
  }

  /// Clear the current error without notifying.
  @protected
  void clearError() {
    _errorMessage = null;
  }

  /// Notify listeners only if not yet disposed.
  void safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Template method for running an async operation with automatic
  /// loading/error lifecycle management.
  @protected
  Future<T?> runAsync<T>(
    Future<T> Function() action, {
    String? errorPrefix,
  }) async {
    setLoading(true);
    clearError();
    try {
      final result = await action();
      return result;
    } catch (err) {
      final prefix = errorPrefix != null ? '$errorPrefix: ' : '';
      setError('$prefix${err.toString().replaceFirst("Exception: ", "")}');
      return null;
    } finally {
      setLoading(false);
    }
  }
}
