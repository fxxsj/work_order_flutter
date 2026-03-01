import 'package:flutter/material.dart';
import 'package:work_order_app/common/app_config.dart';
import 'package:work_order_app/common/app_scroll_behavior.dart';
import 'package:work_order_app/common/http_client.dart';
import 'package:work_order_app/controllers/theme_controller.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:work_order_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

Future<void> init() async {
  await AppConfig.init();
  await GetStorage.init();
  HttpClient.init();
  StoreUtil.init();
  final themeController = Get.put(ThemeController());
  themeController.load();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      final seed = themeController.seedColor.value;
      final mode = themeController.themeMode.value;
      final fontScale = themeController.fontScale.value;
      return GetMaterialApp.router(
        routerDelegate: appRouter.routerDelegate,
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
        scrollBehavior: const AppScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: '新西彩订单管理',
        enableLog: false,
        theme: Utils.getThemeData(themeColor: seed, brightness: Brightness.light),
        darkTheme: Utils.getThemeData(themeColor: seed, brightness: Brightness.dark),
        themeMode: mode,
        builder: (context, child) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(textScaler: TextScaler.linear(fontScale)),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    });
  }
}
