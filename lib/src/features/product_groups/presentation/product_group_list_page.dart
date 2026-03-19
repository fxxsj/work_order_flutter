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
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/product_groups/application/product_group_view_model.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_api_service.dart';
import 'package:work_order_app/src/features/product_groups/data/product_group_repository_impl.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group.dart';
import 'package:work_order_app/src/features/product_groups/domain/product_group_repository.dart';
import 'package:work_order_app/src/features/product_groups/presentation/product_group_edit_page.dart';

/// 产品组列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProductGroupListEntry extends StatelessWidget {
  const ProductGroupListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<ProductGroupApiService, ProductGroupRepository,
        ProductGroupViewModel>(
      createService: (context) =>
          ProductGroupApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          ProductGroupRepositoryImpl(context.read<ProductGroupApiService>()),
      createViewModel: (context) =>
          ProductGroupViewModel(context.read<ProductGroupRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const ProductGroupListPage(),
    );
  }
}

/// 产品组列表页视图，只负责渲染。
class ProductGroupListPage extends StatelessWidget {
  const ProductGroupListPage({super.key});

  @override
  Widget build(BuildContext context) => const _ProductGroupListView();
}

class _ProductGroupListView extends StatefulWidget {
  const _ProductGroupListView();

  @override
  State<_ProductGroupListView> createState() => _ProductGroupListViewState();
}

class _ProductGroupListViewState extends State<_ProductGroupListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索产品组名称/编码';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建产品组';
  static const String _emptyText = '暂无产品组数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除产品组 \"{name}\" 吗？此操作不可恢复。';
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

  void _scheduleSearch(ProductGroupViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadProductGroups(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadProductGroups(resetPage: true);
    });
  }

  Future<void> _openEditPage(
    BuildContext context,
    ProductGroupViewModel viewModel,
    ProductGroup? group,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ProductGroupEditPage(group: group),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(
          group == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductGroupViewModel viewModel,
    ProductGroup group,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', group.name)),
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
      await viewModel.deleteProductGroup(group.id);
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

  static String _pageInfoText(ProductGroupViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<ProductGroupViewModel>(
      builder: (context, viewModel, _) {
        final groups = viewModel.productGroups;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, groups, isMobile),
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
    ProductGroupViewModel viewModel,
    List<ProductGroup> groups,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && groups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadProductGroups(resetPage: true),
      );
    }
    if (!viewModel.loading && groups.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.group_work_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, groups);
    }

    return ListView.separated(
      itemCount: groups.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final group = groups[index];
        return _buildSummaryCard(context, viewModel, group, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    ProductGroupViewModel viewModel,
    List<ProductGroup> groups,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('产品组')),
        DataColumn(label: Text('编码')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('明细数')),
        DataColumn(label: Text('描述')),
        DataColumn(label: Text('操作')),
      ],
      rows: groups
          .map(
            (group) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(group.name),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(_displayText(group.code), style: textStyle)),
                DataCell(Text(_formatStatus(group.isActive), style: textStyle)),
                DataCell(Text(group.itemsCount?.toString() ?? _emptyCellText,
                    style: textStyle)),
                DataCell(
                    Text(_displayText(group.description), style: textStyle)),
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '编辑',
                      onPressed: () => _openEditPage(context, viewModel, group),
                    ),
                    RowAction(
                      label: '删除',
                      onPressed: () =>
                          _confirmDelete(context, viewModel, group),
                      destructive: true,
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
    ProductGroupViewModel viewModel,
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
              onPressed: () => viewModel.loadProductGroups(resetPage: true),
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

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatStatus(bool? isActive) {
    if (isActive == null) return _emptyCellText;
    return isActive ? '启用' : '停用';
  }

  Widget _buildSummaryCard(
    BuildContext context,
    ProductGroupViewModel viewModel,
    ProductGroup group,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final name = _displayText(group.name);
    final code = _displayText(group.code);
    final description = _displayText(group.description);
    final status = _formatStatus(group.isActive);
    final itemsCount = group.itemsCount?.toString() ?? _emptyCellText;

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
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    code,
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
                      _SummaryChip(label: '明细数', value: itemsCount),
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
              _SummaryField(label: '编码', value: code),
              _SummaryField(label: '状态', value: status),
              _SummaryField(label: '明细数', value: itemsCount),
              _SummaryField(label: '描述', value: description),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openEditPage(context, viewModel, group),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, viewModel, group),
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
