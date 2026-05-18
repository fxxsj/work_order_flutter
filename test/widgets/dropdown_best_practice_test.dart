import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_row_widgets.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_sections.dart';

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
      ],
    );
  }

  testWidgets('UnifiedDropdown follows external value updates', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: const Scaffold(body: _UnifiedDropdownHarness()),
      ),
    );

    // Single-select now renders via InputDecorator + Text (not DropdownMenu)
    expect(find.text('待处理'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('change-selection')));
    await tester.pump();
    await tester.pump();

    expect(find.text('已完成'), findsOneWidget);
  });

  testWidgets(
      'UnifiedDropdown shows null option label for filter-style single select',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: AppSelect<int?>(
              value: null,
              decoration: const InputDecoration(labelText: '客户'),
              options: const [
                AppDropdownOption<int?>(value: null, label: '全部客户'),
                AppDropdownOption<int?>(value: 1, label: '客户 A'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    // Single-select now renders via InputDecorator + Text
    expect(find.text('全部客户'), findsOneWidget);
  });

  testWidgets('UnifiedDropdown multi select only commits on confirm',
      (tester) async {
    Set<dynamic>? committedValue;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: AppSelect<dynamic>(
              value: const <dynamic>{'A'},
              isMultiSelect: true,
              decoration: const InputDecoration(labelText: '标签'),
              options: const [
                AppDropdownOption<String>(value: 'A', label: '标签 A'),
                AppDropdownOption<String>(value: 'B', label: '标签 B'),
              ],
              onChanged: (value) => committedValue = value as Set<dynamic>?,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('标签 A'));
    await tester.pumpAndSettle();

    expect(committedValue, isNull);

    await tester.tap(find.text('标签 B'));
    await tester.pump();

    expect(committedValue, isNull);

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(committedValue, <dynamic>{'A', 'B'});
  });

  testWidgets('WorkOrderMultiSelectField now follows shared multi-select flow',
      (tester) async {
    final selected = <int>{1};
    var changedCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: WorkOrderMultiSelectField(
              items: const [
                WorkOrderOptionItem(1, '工序 A'),
                WorkOrderOptionItem(2, '工序 B'),
              ],
              selected: selected,
              emptyText: '暂无数据',
              placeholder: '请选择工序（可多选）',
              onChanged: () => changedCount += 1,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('工序 A'));
    await tester.pumpAndSettle();

    expect(changedCount, 0);

    await tester.tap(find.text('工序 B'));
    await tester.pump();

    expect(changedCount, 0);

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(selected, <int>{1, 2});
    expect(changedCount, 1);
  });

  testWidgets(
      'ResponsivePaginationBar uses DropdownMenu and tolerates stale page size',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: ResponsivePaginationBar(
            infoText: '第 1 页',
            page: 1,
            pageSize: 30,
            pageSizeOptions: const [10, 20, 50],
            onPageSizeChanged: (_) {},
            onPrev: () {},
            onNext: () {},
            hasPrev: false,
            hasNext: true,
          ),
        ),
      ),
    );

    expect(find.byType(DropdownMenu<int>), findsOneWidget);
  });
}

class _UnifiedDropdownHarness extends StatefulWidget {
  const _UnifiedDropdownHarness();

  @override
  State<_UnifiedDropdownHarness> createState() =>
      _UnifiedDropdownHarnessState();
}

class _UnifiedDropdownHarnessState extends State<_UnifiedDropdownHarness> {
  String? _value = 'pending';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppSelect<String>(
            value: _value,
            decoration: const InputDecoration(labelText: '状态'),
            options: const [
              AppDropdownOption(value: 'pending', label: '待处理'),
              AppDropdownOption(value: 'done', label: '已完成'),
            ],
            onChanged: (_) {},
          ),
        ),
        TextButton(
          key: const ValueKey('change-selection'),
          onPressed: () => setState(() => _value = 'done'),
          child: const Text('change'),
        ),
      ],
    );
  }
}
