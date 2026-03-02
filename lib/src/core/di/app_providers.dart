import 'package:provider/provider.dart';
import 'package:work_order_app/api/auth_api.dart';
import 'package:work_order_app/api/user_api.dart';
import 'package:work_order_app/controllers/app_badge_controller.dart';
import 'package:work_order_app/controllers/auth_controller.dart';
import 'package:work_order_app/controllers/notification_controller.dart';
import 'package:work_order_app/controllers/theme_controller.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';

List<SingleChildWidget> buildAppProviders({
  required AppStorage storage,
  required ApiClient apiClient,
  required ThemeController theme,
  required AuthController auth,
  required NotificationController notification,
  required AppBadgeController badge,
}) {
  return [
    Provider.value(value: storage),
    Provider.value(value: apiClient),
    Provider<AuthApi>(create: (context) => AuthApi(context.read<ApiClient>())),
    Provider<UserApi>(create: (context) => UserApi(context.read<ApiClient>())),
    ChangeNotifierProvider.value(value: theme),
    ChangeNotifierProvider.value(value: auth),
    ChangeNotifierProvider.value(value: notification),
    ChangeNotifierProvider.value(value: badge),
  ];
}
