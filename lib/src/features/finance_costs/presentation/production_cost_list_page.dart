import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/finance_costs/application/production_cost_view_model.dart';
import 'package:work_order_app/src/features/finance_costs/data/production_cost_api_service.dart';
import 'package:work_order_app/src/features/finance_costs/data/production_cost_repository_impl.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost.dart';
import 'package:work_order_app/src/features/finance_costs/domain/production_cost_repository.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';

/// 成本核算列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProductionCostListEntry extends StatelessWidget {
  const ProductionCostListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProductionCostApiService, ProductionCostRepository,
        ProductionCostViewModel>(
      createService: (context) =>
          ProductionCostApiService(context.read<ApiClient>()),
      createRepository: (context) => ProductionCostRepositoryImpl(
          context.read<ProductionCostApiService>()),
      createViewModel: (context) =>
          ProductionCostViewModel(context.read<ProductionCostRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductionCostListPage(),
    );
  }
}

/// 成本核算列表页视图，只负责渲染。
class ProductionCostListPage extends StatelessWidget {
  const ProductionCostListPage({super.key});

  @override
  Widget build(BuildContext context) => const _ProductionCostListView();
}

class _ProductionCostListView extends StatefulWidget {
  const _ProductionCostListView();

  @override
  State<_ProductionCostListView> createState() =>
      _ProductionCostListViewState();
}

class _ProductionCostListViewState extends State<_ProductionCostListView> {
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索施工单号';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无成本数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  final _debounce = DebounceController();

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(ProductionCostViewModel viewModel,
      {bool immediate = false}) {
    if (immediate) {
      _debounce.cancel();
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadCosts(resetPage: true);
      return;
    }
    _debounce.run(() {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadCosts(resetPage: true);
    });
  }

  Future<void> _calculateMaterial(
    ProductionCostViewModel viewModel,
    ProductionCost cost,
  ) async {
    try {
      final apiService = context.read<ProductionCostApiService>();
      await apiService.calculateMaterial(cost.id);
      ToastUtil.showSuccess('材料成本已计算');
      await viewModel.loadCosts(resetPage: false);
    } catch (err) {
      ToastUtil.showError('计算失败: $err');
    }
  }

  Future<void> _calculateTotal(
    ProductionCostViewModel viewModel,
    ProductionCost cost,
  ) async {
    try {
      final apiService = context.read<ProductionCostApiService>();
      await apiService.calculateTotal(cost.id);
      ToastUtil.showSuccess('总成本已更新');
      await viewModel.loadCosts(resetPage: false);
    } catch (err) {
      ToastUtil.showError('计算失败: $err');
    }
  }

  static String _pageInfoText(ProductionCostViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<ProductionCostViewModel>(
      builder: (context, viewModel, _) {
        final costs = viewModel.costs;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, costs, isMobile),
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
    ProductionCostViewModel viewModel,
    List<ProductionCost> costs,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && costs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadCosts(resetPage: true),
      );
    }
    if (!viewModel.loading && costs.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.pie_chart_outline,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, costs);
    }

    return ListView.separated(
      itemCount: costs.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final cost = costs[index];
        return _buildSummaryCard(context, cost, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    ProductionCostViewModel viewModel,
    List<ProductionCost> costs,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('总成本')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('计算时间')),
        DataColumn(label: Text('操作')),
      ],
      rows: costs
          .map(
            (cost) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(cost.workOrderNumber ?? '成本 #${cost.id}'),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(_formatAmount(cost.totalCost), style: textStyle)),
                DataCell(Text(
                  cost.statusDisplay ?? cost.status ?? _emptyCellText,
                  style: textStyle,
                )),
                DataCell(
                    Text(_formatDate(cost.calculatedAt), style: textStyle)),
                DataCell(_buildRowActions(viewModel, cost)),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    ProductionCostViewModel viewModel,
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
              onPressed: () => viewModel.loadCosts(resetPage: true),
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

  Widget _buildRowActions(
    ProductionCostViewModel viewModel,
    ProductionCost cost,
  ) {
    final actions = <RowAction>[
      RowAction(
        label: '计算材料',
        icon: Icons.auto_fix_high_outlined,
        onPressed: () => _calculateMaterial(viewModel, cost),
      ),
      RowAction(
        label: '计算总成本',
        icon: Icons.calculate_outlined,
        onPressed: () => _calculateTotal(viewModel, cost),
      ),
    ];
    return RowActionGroup(actions: actions, primaryCount: 2);
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
      BuildContext context, ProductionCost cost, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final workOrder = _displayText(cost.workOrderNumber ?? '成本 #${cost.id}');
    final totalCost = _formatAmount(cost.totalCost);
    final status = cost.statusDisplay ?? cost.status ?? _emptyCellText;
    final calculatedAt = _formatDate(cost.calculatedAt);
    final actions = <RowAction>[
      RowAction(
        label: '计算材料',
        icon: Icons.auto_fix_high_outlined,
        onPressed: () =>
            _calculateMaterial(context.read<ProductionCostViewModel>(), cost),
      ),
      RowAction(
        label: '计算总成本',
        icon: Icons.calculate_outlined,
        onPressed: () =>
            _calculateTotal(context.read<ProductionCostViewModel>(), cost),
      ),
    ];

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
                    workOrder,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '总成本', value: totalCost),
                      _SummaryChip(label: '状态', value: status),
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
                  calculatedAt,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors?.subtleText ?? theme.hintColor,
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
            workOrder: workOrder,
            totalCost: totalCost,
            status: status,
            calculatedAt: calculatedAt,
          ),
          SizedBox(height: sectionSpacing),
          RowActionGroup(actions: actions, primaryCount: 2),
        ],
      ),
    );
  }

  static Widget _buildMobileFields(
    BuildContext context, {
    required String workOrder,
    required String totalCost,
    required String status,
    required String calculatedAt,
  }) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.extension<AppColors>()?.subtleText ?? theme.hintColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileRow(context, labelStyle, '施工单号', workOrder),
        _mobileRow(context, labelStyle, '总成本', totalCost),
        _mobileRow(context, labelStyle, '状态', status),
        _mobileRow(context, labelStyle, '计算时间', calculatedAt, last: true),
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
