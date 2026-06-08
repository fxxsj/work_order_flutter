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
import 'package:work_order_app/src/features/materials/presentation/material_list_page.dart';
import 'package:file_picker/file_picker.dart';

class _MockMaterialRepository implements MaterialRepository {
  bool? lastIsActiveFilter;
  String? lastOrdering;

  @override
  Future<MaterialItem> createMaterial(MaterialItem material) async => material;

  @override
  Future<void> deleteMaterial(int id) async {}

  @override
  Future<void> exportMaterials() async {}

  @override
  Future<List<MaterialSupplierOption>> getActiveSupplierOptions() async => const [];

  @override
  Future<PageData<MaterialItem>> getMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? ordering,
  }) async {
    lastIsActiveFilter = isActive;
    lastOrdering = ordering;
    return PageData<MaterialItem>(
      items: [
        MaterialItem(id: 1, code: 'MAT001', name: 'Material A', isActive: true),
        MaterialItem(id: 2, code: 'MAT002', name: 'Material B', isActive: false),
      ],
      total: 2,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<ImportResult> importMaterials(PlatformFile file) async {
    return const ImportResult(successCount: 0, errorCount: 0);
  }

  @override
  Future<MaterialItem> updateMaterial(MaterialItem material) async => material;
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

  group('MaterialListPage', () {
    late _MockMaterialRepository repository;
    late MaterialViewModel viewModel;

    setUp(() {
      repository = _MockMaterialRepository();
      viewModel = MaterialViewModel(repository);
    });

    testWidgets('渲染列表页并显示物料数据', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const MaterialListPage(),
          viewModel: viewModel,
        ),
      );
      // Trigger initial load
      await viewModel.loadMaterials(resetPage: true);
      await tester.pumpAndSettle();

      // Verify material names appear in the list
      expect(find.text('Material A'), findsWidgets);
      expect(find.text('Material B'), findsWidgets);
    });

    test('isActive filter 默认 null', () {
      expect(viewModel.isActiveFilter, isNull);
    });

    test('setIsActiveFilter 更新筛选并触发加载', () {
      viewModel.setIsActiveFilter(true);
      expect(viewModel.isActiveFilter, isTrue);
      expect(repository.lastIsActiveFilter, isTrue);

      viewModel.setIsActiveFilter(false);
      expect(viewModel.isActiveFilter, isFalse);
      expect(repository.lastIsActiveFilter, isFalse);

      viewModel.setIsActiveFilter(null);
      expect(viewModel.isActiveFilter, isNull);
    });

    test('setOrdering 更新排序并触发加载', () {
      viewModel.setOrdering('name');
      expect(viewModel.ordering, equals('name'));
      expect(repository.lastOrdering, equals('name'));

      viewModel.setOrdering('-stock_quantity');
      expect(viewModel.ordering, equals('-stock_quantity'));
      expect(repository.lastOrdering, equals('-stock_quantity'));
    });

    testWidgets('停用物料在列表中有视觉区分标识', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const MaterialListPage(),
          viewModel: viewModel,
        ),
      );
      await viewModel.loadMaterials(resetPage: true);
      await tester.pumpAndSettle();

      // Status text for active/inactive should be present
      expect(find.text('启用'), findsWidgets);
      expect(find.text('停用'), findsWidgets);
    });
  });
}
