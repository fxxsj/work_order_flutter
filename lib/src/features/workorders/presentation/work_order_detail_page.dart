import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/store_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/workorders/application/work_order_view_model.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_repository_impl.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_repository.dart';

class WorkOrderDetailEntry extends StatefulWidget {
  const WorkOrderDetailEntry({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  State<WorkOrderDetailEntry> createState() => _WorkOrderDetailEntryState();
}

class _WorkOrderDetailEntryState extends State<WorkOrderDetailEntry> {
  WorkOrderApiService? _apiService;
  WorkOrderRepositoryImpl? _repository;
  WorkOrderViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = WorkOrderApiService(apiClient);
    _repository = WorkOrderRepositoryImpl(_apiService!);
    _viewModel = WorkOrderViewModel(_repository!);
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = _apiService;
    final repository = _repository;
    final viewModel = _viewModel;
    if (apiService == null || repository == null || viewModel == null) {
      return const SizedBox.shrink();
    }
    return MultiProvider(
      providers: [
        Provider<WorkOrderApiService>.value(value: apiService),
        Provider<WorkOrderRepository>.value(value: repository),
        ChangeNotifierProvider<WorkOrderViewModel>.value(value: viewModel),
      ],
      child: WorkOrderDetailPage(workOrderId: widget.workOrderId),
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
  final TextEditingController _urgentReasonController =
      TextEditingController();

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
      final apiClient = context.read<ApiClient>();
      final response = await apiClient.get(
        '/multi-level-approval/get_approval_status/',
        queryParameters: {'order_id': widget.workOrderId},
      );
      if (!mounted) return;
      setState(() {
        final payload = response.data;
        _approvalStatus = payload is Map<String, dynamic>
            ? payload
            : payload is Map
                ? Map<String, dynamic>.from(payload)
                : null;
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

  Map<String, dynamic>? get _currentApprovalStep {
    final data = _approvalStatus?['current_step'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  List<Map<String, dynamic>> get _allApprovalSteps {
    final data = _approvalStatus?['all_steps'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }

  Future<void> _submitMultiApproval() async {
    setState(() => _approvalActionLoading = true);
    try {
      final apiClient = context.read<ApiClient>();
      await apiClient.post(
        '/multi-level-approval/submit_for_approval/',
        data: {'order_id': widget.workOrderId},
      );
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
      final apiClient = context.read<ApiClient>();
      await apiClient.post('/approval-steps/$stepId/start_step/');
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
      final apiClient = context.read<ApiClient>();
      await apiClient.post(
        '/approval-steps/$stepId/complete_step/',
        data: {
          'decision': decision,
          if (comments != null) 'comments': comments,
        },
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
      final apiClient = context.read<ApiClient>();
      await apiClient.post(
        '/approval-steps/$stepId/escalate_step/',
        data: {
          'escalation_reason': reason,
          if (toStepId != null) 'to_step_id': toStepId,
        },
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
      final apiClient = context.read<ApiClient>();
      await apiClient.post(
        '/urgent-orders/mark_urgent/',
        data: {
          'order_id': widget.workOrderId,
          'reason': reason,
        },
      );
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

  Widget _buildInfoGrid(List<_InfoItem> items) {
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

  Widget _buildOverviewSection(
    WorkOrderDetail detail, {
    required List<DropdownMenuItem<String>> statusOptions,
  }) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final summary = _buildSection(
      '施工单信息',
      _buildSummaryContent(detail),
    );
    final actions = _buildSection(
      '流程操作',
      _buildActionPanel(detail, statusOptions: statusOptions),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < Breakpoints.lg;
        if (isNarrow) {
          return Column(
            children: [
              summary,
              SizedBox(height: sectionSpacing),
              actions,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: summary),
            SizedBox(width: sectionSpacing),
            SizedBox(width: 300, child: actions),
          ],
        );
      },
    );
  }

  Widget _buildSummaryContent(WorkOrderDetail detail) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final dividerColor = colors?.borderColor.withValues(alpha: 0.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoGrid([
          _InfoItem('客户', detail.customerName ?? _emptyText),
          _InfoItem('业务员', detail.salespersonName ?? _emptyText),
          _InfoItem('负责人', detail.managerName ?? _emptyText),
          _InfoItem('创建人', detail.createdByName ?? _emptyText),
          _InfoItem('审核人', detail.approvedByName ?? _emptyText),
          _InfoItem('状态', detail.statusDisplay ?? detail.status ?? _emptyText),
          _InfoItem(
              '优先级', detail.priorityDisplay ?? detail.priority ?? _emptyText),
          _InfoItem(
              '审批状态',
              detail.approvalStatusDisplay ??
                  detail.approvalStatus ??
                  _emptyText),
          _InfoItem('审批说明', detail.approvalComment ?? _emptyText),
          _InfoItem('下单日期', _formatDate(detail.orderDate)),
          _InfoItem('交货日期', _formatDate(detail.deliveryDate)),
          _InfoItem('实际交货', _formatDate(detail.actualDeliveryDate)),
          _InfoItem(
              '生产数量', detail.productionQuantity?.toString() ?? _emptyText),
          _InfoItem('不良数量', detail.defectiveQuantity?.toString() ?? _emptyText),
          _InfoItem(
            '任务数',
            detail.totalTaskCount == null
                ? _emptyText
                : detail.totalTaskCount!.toString(),
          ),
          _InfoItem(
            '草稿任务',
            detail.draftTaskCount == null
                ? _emptyText
                : detail.draftTaskCount!.toString(),
          ),
          _InfoItem(
            '总金额',
            detail.totalAmount == null
                ? _emptyText
                : detail.totalAmount!.toStringAsFixed(2),
          ),
          _InfoItem(
            '进度',
            detail.progressPercentage == null
                ? _emptyText
                : '${detail.progressPercentage}%',
          ),
          _InfoItem('印刷形式',
              detail.printingTypeDisplay ?? detail.printingType ?? _emptyText),
          _InfoItem('印刷色数', detail.printingColorsDisplay ?? _emptyText),
        ]),
        SizedBox(height: sectionSpacing),
        Divider(height: sectionSpacing, color: dividerColor),
        SizedBox(height: sectionSpacing),
        _buildInfoGrid([
          _InfoItem('备注', detail.notes ?? _emptyText),
          _InfoItem(
            'CMYK 颜色',
            detail.printingCmykColors.isEmpty
                ? _emptyText
                : detail.printingCmykColors.join(', '),
          ),
          _InfoItem(
            '其他颜色',
            detail.printingOtherColors.isEmpty
                ? _emptyText
                : detail.printingOtherColors.join(', '),
          ),
        ]),
        SizedBox(height: sectionSpacing),
        _buildResourceGroup(
          '图稿',
          detail.artworkNames.isNotEmpty
              ? detail.artworkNames
              : detail.artworkCodes,
        ),
        SizedBox(height: sectionSpacing),
        _buildResourceGroup(
          '刀模',
          detail.dieNames.isNotEmpty ? detail.dieNames : detail.dieCodes,
        ),
        SizedBox(height: sectionSpacing),
        _buildResourceGroup(
          '烫金版',
          detail.foilingPlateNames.isNotEmpty
              ? detail.foilingPlateNames
              : detail.foilingPlateCodes,
        ),
        SizedBox(height: sectionSpacing),
        _buildResourceGroup(
          '压凸版',
          detail.embossingPlateNames.isNotEmpty
              ? detail.embossingPlateNames
              : detail.embossingPlateCodes,
        ),
      ],
    );
  }

  Widget _buildActionPanel(
    WorkOrderDetail detail, {
    required List<DropdownMenuItem<String>> statusOptions,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final spacing = LayoutTokens.gapSm;
    final dividerColor = colors?.borderColor.withValues(alpha: 0.6);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumnButtons = constraints.maxWidth < 320;
        final approvalActions = <Widget>[];

        if (!_hasMultiApproval && detail.approvalStatus == 'pending') {
          if (useColumnButtons) {
            approvalActions.addAll([
              FilledButton(
                onPressed: _actionLoading
                    ? null
                    : () => _showApproveDialog(approved: true),
                child: const Text('审核通过'),
              ),
              SizedBox(height: spacing),
              OutlinedButton(
                onPressed: _actionLoading
                    ? null
                    : () => _showApproveDialog(approved: false),
                child: const Text('审核拒绝'),
              ),
            ]);
          } else {
            approvalActions.add(
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _actionLoading
                          ? null
                          : () => _showApproveDialog(approved: true),
                      child: const Text('审核通过'),
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _actionLoading
                          ? null
                          : () => _showApproveDialog(approved: false),
                      child: const Text('审核拒绝'),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        if (!_hasMultiApproval && detail.approvalStatus == 'rejected') {
          approvalActions.add(
            FilledButton(
              onPressed: _actionLoading ? null : _handleResubmit,
              child: const Text('重新提交审核'),
            ),
          );
        }
        if (!_hasMultiApproval && detail.approvalStatus == 'approved') {
          approvalActions.add(
            OutlinedButton(
              onPressed: _actionLoading ? null : _showReapprovalDialog,
              child: const Text('请求重新审核'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchableDropdownFormField<String>(
              initialValue: _statusSelection,
              isExpanded: true,
              decoration: const InputDecoration(labelText: '状态'),
              items: statusOptions,
              onChanged: _actionLoading
                  ? null
                  : (value) => setState(() => _statusSelection = value),
            ),
            SizedBox(height: spacing),
            FilledButton(
              onPressed: _actionLoading ? null : _handleUpdateStatus,
              child: const Text('更新状态'),
            ),
            if (approvalActions.isNotEmpty) ...[
              SizedBox(height: LayoutTokens.gapMd),
              Divider(height: LayoutTokens.gapMd, color: dividerColor),
              Text(
                '审批操作',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors?.sidebarText,
                ),
              ),
              SizedBox(height: spacing),
              ...approvalActions,
            ],
          ],
        );
      },
    );
  }

  Widget _buildMultiApprovalSection(WorkOrderDetail detail) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final isMobile = BreakpointsUtil.isMobile(context);
    final currentStep = _currentApprovalStep;
    final steps = _allApprovalSteps;

    if (_approvalLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_approvalErrorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_approvalErrorMessage!, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _loadApprovalStatus,
            child: const Text('重试'),
          ),
        ],
      );
    }

    if (_approvalStatus == null || steps.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('尚未启动多级审批', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: [
              FilledButton.icon(
                onPressed: _approvalActionLoading ? null : _submitMultiApproval,
                icon: const Icon(Icons.fact_check_outlined, size: 18),
                label: Text(_approvalActionLoading ? '提交中' : '提交审批'),
              ),
              if (detail.priority != 'urgent')
                OutlinedButton.icon(
                  onPressed: _approvalActionLoading ? null : _markUrgent,
                  icon: const Icon(Icons.priority_high, size: 18),
                  label: const Text('标记紧急'),
                ),
            ],
          ),
        ],
      );
    }

    final totalSteps = _approvalStatus?['total_steps']?.toString() ?? _emptyText;
    final completedSteps =
        _approvalStatus?['completed_steps']?.toString() ?? _emptyText;
    final progressText =
        _formatPercentage(_approvalStatus?['progress_percentage']);
    final approvalStatus =
        _approvalStatus?['approval_status']?.toString() ??
            detail.approvalStatusDisplay ??
            _emptyText;

    final assignedTo =
        currentStep == null ? _emptyText : currentStep['assigned_to_name']?.toString() ?? _emptyText;
    final stepStatus =
        currentStep == null ? _emptyText : currentStep['status']?.toString() ?? _emptyText;
    final stepName =
        currentStep == null ? _emptyText : currentStep['step_name']?.toString() ?? _emptyText;
    final stepRawId = currentStep == null ? null : currentStep['id'];
    final stepId = stepRawId is int
        ? stepRawId
        : int.tryParse(stepRawId?.toString() ?? '');

    final currentUser = StoreUtil.getCurrentUserInfo().userName;
    final canAct =
        currentUser == null || currentUser.isEmpty ? true : currentUser == assignedTo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: LayoutTokens.gapLg,
          runSpacing: LayoutTokens.gapSm,
          children: [
            _InfoRow(label: '审批状态', value: approvalStatus),
            _InfoRow(label: '进度', value: '$completedSteps / $totalSteps ($progressText)'),
            _InfoRow(label: '当前步骤', value: stepName),
            _InfoRow(label: '负责人', value: assignedTo),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: LayoutTokens.gapSm,
          runSpacing: LayoutTokens.gapSm,
          children: [
            if (stepId != null && stepStatus == 'pending')
              FilledButton.icon(
                onPressed: _approvalActionLoading || !canAct
                    ? null
                    : () => _startApprovalStep(stepId),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('开始审核'),
              ),
            if (stepId != null &&
                (stepStatus == 'pending' || stepStatus == 'in_progress')) ...[
              FilledButton.icon(
                onPressed: _approvalActionLoading || !canAct
                    ? null
                    : () => _showCompleteStepDialog(
                          stepId: stepId,
                          decision: 'approve',
                        ),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('通过'),
              ),
              OutlinedButton.icon(
                onPressed: _approvalActionLoading || !canAct
                    ? null
                    : () => _showCompleteStepDialog(
                          stepId: stepId,
                          decision: 'reject',
                        ),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('拒绝'),
              ),
              OutlinedButton.icon(
                onPressed: _approvalActionLoading || !canAct
                    ? null
                    : () => _showEscalateDialog(stepId),
                icon: const Icon(Icons.trending_up, size: 18),
                label: const Text('上报'),
              ),
            ],
            FilledButton.icon(
              onPressed: _approvalActionLoading ? null : _submitMultiApproval,
              icon: const Icon(Icons.fact_check_outlined, size: 18),
              label: Text(_approvalActionLoading ? '提交中' : '重新提交'),
            ),
            if (detail.priority != 'urgent')
              OutlinedButton.icon(
                onPressed: _approvalActionLoading ? null : _markUrgent,
                icon: const Icon(Icons.priority_high, size: 18),
                label: const Text('标记紧急'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '审批步骤',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors?.sidebarText,
          ),
        ),
        const SizedBox(height: 8),
        if (!isMobile)
          AppDataTable(
            columns: const [
              DataColumn(label: Text('序号')),
              DataColumn(label: Text('步骤')),
              DataColumn(label: Text('状态')),
              DataColumn(label: Text('负责人')),
              DataColumn(label: Text('决定')),
              DataColumn(label: Text('开始时间')),
              DataColumn(label: Text('完成时间')),
            ],
            rows: steps
                .map(
                  (step) => DataRow(
                    cells: [
                      DataCell(Text(step['step_order']?.toString() ?? _emptyText)),
                      DataCell(Text(step['step_name']?.toString() ?? _emptyText)),
                      DataCell(Text(step['status']?.toString() ?? _emptyText)),
                      DataCell(Text(step['assigned_to_name']?.toString() ?? _emptyText)),
                      DataCell(Text(step['decision']?.toString() ?? _emptyText)),
                      DataCell(Text(_formatDateTime(step['started_at']))),
                      DataCell(Text(_formatDateTime(step['completed_at']))),
                    ],
                  ),
                )
                .toList(),
          )
        else
          Column(
            children: steps
                .map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DetailSectionCard(
                      title: step['step_name']?.toString() ?? _emptyText,
                      child: Wrap(
                        spacing: LayoutTokens.gapLg,
                        runSpacing: LayoutTokens.gapSm,
                        children: [
                          _InfoRow(label: '状态', value: step['status']?.toString() ?? _emptyText),
                          _InfoRow(label: '负责人', value: step['assigned_to_name']?.toString() ?? _emptyText),
                          _InfoRow(label: '决定', value: step['decision']?.toString() ?? _emptyText),
                          _InfoRow(label: '开始时间', value: _formatDateTime(step['started_at'])),
                          _InfoRow(label: '完成时间', value: _formatDateTime(step['completed_at'])),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
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

  Widget _buildProductsTable(List<WorkOrderProductItem> items) {
    if (items.isEmpty) {
      return Text('暂无产品信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DetailListCard(
              title: item.productName ?? _emptyText,
              subtitle: item.productCode ?? _emptyText,
              fields: [
                _DetailField('数量', item.quantity?.toString() ?? _emptyText),
                _DetailField('单位', item.unit ?? _emptyText),
                _DetailField('规格', item.specification ?? _emptyText),
                _DetailField(
                  '拼版数',
                  item.impositionQuantity?.toString() ?? _emptyText,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProcessTable(List<WorkOrderProcessItem> items) {
    if (items.isEmpty) {
      return Text('暂无工序信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DetailListCard(
              title: item.processName ?? _emptyText,
              subtitle: item.processCode ?? _emptyText,
              fields: [
                _DetailField(
                  '状态',
                  item.statusDisplay ?? item.status ?? _emptyText,
                ),
                _DetailField(
                  '操作员',
                  item.operatorName ?? _emptyText,
                ),
                _DetailField(
                  '部门',
                  item.departmentName ?? _emptyText,
                ),
                _DetailField(
                  '任务数',
                  item.tasksCount?.toString() ?? _emptyText,
                ),
                _DetailField(
                  '可开始',
                  item.canStart == null
                      ? _emptyText
                      : (item.canStart! ? '可开始' : '不可开始'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProcessGantt(List<WorkOrderProcessItem> items) {
    final rows = _buildGanttRows(items);
    if (rows.isEmpty) {
      return Text('暂无排程信息', style: Theme.of(context).textTheme.bodyMedium);
    }

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final semantic = theme.extension<AppSemanticColors>();
    final borderColor = colors?.borderColor ?? theme.dividerColor;
    final labelColor = colors?.sidebarText ?? theme.textTheme.bodyMedium?.color;

    final start = rows.map((row) => row.start).reduce((a, b) => a.isBefore(b) ? a : b);
    final end = rows.map((row) => row.end).reduce((a, b) => a.isAfter(b) ? a : b);
    final totalMs = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final safeTotalMs = totalMs <= 0 ? 1 : totalMs;

    const labelWidth = 140.0;
    const rowHeight = 36.0;
    const barHeight = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final minChartWidth = 560.0;
        final chartWidth =
            (constraints.maxWidth - labelWidth - 12).clamp(320.0, double.infinity);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '排程区间：${_formatDateTime(start)} ~ ${_formatDateTime(end)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors?.subtleText ?? theme.hintColor,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: labelWidth + minChartWidth),
                child: SizedBox(
                  width: labelWidth + chartWidth,
                  child: Column(
                    children: [
                      for (final row in rows)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: labelWidth,
                                child: Text(
                                  row.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: labelColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: rowHeight,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: borderColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: _clampDouble(
                                          (row.start.millisecondsSinceEpoch -
                                                  start.millisecondsSinceEpoch) /
                                              safeTotalMs,
                                        ) *
                                            chartWidth,
                                        top: (rowHeight - barHeight) / 2,
                                        child: Container(
                                          width: _resolveBarWidth(
                                            row,
                                            start,
                                            safeTotalMs,
                                            chartWidth,
                                          ),
                                          height: barHeight,
                                          decoration: BoxDecoration(
                                            color: _statusColor(
                                              row.status,
                                              theme,
                                              semantic,
                                            ),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<_GanttRow> _buildGanttRows(List<WorkOrderProcessItem> items) {
    final rows = <_GanttRow>[];
    for (final item in items) {
      var start = item.plannedStartTime ?? item.actualStartTime;
      var end = item.plannedEndTime ?? item.actualEndTime;
      if (start == null && end == null) continue;
      if (start == null && end != null) {
        start = end.subtract(const Duration(hours: 1));
      }
      if (end == null && start != null) {
        end = start.add(const Duration(hours: 1));
      }
      if (start == null || end == null) continue;
      if (end.isBefore(start)) {
        final temp = start;
        start = end;
        end = temp;
      }
      rows.add(
        _GanttRow(
          label: item.processName ?? '工序 #${item.id}',
          status: item.status,
          start: start,
          end: end,
          sequence: item.sequence,
        ),
      );
    }
    rows.sort((a, b) {
      final aSeq = a.sequence ?? 9999;
      final bSeq = b.sequence ?? 9999;
      if (aSeq != bSeq) return aSeq.compareTo(bSeq);
      return a.start.compareTo(b.start);
    });
    return rows;
  }

  double _resolveBarWidth(
    _GanttRow row,
    DateTime start,
    int totalMs,
    double chartWidth,
  ) {
    final durationMs =
        row.end.millisecondsSinceEpoch - row.start.millisecondsSinceEpoch;
    final safeDuration = durationMs <= 0 ? 1 : durationMs;
    final width = safeDuration / totalMs * chartWidth;
    return width < 6 ? 6 : width;
  }

  double _clampDouble(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    if (value < 0) return 0;
    if (value > 1) return 1;
    return value;
  }

  Color _statusColor(
    String? status,
    ThemeData theme,
    AppSemanticColors? semantic,
  ) {
    switch (status) {
      case 'completed':
        return semantic?.success ?? theme.colorScheme.primary;
      case 'in_progress':
        return theme.colorScheme.primary;
      case 'paused':
        return semantic?.warning ?? theme.colorScheme.secondary;
      case 'cancelled':
        return semantic?.danger ?? theme.colorScheme.error;
      case 'pending':
        return semantic?.info ?? theme.colorScheme.secondary;
      default:
        return theme.colorScheme.primary.withValues(alpha: 0.7);
    }
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

        Future<void> loadPreview(void Function(void Function()) setState) async {
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

        Future<void> executeSync(void Function(void Function()) setState) async {
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
            final removedIds =
                _readIdList(previewData?['removed_process_ids']);
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
                        Text('暂无工序可同步',
                            style: theme.textTheme.bodyMedium)
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
      return value.map((item) => int.tryParse(item.toString()) ?? 0).where((id) => id > 0).toList();
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
    final names = ids
        .map((id) => processMap[id]?.processName ?? '工序#$id')
        .toList();
    return names.join(', ');
  }

  Widget _buildMaterialTable(List<WorkOrderMaterialItem> items) {
    if (items.isEmpty) {
      return Text('暂无物料信息', style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DetailListCard(
              title: item.materialName ?? _emptyText,
              subtitle: item.materialCode ?? _emptyText,
              fields: [
                _DetailField('单位', item.materialUnit ?? _emptyText),
                _DetailField('规格', item.materialSize ?? _emptyText),
                _DetailField('用量', item.materialUsage ?? _emptyText),
                _DetailField(
                  '需裁切',
                  item.needCutting == null
                      ? _emptyText
                      : (item.needCutting! ? '是' : '否'),
                ),
                _DetailField(
                  '采购状态',
                  item.purchaseStatusDisplay ??
                      item.purchaseStatus ??
                      _emptyText,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildApprovalLogs(List<WorkOrderApprovalLog> logs) {
    if (logs.isEmpty) {
      return Text('暂无审批记录', style: Theme.of(context).textTheme.bodyMedium);
    }
    final theme = Theme.of(context);
    return Column(
      children: logs.map((log) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
            border:
                Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  log.approvalStatusDisplay ?? log.approvalStatus ?? _emptyText,
                  style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Text('审核人: ${log.approvedByName ?? _emptyText}'),
              Text('时间: ${_formatDate(log.approvedAt)}'),
              if (log.approvalComment != null &&
                  log.approvalComment!.trim().isNotEmpty)
                Text('说明: ${log.approvalComment}'),
              if (log.rejectionReason != null &&
                  log.rejectionReason!.trim().isNotEmpty)
                Text('拒绝原因: ${log.rejectionReason}'),
            ],
          ),
        );
      }).toList(),
    );
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
                        _buildOverviewSection(
                          detail,
                          statusOptions: statusOptions,
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '多级审批',
                          _buildMultiApprovalSection(detail),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                            '产品清单', _buildProductsTable(detail.products)),
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
                          child: _buildProcessTable(detail.processes),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '工序排程',
                          _buildProcessGantt(detail.processes),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                            '物料需求', _buildMaterialTable(detail.materials)),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                            '审批记录', _buildApprovalLogs(detail.approvalLogs)),
                      ],
                    ),
    );
  }
}

class _InfoItem {
  const _InfoItem(this.label, this.value);

  final String label;
  final String value;
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

class _GanttRow {
  const _GanttRow({
    required this.label,
    required this.status,
    required this.start,
    required this.end,
    this.sequence,
  });

  final String label;
  final String? status;
  final DateTime start;
  final DateTime end;
  final int? sequence;
}

class _DetailField {
  const _DetailField(this.label, this.value);

  final String label;
  final String value;
}

class _DetailListCard extends StatelessWidget {
  const _DetailListCard({
    required this.title,
    required this.subtitle,
    required this.fields,
  });

  final String title;
  final String subtitle;
  final List<_DetailField> fields;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isXs = BreakpointsUtil.isXs(context);
    final itemWidth = isXs ? double.infinity : 132.0;
    final basePadding = LayoutTokens.cardPadding(context);
    final radius = isXs ? LayoutTokens.radiusMd : LayoutTokens.radiusLg;

    return Container(
      width: double.infinity,
      padding: basePadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.sidebarText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style:
                theme.textTheme.bodySmall?.copyWith(color: colors.subtleText),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: isXs ? 12 : 20,
            runSpacing: 10,
            children: fields
                .map(
                  (field) => SizedBox(
                    width: itemWidth,
                    child: _InfoRow(label: field.label, value: field.value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
