import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_decision_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_action_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
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
  static const _searchDebounceDuration = AnimationTokens.slower;
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
  static const CrudActionConfig<SalesOrder> _submitOrderConfig =
      CrudActionConfig(
    title: '提交订单',
    summaryBuilder: _submitSummary,
    impactsBuilder: _submitImpacts,
    auditHintBuilder: _submitAuditHint,
    confirmText: '确认提交',
    successMessageBuilder: _submitSuccessMessage,
    errorMessagePrefix: '提交失败: ',
  );

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  SalesOrderActionService? _actionService;
  String? _routeSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actionService ??= SalesOrderActionService(context.read<ApiClient>());
    final uri = GoRouterState.of(context).uri;
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeStatus = uri.queryParameters['status']?.trim() ?? '';
    final signature = '$routeSearch|$routeStatus';
    final hadRouteState = _routeSignature != null;
    if (_routeSignature == signature) return;
    _routeSignature = signature;
    _searchController.text = routeSearch;
    final hasRouteFilter = routeSearch.isNotEmpty || routeStatus.isNotEmpty;
    if (!hasRouteFilter && !hadRouteState) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SalesOrderViewModel>().applyRoutePrefill(
            search: routeSearch,
            status: routeStatus,
          );
    });
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
    await confirmCrudAction(
      context,
      item: order,
      onConfirm: (item) async {
        await _actionService!.submit(item.id);
        await viewModel.loadSalesOrders(resetPage: false);
      },
      config: _submitOrderConfig,
    );
  }

  Future<void> _approveOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final result = await showActionDecisionDialog<void>(
      context,
      title: '审核通过',
      summary: '通过后，客户订单会进入生产准备和后续履约流程。',
      impacts: const [
        '请确认客户信息、产品规格、交期与金额已核对无误',
        '通过后通常会进入施工单生成和排产准备',
      ],
      auditHint: '审批说明会进入业务与审计记录，建议保留必要结论。',
      notesLabel: '审核意见（可选）',
      notesMaxLines: 3,
      submitText: '通过',
    );
    if (result == null) return;
    try {
      await _actionService!.approve(order.id, comment: result.notes);
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
    final result = await showActionDecisionDialog<void>(
      context,
      title: '审核拒绝',
      summary: '拒绝客户订单后，业务需要补充资料或重新确认交期后再提交。',
      impacts: const [
        '请把缺少的资料、需要修改的内容写清楚',
        '只写“有问题”会导致业务反复确认，无法直接修正',
      ],
      auditHint: '拒绝原因会直接进入审批和审计记录，后续会被客户、业务、生产共同参考。',
      destructive: true,
      notesLabel: '拒绝原因',
      requireNotes: true,
      notesErrorText: '请填写拒绝原因',
      extraNotesLabel: '审核意见（可选）',
      extraNotesMaxLines: 3,
      submitText: '拒绝',
    );
    if (result == null) return;
    try {
      await _actionService!.reject(
        order.id,
        reason: result.notes,
        comment: result.extraNotes,
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
    try {
      final detail = await viewModel.fetchDetail(order.id);
      if (!mounted) return;
      final result = await showSalesOrderCompleteDialog(
        context,
        requireReason: !_isAllItemsDelivered(detail.items),
      );
      if (result == null) return;
      await _actionService!.complete(
        order.id,
        completionReason: result.completionReason,
      );
      ToastUtil.showSuccess('已完成');
      await viewModel.loadSalesOrders(resetPage: false);
    } catch (err) {
      ToastUtil.showError('完成失败: $err');
    }
  }

  void _goToCreateDeliveryOrder(SalesOrder order) {
    context.go('/inventory/delivery?create=1&sales_order_id=${order.id}');
  }

  Future<void> _cancelOrder(
    SalesOrderViewModel viewModel,
    SalesOrder order,
  ) async {
    final decision = await showActionDecisionDialog<void>(
      context,
      title: '取消订单',
      summary: '取消客户订单会中断后续施工、发货和财务闭环，相关部门需要同步停单。',
      impacts: const [
        '如果已排产或已出货，请先确认是否应走变更、退货或异常流程',
        '建议填写取消原因，便于业务和财务后续对账追踪',
      ],
      auditHint: '订单取消原因会影响后续争议处理和经营复盘。',
      destructive: true,
      notesLabel: '取消原因（可选）',
      notesMaxLines: 3,
      submitText: '确认取消',
    );
    if (decision == null) return;
    try {
      await _actionService!.cancel(order.id, reason: decision.notes);
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
    try {
      final detail = await viewModel.fetchDetail(order.id);
      if (!mounted) return;
      final result = await showSalesOrderCreateWorkOrderDialog(
        context,
        initialDeliveryDate:
            order.deliveryDate == null ? '' : _formatDate(order.deliveryDate),
        orderItems: detail.items,
      );
      if (result == null) return;

      final payload = <String, dynamic>{
        'sales_order_id': order.id,
        'priority': result.priority,
        'notes': result.notes,
        'selected_items': result.selectedItems
            .map(
              (item) => {
                'sales_order_item_id': item.salesOrderItemId,
                'production_quantity': item.productionQuantity,
              },
            )
            .toList(growable: false),
      };
      final deliveryDate = result.deliveryDateText;
      if (deliveryDate.isNotEmpty) {
        payload['delivery_date'] = deliveryDate;
      }

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
    final permissions = PermissionUtil.snapshot(context);
    final canChangeSalesOrder = permissions.has('workorder.change_salesorder');
    final canCreateWorkOrder = permissions.has('workorder.add_workorder');
    final canCreateDeliveryOrder =
        permissions.has('workorder.add_deliveryorder');
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
      return _buildDesktopTable(
        context,
        orders,
        canChangeSalesOrder: canChangeSalesOrder,
        canCreateWorkOrder: canCreateWorkOrder,
        canCreateDeliveryOrder: canCreateDeliveryOrder,
      );
    }

    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _SalesOrderSummaryCard(
          order: order,
          isMobile: isMobile,
          actions: _buildActionsForOrder(
            context,
            order,
            canChangeSalesOrder: canChangeSalesOrder,
            canCreateWorkOrder: canCreateWorkOrder,
            canCreateDeliveryOrder: canCreateDeliveryOrder,
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    List<SalesOrder> orders, {
    required bool canChangeSalesOrder,
    required bool canCreateWorkOrder,
    required bool canCreateDeliveryOrder,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('订单号')),
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('施工单')),
        DataColumn(label: Text('下一步')),
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
                DataCell(
                  InkWell(
                    onTap: () => context.go('/sales-orders/${order.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        order.orderNumber.isEmpty
                            ? '客户订单 #${order.id}'
                            : order.orderNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(
                    Text(_displayText(order.customerName), style: textStyle)),
                DataCell(Text(
                  _displayText(order.statusDisplay ?? order.status),
                  style: textStyle?.copyWith(color: colors?.sidebarText),
                )),
                DataCell(Text(_workOrderText(order), style: textStyle)),
                DataCell(Text(_followUpText(order), style: textStyle)),
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
                    actions: _buildActionsForOrder(
                      context,
                      order,
                      canChangeSalesOrder: canChangeSalesOrder,
                      canCreateWorkOrder: canCreateWorkOrder,
                      canCreateDeliveryOrder: canCreateDeliveryOrder,
                    ),
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
    SalesOrder order, {
    required bool canChangeSalesOrder,
    required bool canCreateWorkOrder,
    required bool canCreateDeliveryOrder,
  }) {
    final viewModel = context.read<SalesOrderViewModel>();
    final status = order.status ?? '';
    final actions = <RowAction>[
      if (canChangeSalesOrder && (status == 'draft' || status == 'rejected'))
        RowAction(
          label: '编辑',
          icon: Icons.edit_outlined,
          onPressed: () => context.go('/sales-orders/${order.id}/edit'),
        ),
    ];
    if (canChangeSalesOrder && status == 'draft') {
      actions.add(RowAction(
        label: '提交',
        icon: Icons.send_outlined,
        onPressed: () => _submitOrder(viewModel, order),
      ));
    }
    if (canChangeSalesOrder && status == 'rejected') {
      actions.add(RowAction(
        label: '重新提交',
        icon: Icons.send_outlined,
        onPressed: () => _submitOrder(viewModel, order),
      ));
    }
    if (canChangeSalesOrder && status == 'submitted') {
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
    if (canChangeSalesOrder &&
        (status == 'approved' || status == 'in_production')) {
      actions.add(RowAction(
        label: '完成订单',
        icon: Icons.task_alt_outlined,
        onPressed: () => _completeOrder(viewModel, order),
      ));
    }
    if (canChangeSalesOrder &&
        status.isNotEmpty &&
        status != 'completed' &&
        status != 'cancelled') {
      actions.add(RowAction(
        label: '取消订单',
        icon: Icons.block_outlined,
        destructive: true,
        onPressed: () => _cancelOrder(viewModel, order),
      ));
    }
    if (canCreateDeliveryOrder &&
        (status == 'approved' ||
            status == 'in_production' ||
            status == 'completed')) {
      actions.add(RowAction(
        label: '生成送货单',
        icon: Icons.local_shipping_outlined,
        onPressed: () => _goToCreateDeliveryOrder(order),
      ));
    }
    if (canChangeSalesOrder) {
      actions.add(RowAction(
        label: '更新付款',
        icon: Icons.payments_outlined,
        onPressed: () => _updatePayment(viewModel, order),
      ));
    }
    if (canCreateWorkOrder &&
        (status == 'approved' || status == 'in_production')) {
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

  static String _orderLabel(SalesOrder order) {
    return _displayText(order.orderNumber);
  }

  static String _customerLabel(SalesOrder order) {
    return _displayText(order.customerName);
  }

  static String _submitSummary(SalesOrder order) {
    return '即将提交客户订单 ${_orderLabel(order)}。提交后，订单会进入业务审核流程。';
  }

  static List<String> _submitImpacts(SalesOrder order) {
    return [
      '客户：${_customerLabel(order)}',
      '提交后建议尽快跟进审核，避免影响交期和生产准备',
    ];
  }

  static String _submitAuditHint(SalesOrder order) {
    return '提交记录会进入订单流转日志，建议先确认核心字段已填写完整。';
  }

  static String _submitSuccessMessage(SalesOrder order) => '已提交';

  static String _workOrderText(SalesOrder order) {
    final count = order.workOrderCount ?? 0;
    if (count <= 0) return '未生成';
    return '$count 张';
  }

  static String _followUpText(SalesOrder order) {
    final status = order.status ?? '';
    final workOrderCount = order.workOrderCount ?? 0;
    switch (status) {
      case 'draft':
        return '待提交确认';
      case 'submitted':
        return '待业务审核';
      case 'rejected':
        return '待修改后重提';
      case 'approved':
        return workOrderCount > 0 ? '可继续补施工单或直接发货' : '可生成施工单或直接发货';
      case 'in_production':
        return workOrderCount > 0 ? '跟进生产进度，也可分批发货' : '待补施工单或直接发货';
      case 'completed':
        return '订单已完结';
      case 'cancelled':
        return '订单已取消';
      default:
        return _SalesOrderSummaryCard._emptyCellText;
    }
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

  bool _isAllItemsDelivered(List<SalesOrderItem> items) {
    if (items.isEmpty) return false;
    return items.every(
      (item) => (item.deliveredQuantity ?? 0) >= (item.quantity ?? 0),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    SalesOrderViewModel viewModel,
    bool isMobile,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canCreateSalesOrder = permissions.has('workorder.add_salesorder');
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final submittedCount = _summaryCount(
            viewModel,
            'submitted_count',
            fallback: viewModel.salesOrders
                .where((item) => (item.status ?? '') == 'submitted')
                .length,
          );
          final rejectedCount = _summaryCount(
            viewModel,
            'rejected_count',
            fallback: viewModel.salesOrders
                .where((item) => (item.status ?? '') == 'rejected')
                .length,
          );
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
            if (submittedCount > 0)
              StatusHintChip(
                label: '待审核订单',
                count: submittedCount,
                icon: Icons.fact_check_outlined,
                selected: viewModel.statusFilter == 'submitted',
                onTap: () => _openQuickFilter(status: 'submitted'),
              ),
            if (rejectedCount > 0)
              StatusHintChip(
                label: '待处理退回',
                count: rejectedCount,
                selected: viewModel.statusFilter == 'rejected',
                onTap: () => _openQuickFilter(status: 'rejected'),
              ),
            if (_hasQuickFilter(viewModel))
              OutlinedButton.icon(
                onPressed: () => context.go('/sales-orders'),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: const Text('清除筛选'),
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadSalesOrders(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            if (canCreateSalesOrder)
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

  int _summaryCount(
    SalesOrderViewModel viewModel,
    String key, {
    required int fallback,
  }) {
    final summary = viewModel.summary['summary'];
    if (summary is Map<String, dynamic>) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }
    if (summary is Map) {
      final value = summary[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }
    return fallback;
  }

  bool _hasQuickFilter(SalesOrderViewModel viewModel) {
    return viewModel.statusFilter.isNotEmpty;
  }

  void _openQuickFilter({required String status}) {
    context.go(
      Uri(
        path: '/sales-orders',
        queryParameters: {'status': status},
      ).toString(),
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
    final workOrderText = _SalesOrderListViewState._workOrderText(order);
    final followUpText = _SalesOrderListViewState._followUpText(order);
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
                  InkWell(
                    onTap: () => context.go('/sales-orders/${order.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
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
                      _SummaryChip(label: '施工单', value: workOrderText),
                      _SummaryChip(label: '付款', value: payment),
                      _SummaryChip(label: '下一步', value: followUpText),
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
                  duration: AnimationTokens.expandDuration,
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
          _buildMobileFields(
            context,
            order,
            orderDate: orderDate,
            deliveryDate: deliveryDate,
            workOrderText: workOrderText,
            followUpText: followUpText,
            payment: payment,
            itemsCount: itemsCount,
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

  static Widget _buildMobileFields(
    BuildContext context,
    SalesOrder order, {
    required String orderDate,
    required String deliveryDate,
    required String workOrderText,
    required String followUpText,
    required String payment,
    required String itemsCount,
  }) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.extension<AppColors>()?.subtleText ?? theme.hintColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileRow(context, labelStyle, '下单日期', orderDate),
        _mobileRow(context, labelStyle, '交货日期', deliveryDate),
        _mobileRow(context, labelStyle, '施工单', workOrderText),
        _mobileRow(context, labelStyle, '下一步', followUpText),
        _mobileRow(context, labelStyle, '付款状态', payment),
        _mobileRow(context, labelStyle, '明细数量', itemsCount),
        _mobileRow(
          context,
          labelStyle,
          '客户编码',
          order.customerCode ?? _emptyCellText,
          last: true,
        ),
      ],
    );
  }

  static Widget _mobileRow(
    BuildContext context,
    TextStyle? labelStyle,
    String label,
    String value, {
    bool last = false,
  }) {
    final theme = Theme.of(context);
    final spacing = LayoutTokens.sectionSpacing(context) * 0.6;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: Text(label, style: labelStyle)),
          Expanded(
            child: Text(
              value.isEmpty ? _emptyCellText : value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

typedef _SummaryChip = SummaryChip;
