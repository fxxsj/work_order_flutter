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
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';

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
          onView: () => context.go('/sales-orders/${order.id}'),
          onEdit: () => context.go('/sales-orders/${order.id}/edit'),
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
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '查看',
                      onPressed: () => context.go('/sales-orders/${order.id}'),
                    ),
                    RowAction(
                      label: '编辑',
                      onPressed: () =>
                          context.go('/sales-orders/${order.id}/edit'),
                    ),
                  ],
                )),
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
    required this.onView,
    required this.onEdit,
  });

  static const String _emptyCellText = '-';

  final SalesOrder order;
  final bool isMobile;
  final VoidCallback onView;
  final VoidCallback onEdit;

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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onView,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('查看'),
              ),
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
            ],
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
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
