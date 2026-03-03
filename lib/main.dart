import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/app.dart';
import 'package:work_order_app/src/features/notification/data/notification_api.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification/application/notification_controller.dart';
import 'package:work_order_app/src/core/di/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  final storage = AppStorage();
  await storage.init();
  final apiClient = ApiClient();
  apiClient.init();
  runApp(MyApp(storage: storage, apiClient: apiClient));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.storage,
    required this.apiClient,
  });

  final AppStorage storage;
  final ApiClient apiClient;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppStorage _storage;
  late final ApiClient _apiClient;
  late final ThemeController _themeController;
  late final AuthController _authController;
  late final NotificationController _notificationController;
  late final AppBadgeController _appBadgeController;
  late final AppEventController _appEventController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _storage = widget.storage;
    _apiClient = widget.apiClient;
    _themeController = ThemeController(_storage)..load();
    _authController = AuthController(_storage, _apiClient)..initialize();
    _notificationController = NotificationController(
      _authController,
      NotificationApi(_apiClient),
    )..initialize();
    _appBadgeController = AppBadgeController();
    _router = createAppRouter(_authController);
    _appEventController = AppEventController(_authController, _router)..initialize();
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
      providers: buildAppProviders(
        storage: _storage,
        apiClient: _apiClient,
        theme: _themeController,
        auth: _authController,
        notification: _notificationController,
        badge: _appBadgeController,
      ),
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp.router(
            routerDelegate: _router.routerDelegate,
            routeInformationParser: _router.routeInformationParser,
            routeInformationProvider: _router.routeInformationProvider,
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
