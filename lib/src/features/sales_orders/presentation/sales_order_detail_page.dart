import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/approval_rejection_notice_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/widgets/sales_order_detail_sections.dart';
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
  String _workOrderPriority = 'normal';

  final TextEditingController _approvalCommentController =
      TextEditingController();
  final TextEditingController _rejectionReasonController =
      TextEditingController();
  final TextEditingController _cancelReasonController = TextEditingController();
  final TextEditingController _paymentAmountController =
      TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _workOrderQuantityController =
      TextEditingController();
  final TextEditingController _workOrderDeliveryDateController =
      TextEditingController();
  final TextEditingController _workOrderNotesController =
      TextEditingController();

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
    _paymentAmountController.dispose();
    _paymentDateController.dispose();
    _workOrderQuantityController.dispose();
    _workOrderDeliveryDateController.dispose();
    _workOrderNotesController.dispose();
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resubmitting ? '重新提交客户订单' : '提交客户订单'),
        content: Text(
          resubmitting ? '确认按退回意见修改后重新提交该客户订单吗？' : '确认提交该客户订单吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(resubmitting ? '重新提交' : '提交'),
          ),
        ],
      ),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('审核通过'),
        content: TextField(
          controller: _approvalCommentController,
          decoration: const InputDecoration(labelText: '审核意见（可选）'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('通过'),
          ),
        ],
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退回客户订单'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _rejectionReasonController,
              decoration: const InputDecoration(
                labelText: '退回原因',
                hintText: '请明确写清需要补充或修改的内容',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _approvalCommentController,
              decoration: const InputDecoration(
                labelText: '补充说明（可选）',
                hintText: '例如：客户信息不完整，需补充联系人和交期',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认退回'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final reason = _rejectionReasonController.text.trim();
    if (reason.isEmpty) {
      ToastUtil.showError('请填写拒绝原因');
      return;
    }
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('完成订单'),
        content: const Text('确认标记该订单为已完成吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('完成'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final viewModel = context.read<SalesOrderViewModel>();
    await _runDetailAction(
      () => viewModel.complete(widget.orderId),
      successMessage: '已完成',
    );
  }

  void _goToCreateDeliveryOrder() {
    context.go('/inventory/delivery?create=1&sales_order_id=${widget.orderId}');
  }

  Future<void> _showCancelDialog() async {
    _cancelReasonController.clear();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('取消订单'),
        content: TextField(
          controller: _cancelReasonController,
          decoration: const InputDecoration(labelText: '取消原因（可选）'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认取消'),
          ),
        ],
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
    _paymentAmountController.text =
        _detail?.paidAmount?.toStringAsFixed(2) ?? '';
    _paymentDateController.text = _formatDate(_detail?.paymentDate);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更新付款信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _paymentAmountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '已付金额'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _paymentDateController,
              decoration: const InputDecoration(
                labelText: '付款日期（YYYY-MM-DD）',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('更新'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final amountText = _paymentAmountController.text.trim();
    final dateText = _paymentDateController.text.trim();
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

  Future<void> _showCreateWorkOrderDialog() async {
    _workOrderQuantityController.text = '';
    _workOrderDeliveryDateController.text = _formatDate(_detail?.deliveryDate);
    _workOrderNotesController.text = '';
    _workOrderPriority = 'normal';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('生成施工单'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _workOrderQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '生产数量（可选）',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _workOrderDeliveryDateController,
                decoration: const InputDecoration(
                  labelText: '交货日期（YYYY-MM-DD，可选）',
                ),
              ),
              const SizedBox(height: 12),
              SearchableDropdownFormField<String>(
                initialValue: _workOrderPriority,
                decoration: const InputDecoration(labelText: '优先级'),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('低')),
                  DropdownMenuItem(value: 'normal', child: Text('普通')),
                  DropdownMenuItem(value: 'high', child: Text('高')),
                  DropdownMenuItem(value: 'urgent', child: Text('紧急')),
                ],
                onChanged: (value) =>
                    setState(() => _workOrderPriority = value ?? 'normal'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _workOrderNotesController,
                decoration: const InputDecoration(labelText: '备注（可选）'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('生成'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;

    final payload = <String, dynamic>{
      'sales_order_id': widget.orderId,
      'priority': _workOrderPriority,
      'notes': _workOrderNotesController.text.trim(),
    };
    final quantityText = _workOrderQuantityController.text.trim();
    if (quantityText.isNotEmpty) {
      final quantity = int.tryParse(quantityText);
      if (quantity == null || quantity <= 0) {
        ToastUtil.showError('请输入正确的生产数量');
        return;
      }
      payload['production_quantity'] = quantity;
    }
    final deliveryDate = _workOrderDeliveryDateController.text.trim();
    if (deliveryDate.isNotEmpty) {
      payload['delivery_date'] = deliveryDate;
    }

    if (_actionLoading) return;
    setState(() => _actionLoading = true);
    try {
      final viewModel = context.read<SalesOrderViewModel>();
      final workOrderId =
          await viewModel.createWorkOrderFromSalesOrder(payload);
      if (!mounted) return;
      ToastUtil.showSuccess('施工单已生成');
      await _loadDetail();
      if (workOrderId != null && mounted) {
        final goToDetail = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('查看施工单'),
            content: const Text('施工单已生成，是否立即查看？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('稍后'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('查看'),
              ),
            ],
          ),
        );
        if (goToDetail == true && mounted) {
          context.go('/workorders/$workOrderId');
        }
      }
    } catch (err) {
      ToastUtil.showError('生成失败: $err');
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

  List<SalesOrderActionItem> _buildActions(SalesOrderDetail? detail) {
    final status = detail?.status ?? '';
    final actions = <SalesOrderActionItem>[
      if (status == 'draft')
        SalesOrderActionItem(
          label: '提交',
          icon: Icons.send_outlined,
          onTap: _showSubmitDialog,
        ),
      if (status == 'rejected')
        SalesOrderActionItem(
          label: '重新提交',
          icon: Icons.send_outlined,
          onTap: () => _showSubmitDialog(resubmitting: true),
        ),
      if (status == 'submitted') ...[
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
      if (status == 'approved' || status == 'in_production')
        SalesOrderActionItem(
          label: '完成订单',
          icon: Icons.task_alt_outlined,
          onTap: _showCompleteDialog,
        ),
      if (status.isNotEmpty && status != 'completed' && status != 'cancelled')
        SalesOrderActionItem(
          label: '取消订单',
          icon: Icons.block_outlined,
          onTap: _showCancelDialog,
          destructive: true,
        ),
      if (status == 'completed')
        SalesOrderActionItem(
          label: '生成送货单',
          icon: Icons.local_shipping_outlined,
          onTap: _goToCreateDeliveryOrder,
        ),
      SalesOrderActionItem(
        label: '更新付款',
        icon: Icons.payments_outlined,
        onTap: _showUpdatePaymentDialog,
      ),
      if (status == 'approved')
        SalesOrderActionItem(
          label: '生成施工单',
          icon: Icons.assignment_outlined,
          onTap: _showCreateWorkOrderDialog,
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
                  context.go('/sales-orders/${widget.orderId}/edit'),
              icon: const Icon(Icons.edit, size: 16),
              label: '编辑',
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
                        const SizedBox(height: 12),
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
                              onPressed: _actionLoading
                                  ? null
                                  : () => _showSubmitDialog(resubmitting: true),
                              icon: const Icon(Icons.send_outlined, size: 18),
                              label: const Text('重新提交'),
                            ),
                            secondaryAction: OutlinedButton.icon(
                              onPressed: () => context
                                  .go('/sales-orders/${widget.orderId}/edit'),
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
                              detail.subtotal == null
                                  ? _emptyText
                                  : detail.subtotal!.toStringAsFixed(2),
                            ),
                            SalesOrderInfoItem(
                              '税额',
                              detail.taxAmount == null
                                  ? _emptyText
                                  : detail.taxAmount!.toStringAsFixed(2),
                            ),
                            SalesOrderInfoItem(
                              '折扣',
                              detail.discountAmount == null
                                  ? _emptyText
                                  : detail.discountAmount!.toStringAsFixed(2),
                            ),
                            SalesOrderInfoItem(
                              '定金',
                              detail.depositAmount == null
                                  ? _emptyText
                                  : detail.depositAmount!.toStringAsFixed(2),
                            ),
                            SalesOrderInfoItem(
                              '已付金额',
                              detail.paidAmount == null
                                  ? _emptyText
                                  : detail.paidAmount!.toStringAsFixed(2),
                            ),
                            SalesOrderInfoItem(
                              '付款日期',
                              _formatDate(detail.paymentDate),
                            ),
                          ],
                        ),
                        SizedBox(height: sectionSpacing),
                        SalesOrderWorkOrdersSection(
                          items: detail.workOrderNumbers,
                          emptyText: _emptyText,
                        ),
                      ],
                    ),
    );
  }

  Widget _buildOverviewSection(SalesOrderDetail detail, String title) {
    return SalesOrderOverviewSection(
      title: title,
      items: [
        SalesOrderInfoItem('客户', detail.customerName ?? _emptyText),
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
