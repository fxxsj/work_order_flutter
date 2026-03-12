import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
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
  static const String _breadcrumbSeparator = ' / ';
  static const String _emptyText = '-';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除施工单 "{name}" 吗？此操作不可恢复。';
  static const String _summaryHintText = '统一查看施工单状态、明细、物料和审核记录。';

  WorkOrderDetail? _detail;
  bool _loading = false;
  String? _errorMessage;
  bool _initialized = false;
  bool _actionLoading = false;

  String? _statusSelection;

  final TextEditingController _approvalCommentController =
      TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();
  final TextEditingController _reapprovalReasonController =
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
    } catch (err) {
      if (!mounted) return;
      setState(
          () => _errorMessage = err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _approvalCommentController.dispose();
    _rejectionReasonController.dispose();
    _reapprovalReasonController.dispose();
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
          _InfoItem(
              '不良数量', detail.defectiveQuantity?.toString() ?? _emptyText),
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
          _InfoItem(
              '印刷形式',
              detail.printingTypeDisplay ??
                  detail.printingType ??
                  _emptyText),
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

        if (detail.approvalStatus == 'pending') {
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
        if (detail.approvalStatus == 'rejected') {
          approvalActions.add(
            FilledButton(
              onPressed: _actionLoading ? null : _handleResubmit,
              child: const Text('重新提交审核'),
            ),
          );
        }
        if (detail.approvalStatus == 'approved') {
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
            DropdownButtonFormField<String>(
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
                  item.purchaseStatusDisplay ?? item.purchaseStatus ?? _emptyText,
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
    final breadcrumb = [
      ...buildBreadcrumbForPathWith(
        GoRouterState.of(context).uri.path,
        buildPathToIdMap(),
      ),
      '详情',
    ];

    final detail = _detail;
    final title = detail?.orderNumber.isNotEmpty == true
        ? '施工单 ${detail!.orderNumber}'
        : '施工单 #${widget.workOrderId}';
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
      header: WorkbenchHeaderBar(
        breadcrumb: breadcrumb.join(_breadcrumbSeparator),
        title: title,
        subtitle: _summaryHintText,
        stats: [
          WorkbenchStatItem(
            label: '状态',
            value: detail?.statusDisplay ?? detail?.status ?? _emptyText,
          ),
          WorkbenchStatItem(
            label: '审批',
            value: detail?.approvalStatusDisplay ??
                detail?.approvalStatus ??
                _emptyText,
          ),
          WorkbenchStatItem(
            label: '进度',
            value: detail?.progressPercentage == null
                ? _emptyText
                : '${detail!.progressPercentage}%',
          ),
        ],
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
                            '产品清单', _buildProductsTable(detail.products)),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                            '工序进度', _buildProcessTable(detail.processes)),
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
