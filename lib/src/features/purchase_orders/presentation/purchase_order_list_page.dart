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
import 'package:work_order_app/src/features/purchase_orders/application/purchase_order_view_model.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_order_repository_impl.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_repository.dart';

/// 采购单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class PurchaseOrderListEntry extends StatefulWidget {
  const PurchaseOrderListEntry({super.key});

  @override
  State<PurchaseOrderListEntry> createState() => _PurchaseOrderListEntryState();
}

class _PurchaseOrderListEntryState extends State<PurchaseOrderListEntry> {
  PurchaseOrderApiService? _apiService;
  PurchaseOrderRepositoryImpl? _repository;
  PurchaseOrderViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = PurchaseOrderApiService(apiClient);
    _repository = PurchaseOrderRepositoryImpl(_apiService!);
    _viewModel = PurchaseOrderViewModel(_repository!);
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
        Provider<PurchaseOrderApiService>.value(value: apiService),
        Provider<PurchaseOrderRepository>.value(value: repository),
        ChangeNotifierProvider<PurchaseOrderViewModel>.value(value: viewModel),
      ],
      child: const PurchaseOrderListPage(),
    );
  }
}

/// 采购单列表页视图，只负责渲染。
class PurchaseOrderListPage extends StatelessWidget {
  const PurchaseOrderListPage({super.key});

  @override
  Widget build(BuildContext context) => const _PurchaseOrderListView();
}

class _PurchaseOrderListView extends StatefulWidget {
  const _PurchaseOrderListView();

  @override
  State<_PurchaseOrderListView> createState() => _PurchaseOrderListViewState();
}

class _PurchaseOrderListViewState extends State<_PurchaseOrderListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索采购单号/供应商';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建采购单';
  static const String _emptyText = '暂无采购单数据';
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

  void _scheduleSearch(PurchaseOrderViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPurchaseOrders(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPurchaseOrders(resetPage: true);
    });
  }

  static String _pageInfoText(PurchaseOrderViewModel viewModel) {
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

    return Consumer<PurchaseOrderViewModel>(
      builder: (context, viewModel, _) {
        final orders = viewModel.purchaseOrders;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, orders, isMobile),
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
    PurchaseOrderViewModel viewModel,
    List<PurchaseOrder> orders,
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
        onRetry: () => viewModel.loadPurchaseOrders(resetPage: true),
      );
    }
    if (!viewModel.loading && orders.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.receipt_long_outlined,
        text: _emptyText,
      );
    }

    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildSummaryCard(context, order, isMobile);
      },
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    PurchaseOrderViewModel viewModel,
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
            height: PageActionStyle.height,
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
              onPressed: () => viewModel.loadPurchaseOrders(resetPage: true),
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

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }

  Widget _buildSummaryCard(BuildContext context, PurchaseOrder order, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number =
        order.orderNumber.isEmpty ? '采购单 #${order.id}' : order.orderNumber;
    final supplier = _displayText(order.supplierName);
    final status = order.statusDisplay ?? order.status ?? _emptyCellText;
    final totalAmount = _formatAmount(order.totalAmount);
    final itemsCount = order.itemsCount?.toString() ?? _emptyCellText;
    final receivedProgress = order.receivedProgress == null
        ? _emptyCellText
        : '${order.receivedProgress!.toStringAsFixed(0)}%';
    final workOrder = _displayText(order.workOrderNumber);

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
                    number,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    supplier,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '金额', value: totalAmount),
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
          _SummaryField(label: '采购单号', value: number),
          _SummaryField(label: '供应商', value: supplier),
          _SummaryField(label: '状态', value: status),
          _SummaryField(label: '金额', value: totalAmount),
          _SummaryField(label: '明细数', value: itemsCount),
          _SummaryField(label: '收货进度', value: receivedProgress),
          _SummaryField(label: '关联施工单', value: workOrder),
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
