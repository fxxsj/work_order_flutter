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
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

/// 产品列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProductListEntry extends StatefulWidget {
  const ProductListEntry({super.key});

  @override
  State<ProductListEntry> createState() => _ProductListEntryState();
}

class _ProductListEntryState extends State<ProductListEntry> {
  ProductApiService? _apiService;
  ProductRepositoryImpl? _repository;
  ProductViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = ProductApiService(apiClient);
    _repository = ProductRepositoryImpl(_apiService!);
    _viewModel = ProductViewModel(_repository!);
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
        Provider<ProductApiService>.value(value: apiService),
        Provider<ProductRepository>.value(value: repository),
        ChangeNotifierProvider<ProductViewModel>.value(value: viewModel),
      ],
      child: const ProductListPage(),
    );
  }
}

/// 产品列表页视图，只负责渲染。
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) => const _ProductListView();
}

class _ProductListView extends StatefulWidget {
  const _ProductListView();

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<_ProductListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索产品名称/编码';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建产品';
  static const String _emptyText = '暂无产品数据';
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

  void _scheduleSearch(ProductViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadProducts(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadProducts(resetPage: true);
    });
  }

  static String _pageInfoText(ProductViewModel viewModel) {
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

    return Consumer<ProductViewModel>(
      builder: (context, viewModel, _) {
        final products = viewModel.products;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, products, isMobile),
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
    ProductViewModel viewModel,
    List<Product> products,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadProducts(resetPage: true),
      );
    }
    if (!viewModel.loading && products.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.inventory_2_outlined,
        text: _emptyText,
      );
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildSummaryCard(context, product, isMobile);
      },
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    ProductViewModel viewModel,
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
              onPressed: () => viewModel.loadProducts(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.filled(
              onPressed: null,
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

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }

  String _formatStatus(bool? isActive) {
    if (isActive == null) return _emptyCellText;
    return isActive ? '启用' : '停用';
  }

  Widget _buildSummaryCard(
    BuildContext context,
    Product product,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final title = product.name;
    final code = product.code.isEmpty ? _emptyCellText : product.code;
    final type = product.productTypeDisplay ?? _emptyCellText;
    final group = product.productGroupName ?? _emptyCellText;
    final spec = product.specification ?? _emptyCellText;
    final unit = product.unit ?? _emptyCellText;
    final price = _formatAmount(product.unitPrice);
    final stock = _formatAmount(product.stockQuantity);
    final status = _formatStatus(product.isActive);

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
                    '$code · $type',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '状态', value: status),
                      _SummaryChip(label: '单价', value: price),
                      _SummaryChip(label: '库存', value: stock),
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
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '产品编码', value: code),
              _SummaryField(label: '产品类型', value: type),
              _SummaryField(label: '产品组', value: group),
              _SummaryField(label: '规格', value: spec),
              _SummaryField(label: '单位', value: unit),
              _SummaryField(label: '单价', value: price),
              _SummaryField(label: '库存', value: stock),
              _SummaryField(label: '状态', value: status),
            ],
          ),
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
