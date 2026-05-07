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

  /// 从 API payload（Map 或 List）解析分页数据。
  ///
  /// 统一的分页解析逻辑，所有 typed API service 都使用此方法，
  /// 避免重复编写 `payload['results']` / `payload['count']` 的分支判断。
  ///
  /// Usage:
  /// ```dart
  /// final results = payload['results'] as List;
  /// final list = results.map((item) => CustomerDto.fromJson(...)).toList();
  /// return PageData.fromPayload(
  ///   payload: payload,
  ///   page: page,
  ///   pageSize: pageSize,
  ///   results: list,
  /// );
  /// ```
  static PageData<T> fromPayload<T>({
    required dynamic payload,
    required int page,
    required int pageSize,
    required List<T> results,
    int? total,
  }) {
    int count = total ?? results.length;
    if (payload is Map<String, dynamic> && payload.containsKey('count')) {
      count = payload['count'] is int
          ? payload['count']
          : int.tryParse(payload['count']?.toString() ?? '') ?? results.length;
    }
    return PageData(
      items: results,
      total: count,
      page: page,
      pageSize: pageSize,
    );
  }
}
