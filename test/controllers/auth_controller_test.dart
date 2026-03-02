import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:work_order_app/common/app_events.dart';
import 'package:work_order_app/controllers/auth_controller.dart';
import 'package:work_order_app/utils/store_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await GetStorage.init();
  });

  setUp(() {
    StoreUtil.clearTokens();
  });

  test('AuthController emits auth change events and stores tokens', () async {
    final controller = AuthController();
    final events = <AuthChangedEvent>[];
    final sub = AppEvents.stream.listen((event) {
      if (event is AuthChangedEvent) {
        events.add(event);
      }
    });

    controller.handleLogin(access: 'access-token', refresh: 'refresh-token');

    expect(StoreUtil.readAccessToken(), 'access-token');
    expect(controller.isLoggedIn.value, isTrue);
    expect(events.last.loggedIn, isTrue);

    controller.handleLogout();

    expect(StoreUtil.readAccessToken(), isNull);
    expect(controller.isLoggedIn.value, isFalse);
    expect(events.last.loggedIn, isFalse);

    await sub.cancel();
  });
}
