import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/utils/import_export_util.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';
import 'package:work_order_app/src/features/materials/application/material_view_model.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';
import 'package:work_order_app/src/features/materials/presentation/material_edit_page.dart';

class _MockMaterialRepository implements MaterialRepository {
  MaterialItem? createdMaterial;
  MaterialItem? updatedMaterial;

  @override
  Future<MaterialItem> createMaterial(MaterialItem material) async {
    createdMaterial = material;
    return material;
  }

  @override
  Future<void> deleteMaterial(int id) async {}

  @override
  Future<void> exportMaterials() async {}

  @override
  Future<List<MaterialSupplierOption>> getActiveSupplierOptions() async {
    return const [];
  }

  @override
  Future<PageData<MaterialItem>> getMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  }) async {
    return PageData<MaterialItem>(items: const [], total: 0, page: page, pageSize: pageSize);
  }

  @override
  Future<ImportResult> importMaterials(PlatformFile file) async {
    return const ImportResult(successCount: 0, errorCount: 0);
  }

  @override
  Future<MaterialItem> updateMaterial(MaterialItem material) async {
    updatedMaterial = material;
    return material;
  }
}

Widget _buildTestApp({
  required Widget child,
  required MaterialViewModel viewModel,
}) {
  return Provider<AppStorage>.value(
    value: AppStorage(),
    child: ChangeNotifierProvider<MaterialViewModel>.value(
      value: viewModel,
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await StoreUtil.init();
  });

  setUp(() async {
    await StoreUtil.cleanAll();
    final storage = AppStorage();
    await storage.init();
    await storage.write('currentUserInfo', {
      'is_superuser': true,
      'permissions': <String>[],
    });
  });

  group('MaterialEditPage', () {
    late _MockMaterialRepository repository;
    late MaterialViewModel viewModel;

    setUp(() {
      repository = _MockMaterialRepository();
      viewModel = MaterialViewModel(repository);
    });

    testWidgets('新建物料时 isActive 默认启用', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const MaterialEditPage(),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      final enableSwitchFinder = find.descendant(
        of: find.widgetWithText(InputDecorator, '启用'),
        matching: find.byType(Switch),
      );
      final switchWidget = tester.widget<Switch>(enableSwitchFinder);
      expect(switchWidget.value, isTrue);
    });

    testWidgets('编辑停用物料时 isActive 初始为 false', (tester) async {
      final material = MaterialItem(
        id: 1,
        code: 'MAT001',
        name: 'Test Material',
        isActive: false,
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: MaterialEditPage(material: material),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      final enableSwitchFinder = find.descendant(
        of: find.widgetWithText(InputDecorator, '启用'),
        matching: find.byType(Switch),
      );
      final switchWidget = tester.widget<Switch>(enableSwitchFinder);
      expect(switchWidget.value, isFalse);
    });

    testWidgets('编辑启用物料时 isActive 初始为 true', (tester) async {
      final material = MaterialItem(
        id: 1,
        code: 'MAT001',
        name: 'Test Material',
        isActive: true,
      );

      await tester.pumpWidget(
        _buildTestApp(
          child: MaterialEditPage(material: material),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      final enableSwitchFinder = find.descendant(
        of: find.widgetWithText(InputDecorator, '启用'),
        matching: find.byType(Switch),
      );
      final switchWidget = tester.widget<Switch>(enableSwitchFinder);
      expect(switchWidget.value, isTrue);
    });

    testWidgets('切换启用开关改变状态', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const MaterialEditPage(),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      // Find the Switch associated with "启用" label.
      // There are two Switches (启用 and 需要开料), so find by descendant.
      final enableSwitchFinder = find.descendant(
        of: find.widgetWithText(InputDecorator, '启用'),
        matching: find.byType(Switch),
      );
      expect(enableSwitchFinder, findsOneWidget);

      // Initially true
      expect(tester.widget<Switch>(enableSwitchFinder).value, isTrue);

      // Tap the switch to toggle off
      await tester.tap(enableSwitchFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(enableSwitchFinder).value, isFalse);

      // Tap again to toggle on
      await tester.tap(enableSwitchFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(enableSwitchFinder).value, isTrue);
    });

    testWidgets('isActive toggle 单独存在且可交互', (tester) async {
      // Verify both toggles exist
      await tester.pumpWidget(
        _buildTestApp(
          child: const MaterialEditPage(),
          viewModel: viewModel,
        ),
      );
      await tester.pumpAndSettle();

      final enableSwitchFinder = find.descendant(
        of: find.widgetWithText(InputDecorator, '启用'),
        matching: find.byType(Switch),
      );
      final cuttingSwitchFinder = find.descendant(
        of: find.widgetWithText(InputDecorator, '需要开料'),
        matching: find.byType(Switch),
      );

      expect(enableSwitchFinder, findsOneWidget);
      expect(cuttingSwitchFinder, findsOneWidget);

      // They should have independent states
      expect(tester.widget<Switch>(enableSwitchFinder).value, isTrue);
      expect(tester.widget<Switch>(cuttingSwitchFinder).value, isFalse);
    });
  });
}
