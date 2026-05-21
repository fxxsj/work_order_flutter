import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/generic_resource_list_page.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';

void main() {
  testWidgets('GenericResourceListPage renders desktop records',
      (tester) async {
    final repository = _FakeGenericRepository(
      pages: const [
        PageData(
          items: [
            GenericRecord(
              id: 1,
              data: {'name': '客户 A', 'status': '启用'},
            ),
            GenericRecord(
              id: 2,
              data: {'name': '客户 B', 'status': '停用'},
            ),
          ],
          total: 2,
          page: 1,
          pageSize: 20,
        ),
      ],
    );
    final viewModel = GenericListViewModel(repository);
    await viewModel.initialize();

    await _pumpGenericPage(tester, viewModel);

    expect(find.text('名称'), findsOneWidget);
    expect(find.text('状态'), findsOneWidget);
    expect(find.text('客户 A'), findsOneWidget);
    expect(find.text('停用'), findsOneWidget);
  });

  testWidgets('GenericResourceListPage opens detail dialog', (tester) async {
    final repository = _FakeGenericRepository(
      pages: const [
        PageData(
          items: [
            GenericRecord(
              id: 1,
              data: {'name': '客户 A', 'status': '启用'},
            ),
          ],
          total: 1,
          page: 1,
          pageSize: 20,
        ),
      ],
    );
    final viewModel = GenericListViewModel(repository);
    await viewModel.initialize();

    await _pumpGenericPage(tester, viewModel);

    await tester.tap(find.text('客户 A'));
    await tester.pumpAndSettle();

    expect(find.text('客户详情'), findsOneWidget);
    expect(find.text('名称'), findsWidgets);
    expect(find.text('客户 A'), findsWidgets);
    expect(find.text('关闭'), findsOneWidget);
  });

  testWidgets('GenericResourceListPage renders empty state', (tester) async {
    final repository = _FakeGenericRepository(
      pages: const [
        PageData<GenericRecord>(items: [], total: 0, page: 1, pageSize: 20),
      ],
    );
    final viewModel = GenericListViewModel(repository);
    await viewModel.initialize();

    await _pumpGenericPage(tester, viewModel);

    expect(find.text('暂无客户'), findsOneWidget);
  });

  testWidgets('GenericResourceListPage renders error and retries',
      (tester) async {
    final repository = _FakeGenericRepository(
      pages: const [
        PageData(
          items: [
            GenericRecord(
              id: 1,
              data: {'name': '恢复客户', 'status': '启用'},
            ),
          ],
          total: 1,
          page: 1,
          pageSize: 20,
        ),
      ],
      failFirstFetch: true,
    );
    final viewModel = GenericListViewModel(repository);
    await viewModel.initialize();

    await _pumpGenericPage(tester, viewModel);

    expect(find.text('模拟失败'), findsOneWidget);

    await tester.tap(find.text('重新加载'));
    await tester.pumpAndSettle();

    expect(find.text('恢复客户'), findsOneWidget);
    expect(repository.fetchCount, 2);
  });

  testWidgets('GenericResourceListPage submits search text', (tester) async {
    final repository = _FakeGenericRepository(
      pages: const [
        PageData(
          items: [
            GenericRecord(
              id: 1,
              data: {'name': '客户 A', 'status': '启用'},
            ),
          ],
          total: 1,
          page: 1,
          pageSize: 20,
        ),
      ],
    );
    final viewModel = GenericListViewModel(repository);
    await viewModel.initialize();

    await _pumpGenericPage(tester, viewModel);

    await tester.enterText(find.byType(TextField), '客户 A');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(viewModel.searchText, '客户 A');
    expect(repository.lastSearch, '客户 A');
  });

  testWidgets('GenericResourceListPage advances to next page', (tester) async {
    final repository = _FakeGenericRepository(
      pages: const [
        PageData(
          items: [
            GenericRecord(
              id: 1,
              data: {'name': '第一页客户', 'status': '启用'},
            ),
          ],
          total: 25,
          page: 1,
          pageSize: 20,
        ),
        PageData(
          items: [
            GenericRecord(
              id: 2,
              data: {'name': '第二页客户', 'status': '启用'},
            ),
          ],
          total: 25,
          page: 2,
          pageSize: 20,
        ),
      ],
    );
    final viewModel = GenericListViewModel(repository);
    await viewModel.initialize();

    await _pumpGenericPage(tester, viewModel);

    expect(find.text('第 1 / 2 页，共 25 条'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(viewModel.page, 2);
    expect(find.text('第二页客户'), findsOneWidget);
  });
}

Future<void> _pumpGenericPage(
  WidgetTester tester,
  GenericListViewModel viewModel,
) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return ChangeNotifierProvider<GenericListViewModel>.value(
            value: viewModel,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: GenericResourceListPage(config: _config),
              ),
            ),
          );
        },
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(1024, 768)),
      child: MaterialApp.router(
        theme: _buildTheme(),
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
}

const _config = GenericResourceConfig(
  id: 'customers',
  title: '客户',
  detailTitle: '客户详情',
  endpoint: '/customers',
  searchHintText: '搜索客户',
  emptyText: '暂无客户',
  emptyIcon: Icons.people_outline,
  openDetailsOnPrimaryTap: true,
  columns: [
    GenericColumn(
      label: '名称',
      value: _nameValue,
    ),
    GenericColumn(
      label: '状态',
      value: _statusValue,
    ),
  ],
  summaryFields: [
    GenericSummaryField(label: '名称', value: _nameValue),
    GenericSummaryField(label: '状态', value: _statusValue),
  ],
  detailFields: [
    GenericDetailField(label: '名称', value: _nameValue),
    GenericDetailField(label: '状态', value: _statusValue),
  ],
);

String _nameValue(GenericRecord record) => record.getString('name') ?? '-';

String _statusValue(GenericRecord record) => record.getString('status') ?? '-';

ThemeData _buildTheme() {
  return ThemeData(
    useMaterial3: true,
    extensions: const [
      AppColors(
        background: Colors.white,
        surface: Colors.white,
        sidebar: Colors.white,
        subtleText: Colors.black54,
        sidebarText: Colors.black87,
        borderColor: Colors.black12,
      ),
      AppSemanticColors(
        success: Colors.green,
        warning: Colors.orange,
        danger: Colors.red,
        info: Colors.blue,
        surfaceAlt: Color(0xfff5f5f5),
        shadowStrong: Colors.black26,
        unreadBackground: Color(0xffeef6ff),
      ),
    ],
  );
}

class _FakeGenericRepository implements GenericRepository {
  _FakeGenericRepository({
    required this.pages,
    this.failFirstFetch = false,
  });

  final List<PageData<GenericRecord>> pages;
  final bool failFirstFetch;
  int fetchCount = 0;
  String? lastSearch;

  @override
  Future<PageData<GenericRecord>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
    Map<String, dynamic>? extraParams,
  }) async {
    fetchCount += 1;
    lastSearch = search;
    if (failFirstFetch && fetchCount == 1) {
      throw Exception('模拟失败');
    }
    final index = (page - 1).clamp(0, pages.length - 1);
    final data = pages[index];
    return PageData(
      items: data.items,
      total: data.total,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Map<String, dynamic>> fetchSummary({
    Map<String, dynamic>? extraParams,
  }) async {
    return const {};
  }

  @override
  Future<GenericRecord> createRecord(Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecord(int id) {
    throw UnimplementedError();
  }

  @override
  Future<GenericRecord> updateRecord(int id, Map<String, dynamic> payload) {
    throw UnimplementedError();
  }
}
