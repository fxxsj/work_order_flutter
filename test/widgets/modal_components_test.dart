import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';

void main() {
  testWidgets('AppModalScaffold renders header, body and split footer actions',
      (tester) async {
    var closed = false;
    var cleared = false;
    var submitted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppModalScaffold(
            title: '选择数据',
            showCloseButton: true,
            leadingActions: [
              TextButton(
                onPressed: () => cleared = true,
                child: const Text('清空'),
              ),
            ],
            actions: [
              TextButton(
                onPressed: () => closed = true,
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => submitted = true,
                child: const Text('确定'),
              ),
            ],
            body: const Text('主体内容'),
          ),
        ),
      ),
    );

    expect(find.text('选择数据'), findsOneWidget);
    expect(find.text('主体内容'), findsOneWidget);
    expect(find.byTooltip('关闭'), findsOneWidget);
    expect(find.text('清空'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
    expect(find.text('确定'), findsOneWidget);

    await tester.tap(find.text('清空'));
    await tester.tap(find.text('取消'));
    await tester.tap(find.text('确定'));

    expect(cleared, isTrue);
    expect(closed, isTrue);
    expect(submitted, isTrue);
  });

  testWidgets('AppDialog returns a result from footer actions', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AppDialog(
                      title: '确认操作',
                      content: const Text('是否继续？'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text('取消'),
                        ),
                        FilledButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          child: const Text('继续'),
                        ),
                      ],
                    ),
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

    expect(find.text('确认操作'), findsOneWidget);
    expect(find.text('是否继续？'), findsOneWidget);

    await tester.tap(find.text('继续'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.text('确认操作'), findsNothing);
  });

  testWidgets('AppModalScaffold stacks footer actions on narrow widths',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(320, 640)),
          child: Scaffold(
            body: SizedBox(
              width: 320,
              child: AppModalScaffold(
                title: '窄屏操作',
                leadingActions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('清空已选条件'),
                  ),
                ],
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('取消操作'),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('确认提交'),
                  ),
                ],
                body: const Text('主体内容'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('清空已选条件'), findsOneWidget);
    expect(find.text('取消操作'), findsOneWidget);
    expect(find.text('确认提交'), findsOneWidget);

    final clearTop = tester.getTopLeft(find.text('清空已选条件')).dy;
    final cancelTop = tester.getTopLeft(find.text('取消操作')).dy;

    expect(cancelTop, greaterThan(clearTop));
  });

  testWidgets('AppFormDialog disables submit while submitting', (tester) async {
    var submitted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppFormDialog(
            title: '编辑',
            formKey: GlobalKey<FormState>(),
            submitting: true,
            submitText: '保存',
            content: const Text('表单内容'),
            onSubmit: () async => submitted = true,
          ),
        ),
      ),
    );

    expect(find.text('编辑'), findsOneWidget);
    expect(find.text('表单内容'), findsOneWidget);
    expect(find.text('保存中...'), findsOneWidget);

    await tester.tap(find.text('保存中...'));
    await tester.pump();

    expect(submitted, isFalse);
  });

  testWidgets('AppActionFormDialog renders risk copy and validates form',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    var submitted = false;

    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppActionFormDialog(
            title: '处理动作',
            formKey: formKey,
            summary: '提交后会影响后续流程',
            impacts: const ['请确认资料完整'],
            auditHint: '处理说明会进入审计记录',
            submitText: '提交处理',
            content: TextFormField(
              controller: controller,
              decoration: const InputDecoration(labelText: '处理说明'),
              validator: (value) =>
                  (value?.trim().isEmpty ?? true) ? '请填写处理说明' : null,
            ),
            onSubmit: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              submitted = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('处理动作'), findsOneWidget);
    expect(find.text('提交后会影响后续流程'), findsOneWidget);
    expect(find.text('请确认资料完整'), findsOneWidget);
    expect(find.text('处理说明会进入审计记录'), findsOneWidget);

    await tester.tap(find.text('提交处理'));
    await tester.pump();

    expect(find.text('请填写处理说明'), findsOneWidget);
    expect(submitted, isFalse);

    await tester.enterText(find.byType(TextFormField), '已确认');
    await tester.tap(find.text('提交处理'));
    await tester.pump();

    expect(submitted, isTrue);
  });

  testWidgets(
      'AppActionFormDialog handles narrow mobile viewport and long copy',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: '已核对');
    var submitted = false;

    addTearDown(controller.dispose);
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => AppActionFormDialog(
                      title: '这是一段很长的动作确认标题用于验证移动端标题不会造成布局溢出',
                      formKey: formKey,
                      summary:
                          '这段说明会出现在移动端窄屏弹窗中，需要在空间有限时保持可读，并且不能挤压底部按钮或造成 RenderFlex overflow。',
                      impacts: const [
                        '第一条影响说明很长，用于覆盖换行、窄屏和滚动容器组合下的稳定性。',
                        '第二条影响说明同样较长，确保多条风险提示不会导致 footer 被推出可交互区域。',
                      ],
                      auditHint: '审计提示也可能较长，应该随正文滚动而不是破坏底部操作区。',
                      submitText: '确认处理',
                      content: TextFormField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: '处理说明'),
                      ),
                      onSubmit: () async {
                        submitted = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
                child: const Text('打开'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('确认处理'), findsOneWidget);

    await tester.drag(
        find.byType(SingleChildScrollView).last, const Offset(0, -220));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确认处理'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('showRiskActionConfirmDialog returns confirmation',
      (tester) async {
    bool? confirmed;

    await _pumpDialogButton(
      tester,
      onPressed: (context) async {
        confirmed = await showRiskActionConfirmDialog(
          context,
          title: '确认删除',
          summary: '删除后不可恢复',
          confirmText: '删除',
          destructive: true,
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text('确认删除'), findsOneWidget);
    expect(find.text('删除后不可恢复'), findsOneWidget);

    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
  });

  testWidgets('showActionDecisionDialog blocks missing required notes',
      (tester) async {
    ActionDecisionResult<void>? result;

    await _pumpDialogButton(
      tester,
      onPressed: (context) async {
        result = await showActionDecisionDialog<void>(
          context,
          title: '处理异常',
          submitText: '提交处理',
          notesLabel: '处理说明',
          requireNotes: true,
          notesErrorText: '请填写处理说明',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('提交处理'));
    await tester.pump();

    expect(find.text('处理异常'), findsOneWidget);
    expect(find.text('请填写处理说明'), findsOneWidget);
    expect(result, isNull);
  });

  testWidgets('showActionDecisionDialog returns notes and extra notes',
      (tester) async {
    ActionDecisionResult<String>? result;

    await _pumpDialogButton(
      tester,
      onPressed: (context) async {
        result = await showActionDecisionDialog<String>(
          context,
          title: '处理异常',
          submitText: '提交处理',
          selectionLabel: '处理方式',
          options: const [
            ActionDecisionOption(value: 'repair', label: '返修'),
          ],
          initialSelection: 'repair',
          notesLabel: '处理说明',
          extraNotesLabel: '补充说明',
        );
      },
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '  已安排返修  ');
    await tester.enterText(fields.at(1), '  明日复检  ');
    await tester.tap(find.text('提交处理'));
    await tester.pumpAndSettle();

    expect(result?.selection, 'repair');
    expect(result?.notes, '已安排返修');
    expect(result?.extraNotes, '明日复检');
  });
}

Future<void> _pumpDialogButton(
  WidgetTester tester, {
  required void Function(BuildContext context) onPressed,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: TextButton(
              onPressed: () => onPressed(context),
              child: const Text('打开'),
            ),
          );
        },
      ),
    ),
  );
}
