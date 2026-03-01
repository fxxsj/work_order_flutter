import 'package:flutter/material.dart';
import 'package:work_order_app/common/app_config.dart';
import 'package:work_order_app/common/app_scroll_behavior.dart';
import 'package:work_order_app/common/http_client.dart';
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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      scrollBehavior: const AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: '新西彩订单管理',
      enableLog: false,
      theme: Utils.getThemeData(),
      darkTheme: Utils.getThemeData(brightness: Brightness.dark),
    );
  }
}
