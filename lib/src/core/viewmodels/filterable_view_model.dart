import 'package:work_order_app/src/core/viewmodels/paginated_view_model.dart';

/// Base ViewModel for list pages with filter support.
///
/// Extends PaginatedViewModel to add common filter functionality,
/// avoiding code duplication across feature ViewModels.
abstract class FilterableViewModel<T> extends PaginatedViewModel<T> {
  /// Internal filter storage.
  Map<String, String?> _filters = {};

  /// Set a filter value (null or empty string clears the filter).
  void setFilter(String key, String? value) {
    _filters[key] = value?.trim().isEmpty == true ? null : value?.trim();
  }

  /// Clear all filters.
  void clearFilters() {
    _filters.clear();
  }

  /// Get filter params for API calls (only non-null values).
  Map<String, dynamic> getFilterParams() {
    return Map.fromEntries(
      _filters.entries.where((e) => e.value != null),
    );
  }

  /// Check if any filters are active.
  bool get hasActiveFilters => _filters.values.any((v) => v != null);

  /// Get a specific filter value.
  String? getFilter(String key) => _filters[key];

  /// Handle filter change and reload items.
  Future<void> onFilterChanged(String key, String? value) async {
    setFilter(key, value);
    await loadItems(resetPage: true);
  }

  /// Update multiple filters at once and reload.
  Future<void> setFilters(Map<String, String?> filters) async {
    _filters = Map.from(filters);
    await loadItems(resetPage: true);
  }
}