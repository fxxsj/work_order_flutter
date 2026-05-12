import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_mode_toggle.dart';

import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/audit_log_navigation.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/tasks/data/task_list_support_service.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';
import 'package:work_order_app/src/features/tasks/presentation/widgets/task_action_dialogs.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_dialogs.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_page_views.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_print_preview_dialog.dart';
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
  static const double _spacingSm = LayoutTokens.gapSm;
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
  TaskListSupportService? _taskSupportService;

  String? _statusSelection;
  WorkOrderDetailViewMode _viewMode = WorkOrderDetailViewMode.basic;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _taskSupportService ??= TaskListSupportService(context.read<ApiClient>());
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
    } catch (err) {
      if (!mounted) return;
      setState(
          () => _errorMessage = err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
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
      final detail = approved
          ? await viewModel.approveWorkOrder(
              widget.workOrderId,
              comment: comment,
            )
          : await viewModel.rejectWorkOrder(
              widget.workOrderId,
              reason: rejectionReason ?? comment,
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

  Future<void> _handleSubmitApproval() async {
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      final detail = await viewModel.submitApproval(widget.workOrderId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      ToastUtil.showSuccess('已提交审核');
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
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
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<WorkOrderViewModel>();
      await viewModel.markUrgent(widget.workOrderId, reason: reason);
      if (!mounted) return;
      ToastUtil.showSuccess('已标记为紧急订单');
      await _loadDetail();
    } catch (err) {
      ToastUtil.showError('标记失败: $err');
    } finally {
      if (mounted) {
        setState(() => _actionLoading = false);
      }
    }
  }

  Future<void> _handleAssignTask(Task task) async {
    final processId = task.processId;
    if (processId == null) {
      ToastUtil.showError('当前任务缺少工序信息，无法分派');
      return;
    }

    final departments = await _loadAssignableDepartments(processId);
    if (departments == null) return;
    if (!mounted) return;

    await showTaskAssignDialog(
      context,
      task: task,
      departments: departments,
      loadOperators: (value) => _taskSupportService!.loadOperators(value),
      onSubmit: (operatorId, notes) async {
        await _taskSupportService!.assignTask(
          task.id,
          operatorId: operatorId,
          notes: notes,
        );
        ToastUtil.showSuccess('任务已分派');
        await _loadDetail();
      },
    );
  }

  Future<List<TaskDepartmentOption>?> _loadAssignableDepartments(
    int processId,
  ) async {
    try {
      final departments =
          await _taskSupportService!.loadProcessDepartments(processId);
      if (departments.isEmpty) {
        ToastUtil.showError('当前工序未配置负责部门');
        return null;
      }
      return departments;
    } catch (err) {
      ToastUtil.showError('加载工序负责部门失败: $err');
      return null;
    }
  }

  Future<void> _handleUpdateTask(Task task) async {
    await showTaskQuantityDialog(
      context,
      task: task,
      onSubmit: (payload) async {
        await _taskSupportService!.updateQuantity(task.id, payload);
        ToastUtil.showSuccess('已更新任务进度');
        await _loadDetail();
      },
    );
  }

  Future<void> _handleCompleteTask(Task task) async {
    await showTaskCompleteDialog(
      context,
      task: task,
      onSubmit: (payload) async {
        await _taskSupportService!.completeTask(task.id, payload);
        ToastUtil.showSuccess('任务已完成');
        await _loadDetail();
      },
    );
  }

  Widget _buildSection(String title, Widget child) {
    return DetailSectionCard(title: title, child: child);
  }

  Future<void> _showSyncPreviewDialog(WorkOrderDetail detail) async {
    final isSuperuser = PermissionUtil.isSuperuser(context);
    final canSync = isSuperuser && detail.approvalStatus != 'approved';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final statusOptions = const [
      AppDropdownOption<String>(value: 'pending', label: '待开始'),
      AppDropdownOption<String>(value: 'in_progress', label: '进行中'),
      AppDropdownOption<String>(value: 'paused', label: '已暂停'),
      AppDropdownOption<String>(value: 'completed', label: '已完成'),
      AppDropdownOption<String>(value: 'cancelled', label: '已取消'),
    ];

    return ListPageScaffold(
      spacing: sectionSpacing,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: LayoutBuilder(
          builder: (context, constraints) {
            final actions = <Widget>[
              PageActionButton.outlined(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: '返回',
              ),
              PageModeToggle<WorkOrderDetailViewMode>(
                value: _viewMode,
                minWidth: isMobile ? 72 : 88,
                options: const [
                  PageModeOption(
                    value: WorkOrderDetailViewMode.basic,
                    label: '基本信息',
                  ),
                  PageModeOption(
                    value: WorkOrderDetailViewMode.products,
                    label: '产品物料',
                  ),
                  PageModeOption(
                    value: WorkOrderDetailViewMode.process,
                    label: '工序进度',
                  ),
                  PageModeOption(
                    value: WorkOrderDetailViewMode.approval,
                    label: '审批流程',
                  ),
                ],
                onChanged: (value) => setState(() => _viewMode = value),
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
              PageActionButton.outlined(
                onPressed: detail == null
                    ? null
                    : () => showWorkOrderPrintPreviewDialog(
                          context,
                          detail: detail,
                        ),
                icon: const Icon(Icons.print_outlined, size: 16),
                label: '打印预览',
              ),
              if (canDeleteWorkOrder)
                PageActionButton.outlined(
                  onPressed: _actionLoading ? null : _confirmDelete,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  square: true,
                ),
            ];

            return ListToolbar(
              isMobile: isMobile,
              actions: actions,
              spacing: _spacingSm,
            );
          },
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
                          SpacingTokens.vMd,
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
                  : WorkOrderDetailPageViews(
                      viewMode: _viewMode,
                      detail: detail,
                      statusOptions: statusOptions,
                      statusSelection: _statusSelection,
                      actionLoading: _actionLoading,
                      onUploadDesignFile:
                          canChangeWorkOrder ? _handleUploadDesignFile : null,
                      onStatusChanged: canChangeWorkOrder
                          ? (value) => setState(() => _statusSelection = value)
                          : null,
                      onUpdateStatus:
                          canChangeWorkOrder ? _handleUpdateStatus : null,
                      onSubmitApproval: _handleSubmitApproval,
                      onApprove: canChangeWorkOrder
                          ? () => _showApproveDialog(approved: true)
                          : null,
                      onReject: canChangeWorkOrder
                          ? () => _showApproveDialog(approved: false)
                          : null,
                      onResubmit: canChangeWorkOrder ? _handleResubmit : null,
                      onMarkUrgent: _markUrgent,
                      onAssignTask: _handleAssignTask,
                      onUpdateTask: _handleUpdateTask,
                      onCompleteTask: _handleCompleteTask,
                      onSyncPreview: _showSyncPreviewDialog,
                      emptyText: _emptyText,
                      formatDate: _formatDate,
                      formatAmount: _formatAmount,
                      formatDateTime: _formatDateTime,
                      rejectionReason: _workOrderRejectionReason,
                      rejectionComment: _workOrderRejectionComment,
                      onEditPressed: canChangeWorkOrder
                          ? () => context
                              .go('/workorders/${widget.workOrderId}/edit')
                          : null,
                      buildSection: _buildSection,
                    ),
    );
  }
}
