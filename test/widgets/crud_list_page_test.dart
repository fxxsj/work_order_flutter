import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/viewmodels/paginated_view_model.dart';

void main() {
  testWidgets('CrudListPage renders desktop table rows', (tester) async {
    final viewModel = _TestListViewModel(
      pages: const [
        PageData(
          items: [
            _TestRecord(id: 1, name: '工单 A', status: '待处理'),
            _TestRecord(id: 2, name: '工单 B', status: '已完成'),
          ],
          total: 2,
          page: 1,
          pageSize: 20,
        ),
      ],
    );
    await viewModel.loadItems();

    await _pumpCrudList(tester, viewModel);

    expect(find.text('名称'), findsOneWidget);
    expect(find.text('状态'), findsOneWidget);
    expect(find.text('工单 A'), findsOneWidget);
    expect(find.text('已完成'), findsOneWidget);
    expect(find.text('操作'), findsOneWidget);
  });

  testWidgets('CrudListPage renders empty state', (tester) async {
    final viewModel = _TestListViewModel(
      pages: const [
        PageData<_TestRecord>(items: [], total: 0, page: 1, pageSize: 20),
      ],
    );
    await viewModel.loadItems();

    await _pumpCrudList(tester, viewModel);

    expect(find.text('暂无记录'), findsOneWidget);
  });

  testWidgets('CrudListPage renders error and retries load', (tester) async {
    final viewModel = _TestListViewModel(
      pages: const [
        PageData(
          items: [_TestRecord(id: 1, name: '恢复数据', status: '正常')],
          total: 1,
          page: 1,
          pageSize: 20,
        ),
      ],
      failFirstFetch: true,
    );
    await viewModel.loadItems();

    await _pumpCrudList(tester, viewModel);

    expect(find.text('模拟失败'), findsOneWidget);

    await tester.tap(find.text('重新加载'));
    await tester.pumpAndSettle();

    expect(find.text('恢复数据'), findsOneWidget);
    expect(viewModel.fetchCount, 2);
  });

  testWidgets('CrudListPage submits search text through config load',
      (tester) async {
    final viewModel = _TestListViewModel(
      pages: const [
        PageData(
          items: [_TestRecord(id: 1, name: '初始', status: '待处理')],
          total: 1,
          page: 1,
          pageSize: 20,
        ),
      ],
    );
    await viewModel.loadItems();

    await _pumpCrudList(tester, viewModel);

    await tester.enterText(find.byType(TextField), '客户订单');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(viewModel.searchText, '客户订单');
    expect(viewModel.loadResetFlags.last, isTrue);
  });

  testWidgets('CrudListPage footer advances to next page', (tester) async {
    final viewModel = _TestListViewModel(
      pages: const [
        PageData(
          items: [_TestRecord(id: 1, name: '第一页', status: '待处理')],
          total: 25,
          page: 1,
          pageSize: 20,
        ),
        PageData(
          items: [_TestRecord(id: 2, name: '第二页', status: '已完成')],
          total: 25,
          page: 2,
          pageSize: 20,
        ),
      ],
    );
    await viewModel.loadItems();

    await _pumpCrudList(tester, viewModel);

    expect(find.text('第 1 / 2 页，共 25 条'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(viewModel.page, 2);
    expect(find.text('第二页'), findsOneWidget);
  });
}

Future<void> _pumpCrudList(
  WidgetTester tester,
  _TestListViewModel viewModel,
) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(1024, 768)),
      child: MaterialApp(
        theme: _buildTheme(),
        home: ChangeNotifierProvider<_TestListViewModel>.value(
          value: viewModel,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: CrudListPage<_TestRecord, _TestListViewModel>(
                config: _buildConfig(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

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

CrudListConfig<_TestRecord, _TestListViewModel> _buildConfig() {
  return CrudListConfig<_TestRecord, _TestListViewModel>(
    searchHintText: '搜索记录',
    emptyText: '暂无记录',
    emptyIcon: Icons.inbox_outlined,
    refreshButtonText: '刷新',
    columns: [
      CrudTableColumn(
        label: '名称',
        cellBuilder: (_, item) => Text(item.name),
      ),
      CrudTableColumn(
        label: '状态',
        cellBuilder: (_, item) => Text(item.status),
      ),
    ],
    loadItems: (viewModel, {bool resetPage = false}) {
      viewModel.loadResetFlags.add(resetPage);
      return viewModel.loadItems(resetPage: resetPage);
    },
    titleBuilder: (item) => item.name,
    subtitleBuilder: (item) => item.status,
    summaryFieldsBuilder: (item) => [
      CrudSummaryFieldData(label: '编号', value: item.id.toString()),
      CrudSummaryFieldData(label: '状态', value: item.status),
    ],
    rowActionsBuilder: (_, __, ___) => const [],
  );
}

class _TestRecord {
  const _TestRecord({
    required this.id,
    required this.name,
    required this.status,
  });

  final int id;
  final String name;
  final String status;
}

class _TestListViewModel extends PaginatedViewModel<_TestRecord> {
  _TestListViewModel({
    required this.pages,
    this.failFirstFetch = false,
  });

  final List<PageData<_TestRecord>> pages;
  final bool failFirstFetch;
  final List<bool> loadResetFlags = [];
  int fetchCount = 0;

  @override
  Future<PageData<_TestRecord>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    fetchCount += 1;
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
}
