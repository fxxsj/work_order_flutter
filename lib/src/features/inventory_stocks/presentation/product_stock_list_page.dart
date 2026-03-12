import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/inventory_stocks/application/product_stock_view_model.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_api_service.dart';
import 'package:work_order_app/src/features/inventory_stocks/data/product_stock_repository_impl.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock.dart';
import 'package:work_order_app/src/features/inventory_stocks/domain/product_stock_repository.dart';

/// 成品库存列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProductStockListEntry extends StatefulWidget {
  const ProductStockListEntry({super.key});

  @override
  State<ProductStockListEntry> createState() => _ProductStockListEntryState();
}

class _ProductStockListEntryState extends State<ProductStockListEntry> {
  ProductStockApiService? _apiService;
  ProductStockRepositoryImpl? _repository;
  ProductStockViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = ProductStockApiService(apiClient);
    _repository = ProductStockRepositoryImpl(_apiService!);
    _viewModel = ProductStockViewModel(_repository!);
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
        Provider<ProductStockApiService>.value(value: apiService),
        Provider<ProductStockRepository>.value(value: repository),
        ChangeNotifierProvider<ProductStockViewModel>.value(value: viewModel),
      ],
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
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索产品名称/编码';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无库存数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _breadcrumbSeparator = ' / ';
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

  void _scheduleSearch(ProductStockViewModel viewModel, {bool immediate = false}) {
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

  static String _pageInfoText(ProductStockViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<ProductStockViewModel>(
      builder: (context, viewModel, _) {
        final stocks = viewModel.stocks;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, stocks, isMobile),
          footer: viewModel.total > 0
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
    if (viewModel.loading && stocks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadStocks(resetPage: true),
      );
    }
    if (!viewModel.loading && stocks.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.warehouse_outlined,
        text: _emptyText,
      );
    }

    return ListView.separated(
      itemCount: stocks.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return _buildSummaryCard(context, stock, isMobile);
      },
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    ProductStockViewModel viewModel,
    List<String> breadcrumb,
    bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb: breadcrumb.isEmpty ? null : breadcrumb.join(_breadcrumbSeparator),
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
              onPressed: () => viewModel.loadStocks(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
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

  Widget _buildSummaryCard(BuildContext context, ProductStock stock, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final productName = _displayText(stock.productName);
    final productCode = _displayText(stock.productCode);
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
                  Text(
                    productName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    productCode,
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
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
        );
      },
      expandedChild: SummaryFieldWrap(
        isMobile: isMobile,
        children: [
          _SummaryField(label: '产品编码', value: productCode),
          _SummaryField(label: '施工单', value: workOrder),
          _SummaryField(label: '库存', value: quantity),
          _SummaryField(label: '预留', value: reserved),
          _SummaryField(label: '可用', value: available),
          _SummaryField(label: '库存价值', value: totalValue),
          _SummaryField(label: '状态', value: status),
          _SummaryField(label: '到期日', value: expiryDate),
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
