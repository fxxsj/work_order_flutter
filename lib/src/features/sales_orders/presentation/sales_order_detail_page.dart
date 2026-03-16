import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';

class SalesOrderDetailEntry extends StatefulWidget {
  const SalesOrderDetailEntry({super.key, required this.orderId});

  final int orderId;

  @override
  State<SalesOrderDetailEntry> createState() => _SalesOrderDetailEntryState();
}

class _SalesOrderDetailEntryState extends State<SalesOrderDetailEntry> {
  SalesOrderApiService? _apiService;
  SalesOrderRepositoryImpl? _repository;
  SalesOrderViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = SalesOrderApiService(apiClient);
    _repository = SalesOrderRepositoryImpl(_apiService!);
    _viewModel = SalesOrderViewModel(_repository!);
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
        Provider<SalesOrderApiService>.value(value: apiService),
        Provider<SalesOrderRepository>.value(value: repository),
        ChangeNotifierProvider<SalesOrderViewModel>.value(value: viewModel),
      ],
      child: SalesOrderDetailPage(orderId: widget.orderId),
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
  final TextEditingController _cancelReasonController =
      TextEditingController();
  final TextEditingController _paymentAmountController =
      TextEditingController();
  final TextEditingController _paymentDateController =
      TextEditingController();
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
      setState(() => _errorMessage = err.toString().replaceFirst('Exception: ', ''));
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

  Future<void> _showSubmitDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提交订单'),
        content: const Text('确认提交该销售订单吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('提交'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final api = context.read<SalesOrderApiService>();
    await _runDetailAction(
      () => api.submit(widget.orderId).then((dto) => dto.toEntity()),
      successMessage: '已提交',
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
    final api = context.read<SalesOrderApiService>();
    await _runDetailAction(
      () => api
          .approve(widget.orderId, {
            'approval_comment': _approvalCommentController.text.trim(),
          })
          .then((dto) => dto.toEntity()),
      successMessage: '已审核通过',
    );
  }

  Future<void> _showRejectDialog() async {
    _approvalCommentController.clear();
    _rejectionReasonController.clear();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('审核拒绝'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _rejectionReasonController,
              decoration: const InputDecoration(labelText: '拒绝原因'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _approvalCommentController,
              decoration: const InputDecoration(labelText: '审核意见（可选）'),
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
            child: const Text('拒绝'),
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
    final api = context.read<SalesOrderApiService>();
    await _runDetailAction(
      () => api
          .reject(widget.orderId, {
            'reason': reason,
            'approval_comment': _approvalCommentController.text.trim(),
          })
          .then((dto) => dto.toEntity()),
      successMessage: '已拒绝',
    );
  }

  Future<void> _showStartProductionDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('开始生产'),
        content: const Text('确认将订单状态更新为生产中吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final api = context.read<SalesOrderApiService>();
    await _runDetailAction(
      () => api.startProduction(widget.orderId).then((dto) => dto.toEntity()),
      successMessage: '已开始生产',
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
    final api = context.read<SalesOrderApiService>();
    await _runDetailAction(
      () => api.complete(widget.orderId).then((dto) => dto.toEntity()),
      successMessage: '已完成',
    );
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
    final api = context.read<SalesOrderApiService>();
    await _runDetailAction(
      () => api
          .cancel(widget.orderId, {
            'reason': _cancelReasonController.text.trim(),
          })
          .then((dto) => dto.toEntity()),
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
    final api = context.read<SalesOrderApiService>();
    await _runDetailAction(
      () => api.updatePayment(widget.orderId, payload).then((dto) => dto.toEntity()),
      successMessage: '已更新付款信息',
    );
  }

  Future<void> _showCreateWorkOrderDialog() async {
    _workOrderQuantityController.text = '';
    _workOrderDeliveryDateController.text =
        _formatDate(_detail?.deliveryDate);
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
      final api = WorkOrderFlowApiService(context.read<ApiClient>());
      final result = await api.createFromSalesOrder(payload);
      final data = result['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(result['data'])
          : result;
      final workOrderId = toInt(data['id']);
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

  Widget _buildSection(String title, Widget child) {
    return DetailSectionCard(title: title, child: child);
  }

  Widget _buildInfoGrid(List<_InfoItem> items) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
              width: 240,
              child: _InfoRow(label: item.label, value: item.value),
            ),
          )
          .toList(),
    );
  }

  Widget _buildItemsTable(List<SalesOrderItem> items) {
    if (items.isEmpty) {
      return Text('暂无订单明细', style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: items.map((item) {
        final name = item.productName ?? _emptyText;
        final code = item.productCode ?? _emptyText;
        final quantity = item.quantity?.toString() ?? _emptyText;
        final unit = item.unit ?? _emptyText;
        final price = item.unitPrice == null ? _emptyText : item.unitPrice!.toStringAsFixed(2);
        final tax = item.taxRate == null ? _emptyText : item.taxRate!.toStringAsFixed(2);
        final discount =
            item.discountAmount == null ? _emptyText : item.discountAmount!.toStringAsFixed(2);
        final subtotal = item.subtotal == null ? _emptyText : item.subtotal!.toStringAsFixed(2);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DetailSectionCard(
            title: name,
            child: Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _InfoRow(label: '编码', value: code),
                _InfoRow(label: '数量', value: quantity),
                _InfoRow(label: '单位', value: unit),
                _InfoRow(label: '单价', value: price),
                _InfoRow(label: '税率', value: tax),
                _InfoRow(label: '折扣', value: discount),
                _InfoRow(label: '小计', value: subtotal),
              ]
                  .map((row) => SizedBox(width: 220, child: row))
                  .toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipGroup(List<String> items) {
    if (items.isEmpty) {
      return Text(_emptyText, style: Theme.of(context).textTheme.bodyMedium);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((text) => Chip(label: Text(text))).toList(),
    );
  }

  List<_ActionItem> _buildActions(SalesOrderDetail? detail) {
    final status = detail?.status ?? '';
    final actions = <_ActionItem>[
      if (status == 'draft')
        _ActionItem(
          label: '提交',
          icon: Icons.send_outlined,
          onTap: _showSubmitDialog,
        ),
      if (status == 'submitted') ...[
        _ActionItem(
          label: '审核通过',
          icon: Icons.check_circle_outline,
          onTap: _showApproveDialog,
        ),
        _ActionItem(
          label: '审核拒绝',
          icon: Icons.cancel_outlined,
          onTap: _showRejectDialog,
        ),
      ],
      if (status == 'approved')
        _ActionItem(
          label: '开始生产',
          icon: Icons.play_circle_outline,
          onTap: _showStartProductionDialog,
        ),
      if (status == 'approved' || status == 'in_production')
        _ActionItem(
          label: '完成订单',
          icon: Icons.task_alt_outlined,
          onTap: _showCompleteDialog,
        ),
      if (status.isNotEmpty &&
          status != 'completed' &&
          status != 'cancelled' &&
          status != 'rejected')
        _ActionItem(
          label: '取消订单',
          icon: Icons.block_outlined,
          onTap: _showCancelDialog,
          destructive: true,
        ),
      _ActionItem(
        label: '更新付款',
        icon: Icons.payments_outlined,
        onTap: _showUpdatePaymentDialog,
      ),
      if (status == 'approved')
        _ActionItem(
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
        ? '销售订单 ${detail!.orderNumber}'
        : '销售订单 #${widget.orderId}';
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
              onPressed: () => context.go('/sales-orders/${widget.orderId}/edit'),
              icon: const Icon(Icons.edit, size: 16),
              label: '编辑',
            ),
            _ActionMenu(
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
                      child: Center(child: Text('未找到销售订单信息')),
                    )
                  : ListView(
                      children: [
                        _buildSection(
                          title,
                          _buildInfoGrid([
                            _InfoItem('客户', detail.customerName ?? _emptyText),
                            _InfoItem('状态', detail.statusDisplay ?? detail.status ?? _emptyText),
                            _InfoItem('付款状态', detail.paymentStatusDisplay ?? detail.paymentStatus ?? _emptyText),
                            _InfoItem('下单日期', _formatDate(detail.orderDate)),
                            _InfoItem('交货日期', _formatDate(detail.deliveryDate)),
                            _InfoItem('实际交货', _formatDate(detail.actualDeliveryDate)),
                            _InfoItem(
                              '订单金额',
                              detail.totalAmount == null ? _emptyText : detail.totalAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '税率',
                              detail.taxRate == null ? _emptyText : '${detail.taxRate!.toStringAsFixed(2)}%',
                            ),
                          ]),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '客户信息',
                          _buildInfoGrid([
                            _InfoItem('联系人', detail.customerContact ?? detail.contactPerson ?? _emptyText),
                            _InfoItem('电话', detail.customerPhone ?? detail.contactPhone ?? _emptyText),
                            _InfoItem('地址', detail.customerAddress ?? detail.shippingAddress ?? _emptyText),
                          ]),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection('订单明细', _buildItemsTable(detail.items)),
                        SizedBox(height: sectionSpacing),
                        _buildSection(
                          '付款信息',
                          _buildInfoGrid([
                            _InfoItem(
                              '小计',
                              detail.subtotal == null ? _emptyText : detail.subtotal!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '税额',
                              detail.taxAmount == null ? _emptyText : detail.taxAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '折扣',
                              detail.discountAmount == null ? _emptyText : detail.discountAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '定金',
                              detail.depositAmount == null ? _emptyText : detail.depositAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem(
                              '已付金额',
                              detail.paidAmount == null ? _emptyText : detail.paidAmount!.toStringAsFixed(2),
                            ),
                            _InfoItem('付款日期', _formatDate(detail.paymentDate)),
                          ]),
                        ),
                        SizedBox(height: sectionSpacing),
                        _buildSection('关联施工单', _buildChipGroup(detail.workOrderNumbers)),
                      ],
                    ),
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({
    required this.actions,
    this.disabled = false,
  });

  final List<_ActionItem> actions;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final available = actions
        .where((action) => action.label.trim().isNotEmpty)
        .toList();
    if (available.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isEnabled = !disabled;

    return PopupMenuButton<int>(
      enabled: isEnabled,
      tooltip: '更多操作',
      onSelected: (index) => available[index].onTap(),
      itemBuilder: (context) => [
        for (var i = 0; i < available.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              children: [
                Icon(
                  available[i].icon,
                  size: 16,
                  color: available[i].destructive
                      ? theme.colorScheme.error
                      : theme.iconTheme.color,
                ),
                const SizedBox(width: 8),
                Text(
                  available[i].label,
                  style: available[i].destructive
                      ? TextStyle(color: theme.colorScheme.error)
                      : null,
                ),
              ],
            ),
          ),
      ],
      child: IgnorePointer(
        ignoring: true,
        child: PageActionButton.outlined(
          onPressed: isEnabled ? () {} : null,
          icon: const Icon(Icons.more_horiz, size: 16),
          label: '更多操作',
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
