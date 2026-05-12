import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_dialogs.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/audit_log_navigation.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/widgets/sales_order_detail_sections.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/widgets/sales_order_list_dialogs.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';

class SalesOrderDetailEntry extends StatelessWidget {
  const SalesOrderDetailEntry({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<SalesOrderApiService, SalesOrderRepository,
        SalesOrderViewModel>(
      createService: (context) =>
          SalesOrderApiService(context.read<ApiClient>()),
      createRepository: (context) => SalesOrderRepositoryImpl(
        context.read<SalesOrderApiService>(),
        WorkOrderFlowApiService(context.read<ApiClient>()),
      ),
      createViewModel: (context) =>
          SalesOrderViewModel(context.read<SalesOrderRepository>()),
      child: SalesOrderDetailPage(orderId: orderId),
    );
  }
}

class SalesOrderDetailPage extends StatefulWidget {
  const SalesOrderDetailPage({super.key, required this.orderId});

  final int orderId;

  @override
  State<SalesOrderDetailPage> createState() => _SalesOrderDetailPageState();
}

class _SalesOrderDetailPageState extends State<SalesOrderDetailPage> {
  static const String _emptyText = '-';

  SalesOrderDetail? _detail;
  bool _loading = false;
  bool _actionLoading = false;
  String? _errorMessage;
  bool _initialized = false;

  final TextEditingController _approvalCommentController =
      TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();
  final TextEditingController _cancelReasonController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _loadDetail();
  }

