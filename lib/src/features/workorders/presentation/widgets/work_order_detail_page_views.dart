import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_approval_view.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_basic_view.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_process_view.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_products_view.dart';

/// 详情页视图模式枚举
enum WorkOrderDetailViewMode {
  basic,
  products,
  process,
  approval,
}

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
    }
  }

  Widget _buildStatusGuide(BuildContext context) {
    final status = detail.approvalStatus ?? '';
    if (status.isEmpty) return const SizedBox.shrink();

    final (icon, color, message) = switch (status) {
      'draft' => (
          Icons.edit_note_outlined,
          const Color(0xFF3B82F6),
          '补齐资料后提交审核',
        ),
      'pending' || 'submitted' => (
          Icons.hourglass_empty,
          const Color(0xFFF59E0B),
          '等待审核，审核通过后自动生成任务',
        ),
      'rejected' => (
          Icons.cancel_outlined,
          const Color(0xFFEF4444),
          rejectionReason?.isNotEmpty == true
              ? '审核退回: $rejectionReason'
              : '审核退回，请修改后重新提交',
        ),
      'approved' || 'in_progress' => (
          Icons.check_circle_outline,
          const Color(0xFF22C55E),
          '任务已分派至部门，主管可继续分派操作员',
        ),
      _ => (null, null, null),
    };

    if (message == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFF3B82F6)).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (color ?? const Color(0xFF3B82F6)).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: color?.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
