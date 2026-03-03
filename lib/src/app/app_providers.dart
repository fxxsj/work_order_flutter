import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:work_order_app/src/core/controllers/app_badge_controller.dart';
import 'package:work_order_app/src/features/notification/application/notification_view_model.dart';
import 'package:work_order_app/src/core/controllers/theme_controller.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/storage/app_storage.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';
import 'package:work_order_app/src/features/auth/data/auth_api.dart';
import 'package:work_order_app/src/features/auth/data/auth_repository_impl.dart';
import 'package:work_order_app/src/features/auth/data/user_api.dart';
import 'package:work_order_app/src/features/auth/domain/auth_repository.dart';

List<SingleChildWidget> buildAppProviders({
  required AppStorage storage,
  required ApiClient apiClient,
  required ThemeController theme,
  required AuthController auth,
  required NotificationViewModel notification,
  required AppBadgeController badge,
}) {
  return [
    Provider.value(value: storage),
    Provider.value(value: apiClient),
    Provider<AuthApi>(create: (context) => AuthApi(context.read<ApiClient>())),
    Provider<UserApi>(create: (context) => UserApi(context.read<ApiClient>())),
    Provider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        context.read<AuthApi>(),
        context.read<UserApi>(),
      ),
    ),
    ChangeNotifierProvider.value(value: auth),
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        context.read<AuthRepository>(),
        context.read<AppStorage>(),
        context.read<AuthController>(),
      ),
    ),
    ChangeNotifierProvider.value(value: theme),
    ChangeNotifierProvider.value(value: notification),
    ChangeNotifierProvider.value(value: badge),
  ];
}
