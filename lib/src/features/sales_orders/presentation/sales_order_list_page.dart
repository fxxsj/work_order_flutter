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
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_action_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/widgets/sales_order_list_dialogs.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';

/// 客户订单列表入口。
class SalesOrderListEntry extends StatelessWidget {
  const SalesOrderListEntry({super.key});

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
      initialize: (viewModel) => viewModel.initialize(),
      child: const SalesOrderListPage(),
    );
  }
}

/// 客户订单列表页视图，只负责渲染。
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
  static const String _createButtonText = '新建客户订单';
  static const String _emptyText = '暂无客户订单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  SalesOrderActionService? _actionService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actionService ??= SalesOrderActionService(context.read<ApiClient>());
  }

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
    final confirmed = await showSalesOrderConfirmDialog(
      context,
      title: '提交订单',
      content: '确认提交该客户订单吗？',
      confirmText: '提交',
    );
    if (!confirmed) return;
    try {
      await _actionService!.submit(order.id);
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
    final result = await showSalesOrderApproveDialog(context);
    if (result == null) return;
    try {
      await _actionService!.approve(order.id, comment: result.comment);
      ToastUtil.showSuccess('已审核通过');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('审核失败: $err');
    }
  }

  Future<void> _rejectOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final result = await showSalesOrderRejectDialog(context);
    if (result == null) return;
    final reason = result.reason ?? '';
    if (reason.isEmpty) {
      ToastUtil.showError('请填写拒绝原因');
      return;
    }
    try {
      await _actionService!.reject(
        order.id,
        reason: reason,
        comment: result.comment,
      );
      ToastUtil.showSuccess('已拒绝');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('拒绝失败: $err');
    }
  }

  Future<void> _completeOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final confirmed = await showSalesOrderConfirmDialog(
      context,
      title: '完成订单',
      content: '确认标记该订单为已完成吗？',
      confirmText: '完成',
    );
    if (!confirmed) return;
    try {
      await _actionService!.complete(order.id);
      ToastUtil.showSuccess('已完成');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    }
  }

  void _goToCreateDeliveryOrder(SalesOrder order) {
    context.go('/inventory/delivery?create=1&sales_order_id=${order.id}');
  }

  Future<void> _cancelOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final reason = await showSalesOrderCancelDialog(context);
    if (reason == null) return;
    try {
      await _actionService!.cancel(order.id, reason: reason);
      ToastUtil.showSuccess('已取消');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('取消失败: $err');
    }
  }

  Future<void> _updatePayment(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final result = await showSalesOrderPaymentDialog(context);
    if (result == null) return;
    final amountText = result.amountText;
    final dateText = result.dateText;
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
    try {
      await _actionService!.updatePayment(order.id, payload);
      ToastUtil.showSuccess('已更新付款信息');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('更新失败: $err');
    }
  }

  Future<void> _createWorkOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final result = await showSalesOrderCreateWorkOrderDialog(
      context,
      initialDeliveryDate:
          order.deliveryDate == null ? '' : _formatDate(order.deliveryDate),
    );
    if (result == null) return;

    final payload = <String, dynamic>{
      'sales_order_id': order.id,
      'priority': result.priority,
      'notes': result.notes,
    };
    final quantityText = result.quantityText;
    if (quantityText.isNotEmpty) {
      final quantity = int.tryParse(quantityText);
      if (quantity == null || quantity <= 0) {
        ToastUtil.showError('请输入正确的生产数量');
        return;
      }
      payload['production_quantity'] = quantity;
    }
    final deliveryDate = result.deliveryDateText;
    if (deliveryDate.isNotEmpty) {
      payload['delivery_date'] = deliveryDate;
    }

    try {
      final workOrderId =
          await viewModel.createWorkOrderFromSalesOrder(payload);
      ToastUtil.showSuccess('施工单已生成');
      await viewModel.loadSalesOrders(resetPage: false);
      if (workOrderId != null && mounted) {
        final goToDetail = await showSalesOrderNavigateToWorkOrderDialog(
          context,
        );
        if (goToDetail && mounted) {
          context.go('/workorders/$workOrderId');
        }
      }
    } catch (err) {
      ToastUtil.showError('生成失败: $err');
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
                      ? '客户订单 #${order.id}'
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
    if (status == 'rejected') {
      actions.add(RowAction(
        label: '重新提交',
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
    if (status == 'approved' || status == 'in_production') {
      actions.add(RowAction(
        label: '完成订单',
        icon: Icons.task_alt_outlined,
        onPressed: () => _completeOrder(viewModel, order),
      ));
    }
    if (status.isNotEmpty && status != 'completed' && status != 'cancelled') {
      actions.add(RowAction(
        label: '取消订单',
        icon: Icons.block_outlined,
        destructive: true,
        onPressed: () => _cancelOrder(viewModel, order),
      ));
    }
    if (status == 'completed') {
      actions.add(RowAction(
        label: '生成送货单',
        icon: Icons.local_shipping_outlined,
        onPressed: () => _goToCreateDeliveryOrder(order),
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
        order.orderNumber.isEmpty ? '客户订单 #${order.id}' : order.orderNumber;
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
