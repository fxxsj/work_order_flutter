import 'package:flutter/widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/features/notification/presentation/widgets/notification_center_view.dart';
import 'package:work_order_app/src/features/auth/presentation/profile_page.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_list_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_list_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_list_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_placeholder_page.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_list_page.dart';
import 'package:work_order_app/src/features/audit_logs/presentation/audit_log_list_page.dart';
import 'package:work_order_app/src/features/products/presentation/product_list_page.dart';
import 'package:work_order_app/src/features/materials/presentation/material_list_page.dart';
import 'package:work_order_app/src/features/product_groups/presentation/product_group_list_page.dart';
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
    case 'tasks_board':
      return const TaskPlaceholderPage(
        title: '部门任务看板',
        description: '对应 Web 端任务看板视图，包含拖拽列与任务卡片操作。',
      );
    case 'tasks_stats':
      return const TaskPlaceholderPage(
        title: '协作统计',
        description: '对应 Web 端协作统计，包含部门负载与任务趋势分析。',
      );
    case 'tasks_history':
      return const TaskPlaceholderPage(
        title: '分派历史',
        description: '对应 Web 端分派历史记录，支持筛选与导出。',
      );
    case 'tasks_rules':
      return const TaskPlaceholderPage(
        title: '分派规则配置',
        description: '对应 Web 端分派规则配置，支持规则列表与编辑。',
      );
    case 'tasks_operator':
      return const TaskPlaceholderPage(
        title: '操作员任务中心',
        description: '对应 Web 端操作员任务中心，包含我的任务与可认领任务。',
      );
    case 'tasks_supervisor':
      return const TaskPlaceholderPage(
        title: '主管看板',
        description: '对应 Web 端主管看板，包含部门负载与异常提醒。',
      );
    case 'sales_orders':
      return const SalesOrderListEntry();
    case 'audit_logs':
      return const AuditLogListEntry();
    case 'products':
      return const ProductListEntry();
    case 'materials':
      return const MaterialListEntry();
    case 'product_groups':
      return const ProductGroupListEntry();
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