  @override
  void dispose() {
    _approvalCommentController.dispose();
    _rejectionReasonController.dispose();
    _cancelReasonController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final viewModel = context.read<SalesOrderViewModel>();
      final detail = await viewModel.fetchDetail(widget.orderId);
      if (!mounted) return;
      setState(() => _detail = detail);
    } catch (err) {
      if (!mounted) return;
      setState(
          () => _errorMessage = err.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _runDetailAction(
    Future<SalesOrderDetail> Function() action, {
    String? successMessage,
  }) async {
    if (_actionLoading) return;
    setState(() => _actionLoading = true);
    try {
      final detail = await action();
      if (!mounted) return;
      setState(() => _detail = detail);
      if (successMessage != null && successMessage.isNotEmpty) {
        ToastUtil.showSuccess(successMessage);
      }
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _showSubmitDialog({bool resubmitting = false}) async {
    final confirmed = await showRiskActionConfirmDialog(
      context,
      title: resubmitting ? '重新提交客户订单' : '提交客户订单',
      summary: resubmitting ? '确认按退回意见修改后重新提交该客户订单吗？' : '确认提交该客户订单吗？',
      confirmText: resubmitting ? '重新提交' : '提交',
    );
    if (confirmed != true) return;
    final viewModel = context.read<SalesOrderViewModel>();
    await _runDetailAction(
      () => viewModel.submit(widget.orderId),
      successMessage: resubmitting ? '已重新提交审核' : '已提交',
    );
  }

  Future<void> _showApproveDialog() async {
    _approvalCommentController.clear();
    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppFormDialog(
        title: '审核通过',
        formKey: formKey,
        submitText: '通过',
        maxWidth: 420,
        onSubmit: () async => Navigator.of(dialogContext).pop(true),
        content: CrudFieldConfig.textarea(
          label: '审核意见（可选）',
          controller: _approvalCommentController,
          maxLines: 3,
        ).build(context),
      ),
    );
    if (confirmed != true) return;
    final viewModel = context.read<SalesOrderViewModel>();
    await _runDetailAction(
      () => viewModel.approve(widget.orderId, {
        'approval_comment': _approvalCommentController.text.trim(),
      }),
      successMessage: '已审核通过',
    );
  }

  Future<void> _showRejectDialog() async {
    _approvalCommentController.clear();
    _rejectionReasonController.clear();
    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppFormDialog(
        title: '退回客户订单',
        formKey: formKey,
        submitText: '确认退回',
        maxWidth: 520,
        onSubmit: () async => Navigator.of(dialogContext).pop(true),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RiskActionHintPanel(
              summary: '退回后，业务需要先补充订单资料或重新确认交期，再重新提交审核。',
              impacts: [
                '请明确写清需要补什么、改什么',
                '模糊退回会让业务、生产和客户重复确认',
              ],
              auditHint: '退回原因会直接进入审批和审计记录。',
              destructive: true,
            ),
            SpacingTokens.vMd,
            CrudFieldConfig.textarea(
              label: '退回原因',
              controller: _rejectionReasonController,
              hintText: '请明确写清需要补充或修改的内容',
              maxLines: 3,
              validator: (value) =>
                  (value?.trim().isEmpty ?? true) ? '请填写拒绝原因' : null,
            ).build(context),
            SpacingTokens.vMd,
            CrudFieldConfig.textarea(
              label: '补充说明（可选）',
              controller: _approvalCommentController,
              hintText: '例如：客户信息不完整，需补充联系人和交期',
              maxLines: 3,
            ).build(context),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    final reason = _rejectionReasonController.text.trim();
    final viewModel = context.read<SalesOrderViewModel>();
    await _runDetailAction(
      () => viewModel.reject(widget.orderId, {
        'reason': reason,
        'approval_comment': _approvalCommentController.text.trim(),
      }),
      successMessage: '已拒绝',
    );
  }

  Future<void> _showCompleteDialog() async {
    final detail = _detail;
    if (detail == null) return;
    final result = await showSalesOrderCompleteDialog(
      context,
      requireReason: !_isAllItemsDelivered(detail.items),
    );
    if (result == null) return;
    final viewModel = context.read<SalesOrderViewModel>();
    await _runDetailAction(
      () => viewModel.complete(widget.orderId, {
        if (result.completionReason.trim().isNotEmpty)
          'completion_reason': result.completionReason.trim(),
      }),
      successMessage: '已完成',
    );
  }

  void _goToCreateDeliveryOrder() {
    context.go('/inventory/delivery?create=1&sales_order_id=${widget.orderId}');
  }

  Future<void> _showCancelDialog() async {
    _cancelReasonController.clear();
    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppFormDialog(
        title: '取消订单',
        formKey: formKey,
        submitText: '确认取消',
        maxWidth: 520,
        onSubmit: () async => Navigator.of(dialogContext).pop(true),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RiskActionHintPanel(
              summary: '取消客户订单会中断后续施工、发货和财务闭环，相关部门需要同步停单。',
              impacts: [
                '如果已排产或已出货，请先确认是否应走变更、退货或异常流程',
                '建议填写取消原因，便于业务和财务后续对账追踪',
              ],
              auditHint: '订单取消原因会影响后续争议处理和经营复盘。',
              destructive: true,
            ),
            SpacingTokens.vMd,
            CrudFieldConfig.textarea(
              label: '取消原因（可选）',
              controller: _cancelReasonController,
              maxLines: 3,
            ).build(context),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    final viewModel = context.read<SalesOrderViewModel>();
    await _runDetailAction(
      () => viewModel.cancel(widget.orderId, {
        'reason': _cancelReasonController.text.trim(),
      }),
      successMessage: '已取消',
    );
  }

  Future<void> _showUpdatePaymentDialog() async {
    final result = await showSalesOrderPaymentDialog(
      context,
      initialAmountText: _detail?.paidAmount?.toStringAsFixed(2) ?? '',
      initialDateText: _formatDate(_detail?.paymentDate),
    );
    if (result == null) return;

    final amountText = result.amountText.trim();
    final dateText = result.dateText.trim();
    if (amountText.isEmpty && dateText.isEmpty) {
      ToastUtil.showError('请至少填写一项');
      return;
    }
    final payload = <String, dynamic>{};
    if (amountText.isNotEmpty) {
      final amount = double.tryParse(amountText);
      if (amount == null || amount < 0) {
        ToastUtil.showError('请输入正确的金额');
        return;
      }
      payload['paid_amount'] = amount;
    }
    if (dateText.isNotEmpty) {
      payload['payment_date'] = dateText;
    }
    final viewModel = context.read<SalesOrderViewModel>();
    await _runDetailAction(
      () => viewModel.updatePayment(widget.orderId, payload),
      successMessage: '已更新付款信息',
    );
  }

  Future<void> _createWorkOrderDraft() async {
    if (_actionLoading) return;
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<SalesOrderViewModel>();
      final result = await viewModel.createWorkOrderFromSalesOrder({
        'sales_order_id': widget.orderId,
      });
      final workOrderId = int.tryParse(result['id']?.toString() ?? '') ??
          int.tryParse(result['work_order_id']?.toString() ?? '');
      if (!mounted) return;
      ToastUtil.showSuccess('已生成施工单草稿');
      if (workOrderId != null && workOrderId > 0) {
        context.go('/workorders/$workOrderId/edit');
      } else {
        context.go('/workorders');
      }
    } catch (err) {
      ToastUtil.showError('生成施工单草稿失败: $err');
    } finally {
      if (mounted) setState(() => _actionLoading = false);
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

  String _formatAmount(double? value) {
    if (value == null) return _emptyText;
    return value.toStringAsFixed(2);
  }

  List<SalesOrderActionItem> _buildActions(SalesOrderDetail? detail) {
    final status = detail?.status ?? '';
    final permissions = PermissionUtil.snapshot(context);
    final canChangeSalesOrder = permissions.has('workorder.change_salesorder');
    final canCreateWorkOrder = permissions.has('workorder.add_workorder');
    final canCreateDeliveryOrder =
        permissions.has('workorder.add_deliveryorder');
    final actions = <SalesOrderActionItem>[
      if (canChangeSalesOrder && status == 'draft')
        SalesOrderActionItem(
          label: '提交',
          icon: Icons.send_outlined,
          onTap: _showSubmitDialog,
        ),
      if (canChangeSalesOrder && status == 'rejected')
        SalesOrderActionItem(
          label: '重新提交',
          icon: Icons.send_outlined,
          onTap: () => _showSubmitDialog(resubmitting: true),
        ),
      if (canChangeSalesOrder && status == 'submitted') ...[
        SalesOrderActionItem(
          label: '审核通过',
          icon: Icons.check_circle_outline,
          onTap: _showApproveDialog,
        ),
        SalesOrderActionItem(
          label: '审核拒绝',
          icon: Icons.cancel_outlined,
          onTap: _showRejectDialog,
        ),
      ],
      if (canChangeSalesOrder &&
          (status == 'approved' || status == 'in_production'))
        SalesOrderActionItem(
          label: '完成订单',
          icon: Icons.task_alt_outlined,
          onTap: _showCompleteDialog,
        ),
      if (canChangeSalesOrder &&
          status.isNotEmpty &&
          status != 'completed' &&
          status != 'cancelled')
        SalesOrderActionItem(
          label: '取消订单',
          icon: Icons.block_outlined,
          onTap: _showCancelDialog,
          destructive: true,
        ),
      if (canCreateDeliveryOrder &&
          (status == 'approved' ||
              status == 'in_production' ||
              status == 'completed'))
        SalesOrderActionItem(
          label: '生成送货单',
          icon: Icons.local_shipping_outlined,
          onTap: _goToCreateDeliveryOrder,
        ),
      if (canChangeSalesOrder)
        SalesOrderActionItem(
          label: '更新付款',
          icon: Icons.payments_outlined,
          onTap: _showUpdatePaymentDialog,
        ),
      if (canCreateWorkOrder &&
          (status == 'approved' || status == 'in_production'))
        SalesOrderActionItem(
          label: '生成施工单草稿',
          icon: Icons.assignment_outlined,
          onTap: _createWorkOrderDraft,
        ),
    ];
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final title = detail?.orderNumber.isNotEmpty == true
        ? '客户订单 ${detail!.orderNumber}'
        : '客户订单 #${widget.orderId}';
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final permissions = PermissionUtil.snapshot(context);
    final canChangeSalesOrder = permissions.has('workorder.change_salesorder');
    final canEdit = canChangeSalesOrder &&
        ((detail?.status ?? '') == 'draft' ||
            (detail?.status ?? '') == 'rejected');
    final canViewAudit = AuditLogNavigation.canView(context);

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
              onPressed: canEdit
                  ? () => context.go('/sales-orders/${widget.orderId}/edit')
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
            SalesOrderActionMenu(
              actions: _buildActions(detail),
              disabled: _actionLoading,
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
                )
              : detail == null
                  ? const DetailSurfaceCard(
                      child: Center(child: Text('未找到客户订单信息')),
                    )
                  : ListView(
                      children: [
                        _buildOverviewSection(detail, title),
                        if ((detail.status ?? '') == 'rejected' &&
                            ((detail.rejectionReason ?? '').trim().isNotEmpty ||
                                (detail.approvalComment ?? '')
                                    .trim()
                                    .isNotEmpty)) ...[
                          SizedBox(height: sectionSpacing),
                          ApprovalRejectionNoticeCard(
                            reason:
                                (detail.rejectionReason ?? '').trim().isEmpty
                                    ? '请先查看审批说明'
                                    : detail.rejectionReason!.trim(),
                            comment: detail.approvalComment,
                            nextStep: '根据退回原因补充订单信息后，直接重新提交审核。',
                            primaryAction: FilledButton.icon(
                              onPressed: canChangeSalesOrder && !_actionLoading
                                  ? () => _showSubmitDialog(resubmitting: true)
                                  : null,
                              icon: const Icon(Icons.send_outlined, size: 18),
                              label: const Text('重新提交'),
                            ),
                            secondaryAction: OutlinedButton.icon(
                              onPressed: canChangeSalesOrder
                                  ? () => context.go(
                                      '/sales-orders/${widget.orderId}/edit')
                                  : null,
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text('先去修改'),
                            ),
                          ),
                        ],
                        SizedBox(height: sectionSpacing),
                        SalesOrderInfoSection(
                          title: '客户信息',
                          items: [
                            SalesOrderInfoItem(
                              '联系人',
                              detail.customerContact ??
                                  detail.contactPerson ??
                                  _emptyText,
                            ),
                            SalesOrderInfoItem(
                              '电话',
                              detail.customerPhone ??
                                  detail.contactPhone ??
                                  _emptyText,
                            ),
                            SalesOrderInfoItem(
                              '地址',
                              detail.customerAddress ??
                                  detail.shippingAddress ??
                                  _emptyText,
                            ),
                          ],
                        ),
                        SizedBox(height: sectionSpacing),
                        SalesOrderItemsSection(
                          items: detail.items,
                          emptyText: _emptyText,
                        ),
                        SizedBox(height: sectionSpacing),
                        SalesOrderInfoSection(
                          title: '付款信息',
                          items: [
                            SalesOrderInfoItem(
                              '小计',
                              _formatAmount(detail.subtotal),
                            ),
                            SalesOrderInfoItem(
                              '税额',
                              _formatAmount(detail.taxAmount),
                            ),
                            SalesOrderInfoItem(
                              '折扣',
                              _formatAmount(detail.discountAmount),
                            ),
                            SalesOrderInfoItem(
                              '定金',
                              _formatAmount(detail.depositAmount),
                            ),
                            SalesOrderInfoItem(
                              '已付金额',
                              _formatAmount(detail.paidAmount),
                            ),
                            SalesOrderInfoItem(
                              '付款日期',
                              _formatDate(detail.paymentDate),
                            ),
                          ],
                        ),
                        SizedBox(height: sectionSpacing),
                        SalesOrderFinanceSummarySection(
                          items: [
                            SalesOrderInfoItem(
                              '订单金额',
                              _formatAmount(detail.totalAmount),
                            ),
                            SalesOrderInfoItem(
                              '已回款',
                              _formatAmount(detail.paidAmount),
                            ),
                            SalesOrderInfoItem(
                              '未回款',
                              _formatAmount(detail.unpaidAmount),
                            ),
                            SalesOrderInfoItem(
                              '付款状态',
                              detail.paymentStatusDisplay ??
                                  detail.paymentStatus ??
                                  _emptyText,
                            ),
                            SalesOrderInfoItem(
                              '关联发票',
                              detail.invoiceSummaries.length.toString(),
                            ),
                            SalesOrderInfoItem(
                              '收款记录',
                              detail.paymentCount?.toString() ?? _emptyText,
                            ),
                            SalesOrderInfoItem(
                              '待收款计划',
                              detail.pendingPaymentPlanCount == null
                                  ? _emptyText
                                  : '${detail.pendingPaymentPlanCount} 笔',
                            ),
                            SalesOrderInfoItem(
                              '待收金额',
                              _formatAmount(detail.pendingPaymentPlanAmount),
                            ),
                          ],
                          onOpenInvoicePage: () =>
                              context.go('/finance/invoices'),
                          onOpenPaymentPage: () =>
                              context.go('/finance/payments'),
                          onOpenStatementPage: () =>
                              context.go('/finance/statements'),
                        ),
                        SizedBox(height: sectionSpacing),
                        SalesOrderTraceabilitySection(
                          workOrderSummaries: detail.workOrderSummaries,
                          deliveryOrderSummaries: detail.deliveryOrderSummaries,
                          invoiceSummaries: detail.invoiceSummaries,
                          onOpenWorkOrder: (item) {
                            final id = item.id;
                            if (id != null && id > 0) {
                              context.go('/workorders/$id');
                            }
                          },
                          onOpenWorkOrderPage: () => context.go('/workorders'),
                          onOpenDeliveryPage: () =>
                              context.go('/inventory/delivery'),
                          onOpenInvoicePage: () =>
                              context.go('/finance/invoices'),
                          emptyText: _emptyText,
                        ),
                      ],
                    ),
    );
  }

  bool _isAllItemsDelivered(List<SalesOrderItem> items) {
    if (items.isEmpty) return false;
    return items.every(
      (item) => (item.deliveredQuantity ?? 0) >= (item.quantity ?? 0),
    );
  }

  Widget _buildOverviewSection(SalesOrderDetail detail, String title) {
    return SalesOrderOverviewSection(
      title: title,
      items: [
        SalesOrderInfoItem('客户', detail.customerName ?? _emptyText),
        SalesOrderInfoItem(
          '合同号',
          (detail.contractNumber ?? '').trim().isEmpty
              ? _emptyText
              : detail.contractNumber!.trim(),
        ),
        SalesOrderInfoItem(
          '状态',
          detail.statusDisplay ?? detail.status ?? _emptyText,
        ),
        SalesOrderInfoItem(
          '审批说明',
          (detail.approvalComment ?? '').trim().isEmpty
              ? _emptyText
              : detail.approvalComment!.trim(),
        ),
        SalesOrderInfoItem(
          '付款状态',
          detail.paymentStatusDisplay ?? detail.paymentStatus ?? _emptyText,
        ),
        SalesOrderInfoItem('下单日期', _formatDate(detail.orderDate)),
        SalesOrderInfoItem('交货日期', _formatDate(detail.deliveryDate)),
        SalesOrderInfoItem('实际交货', _formatDate(detail.actualDeliveryDate)),
        SalesOrderInfoItem(
          '订单金额',
          detail.totalAmount == null
              ? _emptyText
              : detail.totalAmount!.toStringAsFixed(2),
        ),
        SalesOrderInfoItem(
          '税率',
          detail.taxRate == null
              ? _emptyText
              : '${detail.taxRate!.toStringAsFixed(2)}%',
        ),
      ],
    );
  }
}
