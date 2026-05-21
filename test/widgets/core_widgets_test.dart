import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';

void main() {
  ThemeData buildTheme() {
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

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(1024, 768),
  }) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: size),
        child: MaterialApp(
          theme: buildTheme(),
          home: Scaffold(body: child),
        ),
      ),
    );
  }

  testWidgets('AppDataTable renders columns and rows', (tester) async {
    await pump(
      tester,
      AppDataTable(
        columns: const [
          DataColumn(label: Text('单号')),
          DataColumn(label: Text('状态')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('WO-001')),
            DataCell(Text('待处理')),
          ]),
          DataRow(cells: [
            DataCell(Text('WO-002')),
            DataCell(Text('已完成')),
          ]),
        ],
      ),
    );

    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('单号'), findsOneWidget);
    expect(find.text('WO-001'), findsOneWidget);
    expect(find.text('已完成'), findsOneWidget);
  });

  testWidgets('PageHeaderBar renders breadcrumb and action button',
      (tester) async {
    var pressed = false;

    await pump(
      tester,
      PageHeaderBar(
        breadcrumb: '首页 / 工单',
        actions: PageActionButton.filled(
          icon: const Icon(Icons.add),
          label: '新增',
          onPressed: () => pressed = true,
        ),
      ),
    );

    expect(find.text('首页 / 工单'), findsOneWidget);
    expect(find.text('新增'), findsOneWidget);

    await tester.tap(find.text('新增'));
    await tester.pump();

    expect(pressed, isTrue);
  });

  testWidgets('PageActionButton disables action while loading', (tester) async {
    var pressed = false;

    await pump(
      tester,
      Center(
        child: PageActionButton.outlined(
          label: '保存',
          loading: true,
          onPressed: () => pressed = true,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(OutlinedButton), warnIfMissed: false);
    await tester.pump();

    expect(pressed, isFalse);
  });

  testWidgets('EmptyStateCard renders optional action', (tester) async {
    var pressed = false;

    await pump(
      tester,
      EmptyStateCard(
        icon: Icons.inbox_outlined,
        text: '暂无数据',
        subtitle: '调整筛选条件后重试',
        actionLabel: '新建',
        onAction: () => pressed = true,
      ),
    );

    expect(find.text('暂无数据'), findsOneWidget);
    expect(find.text('调整筛选条件后重试'), findsOneWidget);

    await tester.tap(find.text('新建'));
    await tester.pump();

    expect(pressed, isTrue);
  });

  testWidgets('ErrorStateCard triggers retry action', (tester) async {
    var retryCount = 0;

    await pump(
      tester,
      ErrorStateCard(
        message: '加载失败',
        subtitle: '网络异常',
        retryLabel: '重试',
        onRetry: () => retryCount += 1,
      ),
    );

    expect(find.text('加载失败'), findsOneWidget);
    expect(find.text('网络异常'), findsOneWidget);

    await tester.tap(find.text('重试'));
    await tester.pump();

    expect(retryCount, 1);
  });

  testWidgets('ListSearchField edits and clears text', (tester) async {
    final controller = TextEditingController();
    var changedText = '';
    var submittedText = '';
    var cleared = false;

    await pump(
      tester,
      ListSearchField(
        controller: controller,
        hintText: '搜索',
        height: 40,
        width: 240,
        onChanged: (value) => changedText = value,
        onSubmitted: (value) => submittedText = value,
        onClear: () {
          cleared = true;
          controller.clear();
        },
      ),
    );

    await tester.enterText(find.byType(TextField), '工单');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(changedText, '工单');
    expect(submittedText, '工单');
    expect(find.byTooltip('清空'), findsOneWidget);

    await tester.tap(find.byTooltip('清空'));
    await tester.pump();

    expect(cleared, isTrue);
    expect(controller.text, isEmpty);
  });

  testWidgets('ListDensityToggle reports selected density', (tester) async {
    bool? isDense;

    await pump(
      tester,
      ListDensityToggle(
        isDense: false,
        height: 36,
        onChanged: (value) => isDense = value,
      ),
    );

    await tester.tap(find.text('紧凑'));
    await tester.pump();
    expect(isDense, isTrue);

    await tester.tap(find.text('舒适'));
    await tester.pump();
    expect(isDense, isFalse);
  });
}
