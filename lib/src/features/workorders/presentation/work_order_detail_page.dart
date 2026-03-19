import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_data_sections.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_detail_sections.dart';

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
  static const String _deleteDialogContent = '确定要删除施工单 "{name}" 吗？此操作不可恢复。';

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

  final TextEditingController _approvalCommentController =
      TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();
  final TextEditingController _reapprovalReasonController =
      TextEditingController();
  final TextEditingController _approvalStepCommentController =
      TextEditingController();
  final TextEditingController _escalationReasonController =
      TextEditingController();
  final TextEditingController _escalationTargetController =
      TextEditingController();
  final TextEditingController _urgentReasonController = TextEditingController();

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

  @override
  void dispose() {
    _approvalCommentController.dispose();
    _rejectionReasonController.dispose();
    _reapprovalReasonController.dispose();
    _approvalStepCommentController.dispose();
    _escalationReasonController.dispose();
    _escalationTargetController.dispose();
    _urgentReasonController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final detail = _detail;
    if (detail == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(
            _deleteDialogContent.replaceFirst('{name}', detail.orderNumber)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('删除')),
        ],
      ),
    );
    if (confirmed != true) return;
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

  Future<void> _handleApprove({required bool approved}) async {
    final rejectionReason =
        approved ? null : _rejectionReasonController.text.trim();
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
        approvalComment: _approvalCommentController.text.trim(),
        rejectionReason: rejectionReason,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _statusSelection = detail.status;
      });
      _approvalCommentController.clear();
      _rejectionReasonController.clear();
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
      ToastUtil.showSuccess('已重新提交审核');
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _handleRequestReapproval() async {
    final reason = _reapprovalReasonController.text.trim();
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
      _reapprovalReasonController.clear();
      ToastUtil.showSuccess('已请求重新审核');
    } catch (err) {
      ToastUtil.showError('请求失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _showApproveDialog({required bool approved}) async {
    _approvalCommentController.clear();
    _rejectionReasonController.clear();
    final title = approved ? '审核通过' : '审核拒绝';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _approvalCommentController,
              decoration: const InputDecoration(labelText: '备注说明'),
              maxLines: 3,
            ),
            if (!approved) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _rejectionReasonController,
                decoration: const InputDecoration(labelText: '拒绝原因'),
                maxLines: 3,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确定')),
        ],
      ),
    );
    if (confirmed == true) {
      await _handleApprove(approved: approved);
    }
  }

  Future<void> _showReapprovalDialog() async {
    _reapprovalReasonController.clear();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('请求重新审核'),
        content: TextField(
          controller: _reapprovalReasonController,
          decoration: const InputDecoration(labelText: '原因说明'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('提交')),
        ],
      ),
    );
    if (confirmed == true) {
      await _handleRequestReapproval();
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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
    _urgentReasonController.clear();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('标记紧急订单'),
        content: TextField(
          controller: _urgentReasonController,
          decoration: const InputDecoration(labelText: '紧急原因'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('提交')),
        ],
      ),
    );
    if (confirmed != true) return;
    final reason = _urgentReasonController.text.trim();
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
    _approvalStepCommentController.clear();
    final decisionLabel = decision == 'approve' ? '通过' : '拒绝';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('审批$decisionLabel'),
        content: TextField(
          controller: _approvalStepCommentController,
          decoration: const InputDecoration(labelText: '备注说明'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确定')),
        ],
      ),
    );
    if (confirmed == true) {
      await _completeApprovalStep(
        stepId,
        decision: decision,
        comments: _approvalStepCommentController.text.trim(),
      );
    }
  }

  Future<void> _showEscalateDialog(int stepId) async {
    _escalationReasonController.clear();
    _escalationTargetController.clear();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('上报审批步骤'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _escalationReasonController,
              decoration: const InputDecoration(labelText: '上报原因'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _escalationTargetController,
              decoration: const InputDecoration(labelText: '目标步骤ID（可选）'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('提交')),
        ],
      ),
    );
    if (confirmed != true) return;
    final reason = _escalationReasonController.text.trim();
    if (reason.isEmpty) {
      ToastUtil.showError('请输入上报原因');
      return;
    }
    final targetId = int.tryParse(_escalationTargetController.text.trim());
    await _escalateApprovalStep(stepId, reason: reason, toStepId: targetId);
  }

  Widget _buildInfoGrid(List<WorkOrderInfoItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = maxWidth < Breakpoints.sm
            ? maxWidth
            : maxWidth < Breakpoints.lg
                ? (maxWidth - 24) / 2
                : 240.0;
        return Wrap(
          spacing: LayoutTokens.gapLg,
          runSpacing: LayoutTokens.gapMd,
          children: items
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: _InfoRow(label: item.label, value: item.value),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildSection(String title, Widget child) {
    return DetailSectionCard(title: title, child: child);
  }

  Widget _buildResourceGroup(String title, List<String> items) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors?.sidebarText,
          ),
        ),
        const SizedBox(height: 6),
        _buildChipGroup(items),
      ],
    );
  }

  Widget _buildChipGroup(List<String> items) {
    if (items.isEmpty) {
      return Text(_emptyText, style: Theme.of(context).textTheme.bodyMedium);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (text) => Chip(
              label: Text(text),
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }

  Future<void> _showSyncPreviewDialog(WorkOrderDetail detail) async {
    final canSync = detail.approvalStatus != 'approved';
    final processes = detail.processes;
    final processMap = {
      for (final item in processes) item.id: item,
    };
    final selectedIds = processes.map((item) => item.id).toSet();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        Map<String, dynamic>? preview;
        String? warningMessage;
        bool loading = false;
        bool executing = false;

        Future<void> loadPreview(
            void Function(void Function()) setState) async {
          if (!canSync) return;
          setState(() {
            loading = true;
            warningMessage = null;
          });
          try {
            final api = dialogContext.read<WorkOrderApiService>();
            final result = await api.syncTasksPreview(
              detail.id,
              processIds: selectedIds.toList(),
            );
            preview = _extractPreview(result);
          } catch (err) {
            if (err is ApiException) {
              final previewData = _extractPreview(err.data);
              if (previewData != null) {
                preview = previewData;
                warningMessage = err.message;
              } else {
                ToastUtil.showError('获取预览失败: ${err.message}');
              }
            } else {
              ToastUtil.showError('获取预览失败: $err');
            }
          } finally {
            setState(() => loading = false);
          }
        }

        Future<void> executeSync(
            void Function(void Function()) setState) async {
          if (!canSync || preview == null) return;
          setState(() => executing = true);
          try {
            final api = dialogContext.read<WorkOrderApiService>();
            final result = await api.syncTasksExecute(
              detail.id,
              processIds: selectedIds.toList(),
            );
            final payload = _unwrapApiData(result);
            final message = payload['message']?.toString() ??
                (payload['result'] is Map
                    ? payload['result']['message']?.toString()
                    : null) ??
                '任务同步完成';
            ToastUtil.showSuccess(message);
            if (mounted) {
              Navigator.of(dialogContext).maybePop();
              await _loadDetail();
            }
          } catch (err) {
            if (err is ApiException) {
              ToastUtil.showError('同步失败: ${err.message}');
            } else {
              ToastUtil.showError('同步失败: $err');
            }
          } finally {
            setState(() => executing = false);
          }
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            final colors = theme.extension<AppColors>();
            final previewData = preview;
            final removedIds = _readIdList(previewData?['removed_process_ids']);
            final addedIds = _readIdList(previewData?['added_process_ids']);
            final tasksToRemove = _readInt(previewData?['tasks_to_remove']);
            final tasksToAdd = _readInt(previewData?['tasks_to_add']);
            final affected = previewData?['affected'] == true;

            return AlertDialog(
              title: const Text('任务同步预览'),
              content: SizedBox(
                width: 540,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '选择要保留的工序，预览同步后将删除被移除工序的草稿任务，并为新增工序生成草稿任务。',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors?.subtleText ?? theme.hintColor,
                        ),
                      ),
                      if (!canSync) ...[
                        const SizedBox(height: 8),
                        Text(
                          '已审核的施工单不能同步任务。',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => setState(() {
                              selectedIds
                                ..clear()
                                ..addAll(processMap.keys);
                            }),
                            child: const Text('全选'),
                          ),
                          TextButton(
                            onPressed: () => setState(selectedIds.clear),
                            child: const Text('清空'),
                          ),
                        ],
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      if (processes.isEmpty)
                        Text('暂无工序可同步', style: theme.textTheme.bodyMedium)
                      else
                        Column(
                          children: [
                            for (final process in processes)
                              CheckboxListTile(
                                value: selectedIds.contains(process.id),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedIds.add(process.id);
                                    } else {
                                      selectedIds.remove(process.id);
                                    }
                                  });
                                },
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  process.processName ?? _emptyText,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  process.processCode ?? _emptyText,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors?.subtleText,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      if (loading) ...[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(minHeight: 2),
                      ],
                      if (warningMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          warningMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                      if (previewData != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          '预览结果',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors?.sidebarText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(label: '将删除草稿任务', value: '$tasksToRemove'),
                        _InfoRow(label: '预计新增草稿任务', value: '$tasksToAdd'),
                        _InfoRow(
                          label: '移除工序',
                          value: _formatProcessNames(removedIds, processMap),
                        ),
                        _InfoRow(
                          label: '新增工序',
                          value: _formatProcessNames(addedIds, processMap),
                        ),
                        _InfoRow(label: '是否有变更', value: affected ? '是' : '否'),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('关闭'),
                ),
                FilledButton(
                  onPressed: (!canSync || loading)
                      ? null
                      : () => loadPreview(setState),
                  child: const Text('预览变更'),
                ),
                FilledButton(
                  onPressed: (!canSync ||
                          loading ||
                          executing ||
                          preview == null ||
                          previewData?['affected'] != true)
                      ? null
                      : () => executeSync(setState),
                  child: Text(executing ? '同步中' : '执行同步'),
                ),
              ],
            );
          },
        );
      },
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

  List<int> _readIdList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => int.tryParse(item.toString()) ?? 0)
          .where((id) => id > 0)
          .toList();
    }
    return const [];
  }

  int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
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

    final statusOptions = const [
      DropdownMenuItem(value: 'pending', child: Text('待开始')),
      DropdownMenuItem(value: 'in_progress', child: Text('进行中')),
      DropdownMenuItem(value: 'paused', child: Text('已暂停')),
      DropdownMenuItem(value: 'completed', child: Text('已完成')),
      DropdownMenuItem(value: 'cancelled', child: Text('已取消')),
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
              onPressed: () =>
                  context.go('/workorders/${widget.workOrderId}/edit'),
              icon: const Icon(Icons.edit, size: 16),
              label: '编辑',
            ),
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
                          hasMultiApproval: _hasMultiApproval,
                          onStatusChanged: (value) =>
                              setState(() => _statusSelection = value),
                          onUpdateStatus: _handleUpdateStatus,
                          onApprove: () => _showApproveDialog(approved: true),
                          onReject: () => _showApproveDialog(approved: false),
                          onResubmit: _handleResubmit,
                          onRequestReapproval: _showReapprovalDialog,
                          buildInfoGrid: _buildInfoGrid,
                          buildSection: _buildSection,
                          buildResourceGroup: _buildResourceGroup,
                          emptyText: _emptyText,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                theme.textTheme.bodySmall?.copyWith(color: colors?.subtleText)),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
