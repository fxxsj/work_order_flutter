import 'package:flutter/widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/content_page_types.dart';
import 'package:work_order_app/src/features/notification/presentation/widgets/notification_center_view.dart';
import 'package:work_order_app/src/features/auth/presentation/profile_page.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_list_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_list_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_list_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_operator_center_page.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_supervisor_dashboard_page.dart';
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
import 'package:work_order_app/src/features/notification_admin/presentation/notification_management_page.dart';

final _pages = <String, Widget Function()> {
  'profile': () => const ProfilePage(),
  'customers': () => const CustomerListEntry(),
  'workorders': () => const WorkOrderListEntry(),
  'tasks_list': () => const TaskListEntry(),
  'tasks_rules': () => const TaskAssignmentRuleEntry(),
  'tasks_operator': () => const TaskOperatorCenterEntry(),
  'tasks_supervisor': () => const TaskSupervisorDashboardEntry(),
  'sales_orders': () => const SalesOrderListEntry(),
  'audit_logs': () => const AuditLogListEntry(),
  'products': () => const ProductListEntry(),
  'materials': () => const MaterialListEntry(),
  'product_groups': () => const ProductGroupListEntry(),
  'purchase_orders': () => const PurchaseOrderListEntry(),
  'stocks': () => const ProductStockListEntry(),
  'delivery': () => const DeliveryOrderListEntry(),
  'quality': () => const QualityInspectionListEntry(),
  'invoices': () => const InvoiceListEntry(),
  'payments': () => const PaymentListEntry(),
  'costs': () => const ProductionCostListEntry(),
  'statements': () => const StatementListEntry(),
  'suppliers': () => const SupplierListEntry(),
  'departments': () => const DepartmentListEntry(),
  'processes': () => const ProcessListEntry(),
  'artworks': () => const ArtworkListEntry(),
  'dies': () => const DieListEntry(),
  'foiling': () => const FoilingPlateListEntry(),
  'embossing': () => const EmbossingPlateListEntry(),
  'stock_ins': () => const StockInListEntry(),
  'stock_outs': () => const StockOutListEntry(),
  'cost_centers': () => const CostCenterListEntry(),
  'cost_items': () => const CostItemListEntry(),
  'payment_plans': () => const PaymentPlanListEntry(),
  'process_logs': () => const ProcessLogListEntry(),
  'system_notifications': () => const NotificationManagementPage(),
};

Widget? buildFullPage(String id) => _pages[id]?.call();

ContentBodyBuilder? buildContentBody(String id) {
  if (id == 'notifications') {
    return (context, style) => NotificationCenterView(
          primary: style.primary,
          surface: style.surface,
          accent: style.accent,
          subtleText: style.subtleText,
          borderColor: style.borderColor,
        );
  }
  return null;
}
