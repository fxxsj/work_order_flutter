import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/viewmodels/base_view_model.dart';

/// 测试用 ViewModel - 测试 BaseViewModel 的公共 API 行为
class TestViewModel extends BaseViewModel {
  int callCount = 0;
  bool shouldFail = false;

  /// 包装 runAsync 的公共方法
  Future<int?> executeAction() async {
    return runAsync(() async {
      callCount++;
      if (shouldFail) {
        throw Exception('Test error');
      }
      return 42;
    });
  }
}

void main() {
  group('BaseViewModel', () {
    group('initial state', () {
      late TestViewModel viewModel;

      setUp(() {
        viewModel = TestViewModel();
      });

      tearDown(() {
        try {
          viewModel.dispose();
        } catch (_) {}
      });

      test('loading is false', () {
        expect(viewModel.loading, isFalse);
      });

      test('errorMessage is null', () {
        expect(viewModel.errorMessage, isNull);
      });

      test('hasError is false', () {
        expect(viewModel.hasError, isFalse);
      });
    });

    group('setLoading', () {
      late TestViewModel viewModel;

      setUp(() {
        viewModel = TestViewModel();
      });

      tearDown(() {
        try {
          viewModel.dispose();
        } catch (_) {}
      });

      test('setLoading(true) sets loading to true', () {
        viewModel.setLoading(true);
        expect(viewModel.loading, isTrue);
      });

      test('setLoading(false) sets loading to false', () {
        viewModel.setLoading(true);
        viewModel.setLoading(false);
        expect(viewModel.loading, isFalse);
      });
    });

    group('error handling via runAsync', () {
      late TestViewModel viewModel;

      setUp(() {
        viewModel = TestViewModel();
      });

      tearDown(() {
        try {
          viewModel.dispose();
        } catch (_) {}
      });

      test('loading state during async action', () async {
        var loadingDuringAction = false;
        viewModel.addListener(() {
          if (viewModel.loading) loadingDuringAction = true;
        });

        await viewModel.executeAction();
        expect(loadingDuringAction, isTrue);
      });

      test('loading is false after successful action', () async {
        await viewModel.executeAction();
        expect(viewModel.loading, isFalse);
      });

      test('error is set when action fails', () async {
        viewModel.shouldFail = true;
        await viewModel.executeAction();
        expect(viewModel.hasError, isTrue);
        expect(viewModel.errorMessage, contains('Test error'));
      });

      test('loading is false after failed action', () async {
        viewModel.shouldFail = true;
        await viewModel.executeAction();
        expect(viewModel.loading, isFalse);
      });

      test('error message strips Exception prefix', () async {
        viewModel.shouldFail = true;
        await viewModel.executeAction();
        expect(viewModel.errorMessage, isNot(contains('Exception: Exception')));
      });
    });

    group('safeNotify', () {
      test('notifies listeners when not disposed', () {
        final vm = TestViewModel();
        var notified = false;
        vm.addListener(() => notified = true);
        vm.safeNotify();
        expect(notified, isTrue);
        vm.dispose();
      });
    });

    group('result handling', () {
      late TestViewModel viewModel;

      setUp(() {
        viewModel = TestViewModel();
      });

      tearDown(() {
        try {
          viewModel.dispose();
        } catch (_) {}
      });

      test('successful action returns result', () async {
        final result = await viewModel.executeAction();
        expect(result, equals(42));
        expect(viewModel.callCount, equals(1));
      });

      test('failed action returns null', () async {
        viewModel.shouldFail = true;
        final result = await viewModel.executeAction();
        expect(result, isNull);
      });
    });
  });
}