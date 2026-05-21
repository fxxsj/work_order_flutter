import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_dialog.dart';

void main() {
  Future<void> pumpField(
    WidgetTester tester,
    CrudFieldConfig field,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16),
              child: field.build(context),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('tags field adds a tag and updates chips', (tester) async {
    var changedValues = <String>['专色'];

    await pumpField(
      tester,
      CrudFieldConfig.tags(
        label: '其他颜色',
        values: changedValues,
        onChanged: (values) => changedValues = values,
      ),
    );

    await tester.enterText(find.byType(TextField), '金色');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(changedValues, <String>['专色', '金色']);
    expect(find.text('金色'), findsOneWidget);
  });

  testWidgets('checkbox group toggles multiple values', (tester) async {
    var changedValues = <String>{'C'};

    await pumpField(
      tester,
      CrudFieldConfig.checkboxGroup(
        label: 'CMYK',
        options: const [
          AppDropdownOption<dynamic>(value: 'C', label: 'C'),
          AppDropdownOption<dynamic>(value: 'M', label: 'M'),
        ],
        values: changedValues,
        onChanged: (values) => changedValues = values.cast<String>(),
      ),
    );

    await tester.tap(find.text('M'));
    await tester.pump();

    expect(changedValues, <String>{'C', 'M'});
  });

  testWidgets('radio group switches selected option', (tester) async {
    dynamic changedValue = 'cash';

    await pumpField(
      tester,
      CrudFieldConfig.radioGroup(
        label: '收款方式',
        value: changedValue,
        options: const [
          AppDropdownOption<dynamic>(value: 'cash', label: '现金'),
          AppDropdownOption<dynamic>(value: 'transfer', label: '转账'),
        ],
        onChanged: (value) => changedValue = value,
      ),
    );

    await tester.tap(find.text('转账'));
    await tester.pump();

    expect(changedValue, 'transfer');
  });

  testWidgets('file upload field clears existing selection', (tester) async {
    CrudPickedFile? changedValue = CrudPickedFile(
      filename: 'demo.pdf',
      file: MultipartFile.fromBytes([1, 2, 3], filename: 'demo.pdf'),
    );

    await pumpField(
      tester,
      CrudFieldConfig.fileUpload(
        label: '附件',
        value: changedValue,
        allowedExtensions: const ['pdf'],
        fallbackFilename: 'attachment',
        hintText: '请选择文件',
        onChanged: (value) => changedValue = value,
      ),
    );

    expect(find.text('demo.pdf'), findsOneWidget);

    await tester.tap(find.text('清空'));
    await tester.pump();

    expect(changedValue, isNull);
    expect(find.text('请选择文件'), findsOneWidget);
  });

  testWidgets('file upload dialog validates, picks, clears and replaces file',
      (tester) async {
    final picks = <MultipartFile>[
      MultipartFile.fromBytes([1, 2], filename: 'first.pdf'),
      MultipartFile.fromBytes([3, 4], filename: 'second.pdf'),
    ];
    CrudPickedFile? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showFileUploadDialog(
                    context,
                    title: '上传附件',
                    label: '附件',
                    allowedExtensions: const ['pdf', 'jpg'],
                    fallbackFilename: 'fallback.bin',
                    hintText: '请选择附件',
                    picker: ({
                      required allowedExtensions,
                      required fallbackFilename,
                    }) async {
                      expect(allowedExtensions, const ['pdf', 'jpg']);
                      expect(fallbackFilename, 'fallback.bin');
                      return picks.removeAt(0);
                    },
                  );
                },
                child: const Text('打开'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('上传'));
    await tester.pump();

    expect(find.text('请选择文件'), findsOneWidget);
    expect(result, isNull);

    await tester.tap(find.text('选择文件'));
    await tester.pumpAndSettle();

    expect(find.text('first.pdf'), findsOneWidget);

    await tester.tap(find.text('清空'));
    await tester.pump();
    await tester.tap(find.text('上传'));
    await tester.pump();

    expect(find.text('请选择文件'), findsOneWidget);
    expect(result, isNull);

    await tester.tap(find.text('选择文件'));
    await tester.pumpAndSettle();

    expect(find.text('second.pdf'), findsOneWidget);

    await tester.tap(find.text('上传'));
    await tester.pumpAndSettle();

    expect(result?.filename, 'second.pdf');
  });
}
