import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/viewmodels/paginated_view_model.dart';

/// 测试用 PaginatedViewModel
class TestPaginatedViewModel extends PaginatedViewModel<String> {
  int fetchCallCount = 0;
  bool shouldFail = false;
  List<String>? returnItems;
  int? returnTotal;

  @override
  Future<PageData<String>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    fetchCallCount++;
    if (shouldFail) {
      throw Exception('Fetch failed');
    }
    return PageData<String>(
      items: returnItems ?? ['item1', 'item2'],
      total: returnTotal ?? 2,
      page: page,
      pageSize: pageSize,
    );
  }
}

void main() {
  group('PaginatedViewModel', () {
    late TestPaginatedViewModel viewModel;

    setUp(() {
      viewModel = TestPaginatedViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('initial state', () {
      test('items is empty', () {
        expect(viewModel.items, isEmpty);
      });

      test('page is 1', () {
        expect(viewModel.page, equals(1));
      });

      test('pageSize is 20', () {
        expect(viewModel.pageSize, equals(20));
      });

      test('total is 0', () {
        expect(viewModel.total, equals(0));
      });

      test('searchText is empty', () {
        expect(viewModel.searchText, isEmpty);
      });

      test('pageSizeOptions contains default values', () {
        expect(viewModel.pageSizeOptions, contains(10));
        expect(viewModel.pageSizeOptions, contains(20));
        expect(viewModel.pageSizeOptions, contains(50));
        expect(viewModel.pageSizeOptions, contains(100));
      });
    });

    group('totalPages', () {
      test('returns 1 when total is 0', () {
        expect(viewModel.totalPages, equals(1));
      });

      test('returns 1 when total is less than pageSize', () async {
        viewModel.returnItems = ['a', 'b', 'c', 'd', 'e'];
        viewModel.returnTotal = 5;
        await viewModel.loadItems();
        expect(viewModel.totalPages, equals(1));
      });

      test('calculates correct pages for exact division', () async {
        viewModel.returnItems = List.generate(20, (i) => 'item$i');
        viewModel.returnTotal = 20;
        await viewModel.loadItems();
        // total=20, pageSize=20 → (20/20).ceil() = 1
        expect(viewModel.totalPages, equals(1));
      });

      test('calculates correct pages with remainder', () async {
        // Override fetch to return 21 items
        viewModel.returnItems = List.generate(20, (i) => 'item$i');
        viewModel.returnTotal = 21;
        await viewModel.loadItems();
        // total=21, pageSize=20 → (21/20).ceil() = 2
        expect(viewModel.totalPages, equals(2));
      });

      test('returns at least 1 page', () async {
        viewModel.returnItems = [];
        viewModel.returnTotal = 0;
        await viewModel.loadItems();
        expect(viewModel.totalPages, equals(1));
      });
    });

    group('hasPrev / hasNext', () {
      test('hasPrev is false on page 1', () {
        expect(viewModel.hasPrev, isFalse);
      });

      test('hasNext is false when on last page', () async {
        viewModel.returnItems = List.generate(10, (i) => 'item$i');
        viewModel.returnTotal = 10;
        await viewModel.loadItems();
        // total=10, pageSize=20, page=1 → items(10) + (1-1)*20 = 10 < 10 → false (no next)
        expect(viewModel.hasNext, isFalse);
      });

      test('hasNext is true when more pages exist', () async {
        // total=30, pageSize=20, page=1 → items(20) + (1-1)*20 = 20 < 30 → true
        viewModel.returnItems = List.generate(20, (i) => 'item$i');
        viewModel.returnTotal = 30;
        await viewModel.loadItems();
        expect(viewModel.hasNext, isTrue);
      });
    });

    group('loadItems', () {
      test('fetchPage is called', () async {
        await viewModel.loadItems();
        expect(viewModel.fetchCallCount, equals(1));
      });

      test('items are populated after load', () async {
        viewModel.returnItems = ['a', 'b', 'c'];
        viewModel.returnTotal = 3;
        await viewModel.loadItems();
        expect(viewModel.items, equals(['a', 'b', 'c']));
      });

      test('total is set after load', () async {
        viewModel.returnItems = ['a', 'b'];
        viewModel.returnTotal = 50;
        await viewModel.loadItems();
        expect(viewModel.total, equals(50));
      });

      test('loading state is managed correctly', () async {
        var loadingDuringFetch = false;
        viewModel.addListener(() {
          if (viewModel.loading) loadingDuringFetch = true;
        });
        await viewModel.loadItems();
        expect(loadingDuringFetch, isTrue);
        expect(viewModel.loading, isFalse);
      });

      test('loadItems with resetPage resets page to 1', () async {
        viewModel.returnItems = ['a'];
        viewModel.returnTotal = 1;
        await viewModel.loadItems(resetPage: true);
        expect(viewModel.page, equals(1));
      });

      test('error is set when fetch fails', () async {
        viewModel.shouldFail = true;
        await viewModel.loadItems();
        expect(viewModel.hasError, isTrue);
      });

      test('page token increments', () async {
        await viewModel.loadItems();
        // First load should work
        expect(viewModel.fetchCallCount, equals(1));

        // Second load with reset
        viewModel.returnItems = ['new'];
        viewModel.returnTotal = 1;
        await viewModel.loadItems(resetPage: true);
        expect(viewModel.fetchCallCount, equals(2));
      });
    });

    group('request token cancellation', () {
      test('stale requests do not update state', () async {
        viewModel.returnItems = ['slow_item'];
        viewModel.returnTotal = 1;

        // Start first request
        final future1 = viewModel.loadItems();

        // Override return values before first request completes
        viewModel.returnItems = ['fast_item'];
        viewModel.returnTotal = 1;

        // Start second request (gets new token)
        await viewModel.loadItems(resetPage: true);
        await future1;

        // Should have latest items, not slow ones
        expect(viewModel.items, equals(['fast_item']));
      });
    });
  });

  group('PageData', () {
    test('hasNext is true when more pages exist', () {
      final pageData = PageData<String>(
        items: ['a'],
        total: 25,
        page: 1,
        pageSize: 20,
      );
      expect(pageData.hasNext, isTrue);
    });

    test('hasNext is false on last page', () {
      // total=25, pageSize=20, last page (page 2) should have 5 items
      // 5 + (2-1)*20 = 5 + 20 = 25 < 25 → false
      final pageData = PageData<String>(
        items: ['a', 'b', 'c', 'd', 'e'], // 5 items on page 2
        total: 25,
        page: 2,
        pageSize: 20,
      );
      expect(pageData.hasNext, isFalse);
    });

    test('hasPrev is false on first page', () {
      final pageData = PageData<String>(
        items: ['a'],
        total: 25,
        page: 1,
        pageSize: 20,
      );
      expect(pageData.hasPrev, isFalse);
    });

    test('hasPrev is true when page > 1', () {
      final pageData = PageData<String>(
        items: ['a'],
        total: 25,
        page: 2,
        pageSize: 20,
      );
      expect(pageData.hasPrev, isTrue);
    });

    test('totalPages calculates correctly', () {
      // 55 items, pageSize=20 → (55/20).ceil() = 3 pages
      final pageData = PageData<String>(
        items: List.generate(20, (i) => 'a$i'),
        total: 55,
        page: 1,
        pageSize: 20,
      );
      expect(pageData.totalPages, equals(3));
    });

  });
}