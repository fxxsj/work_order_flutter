import 'package:flutter/widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/features/notification/presentation/widgets/notification_center_view.dart';
import 'package:work_order_app/src/features/auth/presentation/profile_page.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_list_page.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_list_page.dart';
import 'package:work_order_app/src/features/departments/presentation/department_list_page.dart';
import 'package:work_order_app/src/features/processes/presentation/process_list_page.dart';

Widget? buildFullPage(String id) {
  switch (id) {
    case 'profile':
      return const ProfilePage();
    case 'customers':
      return const CustomerListEntry();
    case 'suppliers':
      return const SupplierListEntry();
    case 'departments':
      return const DepartmentListEntry();
    case 'processes':
      return const ProcessListEntry();
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
