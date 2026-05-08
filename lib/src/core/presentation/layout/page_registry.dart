import 'package:flutter/widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/features/notification/presentation/widgets/notification_center_view.dart';
import 'package:work_order_app/src/features/auth/presentation/profile_page.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_list_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_list_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_list_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_board_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_operator_center_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_supervisor_dashboard_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_stats_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_assignment_history_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_assignment_rule_page.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/sales_order_list_page.dart';
import 'package:work_order_app/src/features/audit_logs/presentation/audit_log_list_page.dart';
import 'package:work_order_app/src/features/products/presentation/product_list_page.dart';
import 'package:work_order_app/src/features/materials/presentation/material_list_page.dart';
import 'package:work_order_app/src/features/product_groups/presentation/product_group_list_page.dart';
import 'package:work_order_app/src/features/purchase_orders/presentation/purchase_order_list_page.dart';
import 'package:work_order_app/src/features/inventory_stocks/presentation/product_stock_list_page.dart';
import 'package:work_order_app/src/features/inventory_delivery/presentation/delivery_order_list_page.dart';
import 'package:work_order_app/src/features/inventory_quality/presentation/quality_inspection_list_page.dart';
import 'package:work_order_app/src/features/finance_invoices/presentation/invoice_list_page.dart';
import 'package:work_order_app/src/features/finance_payments/presentation/payment_list_page.dart';
import 'package:work_order_app/src/features/finance_costs/presentation/production_cost_list_page.dart';
import 'package:work_order_app/src/features/finance_statements/presentation/statement_list_page.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_list_page.dart';
import 'package:work_order_app/src/features/departments/presentation/department_list_page.dart';
import 'package:work_order_app/src/features/processes/presentation/process_list_page.dart';
import 'package:work_order_app/src/features/artworks/presentation/artwork_list_page.dart';
import 'package:work_order_app/src/features/dies/presentation/die_list_page.dart';
import 'package:work_order_app/src/features/foiling_plates/presentation/foiling_plate_list_page.dart';
import 'package:work_order_app/src/features/embossing_plates/presentation/embossing_plate_list_page.dart';
import 'package:work_order_app/src/features/stock_in/presentation/stock_in_list_page.dart';
import 'package:work_order_app/src/features/stock_out/presentation/stock_out_list_page.dart';
import 'package:work_order_app/src/features/finance_costs/presentation/cost_center_list_page.dart';
import 'package:work_order_app/src/features/finance_costs/presentation/cost_item_list_page.dart';
import 'package:work_order_app/src/features/finance_payments/presentation/payment_plan_list_page.dart';
import 'package:work_order_app/src/features/processes/presentation/process_log_list_page.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/system_notification_page.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/user_notification_settings_page.dart';
import 'package:work_order_app/src/features/notification_admin/presentation/notification_template_page.dart';

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
      return const TaskBoardEntry();
    case 'tasks_stats':
      return const TaskStatsEntry();
    case 'tasks_history':
      return const TaskAssignmentHistoryEntry();
    case 'tasks_rules':
      return const TaskAssignmentRuleEntry();
    case 'tasks_operator':
      return const TaskOperatorCenterEntry();
    case 'tasks_supervisor':
      return const TaskSupervisorDashboardEntry();
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
    case 'purchase_orders':
      return const PurchaseOrderListEntry();
    case 'stocks':
      return const ProductStockListEntry();
    case 'delivery':
      return const DeliveryOrderListEntry();
    case 'quality':
      return const QualityInspectionListEntry();
    case 'invoices':
      return const InvoiceListEntry();
    case 'payments':
      return const PaymentListEntry();
    case 'costs':
      return const ProductionCostListEntry();
    case 'statements':
      return const StatementListEntry();
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
    case 'stock_ins':
      return const StockInListEntry();
    case 'stock_outs':
      return const StockOutListEntry();
    case 'cost_centers':
      return const CostCenterListEntry();
    case 'cost_items':
      return const CostItemListEntry();
    case 'payment_plans':
      return const PaymentPlanListEntry();
    case 'process_logs':
      return const ProcessLogListEntry();
    case 'system_notifications':
      return const SystemNotificationPage();
    case 'user_notification_settings':
      return const UserNotificationSettingsPage();
    case 'notification_templates':
      return const NotificationTemplatePage();
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
