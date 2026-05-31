import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_approval_view.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_basic_view.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_process_view.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_products_view.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_procurement_view.dart';

/// 详情页视图模式枚举
enum WorkOrderDetailViewMode { basic, products, process, approval, procurement }

/// 详情页视图切换组件
class WorkOrderDetailPageViews extends StatelessWidget {
  const WorkOrderDetailPageViews({
    super.key,
    required this.viewMode,
    required this.detail,
    required this.statusOptions,
    required this.statusSelection,
    required this.actionLoading,
    required this.onUploadDesignFile,
    required this.onStatusChanged,
    required this.onUpdateStatus,
    required this.onSubmitApproval,
    required this.onApprove,
    required this.onReject,
    required this.onResubmit,
    required this.onMarkUrgent,
    required this.onAssignTask,
    required this.onUpdateTask,
    required this.onCompleteTask,
    required this.onSyncPreview,
    required this.canSyncTasks,
    this.onCreatePurchaseOrder,
    this.onViewPurchaseOrder,
    this.onViewPurchaseOrdersList,
    required this.emptyText,
    required this.formatDate,
    required this.formatAmount,
    required this.formatDateTime,
    required this.rejectionReason,
    required this.rejectionComment,
    required this.onEditPressed,
    required this.buildSection,
  });

  final WorkOrderDetailViewMode viewMode;
  final WorkOrderDetail detail;
  final List<AppDropdownOption<String>> statusOptions;
  final String? statusSelection;
  final bool actionLoading;
  final VoidCallback? onUploadDesignFile;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onUpdateStatus;
  final VoidCallback onSubmitApproval;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onResubmit;
  final Future<void> Function() onMarkUrgent;
  final Future<void> Function(Task task) onAssignTask;
  final Future<void> Function(Task task) onUpdateTask;
  final Future<void> Function(Task task) onCompleteTask;
  final Future<void> Function(WorkOrderDetail detail) onSyncPreview;
  final bool canSyncTasks;
  final VoidCallback? onCreatePurchaseOrder;
  final ValueChanged<int>? onViewPurchaseOrder;
  final VoidCallback? onViewPurchaseOrdersList;
  final String emptyText;
  final String Function(DateTime? value) formatDate;
  final String Function(double? value) formatAmount;
  final String Function(dynamic value) formatDateTime;
  final String? rejectionReason;
  final String? rejectionComment;
  final VoidCallback? onEditPressed;
  final Widget Function(String title, Widget child) buildSection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStatusGuide(context),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    switch (viewMode) {
      case WorkOrderDetailViewMode.basic:
        return WorkOrderDetailBasicView(
          detail: detail,
          statusOptions: statusOptions,
          statusSelection: statusSelection,
          actionLoading: actionLoading,
          onUploadDesignFile: onUploadDesignFile,
          onStatusChanged: onStatusChanged,
          onUpdateStatus: onUpdateStatus,
          buildSection: buildSection,
          emptyText: emptyText,
          formatAmount: formatAmount,
        );

      case WorkOrderDetailViewMode.products:
        return WorkOrderDetailProductsView(
          detail: detail,
          buildSection: buildSection,
          emptyText: emptyText,
        );

      case WorkOrderDetailViewMode.process:
        return WorkOrderDetailProcessView(
          detail: detail,
          buildSection: buildSection,
          emptyText: emptyText,
          formatDateTime: formatDateTime,
          onAssignTask: onAssignTask,
          onUpdateTask: onUpdateTask,
          onCompleteTask: onCompleteTask,
          canManageTask: (task) {
            final status = task.status ?? '';
            return status != 'draft' &&
                status != 'completed' &&
                status != 'cancelled';
          },
          onSyncPreview: onSyncPreview,
          canSyncTasks: canSyncTasks,
        );

      case WorkOrderDetailViewMode.approval:
        return WorkOrderDetailApprovalView(
          detail: detail,
          actionLoading: actionLoading,
          onSubmitApproval: onSubmitApproval,
          onApprove: onApprove,
          onReject: onReject,
          onResubmit: onResubmit,
          onMarkUrgent: onMarkUrgent,
          buildSection: buildSection,
          emptyText: emptyText,
          formatDate: formatDate,
          rejectionReason: rejectionReason,
          rejectionComment: rejectionComment,
          onEditPressed: onEditPressed,
        );

      case WorkOrderDetailViewMode.procurement:
        return WorkOrderDetailProcurementView(
          detail: detail,
          buildSection: buildSection,
          emptyText: emptyText,
          onCreatePurchaseOrder: onCreatePurchaseOrder,
          onViewPurchaseOrder: onViewPurchaseOrder,
          onViewPurchaseOrdersList: onViewPurchaseOrdersList,
        );
    }
  }

  Widget _buildStatusGuide(BuildContext context) {
    final status = detail.approvalStatus ?? '';
    if (status.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();

    final (icon, color, message) = switch (status) {
      'draft' => (
        Icons.edit_note_outlined,
        theme.colorScheme.primary,
        '补齐资料后提交审核',
      ),
      'submitted' => (
        Icons.hourglass_empty,
        semantic?.warning ?? theme.colorScheme.secondary,
        '等待审核，审核通过后将自动生成部门任务',
      ),
      'rejected' => (
        Icons.cancel_outlined,
        semantic?.danger ?? theme.colorScheme.error,
        rejectionReason?.isNotEmpty == true
            ? '审核退回: $rejectionReason'
            : '审核退回，请修改后重新提交',
      ),
      'approved' => (
        Icons.check_circle_outline,
        semantic?.success ?? const Color(0xFF27a644),
        '任务已分派至部门，主管可继续分派操作员',
      ),
      _ => (null, null, null),
    };

    if (message == null) return const SizedBox.shrink();

    final effectiveColor = color ?? theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: SpacingTokens.md),
      padding: SpacingTokens.h16v12,
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: OpacityTokens.subtle),
        borderRadius: RadiusTokens.bSm,
        border: Border.all(
          color: effectiveColor.withValues(alpha: OpacityTokens.distinct),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: LayoutTokens.iconLg, color: effectiveColor),
          const SizedBox(width: SpacingTokens.md),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: TextTokens.fontSizeBodyMedium,
                color: effectiveColor.withValues(
                  alpha: OpacityTokens.textProminent,
                ),
                fontWeight: TextTokens.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
