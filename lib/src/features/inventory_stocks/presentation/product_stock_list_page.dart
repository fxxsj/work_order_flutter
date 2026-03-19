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
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= ProductStockSupportService(context.read<ApiClient>());
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
        DataColumn(label: Text('批次')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('库存')),
        DataColumn(label: Text('预留')),
        DataColumn(label: Text('可用')),
        DataColumn(label: Text('库位')),
        DataColumn(label: Text('到期日')),
        DataColumn(label: Text('库存价值')),
        DataColumn(label: Text('操作')),
      ],
      rows: stocks
          .map(
            (stock) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(stock.productName),
                  style: theme.textTheme.bodyMedium,
                )),
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
                DataCell(Text(_displayText(stock.location), style: textStyle)),
                DataCell(Text(_formatDate(stock.expiryDate), style: textStyle)),
                DataCell(Text(_formatAmount(stock.totalValue),
                    style: theme.textTheme.bodyMedium)),
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '查看',
                      onPressed: () => _openDetailDialog(stock),
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
      if (isMobile) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          builder: (sheetContext) {
            return ProductStockFilterDrawerContent(
              title: '筛选',
              child: _buildFilterPanel(
                sheetContext,
                viewModel,
                bottomSpacing: 16,
              ),
            );
          },
        );
        return;
      }

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '筛选',
        barrierColor: Colors.black.withValues(alpha: 0.3),
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Theme.of(dialogContext).colorScheme.surface,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: SizedBox(
                width: 360,
                height: double.infinity,
                child: SafeArea(
                  child: ProductStockFilterDrawerContent(
                    title: '筛选',
                    child: _buildFilterPanel(
                      dialogContext,
                      viewModel,
                      bottomSpacing: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final offsetTween =
              Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
          return SlideTransition(
            position: animation
                .drive(
                  CurveTween(curve: Curves.easeOutCubic),
                )
                .drive(offsetTween),
            child: child,
          );
        },
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
    final spacing = LayoutTokens.formSectionSpacing(context);
    final statusValue =
        viewModel.statusFilter.isEmpty ? '' : viewModel.statusFilter;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchableDropdownFormField<String>(
          key: ValueKey<String>(statusValue),
          initialValue: statusValue,
          isExpanded: true,
          decoration: const InputDecoration(labelText: _statusFilterLabel),
          items: const [
            DropdownMenuItem(value: '', child: Text('全部状态')),
            DropdownMenuItem(value: 'in_stock', child: Text('在库')),
            DropdownMenuItem(value: 'reserved', child: Text('已预留')),
            DropdownMenuItem(value: 'quality_check', child: Text('质检中')),
            DropdownMenuItem(value: 'defective', child: Text('次品')),
          ],
          onChanged: (value) => viewModel.setStatusFilter(value ?? ''),
        ),
        SizedBox(height: bottomSpacing < spacing ? spacing : bottomSpacing),
        Row(
          children: [
            PageActionButton.outlined(
              onPressed: () => _resetFilters(viewModel),
              icon: const Icon(Icons.restart_alt, size: 16),
              label: _resetButtonText,
            ),
            SizedBox(width: spacing),
            PageActionButton.filled(
              onPressed: () => Navigator.of(context).maybePop(),
              label: '完成',
            ),
          ],
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [content],
    );
  }

  int _activeFilterCount(ProductStockViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.statusFilter.isNotEmpty) count += 1;
    return count;
  }

  void _resetFilters(ProductStockViewModel viewModel) {
    _searchController.clear();
    viewModel.setSearchText('');
    if (viewModel.statusFilter.isNotEmpty) {
      viewModel.setStatusFilter('');
    } else {
      viewModel.loadStocks(resetPage: true);
    }
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
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
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
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openDetailDialog(stock),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('查看'),
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
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
