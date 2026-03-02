import 'package:flutter/foundation.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/viewmodels/base_view_model.dart';

/// Base ViewModel for paginated list pages.
///
/// Extracts common pagination, search, and request-token logic from
/// feature-specific ViewModels. Subclasses only need to implement [fetchPage].
abstract class PaginatedViewModel<T> extends BaseViewModel {
  static const List<int> defaultPageSizeOptions = [10, 20, 50, 100];

  List<T> _items = [];
  int _page = 1;
  int _pageSize = 20;
  int _total = 0;
  String _searchText = '';
  int _requestToken = 0;

  /// Current list of items.
  List<T> get items => _items;

  /// Current page number (1-based).
  int get page => _page;

  /// Current page size.
  int get pageSize => _pageSize;

  /// Total number of items across all pages.
  int get total => _total;

  /// Current search keyword.
  String get searchText => _searchText;

  /// Available page size options.
  List<int> get pageSizeOptions => defaultPageSizeOptions;

  /// Total number of pages.
  int get totalPages {
    if (_total <= 0) return 1;
    final pages = (_total / _pageSize).ceil();
    return pages < 1 ? 1 : pages;
  }

  /// Whether a previous page exists.
  bool get hasPrev => _page > 1;

  /// Whether a next page exists.
  bool get hasNext => _page < totalPages;

  /// Subclasses implement this to fetch a page of data from the repository.
  @protected
  Future<PageData<T>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  });

  /// Load items with optional page reset.
  Future<void> loadItems({bool resetPage = false}) async {
    if (resetPage) _page = 1;
    final token = ++_requestToken;
    setLoading(true);
    clearError();
    try {
      final pageData = await fetchPage(
        page: _page,
        pageSize: _pageSize,
        search: _searchText,
      );
      if (token != _requestToken) return;
      _items = pageData.items;
      _total = pageData.total;
    } catch (err) {
      if (token != _requestToken) return;
      setError(err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (token != _requestToken) return;
      setLoading(false);
    }
  }

  /// Update the search keyword (does not trigger reload).
  void setSearchText(String value) {
    _searchText = value;
  }

  /// Update page size and reload from first page.
  Future<void> setPageSize(int size) async {
    _pageSize = size;
    _page = 1;
    await loadItems();
  }

  /// Navigate to a specific page.
  Future<void> setPage(int page) async {
    if (page == _page) return;
    _page = page;
    await loadItems();
  }

  /// Delete an item and reload, adjusting page if last item on current page.
  Future<void> deleteAndReload(Future<void> Function() deleteAction) async {
    await deleteAction();
    if (_items.length == 1 && _page > 1) {
      _page -= 1;
    }
    await loadItems();
  }
}
