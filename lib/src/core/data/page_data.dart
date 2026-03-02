/// Generic paginated response model.
///
/// Provides a reusable container for paginated API responses, replacing
/// feature-specific models like `CustomerPage`.
class PageData<T> {
  /// Creates a paginated data result.
  const PageData({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  /// Whether there is a next page.
  bool get hasNext => items.length + (page - 1) * pageSize < total;

  /// Whether there is a previous page.
  bool get hasPrev => page > 1;

  /// Total number of pages.
  int get totalPages {
    if (total <= 0) return 1;
    final pages = (total / pageSize).ceil();
    return pages < 1 ? 1 : pages;
  }
}
