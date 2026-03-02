import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/common/app_config.dart';
import 'package:work_order_app/common/app_scroll_behavior.dart';
import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/controllers/auth_controller.dart';
import 'package:work_order_app/controllers/app_event_controller.dart';
import 'package:work_order_app/controllers/notification_controller.dart';
import 'package:work_order_app/controllers/app_badge_controller.dart';
import 'package:work_order_app/controllers/theme_controller.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:work_order_app/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initServices();
  runApp(const MyApp());
}

Future<void> _initServices() async {
  await AppConfig.init();
  await StoreUtil.init();
  HttpClient.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeController _themeController;
  late final AuthController _authController;
  late final NotificationController _notificationController;
  late final AppBadgeController _appBadgeController;
  late final AppEventController _appEventController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController()..load();
    _authController = AuthController()..initialize();
    _notificationController = NotificationController()..initialize();
    _appBadgeController = AppBadgeController();
    _appEventController = AppEventController(_authController)..initialize();
  }

  @override
  void dispose() {
    _appEventController.dispose();
    _notificationController.dispose();
    _themeController.dispose();
    _authController.dispose();
    _appBadgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeController),
        ChangeNotifierProvider.value(value: _authController),
        ChangeNotifierProvider.value(value: _notificationController),
        ChangeNotifierProvider.value(value: _appBadgeController),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp.router(
            routerDelegate: appRouter.routerDelegate,
            routeInformationParser: appRouter.routeInformationParser,
            routeInformationProvider: appRouter.routeInformationProvider,
            scrollBehavior: const AppScrollBehavior(),
            debugShowCheckedModeBanner: false,
            title: '新西彩订单管理',
            theme: Utils.getThemeData(
              themeColor: theme.seedColor,
              brightness: Brightness.light,
            ),
            darkTheme: Utils.getThemeData(
              themeColor: theme.seedColor,
              brightness: Brightness.dark,
            ),
            themeMode: theme.themeMode,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.linear(theme.fontScale),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
