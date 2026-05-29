import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/src/core/constants/constant.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await StoreUtil.init();
  });

  setUp(() async {
    await StoreUtil.cleanAll();
  });

  Widget buildTestApp(Widget child) {
    return Provider<AppStorage>.value(
      value: AppStorage(),
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      ),
    );
  }

  group('PermissionUtil', () {
    group('snapshot - isAdmin behavior', () {
      testWidgets('superuser 被识别为 admin', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': true,
          'permissions': <String>[],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(snap.isAdmin, isTrue);
                expect(snap.has('any_permission'), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('拥有通配符 * 权限被识别为 admin', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['*'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(snap.isAdmin, isTrue);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('普通用户不被识别为 admin', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['workorder.view_workorder'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(snap.isAdmin, isFalse);
                expect(snap.has('workorder.view_workorder'), isTrue);
                expect(snap.has('workorder.delete_workorder'), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('空权限用户不能访问普通权限', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': <String>[],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(snap.isAdmin, isFalse);
                expect(snap.has('any_permission'), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('snapshot - has behavior', () {
      testWidgets('用户拥有指定权限时 has 返回 true', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': [
            'workorder.view_workorder',
            'workorder.add_workorder',
          ],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(snap.has('workorder.view_workorder'), isTrue);
                expect(snap.has('workorder.add_workorder'), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('用户不拥有指定权限时 has 返回 false', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['workorder.view_workorder'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(snap.has('workorder.delete_workorder'), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('snapshot - hasAny behavior', () {
      testWidgets('拥有任意一个指定权限时 hasAny 返回 true', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['workorder.view_workorder'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(
                  snap.hasAny([
                    'workorder.view_workorder',
                    'workorder.delete_workorder',
                  ]),
                  isTrue,
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('不拥有任何指定权限时 hasAny 返回 false', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['workorder.view_customer'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(
                  snap.hasAny([
                    'workorder.view_workorder',
                    'workorder.delete_workorder',
                  ]),
                  isFalse,
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('snapshot - 无用户信息时', () {
      testWidgets('返回空权限 snapshot', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, null);

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final snap = PermissionUtil.snapshot(context);
                expect(snap.permissions, isEmpty);
                expect(snap.isSuperuser, isFalse);
                expect(snap.has('workorder.view_workorder'), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('hasPermission', () {
      testWidgets('返回 snapshot.has 的结果', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['workorder.view_workorder'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(
                  PermissionUtil.hasPermission(
                    context,
                    'workorder.view_workorder',
                  ),
                  isTrue,
                );
                expect(
                  PermissionUtil.hasPermission(
                    context,
                    'workorder.delete_workorder',
                  ),
                  isFalse,
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('superuser 可以访问任何权限', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': true,
          'permissions': <String>[],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(
                  PermissionUtil.hasPermission(context, 'any_permission'),
                  isTrue,
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('hasAnyPermission', () {
      testWidgets('拥有任意权限时返回 true', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['workorder.view_workorder'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(
                  PermissionUtil.hasAnyPermission(context, [
                    'workorder.view_workorder',
                    'workorder.delete',
                  ]),
                  isTrue,
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('没有任何权限时返回 false', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
          'permissions': ['workorder.view_customer'],
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(
                  PermissionUtil.hasAnyPermission(context, [
                    'workorder.view_workorder',
                    'workorder.delete',
                  ]),
                  isFalse,
                );
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('isSuperuser', () {
      testWidgets('superuser 返回 true', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': true,
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(PermissionUtil.isSuperuser(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('非 superuser 返回 false', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, {
          'is_superuser': false,
        });

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(PermissionUtil.isSuperuser(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('无用户信息时返回 false', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, null);

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(PermissionUtil.isSuperuser(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('currentUser', () {
      testWidgets('返回存储的用户信息', (tester) async {
        final storage = AppStorage();
        await storage.init();
        final userInfo = {
          'id': 1,
          'username': 'testuser',
          'is_superuser': false,
        };
        await storage.write(Constant.KEY_CURRENT_USER_INFO, userInfo);

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                final user = PermissionUtil.currentUser(context);
                expect(user?['username'], equals('testuser'));
                expect(user?['is_superuser'], isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('无用户信息时返回 null', (tester) async {
        final storage = AppStorage();
        await storage.init();
        await storage.write(Constant.KEY_CURRENT_USER_INFO, null);

        await tester.pumpWidget(
          buildTestApp(
            Builder(
              builder: (context) {
                expect(PermissionUtil.currentUser(context), isNull);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });
}
