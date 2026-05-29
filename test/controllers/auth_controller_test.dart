import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';

class _FakeApiClient extends ApiClient {
  String? updatedAccess;
  String? updatedRefresh;
  bool clearedTokens = false;

  @override
  void updateTokens(String access, [String? refresh]) {
    updatedAccess = access;
    updatedRefresh = refresh;
  }

  @override
  void clearTokens() {
    clearedTokens = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await StoreUtil.init();
  });

  setUp(() async {
    await StoreUtil.cleanAll();
  });

  test('AuthController stores tokens and updates login state', () async {
    final storage = AppStorage();
    await storage.init();
    final apiClient = _FakeApiClient();
    final controller = AuthController(storage, apiClient)..initialize();

    addTearDown(controller.dispose);

    await controller.handleLogin(
      access: 'access-token',
      refresh: 'refresh-token',
    );

    expect(storage.readAccessToken(), 'access-token');
    expect(storage.readRefreshToken(), 'refresh-token');
    expect(controller.isLoggedIn, isTrue);
    expect(apiClient.updatedAccess, 'access-token');
    expect(apiClient.updatedRefresh, 'refresh-token');

    await storage.write(Constant.KEY_CURRENT_USER_INFO, {
      'permissions': ['workorder.view_workorder'],
    });
    expect(controller.currentUser?['permissions'], [
      'workorder.view_workorder',
    ]);

    await controller.handleLogout();

    expect(storage.readAccessToken(), isNull);
    expect(storage.readRefreshToken(), isNull);
    expect(controller.isLoggedIn, isFalse);
    expect(apiClient.clearedTokens, isTrue);
  });
}
