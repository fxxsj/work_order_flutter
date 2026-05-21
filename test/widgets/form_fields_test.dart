import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/date_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/radio_group_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/toggle_field.dart';

void main() {
  testWidgets('DateField shows controller value and handles tap',
      (tester) async {
    final controller = TextEditingController(text: '2026-05-21');
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: DateField(
              label: '交付日期',
              controller: controller,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('2026-05-21'), findsOneWidget);

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('ToggleField changes value when enabled', (tester) async {
    var value = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ToggleField(
              label: '启用',
              value: value,
              onChanged: (nextValue) => value = nextValue,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Switch), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(value, isTrue);
  });

  testWidgets('ToggleField ignores taps when disabled', (tester) async {
    var value = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ToggleField(
              label: '启用',
              value: value,
              enabled: false,
              onChanged: (nextValue) => value = nextValue,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch), warnIfMissed: false);
    await tester.pump();

    expect(value, isFalse);
  });

  testWidgets('RadioGroupField only allows enabled options', (tester) async {
    var value = 'draft';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: RadioGroupField<String>(
              label: '状态',
              value: value,
              options: const [
                RadioGroupFieldOption(value: 'draft', label: '草稿'),
                RadioGroupFieldOption(
                  value: 'archived',
                  label: '归档',
                  enabled: false,
                ),
                RadioGroupFieldOption(value: 'active', label: '启用'),
              ],
              onChanged: (nextValue) => value = nextValue,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('归档'), warnIfMissed: false);
    await tester.pump();
    expect(value, 'draft');

    await tester.tap(find.text('启用'));
    await tester.pump();
    expect(value, 'active');
  });
}
