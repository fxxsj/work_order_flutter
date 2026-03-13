import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';
import 'package:work_order_app/src/features/products/presentation/product_edit_page.dart';

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
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除产品 \"{name}\" 吗？此操作不可恢复。';
  static const String _cancelText = '取消';
  static const String _deleteText = '删除';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';
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

  Future<void> _openEditPage(
    BuildContext context,
    ProductViewModel viewModel,
    Product? product,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ProductEditPage(product: product),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(product == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductViewModel viewModel,
    Product product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', product.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(_cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(_deleteText),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await viewModel.deleteProduct(product.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_deleteSuccessText)),
      );
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_deleteFailedText$err')),
      );
    }
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

    return Consumer<ProductViewModel>(
      builder: (context, viewModel, _) {
        final products = viewModel.products;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, products, isMobile),
          footer: viewModel.totalPages > 1 ? ResponsivePaginationBar(
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

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, products);
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildSummaryCard(context, viewModel, product, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    ProductViewModel viewModel,
    List<Product> products,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('产品')),
        DataColumn(label: Text('编码')),
        DataColumn(label: Text('类型')),
        DataColumn(label: Text('规格')),
        DataColumn(label: Text('单位')),
        DataColumn(label: Text('单价')),
        DataColumn(label: Text('库存')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('操作')),
      ],
      rows: products
          .map(
            (product) => DataRow(
              cells: [
                DataCell(Text(
                  product.name.isNotEmpty ? product.name : _emptyCellText,
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(
                  product.code.isNotEmpty ? product.code : _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(
                  product.productTypeDisplay ?? _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(
                  product.specification ?? _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(product.unit ?? _emptyCellText, style: textStyle)),
                DataCell(Text(_formatAmount(product.unitPrice), style: textStyle)),
                DataCell(
                    Text(_formatAmount(product.stockQuantity), style: textStyle)),
                DataCell(
                    Text(_formatStatus(product.isActive), style: textStyle)),
                DataCell(Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () =>
                          _openEditPage(context, viewModel, product),
                      child: const Text('编辑'),
                    ),
                    TextButton(
                      onPressed: () =>
                          _confirmDelete(context, viewModel, product),
                      child: const Text('删除'),
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
    ProductViewModel viewModel,
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
              onPressed: () => viewModel.loadProducts(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.filled(
              onPressed: () => _openEditPage(context, viewModel, null),
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
    ProductViewModel viewModel,
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
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openEditPage(context, viewModel, product),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, viewModel, product),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('删除'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
