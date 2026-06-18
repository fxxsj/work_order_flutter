import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/app.dart';
import 'package:work_order_app/src/core/common/app_metadata.dart';
import 'package:work_order_app/src/core/presentation/widgets/offline_banner.dart';
import 'package:work_order_app/src/features/notification/data/notification_api.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification/application/notification_view_model.dart';
import 'package:work_order_app/src/app/app_providers.dart';
import 'package:work_order_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppConfig.init();
    final storage = AppStorage();
    await storage.init();
    final apiClient = ApiClient();
    apiClient.init();
    runApp(MyApp(storage: storage, apiClient: apiClient));
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'main',
        context: ErrorDescription('应用初始化失败'),
      ),
    );
    runApp(_FatalErrorApp(error: error));
  }
}

class _FatalErrorApp extends StatelessWidget {
  const _FatalErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                const Text('应用启动失败，请重启或联系管理员。'),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.storage, required this.apiClient});

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
  late final NotificationViewModel _notificationController;
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
    Future.microtask(() => _authController.ensureValidSession());
    _notificationController = NotificationViewModel(
      _authController,
      NotificationApi(_apiClient),
    )..initialize();
    _appBadgeController = AppBadgeController();
    _router = createAppRouter(_authController);
    _appEventController = AppEventController(_authController, _router)
      ..initialize();
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
            title: AppMetadata.displayName,
            locale: const Locale('zh', 'CN'),
            supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.build(
              brightness: Brightness.light,
              seedColor: theme.seedColor,
            ),
            darkTheme: AppTheme.build(
              brightness: Brightness.dark,
              seedColor: theme.seedColor,
            ),
            themeMode: theme.themeMode,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.linear(theme.fontScale),
                ),
                child: OfflineBanner(
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
