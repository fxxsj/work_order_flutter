import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_data_sections.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_sections.dart';

/// 基本信息视图：Overview + Traceability + FinanceSummary
class WorkOrderDetailBasicView extends StatelessWidget {
  const WorkOrderDetailBasicView({
    super.key,
    required this.detail,
    required this.statusOptions,
    required this.statusSelection,
    required this.actionLoading,
    required this.onUploadDesignFile,
    required this.onStatusChanged,
    required this.onUpdateStatus,
    required this.buildSection,
    required this.emptyText,
    required this.formatAmount,
  });

  final WorkOrderDetail detail;
  final List<AppDropdownOption<String?>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final VoidCallback? onUploadDesignFile;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onUpdateStatus;
  final Widget Function(String title, Widget child) buildSection;
  final String emptyText;
  final String Function(double? value) formatAmount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(LayoutTokens.sectionSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkOrderDetailOverviewSection(
            detail: detail,
            statusOptions: statusOptions,
            statusSelection: statusSelection,
            actionLoading: actionLoading,
            onUploadDesignFile: onUploadDesignFile,
            onStatusChanged: onStatusChanged,
            onUpdateStatus: onUpdateStatus,
            buildSection: buildSection,
            emptyText: emptyText,
          ),
          SizedBox(height: LayoutTokens.sectionSpacing(context)),
          WorkOrderTraceabilitySection(
            salesOrderSummaries: detail.salesOrderSummaries,
            qualityInspectionSummaries: detail.qualityInspectionSummaries,
            invoiceSummaries: detail.invoiceSummaries,
            onOpenSalesOrder: (item) {
              final id = item.id;
              if (id != null && id > 0) {
                context.go('/sales-orders/$id');
              }
            },
            onOpenSalesOrderPage: () => context.go('/sales-orders'),
            onOpenQualityPage: () => context.go('/inventory/quality'),
            onOpenInvoicePage: () => context.go('/finance/invoices'),
            emptyText: emptyText,
          ),
          SizedBox(height: LayoutTokens.sectionSpacing(context)),
          WorkOrderFinanceSummarySection(
            items: [
              WorkOrderDetailInfoItem(
                '来源订单金额合计',
                formatAmount(detail.salesOrderTotalAmount),
              ),
              WorkOrderDetailInfoItem(
                '已回款合计',
                formatAmount(detail.salesOrderPaidAmount),
              ),
              WorkOrderDetailInfoItem(
                '未回款合计',
                formatAmount(detail.salesOrderUnpaidAmount),
              ),
              WorkOrderDetailInfoItem(
                '已结清订单',
                detail.settledSalesOrderCount?.toString() ?? emptyText,
              ),
              WorkOrderDetailInfoItem(
                '未结清订单',
                detail.unsettledSalesOrderCount?.toString() ?? emptyText,
              ),
              WorkOrderDetailInfoItem(
                '关联发票',
                detail.invoiceCount?.toString() ?? emptyText,
              ),
            ],
            onOpenSalesOrderPage: () => context.go('/sales-orders'),
            onOpenInvoicePage: () => context.go('/finance/invoices'),
            onOpenPaymentPage: () => context.go('/finance/payments'),
          ),
        ],
      ),
    );
  }
}
