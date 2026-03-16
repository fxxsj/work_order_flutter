import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';

/// 销售订单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class SalesOrderListEntry extends StatefulWidget {
  const SalesOrderListEntry({super.key});

  @override
  State<SalesOrderListEntry> createState() => _SalesOrderListEntryState();
}

class _SalesOrderListEntryState extends State<SalesOrderListEntry> {
  SalesOrderApiService? _apiService;
  SalesOrderRepositoryImpl? _repository;
  SalesOrderViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = SalesOrderApiService(apiClient);
    _repository = SalesOrderRepositoryImpl(_apiService!);
    _viewModel = SalesOrderViewModel(_repository!);
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _viewModel?.initialize();
      });
    }
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
      child: const SalesOrderListPage(),
    );
  }
}

/// 销售订单列表页视图，只负责渲染。
class SalesOrderListPage extends StatelessWidget {
  const SalesOrderListPage({super.key});

  @override
  Widget build(BuildContext context) => const _SalesOrderListView();
}

class _SalesOrderListView extends StatefulWidget {
  const _SalesOrderListView();

  @override
  State<_SalesOrderListView> createState() => _SalesOrderListViewState();
}

class _SalesOrderListViewState extends State<_SalesOrderListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _searchHintText = '搜索订单号/客户';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建销售订单';
  static const String _emptyText = '暂无销售订单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(SalesOrderViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadSalesOrders(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadSalesOrders(resetPage: true);
    });
  }

  static String _pageInfoText(SalesOrderViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  Future<void> _submitOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
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
    try {
      final api = context.read<SalesOrderApiService>();
      await api.submit(order.id);
      ToastUtil.showSuccess('已提交');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  Future<void> _approveOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final commentController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('审核通过'),
        content: TextField(
          controller: commentController,
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
    if (confirmed != true) {
      commentController.dispose();
      return;
    }
    try {
      final api = context.read<SalesOrderApiService>();
      await api.approve(order.id, {
        'approval_comment': commentController.text.trim(),
      });
      ToastUtil.showSuccess('已审核通过');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('审核失败: $err');
    } finally {
      commentController.dispose();
    }
  }

  Future<void> _rejectOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final reasonController = TextEditingController();
    final commentController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('审核拒绝'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: '拒绝原因'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentController,
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
    if (confirmed != true) {
      reasonController.dispose();
      commentController.dispose();
      return;
    }
    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      ToastUtil.showError('请填写拒绝原因');
      reasonController.dispose();
      commentController.dispose();
      return;
    }
    try {
      final api = context.read<SalesOrderApiService>();
      await api.reject(order.id, {
        'reason': reason,
        'approval_comment': commentController.text.trim(),
      });
      ToastUtil.showSuccess('已拒绝');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('拒绝失败: $err');
    } finally {
      reasonController.dispose();
      commentController.dispose();
    }
  }

  Future<void> _startProduction(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
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
    try {
      final api = context.read<SalesOrderApiService>();
      await api.startProduction(order.id);
      ToastUtil.showSuccess('已开始生产');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    }
  }

  Future<void> _completeOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
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
    try {
      final api = context.read<SalesOrderApiService>();
      await api.complete(order.id);
      ToastUtil.showSuccess('已完成');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    }
  }

  Future<void> _cancelOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('取消订单'),
        content: TextField(
          controller: reasonController,
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
    if (confirmed != true) {
      reasonController.dispose();
      return;
    }
    try {
      final api = context.read<SalesOrderApiService>();
      await api.cancel(order.id, {
        'reason': reasonController.text.trim(),
      });
      ToastUtil.showSuccess('已取消');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('取消失败: $err');
    } finally {
      reasonController.dispose();
    }
  }

  Future<void> _updatePayment(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final amountController = TextEditingController();
    final dateController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更新付款信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '已付金额'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
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
    if (confirmed != true) {
      amountController.dispose();
      dateController.dispose();
      return;
    }
    final amountText = amountController.text.trim();
    final dateText = dateController.text.trim();
    if (amountText.isEmpty && dateText.isEmpty) {
      ToastUtil.showError('请至少填写一项');
      amountController.dispose();
      dateController.dispose();
      return;
    }
    final payload = <String, dynamic>{};
    if (amountText.isNotEmpty) {
      final amount = double.tryParse(amountText);
      if (amount == null || amount < 0) {
        ToastUtil.showError('请输入正确的金额');
        amountController.dispose();
        dateController.dispose();
        return;
      }
      payload['paid_amount'] = amount;
    }
    if (dateText.isNotEmpty) {
      payload['payment_date'] = dateText;
    }
    try {
      final api = context.read<SalesOrderApiService>();
      await api.updatePayment(order.id, payload);
      ToastUtil.showSuccess('已更新付款信息');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('更新失败: $err');
    } finally {
      amountController.dispose();
      dateController.dispose();
    }
  }

  Future<void> _createWorkOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    String priority = 'normal';
    final quantityController = TextEditingController();
    final deliveryController = TextEditingController(
        text: order.deliveryDate == null ? '' : _formatDate(order.deliveryDate));
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('生成施工单'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '生产数量（可选）',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deliveryController,
                decoration: const InputDecoration(
                  labelText: '交货日期（YYYY-MM-DD，可选）',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(labelText: '优先级'),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('低')),
                  DropdownMenuItem(value: 'normal', child: Text('普通')),
                  DropdownMenuItem(value: 'high', child: Text('高')),
                  DropdownMenuItem(value: 'urgent', child: Text('紧急')),
                ],
                onChanged: (value) =>
                    setState(() => priority = value ?? 'normal'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
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
    if (confirmed != true) {
      quantityController.dispose();
      deliveryController.dispose();
      notesController.dispose();
      return;
    }

    final payload = <String, dynamic>{
      'sales_order_id': order.id,
      'priority': priority,
      'notes': notesController.text.trim(),
    };
    final quantityText = quantityController.text.trim();
    if (quantityText.isNotEmpty) {
      final quantity = int.tryParse(quantityText);
      if (quantity == null || quantity <= 0) {
        ToastUtil.showError('请输入正确的生产数量');
        quantityController.dispose();
        deliveryController.dispose();
        notesController.dispose();
        return;
      }
      payload['production_quantity'] = quantity;
    }
    final deliveryDate = deliveryController.text.trim();
    if (deliveryDate.isNotEmpty) {
      payload['delivery_date'] = deliveryDate;
    }

    try {
      final api = WorkOrderFlowApiService(context.read<ApiClient>());
      final result = await api.createFromSalesOrder(payload);
      final data = result['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(result['data'])
          : result;
      final workOrderId = toInt(data['id']);
      ToastUtil.showSuccess('施工单已生成');
      await viewModel.loadSalesOrders(resetPage: false);
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
      quantityController.dispose();
      deliveryController.dispose();
      notesController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<SalesOrderViewModel>(
      builder: (context, viewModel, _) {
        final orders = viewModel.salesOrders;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, orders, isMobile),
          footer: viewModel.totalPages > 1
              ? ResponsivePaginationBar(
                  infoText: _pageInfoText(viewModel),
                  page: viewModel.page,
                  pageSize: viewModel.pageSize,
                  pageSizeOptions: viewModel.pageSizeOptions,
                  onPageSizeChanged: viewModel.setPageSize,
                  onPrev: () => viewModel.setPage(viewModel.page - 1),
                  onNext: () => viewModel.setPage(viewModel.page + 1),
                  hasPrev: viewModel.hasPrev,
                  hasNext: viewModel.hasNext,
                  pageSizeLabelBuilder: (size) =>
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    SalesOrderViewModel viewModel,
    List<SalesOrder> orders,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadSalesOrders(resetPage: true),
      );
    }
    if (!viewModel.loading && orders.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.point_of_sale_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, orders);
    }

    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _SalesOrderSummaryCard(
          order: order,
          isMobile: isMobile,
          actions: _buildActionsForOrder(context, order),
        );
      },
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<SalesOrder> orders) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('订单号')),
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('付款')),
        DataColumn(label: Text('下单日期')),
        DataColumn(label: Text('交货日期')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('操作')),
      ],
      rows: orders
          .map(
            (order) => DataRow(
              cells: [
                DataCell(Text(
                  order.orderNumber.isEmpty
                      ? '销售订单 #${order.id}'
                      : order.orderNumber,
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(
                    Text(_displayText(order.customerName), style: textStyle)),
                DataCell(Text(
                  _displayText(order.statusDisplay ?? order.status),
                  style: textStyle?.copyWith(color: colors?.sidebarText),
                )),
                DataCell(Text(
                  _displayText(
                      order.paymentStatusDisplay ?? order.paymentStatus),
                  style: textStyle,
                )),
                DataCell(Text(_formatDate(order.orderDate), style: textStyle)),
                DataCell(
                    Text(_formatDate(order.deliveryDate), style: textStyle)),
                DataCell(Text(_formatAmount(order.totalAmount),
                    style: theme.textTheme.bodyMedium)),
                DataCell(
                  RowActionGroup(
                    actions: _buildActionsForOrder(context, order),
                    primaryCount: 2,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  List<RowAction> _buildActionsForOrder(
    BuildContext context,
    SalesOrder order,
  ) {
    final viewModel = context.read<SalesOrderViewModel>();
    final actions = <RowAction>[
      RowAction(
        label: '查看',
        icon: Icons.visibility_outlined,
        onPressed: () => context.go('/sales-orders/${order.id}'),
      ),
      RowAction(
        label: '编辑',
        icon: Icons.edit_outlined,
        onPressed: () => context.go('/sales-orders/${order.id}/edit'),
      ),
    ];

    final status = order.status ?? '';
    if (status == 'draft') {
      actions.add(RowAction(
        label: '提交',
        icon: Icons.send_outlined,
        onPressed: () => _submitOrder(viewModel, order),
      ));
    }
    if (status == 'submitted') {
      actions.add(RowAction(
        label: '审核通过',
        icon: Icons.check_circle_outline,
        onPressed: () => _approveOrder(viewModel, order),
      ));
      actions.add(RowAction(
        label: '审核拒绝',
        icon: Icons.cancel_outlined,
        destructive: true,
        onPressed: () => _rejectOrder(viewModel, order),
      ));
    }
    if (status == 'approved') {
      actions.add(RowAction(
        label: '开始生产',
        icon: Icons.play_circle_outline,
        onPressed: () => _startProduction(viewModel, order),
      ));
    }
    if (status == 'approved' || status == 'in_production') {
      actions.add(RowAction(
        label: '完成订单',
        icon: Icons.task_alt_outlined,
        onPressed: () => _completeOrder(viewModel, order),
      ));
    }
    if (status.isNotEmpty &&
        status != 'completed' &&
        status != 'cancelled' &&
        status != 'rejected') {
      actions.add(RowAction(
        label: '取消订单',
        icon: Icons.block_outlined,
        destructive: true,
        onPressed: () => _cancelOrder(viewModel, order),
      ));
    }
    actions.add(RowAction(
      label: '更新付款',
      icon: Icons.payments_outlined,
      onPressed: () => _updatePayment(viewModel, order),
    ));
    if (status == 'approved') {
      actions.add(RowAction(
        label: '生成施工单',
        icon: Icons.assignment_outlined,
        onPressed: () => _createWorkOrder(viewModel, order),
      ));
    }

    return actions;
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _SalesOrderSummaryCard._emptyCellText : text;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _SalesOrderSummaryCard._emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return _SalesOrderSummaryCard._emptyCellText;
    return value.toStringAsFixed(2);
  }

  Widget _buildPageHeader(
    BuildContext context,
    SalesOrderViewModel viewModel,
    bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: _controlHeight,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            PageActionButton.outlined(
              onPressed: () => viewModel.loadSalesOrders(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.filled(
              onPressed: () => context.go('/sales-orders/create'),
              icon: const Icon(Icons.add),
              label: _createButtonText,
            ),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _spacingSm,
          );
        },
      ),
    );
  }
}

class _SalesOrderSummaryCard extends StatelessWidget {
  const _SalesOrderSummaryCard({
    required this.order,
    required this.isMobile,
    required this.actions,
  });

  static const String _emptyCellText = '-';

  final SalesOrder order;
  final bool isMobile;
  final List<RowAction> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final title =
        order.orderNumber.isEmpty ? '销售订单 #${order.id}' : order.orderNumber;
    final customer = order.customerName ?? _emptyCellText;
    final status = order.statusDisplay ?? order.status ?? _emptyCellText;
    final payment =
        order.paymentStatusDisplay ?? order.paymentStatus ?? _emptyCellText;
    final amount = _formatAmount(order.totalAmount);
    final deliveryDate = _formatDate(order.deliveryDate);
    final orderDate = _formatDate(order.orderDate);
    final itemsCount = order.itemsCount?.toString() ?? _emptyCellText;
    final sectionSpacing = LayoutTokens.sectionSpacing(context);

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    '$customer · $status',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '付款', value: payment),
                      _SummaryChip(label: '交货', value: deliveryDate),
                      _SummaryChip(label: '明细', value: itemsCount),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors?.sidebarText,
                  ),
                ),
                SizedBox(height: sectionSpacing),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    size: 20,
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            desktopWidth: 180,
            children: [
              _SummaryField(label: '下单日期', value: orderDate),
              _SummaryField(label: '交货日期', value: deliveryDate),
              _SummaryField(label: '付款状态', value: payment),
              _SummaryField(label: '明细数量', value: itemsCount),
              _SummaryField(
                  label: '客户编码', value: order.customerCode ?? _emptyCellText),
            ],
          ),
          SizedBox(height: sectionSpacing),
          if (actions.isNotEmpty)
            RowActionGroup(actions: actions, primaryCount: 2),
        ],
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
