import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/inventory_stocks/application/product_stock_view_model.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_api_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_support_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';
import 'package:work_order_app/src/features/inventory_stocks/presentation/widgets/product_stock_dialogs.dart';

/// 成品库存列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProductStockListEntry extends StatelessWidget {
  const ProductStockListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProductStockApiService, ProductStockRepository,
        ProductStockViewModel>(
      createService: (context) =>
          ProductStockApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProductStockRepositoryImpl(context.read<ProductStockApiService>()),
      createViewModel: (context) =>
          ProductStockViewModel(context.read<ProductStockRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductStockListPage(),
    );
  }
}

/// 成品库存列表页视图，只负责渲染。
class ProductStockListPage extends StatelessWidget {
  const ProductStockListPage({super.key});

  @override
  Widget build(BuildContext context) => const _ProductStockListView();
}

class _ProductStockListView extends StatefulWidget {
  const _ProductStockListView();

  @override
  State<_ProductStockListView> createState() => _ProductStockListViewState();
}

class _ProductStockListViewState extends State<_ProductStockListView> {
  static const _searchDebounceDuration = AnimationTokens.slower;
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索产品名称/编码/客户/施工单';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无库存数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _adjustTitle = '库存调整';
  static const String _adjustSuccessText = '库存调整成功';
  static const String _adjustErrorText = '库存调整失败: ';
  static const String _adjustSubmitText = '提交';
  static const String _cancelText = '取消';
  static const String _detailTitle = '库存详情';
  static const String _lowStockTitle = '库存预警';
  static const String _expiredTitle = '过期库存';
  static const String _lowStockText = '库存预警';
  static const String _expiredText = '过期库存';
  static const String _statusFilterLabel = '库存状态';
  static const String _resetButtonText = '重置筛选';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _lowStockLoading = false;
  bool _expiredLoading = false;
  List<ProductStock> _lowStockList = [];
  List<ProductStock> _expiredList = [];
  ProductStockSupportService? _supportService;
  String? _routeSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= ProductStockSupportService(context.read<ApiClient>());
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
      context.read<ProductStockViewModel>().applyRoutePrefill(
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

  void _scheduleSearch(ProductStockViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStocks(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStocks(resetPage: true);
    });
  }

  Future<void> _openLowStockDialog() async {
    setState(() {
      _lowStockLoading = true;
      _lowStockList = [];
    });
    try {
      final list = await _supportService!.fetchLowStock();
      if (!mounted) return;
      setState(() => _lowStockList = list);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('获取库存预警失败: $err');
    } finally {
      if (!mounted) return;
      setState(() => _lowStockLoading = false);
    }

    if (!mounted) return;
    await showProductStockListDialog(
      context,
      title: _lowStockTitle,
      closeText: _cancelText,
      child: _lowStockLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildStockDialogList(_lowStockList, highlightLowStock: true),
    );
  }

  Future<void> _openExpiredDialog() async {
    setState(() {
      _expiredLoading = true;
      _expiredList = [];
    });
    try {
      final list = await _supportService!.fetchExpired();
      if (!mounted) return;
      setState(() => _expiredList = list);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('获取过期库存失败: $err');
    } finally {
      if (!mounted) return;
      setState(() => _expiredLoading = false);
    }

    if (!mounted) return;
    await showProductStockListDialog(
      context,
      title: _expiredTitle,
      closeText: _cancelText,
      child: _expiredLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildStockDialogList(_expiredList, highlightExpired: true),
    );
  }

