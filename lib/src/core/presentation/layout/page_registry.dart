import 'package:flutter/widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/features/notification/presentation/widgets/notification_center_view.dart';
import 'package:work_order_app/src/features/auth/presentation/profile_page.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_list_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_list_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_list_page.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_list_page.dart';
import 'package:work_order_app/src/features/departments/presentation/department_list_page.dart';
import 'package:work_order_app/src/features/processes/presentation/process_list_page.dart';
import 'package:work_order_app/src/features/artworks/presentation/artwork_list_page.dart';
import 'package:work_order_app/src/features/dies/presentation/die_list_page.dart';
import 'package:work_order_app/src/features/foiling_plates/presentation/foiling_plate_list_page.dart';
import 'package:work_order_app/src/features/embossing_plates/presentation/embossing_plate_list_page.dart';

Widget? buildFullPage(String id) {
  switch (id) {
    case 'profile':
      return const ProfilePage();
    case 'customers':
      return const CustomerListEntry();
    case 'workorders':
      return const WorkOrderListEntry();
    case 'tasks_list':
      return const TaskListEntry();
    case 'suppliers':
      return const SupplierListEntry();
    case 'departments':
      return const DepartmentListEntry();
    case 'processes':
      return const ProcessListEntry();
    case 'artworks':
      return const ArtworkListEntry();
    case 'dies':
      return const DieListEntry();
    case 'foiling':
      return const FoilingPlateListEntry();
    case 'embossing':
      return const EmbossingPlateListEntry();
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
