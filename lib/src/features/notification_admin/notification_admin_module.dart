import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/notification_admin/data/notification_admin_repository_impl.dart';
import 'package:work_order_app/src/features/notification_admin/domain/notification_admin_repository.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/notification_management_page.dart';

class NotificationManagementEntry extends StatelessWidget {
  const NotificationManagementEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<NotificationAdminRepository>(
      create: (context) => NotificationAdminRepositoryImpl(
        context.read<ApiClient>(),
      ),
      child: const NotificationManagementPage(),
    );
  }
}
