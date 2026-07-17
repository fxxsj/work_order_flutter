import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/presentation/widgets/shimmer_loading.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/presentation/widgets/sales_order_list_dialogs.dart';

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
  static const double _searchWidth = 320;
  static const double _spacingSm = SpacingTokens.sm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _searchHintText = '搜索订单号/客户';
  static const String _statusFilterLabel = '状态';
  static const String _paymentStatusFilterLabel = '付款';
  static const String _orderingLabel = '排序';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建客户订单';
  static const String _emptyText = '暂无客户订单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  final _debounce = DebounceController();
  String? _routeSignature;
  bool _selectionMode = false;
  final Set<int> _selectedOrderIds = <int>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _isSelectableForWorkOrder(SalesOrder order) {
    final status = order.status ?? '';
    return status == 'approved' || status == 'in_production';
  }

  void _setSelectionMode(bool enabled) {
    setState(() {
      _selectionMode = enabled;
      if (!enabled) {
        _selectedOrderIds.clear();
      }
    });
  }

  void _toggleOrderSelection(SalesOrder order, bool selected) {
    if (!_isSelectableForWorkOrder(order)) return;
    setState(() {
      if (selected) {
        _selectedOrderIds.add(order.id);
      } else {
        _selectedOrderIds.remove(order.id);
      }
    });
  }

  void _toggleSelectAllCurrentPage(List<SalesOrder> orders, bool selected) {
    final eligibleIds = orders
        .where(_isSelectableForWorkOrder)
        .map((order) => order.id)
        .toList(growable: false);
    setState(() {
      if (selected) {
        _selectedOrderIds.addAll(eligibleIds);
      } else {
        _selectedOrderIds.removeAll(eligibleIds);
      }
    });
  }

  Future<void> _createBatchWorkOrders(
    SalesOrderViewModel viewModel,
    List<SalesOrder> orders,
  ) async {
    final selectedOrders = orders
        .where((order) => _selectedOrderIds.contains(order.id))
        .where(_isSelectableForWorkOrder)
        .toList(growable: false);
    if (selectedOrders.isEmpty) {
      ToastUtil.showError('请先选择要生成施工单草稿的客户订单');
      return;
    }

    final result = await showSalesOrderBatchCreateWorkOrdersDialog(
      context,
      selectedCount: selectedOrders.length,
    );
    if (result == null) return;

    final payload = <String, dynamic>{
      'sales_order_ids': selectedOrders
          .map((order) => order.id)
          .toList(growable: false),
      'priority': result.priority,
      'notes': result.notes,
      'allow_partial': true,
    };
    if (result.deliveryDateText.isNotEmpty) {
      payload['delivery_date'] = result.deliveryDateText;
    }

    try {
      final response = await viewModel.createWorkOrdersFromSalesOrders(payload);
      final created = response['created'] is List
          ? (response['created'] as List)
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList(growable: false)
          : const <Map<String, dynamic>>[];
      final failed = response['failed'] is List
          ? (response['failed'] as List)
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList(growable: false)
          : const <Map<String, dynamic>>[];

      // 部分成功时显示详情对话框
      if (created.isNotEmpty && failed.isNotEmpty) {
        await _showBatchCreateResultDialog(
          context: context,
          created: created,
          failed: failed,
          orders: orders,
          viewModel: viewModel,
        );
      } else if (created.isNotEmpty) {
        // 全部成功
        ToastUtil.showSuccess('已生成 ${created.length} 张施工单');
        await viewModel.loadSalesOrders(resetPage: false);
        if (!mounted) return;
        setState(() {
          _selectedOrderIds.clear();
          _selectionMode = false;
        });
      } else {
        // 全部失败
        final errorMsg = failed.isNotEmpty && failed.first['error'] != null
            ? failed.first['error'].toString()
            : '批量生成失败';
        ToastUtil.showError(errorMsg);
        await viewModel.loadSalesOrders(resetPage: false);
      }
    } catch (err) {
      ToastUtil.showError('批量生成失败: $err');
    }
  }

  Future<void> _showBatchCreateResultDialog({
    required BuildContext context,
    required List<Map<String, dynamic>> created,
    required List<Map<String, dynamic>> failed,
    required List<SalesOrder> orders,
    required SalesOrderViewModel viewModel,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AppDialog(
          title: '批量创建结果',
          maxWidth: LayoutTokens.dialogWidthLg,
          scrollable: false,
          content: SizedBox(
            width: LayoutTokens.dialogWidthLg,
            height: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 成功部分
                if (created.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '成功创建 ${created.length} 张施工单：',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: created.length,
                      itemBuilder: (context, index) {
                        final item = created[index];
                        final order = orders.firstWhere(
                          (o) => o.id == item['sales_order_id'],
                          orElse: () => SalesOrder(
                            id: item['sales_order_id'] as int,
                            orderNumber: '未知',
                          ),
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${order.orderNumber} → ${item['order_number'] ?? 'N/A'}',
                                  style: Theme.of(
                                    dialogContext,
                                  ).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 24),
                ],
                // 失败部分
                if (failed.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '失败 ${failed.length} 项：',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: failed.length,
                      itemBuilder: (context, index) {
                        final item = failed[index];
                        final order = orders.firstWhere(
                          (o) => o.id == item['sales_order_id'],
                          orElse: () => SalesOrder(
                            id: item['sales_order_id'] as int,
                            orderNumber: '未知',
                          ),
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.orderNumber,
                                      style: Theme.of(dialogContext)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      item['error']?.toString() ?? '未知错误',
                                      style: Theme.of(dialogContext)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                viewModel.loadSalesOrders(resetPage: false);
                if (!mounted) return;
                setState(() {
                  _selectedOrderIds.clear();
                });
              },
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  void _scheduleSearch(
    SalesOrderViewModel viewModel, {
    bool immediate = false,
  }) {
    _debounce.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadSalesOrders(resetPage: true);
      return;
    }
    _debounce.run(() {
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

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

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
      return const ShimmerLoading(child: ShimmerList());
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
        selectionMode: _selectionMode,
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadSalesOrders(resetPage: true),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: orders.length,
        separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _SalesOrderSummaryCard(
            order: order,
            isMobile: isMobile,
            selectionMode: _selectionMode,
            selected: _selectedOrderIds.contains(order.id),
            selectable: _isSelectableForWorkOrder(order),
            onSelectedChanged: (value) =>
                _toggleOrderSelection(order, value ?? false),
          );
        },
      ),
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    List<SalesOrder> orders, {
    required bool selectionMode,
  }) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final textStyle = theme.textTheme.bodySmall;
    final selectableOrders = orders
        .where(_isSelectableForWorkOrder)
        .toList(growable: false);
    final selectedOnPage = _selectedOrderIds.intersection(
      selectableOrders.map((item) => item.id).toSet(),
    );
    final allSelected =
        selectableOrders.isNotEmpty &&
        selectableOrders.every((order) => _selectedOrderIds.contains(order.id));
    final bool? headerSelectionValue = selectableOrders.isEmpty
        ? false
        : allSelected
        ? true
        : selectedOnPage.isNotEmpty
        ? null
        : false;

    return AppDataTable(
      columns: [
        if (selectionMode)
          DataColumn(
            label: Checkbox(
              value: headerSelectionValue,
              tristate: true,
              onChanged: selectableOrders.isEmpty
                  ? null
                  : (value) =>
                        _toggleSelectAllCurrentPage(orders, value ?? false),
            ),
          ),
        DataColumn(label: Text('订单号')),
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('施工单')),
        DataColumn(label: Text('下一步')),
        DataColumn(label: Text('付款')),
        DataColumn(label: Text('下单日期')),
        DataColumn(label: Text('交货日期')),
        DataColumn(label: Text('金额')),
      ],
      rows: orders
          .map(
            (order) => DataRow(
              selected: selectionMode && _selectedOrderIds.contains(order.id),
              cells: [
                if (selectionMode)
                  DataCell(
                    Checkbox(
                      value: _selectedOrderIds.contains(order.id),
                      onChanged: _isSelectableForWorkOrder(order)
                          ? (value) =>
                                _toggleOrderSelection(order, value ?? false)
                          : null,
                    ),
                  ),
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
                  Text(_displayText(order.customerName), style: textStyle),
                ),
                DataCell(
                  Text(
                    _displayText(order.statusDisplay ?? order.status),
                    style: textStyle?.copyWith(color: colors?.sidebarText),
                  ),
                ),
                DataCell(Text(_workOrderText(order), style: textStyle)),
                DataCell(Text(_followUpText(order), style: textStyle)),
                DataCell(
                  Text(
                    _displayText(
                      order.paymentStatusDisplay ?? order.paymentStatus,
                    ),
                    style: textStyle,
                  ),
                ),
                DataCell(Text(_formatDate(order.orderDate), style: textStyle)),
                DataCell(
                  Text(_formatDate(order.deliveryDate), style: textStyle),
                ),
                DataCell(
                  Text(
                    _formatAmount(order.totalAmount),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _SalesOrderSummaryCard._emptyCellText : text;
  }

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
        return workOrderCount > 0 ? '可继续补施工单草稿或直接发货' : '可生成施工单草稿或直接发货';
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

  Widget _buildPageHeader(
    BuildContext context,
    SalesOrderViewModel viewModel,
    bool isMobile,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canCreateSalesOrder = permissions.has('workorder.add_salesorder');
    final canCreateWorkOrder = permissions.has('workorder.add_workorder');
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

          final statusValue = viewModel.statusFilter.isEmpty
              ? ''
              : viewModel.statusFilter;
          final statusField = SizedBox(
            width: isMobile ? constraints.maxWidth : 150,
            child: AppSelect<String>(
              key: ValueKey<String>('sales-status-$statusValue'),
              value: statusValue,
              decoration: const InputDecoration(
                labelText: _statusFilterLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              options: const [
                AppDropdownOption(value: '', label: '全部状态'),
                AppDropdownOption(value: 'draft', label: '草稿'),
                AppDropdownOption(value: 'submitted', label: '已提交'),
                AppDropdownOption(value: 'approved', label: '已审核'),
                AppDropdownOption(value: 'rejected', label: '已拒绝'),
                AppDropdownOption(value: 'pending', label: '待处理'),
                AppDropdownOption(value: 'in_production', label: '生产中'),
                AppDropdownOption(value: 'completed', label: '已完成'),
                AppDropdownOption(value: 'cancelled', label: '已取消'),
              ],
              onChanged: (value) => viewModel.setStatusFilter(value ?? ''),
            ),
          );

          final paymentStatusValue = viewModel.paymentStatusFilter.isEmpty
              ? ''
              : viewModel.paymentStatusFilter;
          final paymentStatusField = SizedBox(
            width: isMobile ? constraints.maxWidth : 140,
            child: AppSelect<String>(
              key: ValueKey<String>('sales-payment-$paymentStatusValue'),
              value: paymentStatusValue,
              decoration: const InputDecoration(
                labelText: _paymentStatusFilterLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              options: const [
                AppDropdownOption(value: '', label: '全部付款'),
                AppDropdownOption(value: 'unpaid', label: '未付款'),
                AppDropdownOption(value: 'partial', label: '部分付款'),
                AppDropdownOption(value: 'paid', label: '已付款'),
              ],
              onChanged: (value) =>
                  viewModel.setPaymentStatusFilter(value ?? ''),
            ),
          );

          final orderingField = SizedBox(
            width: isMobile ? constraints.maxWidth : 160,
            child: AppSelect<String>(
              key: ValueKey<String>('sales-ordering-${viewModel.ordering}'),
              value: viewModel.ordering,
              decoration: const InputDecoration(
                labelText: _orderingLabel,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              options: const [
                AppDropdownOption(value: '-created_at', label: '最新创建'),
                AppDropdownOption(value: 'created_at', label: '最早创建'),
                AppDropdownOption(value: 'order_number', label: '单号升序'),
                AppDropdownOption(value: '-order_number', label: '单号降序'),
                AppDropdownOption(value: 'customer__name', label: '客户升序'),
                AppDropdownOption(value: '-customer__name', label: '客户降序'),
                AppDropdownOption(value: 'order_date', label: '下单日期升序'),
                AppDropdownOption(value: '-order_date', label: '下单日期降序'),
                AppDropdownOption(value: 'delivery_date', label: '交期升序'),
                AppDropdownOption(value: '-delivery_date', label: '交期降序'),
                AppDropdownOption(value: 'total_amount', label: '金额升序'),
                AppDropdownOption(value: '-total_amount', label: '金额降序'),
              ],
              onChanged: (value) {
                if (value != null) viewModel.setOrdering(value);
              },
            ),
          );

          final actions = <Widget>[
            statusField,
            paymentStatusField,
            orderingField,
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
                onPressed: () => _resetFilters(viewModel),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: const Text('清除筛选'),
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadSalesOrders(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            if (canCreateWorkOrder && !_selectionMode)
              PageActionButton.outlined(
                onPressed: () => _setSelectionMode(true),
                icon: const Icon(Icons.checklist_rtl_outlined, size: 16),
                label: '批量选单',
              ),
            if (canCreateWorkOrder && _selectionMode)
              PageActionButton.outlined(
                onPressed: () => _toggleSelectAllCurrentPage(
                  viewModel.salesOrders,
                  !_allSelectableOrdersSelected(viewModel.salesOrders),
                ),
                icon: const Icon(Icons.select_all_outlined, size: 16),
                label: _allSelectableOrdersSelected(viewModel.salesOrders)
                    ? '取消全选'
                    : '全选本页',
              ),
            if (canCreateWorkOrder && _selectionMode)
              PageActionButton.filled(
                onPressed: _selectedOrderIds.isEmpty
                    ? null
                    : () => _createBatchWorkOrders(
                        viewModel,
                        viewModel.salesOrders,
                      ),
                icon: const Icon(Icons.assignment_add, size: 16),
                label: '批量生成(${_selectedOrderIds.length})',
              ),
            if (canCreateWorkOrder && _selectionMode)
              PageActionButton.outlined(
                onPressed: () => _setSelectionMode(false),
                icon: const Icon(Icons.close, size: 16),
                label: '退出多选',
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
    return viewModel.statusFilter.isNotEmpty ||
        viewModel.paymentStatusFilter.isNotEmpty ||
        viewModel.ordering != '-created_at';
  }

  void _resetFilters(SalesOrderViewModel viewModel) {
    _searchController.clear();
    viewModel.resetFilters();
    if (GoRouterState.of(context).uri.queryParameters.isNotEmpty) {
      context.go('/sales-orders');
    }
  }

  bool _allSelectableOrdersSelected(List<SalesOrder> orders) {
    final selectableOrders = orders
        .where(_isSelectableForWorkOrder)
        .toList(growable: false);
    if (selectableOrders.isEmpty) {
      return false;
    }
    return selectableOrders.every(
      (order) => _selectedOrderIds.contains(order.id),
    );
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
    required this.selectionMode,
    required this.selected,
    required this.selectable,
    required this.onSelectedChanged,
  });

  static const String _emptyCellText = '-';

  final SalesOrder order;
  final bool isMobile;
  final bool selectionMode;
  final bool selected;
  final bool selectable;
  final ValueChanged<bool?>? onSelectedChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final title = order.orderNumber.isEmpty
        ? '客户订单 #${order.id}'
        : order.orderNumber;
    final customer = order.customerName ?? _emptyCellText;
    final approvalStatus = order.approvalStatus;
    final isApprovalState = [
      'draft',
      'submitted',
      'rejected',
    ].contains(approvalStatus);
    final status = isApprovalState
        ? (order.approvalStatusDisplay ?? approvalStatus ?? _emptyCellText)
        : (order.statusDisplay ?? order.status ?? _emptyCellText);
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
            if (selectionMode) ...[
              Padding(
                padding: const EdgeInsets.only(right: SpacingTokens.md),
                child: Checkbox(
                  value: selected,
                  onChanged: selectable ? onSelectedChanged : null,
                ),
              ),
            ],
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