  Future<void> _openDetailDialog(ProductStock stock) async {
    await showProductStockDetailDialog(
      context,
      title: _detailTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductStockDetailRow(
            label: '产品名称',
            value: _displayText(stock.productName),
          ),
          ProductStockDetailRow(
            label: '产品编码',
            value: _displayText(stock.productCode),
          ),
          ProductStockDetailRow(
              label: '批次号', value: _displayText(stock.batchNo)),
          ProductStockDetailRow(
              label: '库存数量', value: _formatAmount(stock.quantity)),
          ProductStockDetailRow(
            label: '预留数量',
            value: _formatAmount(stock.reservedQuantity),
          ),
          ProductStockDetailRow(
            label: '可用数量',
            value: _formatAmount(stock.availableQuantity),
          ),
          ProductStockDetailRow(
            label: '最小库存',
            value: stock.minStockLevel?.toString() ?? _emptyCellText,
          ),
          ProductStockDetailRow(
              label: '库位', value: _displayText(stock.location)),
          ProductStockDetailRow(
              label: '生产日期', value: _formatDate(stock.productionDate)),
          ProductStockDetailRow(
              label: '到期日期', value: _formatDate(stock.expiryDate)),
          ProductStockDetailRow(
            label: '状态',
            value: _displayText(stock.statusDisplay ?? stock.status),
          ),
          ProductStockDetailRow(
              label: '单位成本', value: _formatAmount(stock.unitCost)),
          ProductStockDetailRow(
              label: '总价值', value: _formatAmount(stock.totalValue)),
          ProductStockDetailRow(
              label: '创建时间', value: _formatDate(stock.createdAt)),
          if ((stock.notes ?? '').trim().isNotEmpty)
            ProductStockDetailRow(
              label: '备注',
              value: stock.notes ?? _emptyCellText,
            ),
        ],
      ),
    );
  }

  Future<void> _openAdjustDialog(
    BuildContext context,
    ProductStockViewModel viewModel,
    ProductStock stock,
  ) async {
    final result = await showProductStockAdjustDialog(
      context,
      title: _adjustTitle,
      submitText: _adjustSubmitText,
      cancelText: _cancelText,
    );
    if (result == null) return;
    try {
      await _supportService!.adjustStock(
        stock.id,
        adjustType: result.adjustType,
        quantity: result.quantity,
        reason: result.reason,
      );
      if (!mounted) return;
      ToastUtil.showSuccess(_adjustSuccessText);
      await viewModel.loadStocks(resetPage: false);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_adjustErrorText$err');
    }
  }

  static String _pageInfoText(ProductStockViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<ProductStockViewModel>(
      builder: (context, viewModel, _) {
        final stocks = viewModel.stocks;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, stocks, isMobile),
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
    ProductStockViewModel viewModel,
    List<ProductStock> stocks,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    Widget listContent;
    if (viewModel.loading && stocks.isEmpty) {
      listContent = const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null && !viewModel.loading) {
      listContent = ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadStocks(resetPage: true),
      );
    } else if (!viewModel.loading && stocks.isEmpty) {
      listContent = const EmptyStateCard(
        icon: Icons.warehouse_outlined,
        text: _emptyText,
      );
    } else {
      if (!isMobile) {
        listContent = _buildDesktopTable(context, viewModel, stocks);
      } else {
        listContent = ListView.separated(
          itemCount: stocks.length,
          separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
          itemBuilder: (context, index) {
            final stock = stocks[index];
            return _buildSummaryCard(context, viewModel, stock, isMobile);
          },
        );
      }
    }

    return listContent;
  }

  Widget _buildDesktopTable(
    BuildContext context,
    ProductStockViewModel viewModel,
    List<ProductStock> stocks,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('产品')),
        DataColumn(label: Text('来源')),
        DataColumn(label: Text('批次')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('库存')),
        DataColumn(label: Text('预留')),
        DataColumn(label: Text('可用')),
        DataColumn(label: Text('待办')),
        DataColumn(label: Text('库位')),
        DataColumn(label: Text('到期日')),
        DataColumn(label: Text('库存价值')),
        DataColumn(label: Text('操作')),
      ],
      rows: stocks
          .map(
            (stock) => DataRow(
              cells: [
                DataCell(
                  InkWell(
                    onTap: () => _openDetailDialog(stock),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _displayText(stock.productName),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(Text(_sourceSummary(stock), style: textStyle)),
                DataCell(Text(_displayText(stock.batchNo), style: textStyle)),
                DataCell(Text(
                  _displayText(stock.statusDisplay ?? stock.status),
                  style: textStyle,
                )),
                DataCell(Text(_formatAmount(stock.quantity), style: textStyle)),
                DataCell(Text(_formatAmount(stock.reservedQuantity),
                    style: textStyle)),
                DataCell(Text(_formatAmount(stock.availableQuantity),
                    style: textStyle)),
                DataCell(Text(_followUpText(stock), style: textStyle)),
                DataCell(Text(_displayText(stock.location), style: textStyle)),
                DataCell(Text(_formatDate(stock.expiryDate), style: textStyle)),
                DataCell(Text(_formatAmount(stock.totalValue),
                    style: theme.textTheme.bodyMedium)),
                DataCell(RowActionGroup(
                  actions: [
                    if ((stock.customerName ?? '').trim().isNotEmpty)
                      RowAction(
                        label: '去发货',
                        icon: Icons.local_shipping_outlined,
                        onPressed: () => _openDeliveryList(stock.customerName!),
                      ),
                    RowAction(
                      label: _adjustTitle,
                      onPressed: () =>
                          _openAdjustDialog(context, viewModel, stock),
                    ),
                  ],
                )),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    ProductStockViewModel viewModel,
    bool isMobile,
  ) {
    void openFilterDrawer() {
      showAdaptiveFilterDrawer(
        context,
        isMobile: isMobile,
        child: _buildFilterPanel(
          context,
          viewModel,
          bottomSpacing: isMobile ? 16 : 20,
        ),
      );
    }

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeFilters = _activeFilterCount(viewModel);
          final reservedCount = _summaryCount(
            viewModel,
            'reserved_count',
            fallback: viewModel.stocks
                .where((stock) => (stock.status ?? '') == 'reserved')
                .length,
          );
          final qualityCount = _summaryCount(
            viewModel,
            'quality_check_count',
            fallback: viewModel.stocks
                .where((stock) => (stock.status ?? '') == 'quality_check')
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
            if (reservedCount > 0)
              StatusHintChip(
                label: '待发货库存',
                count: reservedCount,
                icon: Icons.local_shipping_outlined,
                selected: viewModel.statusFilter == 'reserved',
                onTap: () => _openQuickFilter(status: 'reserved'),
              ),
            if (qualityCount > 0)
              StatusHintChip(
                label: '待质检库存',
                count: qualityCount,
                icon: Icons.fact_check_outlined,
                selected: viewModel.statusFilter == 'quality_check',
                onTap: () => _openQuickFilter(status: 'quality_check'),
              ),
            if (_hasRouteQuickFilter(viewModel))
              OutlinedButton.icon(
                onPressed: () => context.go('/inventory/stocks'),
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: const Text('清除筛选'),
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadStocks(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.outlined(
              onPressed: _lowStockLoading ? null : _openLowStockDialog,
              icon: const Icon(Icons.warning_amber_outlined, size: 16),
              label: _lowStockText,
            ),
            PageActionButton.outlined(
              onPressed: _expiredLoading ? null : _openExpiredDialog,
              icon: const Icon(Icons.event_busy_outlined, size: 16),
              label: _expiredText,
            ),
            PageActionButton.outlined(
              onPressed: openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: activeFilters > 0 ? '筛选 $activeFilters' : '筛选',
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

  Widget _buildFilterPanel(
    BuildContext context,
    ProductStockViewModel viewModel, {
    required double bottomSpacing,
  }) {
    final statusValue =
        viewModel.statusFilter.isEmpty ? '' : viewModel.statusFilter;
    return FilterPanelBody(
      bottomSpacing: bottomSpacing,
      resetLabel: _resetButtonText,
      onReset: () => _resetFilters(context, viewModel),
      fields: [
        AppSelect<String>(
          key: ValueKey<String>(statusValue),
          value: statusValue,
          decoration: const InputDecoration(labelText: _statusFilterLabel),
          options: const [
            AppDropdownOption(value: '', label: '全部状态'),
            AppDropdownOption(value: 'in_stock', label: '在库'),
            AppDropdownOption(value: 'reserved', label: '已预留'),
            AppDropdownOption(value: 'quality_check', label: '质检中'),
            AppDropdownOption(value: 'defective', label: '次品'),
          ],
          onChanged: (value) => viewModel.setStatusFilter(value ?? ''),
        ),
      ],
    );
  }

  int _activeFilterCount(ProductStockViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.statusFilter.isNotEmpty) count += 1;
    return count;
  }

  void _resetFilters(
    BuildContext context,
    ProductStockViewModel viewModel,
  ) {
    if (_hasRouteQuickFilter(viewModel) ||
        _searchController.text.trim().isNotEmpty) {
      context.go('/inventory/stocks');
      return;
    }
    _searchController.clear();
    viewModel.setSearchText('');
    if (viewModel.statusFilter.isNotEmpty) {
      viewModel.setStatusFilter('');
    } else {
      viewModel.loadStocks(resetPage: true);
    }
  }

  bool _hasRouteQuickFilter(ProductStockViewModel viewModel) {
    return viewModel.statusFilter.isNotEmpty;
  }

  int _summaryCount(
    ProductStockViewModel viewModel,
    String key, {
    required int fallback,
  }) {
    final value = viewModel.summary[key];
    if (value is int) return value;
    final parsed = int.tryParse(value?.toString() ?? '');
    return parsed ?? fallback;
  }

  void _openQuickFilter({required String status}) {
    context.go(
      Uri(
        path: '/inventory/stocks',
        queryParameters: {'status': status},
      ).toString(),
    );
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _sourceSummary(ProductStock stock) {
    final customer = (stock.customerName ?? '').trim();
    final workOrder = (stock.workOrderNumber ?? '').trim();
    if (customer.isNotEmpty && workOrder.isNotEmpty) {
      return '$customer · $workOrder';
    }
    if (customer.isNotEmpty) return customer;
    if (workOrder.isNotEmpty) return workOrder;
    final productCode = (stock.productCode ?? '').trim();
    return productCode.isEmpty ? _emptyCellText : productCode;
  }

  String _followUpText(ProductStock stock) {
    switch (stock.status ?? '') {
      case 'quality_check':
        return '待完成质检';
      case 'reserved':
        return '待安排发货';
      case 'in_stock':
        return '可备货/发货';
      case 'defective':
        return '待处置次品';
      default:
        return _emptyCellText;
    }
  }

  void _openDeliveryList(String keyword) {
    final uri = Uri(
      path: '/inventory/delivery',
      queryParameters: {'search': keyword},
    );
    context.go(uri.toString());
  }

  Widget _buildSummaryCard(
    BuildContext context,
    ProductStockViewModel viewModel,
    ProductStock stock,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final productName = _displayText(stock.productName);
    final productCode = _displayText(stock.productCode);
    final customer = _displayText(stock.customerName);
    final workOrder = _displayText(stock.workOrderNumber);
    final quantity = _formatAmount(stock.quantity);
    final reserved = _formatAmount(stock.reservedQuantity);
    final available = _formatAmount(stock.availableQuantity);
    final totalValue = _formatAmount(stock.totalValue);
    final status = stock.statusDisplay ?? stock.status ?? _emptyCellText;
    final expiryDate = _formatDate(stock.expiryDate);

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
                    onTap: () => _openDetailDialog(stock),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        productName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    _sourceSummary(stock),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '可用', value: available),
                      _SummaryChip(label: '状态', value: status),
                      _SummaryChip(label: '待办', value: _followUpText(stock)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
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
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileFields(
            context,
            productCode: productCode,
            customer: customer,
            workOrder: workOrder,
            quantity: quantity,
            reserved: reserved,
            available: available,
            totalValue: totalValue,
            status: status,
            followUp: _followUpText(stock),
            expiryDate: expiryDate,
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if ((stock.customerName ?? '').trim().isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () => _openDeliveryList(stock.customerName!),
                  icon: const Icon(Icons.local_shipping_outlined, size: 16),
                  label: const Text('去发货'),
                ),
              OutlinedButton.icon(
                onPressed: () => _openAdjustDialog(context, viewModel, stock),
                icon: const Icon(Icons.tune, size: 16),
                label: const Text(_adjustTitle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockDialogList(
    List<ProductStock> items, {
    bool highlightLowStock = false,
    bool highlightExpired = false,
  }) {
    if (items.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.inventory_outlined,
        text: '暂无数据',
      );
    }
    return SizedBox(
      height: 360,
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final stock = items[index];
          final qty = _formatAmount(stock.quantity);
          final available = _formatAmount(stock.availableQuantity);
          final expiry = _formatDate(stock.expiryDate);
          final days = stock.daysUntilExpiry;
          final daysText = days == null
              ? _emptyCellText
              : days >= 0
                  ? '$days 天'
                  : '已过期 ${days.abs()} 天';
          final title = _displayText(stock.productName);
          final subtitle =
              '批次: ${_displayText(stock.batchNo)} · 库位: ${_displayText(stock.location)}';
          Color? valueColor;
          if (highlightLowStock && (stock.isLowStock ?? false)) {
            valueColor = Theme.of(context).colorScheme.tertiary;
          }
          if (highlightExpired && (days != null && days < 0)) {
            valueColor = Theme.of(context).colorScheme.error;
          }
          return Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          )),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      ProductStockInlineMeta(
                          label: '库存', value: qty, valueColor: valueColor),
                      ProductStockInlineMeta(label: '可用', value: available),
                      ProductStockInlineMeta(label: '到期', value: expiry),
                      ProductStockInlineMeta(label: '剩余', value: daysText),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildMobileFields(
    BuildContext context, {
    required String productCode,
    required String customer,
    required String workOrder,
    required String quantity,
    required String reserved,
    required String available,
    required String totalValue,
    required String status,
    required String followUp,
    required String expiryDate,
  }) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.extension<AppColors>()?.subtleText ?? theme.hintColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileRow(context, labelStyle, '产品编码', productCode),
        _mobileRow(context, labelStyle, '客户', customer),
        _mobileRow(context, labelStyle, '施工单', workOrder),
        _mobileRow(context, labelStyle, '库存', quantity),
        _mobileRow(context, labelStyle, '预留', reserved),
        _mobileRow(context, labelStyle, '可用', available),
        _mobileRow(context, labelStyle, '库存价值', totalValue),
        _mobileRow(context, labelStyle, '状态', status),
        _mobileRow(context, labelStyle, '下一步', followUp),
        _mobileRow(context, labelStyle, '到期日', expiryDate, last: true),
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
