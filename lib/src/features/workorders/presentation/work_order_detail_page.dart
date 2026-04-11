import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/audit_log_navigation.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_data_sections.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_dialogs.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_sections.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_sync_preview_dialog.dart';

class WorkOrderDetailEntry extends StatelessWidget {
  const WorkOrderDetailEntry({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<WorkOrderApiService, WorkOrderRepository,
        WorkOrderViewModel>(
      createService: (context) =>
          WorkOrderApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          WorkOrderRepositoryImpl(context.read<WorkOrderApiService>()),
      createViewModel: (context) =>
          WorkOrderViewModel(context.read<WorkOrderRepository>()),
      child: WorkOrderDetailPage(workOrderId: workOrderId),
    );
  }
}

class WorkOrderDetailPage extends StatefulWidget {
  const WorkOrderDetailPage({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  State<WorkOrderDetailPage> createState() => _WorkOrderDetailPageState();
}

class _WorkOrderDetailPageState extends State<WorkOrderDetailPage> {
  static const String _emptyText = '-';
  static const String _deleteDialogTitle = '确认删除';
  static const List<String> _designFileExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
    'ai',
    'psd',
    'cdr',
    'svg',
  ];

  WorkOrderDetail? _detail;
  bool _loading = false;
  String? _errorMessage;
  bool _initialized = false;
  bool _actionLoading = false;
  bool _approvalLoading = false;
  bool _approvalActionLoading = false;
  String? _approvalErrorMessage;
  Map<String, dynamic>? _approvalStatus;

  String? _statusSelection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.fetchDetail(widget.workOrderId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      await _loadApprovalStatus();
    } catch (err) {
      if (!mounted) return;
      setState(
          () => _errorMessage = err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadApprovalStatus() async {
    setState(() {
      _approvalLoading = true;
      _approvalErrorMessage = null;
    });
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final payload = await viewModel.fetchApprovalStatus(widget.workOrderId);
      if (!mounted) return;
      setState(() {
        _approvalStatus = payload;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() => _approvalErrorMessage =
          err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _approvalLoading = false);
    }
  }

  Future<void> _confirmDelete() async {
    final detail = _detail;
    if (detail == null) return;
    final confirmed = await showWorkOrderDeleteConfirmDialog(
      context,
      title: _deleteDialogTitle,
      number: detail.orderNumber,
      customerName: detail.customerName,
    );
    if (!confirmed) return;
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      await viewModel.deleteWorkOrder(widget.workOrderId);
      if (!mounted) return;
      ToastUtil.showSuccess('施工单已删除');
      context.pop();
    } catch (err) {
      ToastUtil.showError('删除失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _handleUpdateStatus() async {
    final status = _statusSelection;
    if (status == null || status.isEmpty) {
      ToastUtil.showError('请选择状态');
      return;
    }
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.updateStatus(widget.workOrderId, status);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      ToastUtil.showSuccess('状态已更新');
    } catch (err) {
      ToastUtil.showError('更新状态失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _handleUploadDesignFile() async {
    final pickedFile = await showFileUploadDialog(
      context,
      title: '上传设计文件',
      label: '设计文件',
      allowedExtensions: _designFileExtensions,
      fallbackFilename: 'design-file',
      helperText: '支持 PDF、AI、PSD、CDR、SVG 和常见图片格式',
      submitText: '上传',
    );
    final designFile = pickedFile?.file;
    if (designFile == null) {
      return;
    }

    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail =
          await viewModel.uploadDesignFile(widget.workOrderId, designFile);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      ToastUtil.showSuccess('设计文件已上传');
    } catch (err) {
      ToastUtil.showError('上传设计文件失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _handleApprove({
    required bool approved,
    required String comment,
    String? rejectionReason,
  }) async {
    if (!approved && (rejectionReason == null || rejectionReason.isEmpty)) {
      ToastUtil.showError('请填写拒绝原因');
      return;
    }
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.approve(
        id: widget.workOrderId,
        approvalStatus: approved ? 'approved' : 'rejected',
        approvalComment: comment,
        rejectionReason: rejectionReason,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      ToastUtil.showSuccess(approved ? '审核已通过' : '审核已拒绝');
    } catch (err) {
      ToastUtil.showError('审核失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _handleResubmit() async {
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.resubmitForApproval(widget.workOrderId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      ToastUtil.showSuccess('已按退回意见重新提交审核');
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _handleRequestReapproval(String reason) async {
    if (reason.isEmpty) {
      ToastUtil.showError('请填写重新审核原因');
      return;
    }
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail =
          await viewModel.requestReapproval(widget.workOrderId, reason);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      ToastUtil.showSuccess('已请求重新审核');
    } catch (err) {
      ToastUtil.showError('请求失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _showApproveDialog({required bool approved}) async {
    final result = await showWorkOrderApprovalDialog(
      context,
      approved: approved,
    );
    if (result == null) return;
    await _handleApprove(
      approved: approved,
      comment: result.comment,
      rejectionReason: result.rejectionReason,
    );
  }

  Future<void> _showReapprovalDialog() async {
    final reason = await showWorkOrderReasonDialog(
      context,
      title: '请求重新审核',
      label: '原因说明',
    );
    if (reason == null) return;
    await _handleRequestReapproval(reason);
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyText;
    return value.toStringAsFixed(2);
  }

  String _formatDateTime(dynamic value) {
    if (value == null) return _emptyText;
    if (value is DateTime) {
      final local = value.toLocal();
      final date = _formatDate(local);
      final hour = local.hour.toString().padLeft(2, '0');
      final minute = local.minute.toString().padLeft(2, '0');
      return '$date $hour:$minute';
    }
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed == null ? value : _formatDateTime(parsed);
    }
    return value.toString();
  }

  bool get _hasMultiApproval {
    final total = _approvalStatus?['total_steps'];
    final value = total is int ? total : int.tryParse(total?.toString() ?? '');
    return value != null && value > 0;
  }

  String _formatPercentage(dynamic value) {
    if (value == null) return _emptyText;
    if (value is num) return '${value.toStringAsFixed(0)}%';
    final parsed = double.tryParse(value.toString());
    if (parsed == null) return _emptyText;
    return '${parsed.toStringAsFixed(0)}%';
  }

  String? get _workOrderRejectionReason {
    final direct = _detail?.rejectionReason?.trim() ?? '';
    if (direct.isNotEmpty) {
      return direct;
    }
    for (final log in _detail?.approvalLogs ?? const <WorkOrderApprovalLog>[]) {
      final reason = log.rejectionReason?.trim() ?? '';
      if (reason.isNotEmpty) {
        return reason;
      }
    }
    return null;
  }

  String? get _workOrderRejectionComment {
    final direct = _detail?.approvalComment?.trim() ?? '';
    if (direct.isNotEmpty) {
      return direct;
    }
    for (final log in _detail?.approvalLogs ?? const <WorkOrderApprovalLog>[]) {
      final comment = log.approvalComment?.trim() ?? '';
      if (comment.isNotEmpty) {
        return comment;
      }
    }
    return null;
  }

  Future<void> _submitMultiApproval() async {
    setState(() => _approvalActionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      await viewModel.submitMultiApproval(widget.workOrderId);
      if (!mounted) return;
      ToastUtil.showSuccess('已提交多级审批');
      await _loadDetail();
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    } finally {
      if (mounted) setState(() => _approvalActionLoading = false);
    }
  }

  Future<void> _startApprovalStep(int stepId) async {
    setState(() => _approvalActionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      await viewModel.startApprovalStep(stepId);
      if (!mounted) return;
      ToastUtil.showSuccess('步骤已开始');
      await _loadApprovalStatus();
    } catch (err) {
      ToastUtil.showError('开始失败: $err');
    } finally {
      if (mounted) setState(() => _approvalActionLoading = false);
    }
  }

  Future<void> _completeApprovalStep(
    int stepId, {
    required String decision,
    String? comments,
  }) async {
    setState(() => _approvalActionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      await viewModel.completeApprovalStep(
        stepId,
        decision: decision,
        comments: comments,
      );
      if (!mounted) return;
      ToastUtil.showSuccess('步骤已完成');
      await _loadDetail();
    } catch (err) {
      ToastUtil.showError('完成失败: $err');
    } finally {
      if (mounted) setState(() => _approvalActionLoading = false);
    }
  }

  Future<void> _escalateApprovalStep(
    int stepId, {
    required String reason,
    int? toStepId,
  }) async {
    setState(() => _approvalActionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      await viewModel.escalateApprovalStep(
        stepId,
        reason: reason,
        toStepId: toStepId,
      );
      if (!mounted) return;
      ToastUtil.showSuccess('已上报审批步骤');
      await _loadApprovalStatus();
    } catch (err) {
      ToastUtil.showError('上报失败: $err');
    } finally {
      if (mounted) setState(() => _approvalActionLoading = false);
    }
  }

  Future<void> _markUrgent() async {
    final reason = await showWorkOrderReasonDialog(
      context,
      title: '标记紧急订单',
      label: '紧急原因',
    );
    if (reason == null) return;
    if (reason.isEmpty) {
      ToastUtil.showError('请输入紧急原因');
      return;
    }
    setState(() => _approvalActionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      await viewModel.markUrgent(widget.workOrderId, reason: reason);
      if (!mounted) return;
      ToastUtil.showSuccess('已标记为紧急订单');
      await _loadDetail();
    } catch (err) {
      ToastUtil.showError('标记失败: $err');
    } finally {
      if (mounted) setState(() => _approvalActionLoading = false);
    }
  }

  Future<void> _showCompleteStepDialog({
    required int stepId,
    required String decision,
  }) async {
    final comments = await showWorkOrderApprovalStepDialog(
      context,
      decision: decision,
    );
    if (comments == null) return;
    await _completeApprovalStep(
      stepId,
      decision: decision,
      comments: comments,
    );
  }

  Future<void> _showEscalateDialog(int stepId) async {
    final result = await showWorkOrderEscalateDialog(context);
    if (result == null) return;
    if (result.reason.isEmpty) {
      ToastUtil.showError('请输入上报原因');
      return;
    }
    await _escalateApprovalStep(
      stepId,
      reason: result.reason,
      toStepId: result.targetStepId,
    );
  }

  Widget _buildSection(String title, Widget child) {
    return DetailSectionCard(title: title, child: child);
  }

  Future<void> _showSyncPreviewDialog(WorkOrderDetail detail) async {
    final canSync = detail.approvalStatus != 'approved';
    await showWorkOrderSyncPreviewDialog(
      context,
      canSync: canSync,
      processes: detail.processes,
      emptyText: _emptyText,
      loadPreview: (selectedIds) async {
        try {
          final api = context.read<WorkOrderApiService>();
          final result = await api.syncTasksPreview(
            detail.id,
            processIds: selectedIds,
          );
          return WorkOrderSyncPreviewResult(
            preview: _extractPreview(result),
          );
        } catch (err) {
          if (err is ApiException) {
            final previewData = _extractPreview(err.data);
            if (previewData != null) {
              return WorkOrderSyncPreviewResult(
                preview: previewData,
                warningMessage: err.message,
              );
            }
            ToastUtil.showError('获取预览失败: ${err.message}');
            return const WorkOrderSyncPreviewResult(preview: null);
          }
          ToastUtil.showError('获取预览失败: $err');
          return const WorkOrderSyncPreviewResult(preview: null);
        }
      },
      executeSync: (selectedIds) async {
        try {
          final api = context.read<WorkOrderApiService>();
          final result = await api.syncTasksExecute(
            detail.id,
            processIds: selectedIds,
          );
          final payload = _unwrapApiData(result);
          final message = payload['message']?.toString() ??
              (payload['result'] is Map
                  ? payload['result']['message']?.toString()
                  : null) ??
              '任务同步完成';
          ToastUtil.showSuccess(message);
          if (mounted) {
            await _loadDetail();
          }
        } catch (err) {
          if (err is ApiException) {
            ToastUtil.showError('同步失败: ${err.message}');
          } else {
            ToastUtil.showError('同步失败: $err');
          }
          rethrow;
        }
      },
      formatProcessNames: _formatProcessNames,
    );
  }

  Map<String, dynamic>? _extractPreview(dynamic payload) {
    final data = _unwrapApiData(payload);
    if (data.isEmpty) return null;
    final preview = data['preview'];
    if (preview is Map<String, dynamic>) {
      return preview;
    }
    if (data.containsKey('tasks_to_remove') ||
        data.containsKey('tasks_to_add')) {
      return data;
    }
    return null;
  }

  Map<String, dynamic> _unwrapApiData(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data);
      }
      return Map<String, dynamic>.from(payload);
    }
    return {};
  }

  String _formatProcessNames(
    List<int> ids,
    Map<int, WorkOrderProcessItem> processMap,
  ) {
    if (ids.isEmpty) return _emptyText;
    final names =
        ids.map((id) => processMap[id]?.processName ?? '工序#$id').toList();
    return names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final permissions = PermissionUtil.snapshot(context);
    final canChangeWorkOrder = permissions.has('workorder.change_workorder');
    final canDeleteWorkOrder = permissions.has('workorder.delete_workorder');
    final canViewAudit = AuditLogNavigation.canView(context);

    final statusOptions = const [
      DropdownOption(value: 'pending', label: '待开始'),
      DropdownOption(value: 'in_progress', label: '进行中'),
      DropdownOption(value: 'paused', label: '已暂停'),
      DropdownOption(value: 'completed', label: '已完成'),
      DropdownOption(value: 'cancelled', label: '已取消'),
    ];

    return ListPageScaffold(
      spacing: sectionSpacing,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: Wrap(
          spacing: sectionSpacing,
          runSpacing: 8,
          children: [
            PageActionButton.outlined(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: '返回',
            ),
            PageActionButton.filled(
              onPressed: canChangeWorkOrder
                  ? () => context.go('/workorders/${widget.workOrderId}/edit')
                  : null,
              icon: const Icon(Icons.edit, size: 16),
              label: '编辑',
            ),
            if (canViewAudit &&
                (detail?.orderNumber.trim().isNotEmpty ?? false))
              PageActionButton.outlined(
                onPressed: () => AuditLogNavigation.open(
                  context,
                  keyword: detail!.orderNumber,
                ),
                icon: const Icon(Icons.history_outlined, size: 16),
                label: '相关审计',
              ),
            if (canDeleteWorkOrder)
              PageActionButton.outlined(
                onPressed: _actionLoading ? null : _confirmDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                square: true,
              ),
          ],
        ),
      ),
      body: _loading
          ? const DetailSurfaceCard(
              child: Center(child: CircularProgressIndicator()),
            )
          : _errorMessage != null
              ? DetailSurfaceCard(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_errorMessage!),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _loadDetail,
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : detail == null
                  ? const DetailSurfaceCard(
                      child: Center(child: Text('未找到施工单信息')),
                    )
                  : ListView(
                      children: [
                        WorkOrderDetailOverviewSection(
                          detail: detail,
                          statusOptions: statusOptions,
                          statusSelection: _statusSelection,
                          actionLoading: _actionLoading,
                          onUploadDesignFile: canChangeWorkOrder
                              ? _handleUploadDesignFile
                              : null,
                          hasMultiApproval: _hasMultiApproval,
                          onStatusChanged: canChangeWorkOrder
                              ? (value) =>
                                  setState(() => _statusSelection = value)
                              : null,
                          onUpdateStatus:
                              canChangeWorkOrder ? _handleUpdateStatus : null,
                          onApprove: canChangeWorkOrder
                              ? () => _showApproveDialog(approved: true)
                              : null,
                          onReject: canChangeWorkOrder
                              ? () => _showApproveDialog(approved: false)
                              : null,
                          onResubmit:
                              canChangeWorkOrder ? _handleResubmit : null,
                          onRequestReapproval:
                              canChangeWorkOrder ? _showReapprovalDialog : null,
                          buildSection: _buildSection,
                          emptyText: _emptyText,
                        ),
                        if ((detail.approvalStatus ?? '') == 'rejected' &&
                            ((_workOrderRejectionReason ?? '').isNotEmpty ||
                                (_workOrderRejectionComment ?? '')
                                    .isNotEmpty)) ...[
                          SizedBox(height: sectionSpacing),
                          ApprovalRejectionNoticeCard(
                            reason: _workOrderRejectionReason ?? '请先查看审批说明',
                            comment: _workOrderRejectionComment,
                            nextStep: '根据退回原因补充资料或修改内容后，直接点击“重新提交审核”。',
                            primaryAction: FilledButton.icon(
                              onPressed: canChangeWorkOrder && !_actionLoading
                                  ? _handleResubmit
                                  : null,
                              icon: const Icon(Icons.send_outlined, size: 18),
                              label: const Text('重新提交审核'),
                            ),
                            secondaryAction: OutlinedButton.icon(
                              onPressed: canChangeWorkOrder
                                  ? () => context.go(
                                      '/workorders/${widget.workOrderId}/edit')
                                  : null,
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text('先去修改'),
                            ),
                          ),
                        ],
                        SizedBox(height: sectionSpacing),
                        WorkOrderTraceabilitySection(
                          salesOrderSummaries: detail.salesOrderSummaries,
                          qualityInspectionSummaries:
                              detail.qualityInspectionSummaries,
                          invoiceSummaries: detail.invoiceSummaries,
                          onOpenSalesOrder: (item) {
                            final id = item.id;
                            if (id != null && id > 0) {
                              context.go('/sales-orders/$id');
                            }
                          },
                          onOpenSalesOrderPage: () =>
                              context.go('/sales-orders'),
                          onOpenQualityPage: () =>
                              context.go('/inventory/quality'),
                          onOpenInvoicePage: () =>
                              context.go('/finance/invoices'),
                          emptyText: _emptyText,
                        ),
                        SizedBox(height: sectionSpacing),
                        WorkOrderFinanceSummarySection(
                          items: [
                            WorkOrderDetailInfoItem(
                              '来源订单金额合计',
                              _formatAmount(detail.salesOrderTotalAmount),
                            ),
                            WorkOrderDetailInfoItem(
                              '已回款合计',
                              _formatAmount(detail.salesOrderPaidAmount),
                            ),
                            WorkOrderDetailInfoItem(
                              '未回款合计',
                              _formatAmount(detail.salesOrderUnpaidAmount),
                            ),
                            WorkOrderDetailInfoItem(
                              '已结清订单',
                              detail.settledSalesOrderCount?.toString() ??
                                  _emptyText,
                            ),
                            WorkOrderDetailInfoItem(
                              '未结清订单',
                              detail.unsettledSalesOrderCount?.toString() ??
                                  _emptyText,
                            ),
                            WorkOrderDetailInfoItem(
                              '关联发票',
                              detail.invoiceCount?.toString() ?? _emptyText,
                            ),
                          ],
                          onOpenSalesOrderPage: () =>
                              context.go('/sales-orders'),
                          onOpenInvoicePage: () =>
                              context.go('/finance/invoices'),
                          onOpenPaymentPage: () =>
                              context.go('/finance/payments'),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '多级审批',
                          WorkOrderMultiApprovalSection(
                            detail: detail,
                            approvalLoading: _approvalLoading,
                            approvalActionLoading: _approvalActionLoading,
                            approvalErrorMessage: _approvalErrorMessage,
                            approvalStatus: _approvalStatus,
                            currentUserName:
                                StoreUtil.getCurrentUserInfo().userName,
                            formatPercentage: _formatPercentage,
                            formatDateTime: _formatDateTime,
                            onRetry: _loadApprovalStatus,
                            onSubmitApproval: _submitMultiApproval,
                            onMarkUrgent: _markUrgent,
                            onStartStep: _startApprovalStep,
                            onApproveStep: (stepId) => _showCompleteStepDialog(
                              stepId: stepId,
                              decision: 'approve',
                            ),
                            onRejectStep: (stepId) => _showCompleteStepDialog(
                              stepId: stepId,
                              decision: 'reject',
                            ),
                            onEscalateStep: _showEscalateDialog,
                            emptyText: _emptyText,
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '产品清单',
                          WorkOrderProductsSection(
                            items: detail.products,
                            emptyText: _emptyText,
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        DetailSectionCard(
                          title: '工序进度',
                          trailing: OutlinedButton.icon(
                            onPressed: detail.processes.isEmpty
                                ? null
                                : () => _showSyncPreviewDialog(detail),
                            icon: const Icon(Icons.sync_alt, size: 16),
                            label: const Text('任务同步预览'),
                          ),
                          child: WorkOrderProcessesSection(
                            items: detail.processes,
                            emptyText: _emptyText,
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '工序排程',
                          WorkOrderProcessGanttSection(
                            items: detail.processes,
                            emptyText: _emptyText,
                            formatDateTime: _formatDateTime,
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '物料需求',
                          WorkOrderMaterialsSection(
                            items: detail.materials,
                            emptyText: _emptyText,
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '审批记录',
                          WorkOrderApprovalLogsSection(
                            logs: detail.approvalLogs,
                            emptyText: _emptyText,
                            formatDate: _formatDate,
                          ),
                        ),
                      ],
                    ),
    );
  }
}
