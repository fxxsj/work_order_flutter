import 'package:flutter/widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/features/notification/presentation/widgets/notification_center_view.dart';
import 'package:work_order_app/src/features/auth/presentation/profile_page.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_list_page.dart';

Widget? buildFullPage(String id) {
  switch (id) {
    case 'profile':
      return const ProfilePage();
    case 'customers':
      return const CustomerListEntry();
    default:
      return null;
  }
}

ContentBodyBuilder? buildContentBody(String id) {
  switch (id) {
    case 'notifications':
      return (context, style) => NotificationCenterView(
            primary: style.primary,
            surface: style.surface,
            accent: style.accent,
            subtleText: style.subtleText,
            borderColor: style.borderColor,
          );
    default:
      return null;
  }
}
