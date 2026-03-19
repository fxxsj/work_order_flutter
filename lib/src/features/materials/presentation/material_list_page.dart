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
import 'package:work_order_app/src/features/materials/application/material_view_model.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/data/material_repository_impl.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';
import 'package:work_order_app/src/features/materials/presentation/material_edit_page.dart';

/// 物料列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class MaterialListEntry extends StatelessWidget {
  const MaterialListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<MaterialApiService, MaterialRepository,
        MaterialViewModel>(
      createService: (context) => MaterialApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          MaterialRepositoryImpl(context.read<MaterialApiService>()),
      createViewModel: (context) =>
          MaterialViewModel(context.read<MaterialRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const MaterialListPage(),
    );
  }
}

/// 物料列表页视图，只负责渲染。
class MaterialListPage extends StatelessWidget {
  const MaterialListPage({super.key});

  @override
  Widget build(BuildContext context) => const _MaterialListView();
}

class _MaterialListView extends StatefulWidget {
  const _MaterialListView();

  @override
  State<_MaterialListView> createState() => _MaterialListViewState();
}

class _MaterialListViewState extends State<_MaterialListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索物料名称/编码';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建物料';
  static const String _emptyText = '暂无物料数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除物料 \"{name}\" 吗？此操作不可恢复。';
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

  void _scheduleSearch(MaterialViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadMaterials(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadMaterials(resetPage: true);
    });
  }

  Future<void> _openEditPage(
    BuildContext context,
    MaterialViewModel viewModel,
    MaterialItem? material,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: MaterialEditPage(material: material),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(
          material == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    MaterialViewModel viewModel,
    MaterialItem material,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content:
            Text(_deleteDialogContent.replaceFirst('{name}', material.name)),
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
      await viewModel.deleteMaterial(material.id);
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

  static String _pageInfoText(MaterialViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<MaterialViewModel>(
      builder: (context, viewModel, _) {
        final materials = viewModel.materials;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, materials, isMobile),
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
    MaterialViewModel viewModel,
    List<MaterialItem> materials,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && materials.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadMaterials(resetPage: true),
      );
    }
    if (!viewModel.loading && materials.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.category_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, materials);
    }

    return ListView.separated(
      itemCount: materials.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final material = materials[index];
        return _buildSummaryCard(context, viewModel, material, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    MaterialViewModel viewModel,
    List<MaterialItem> materials,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('物料')),
        DataColumn(label: Text('编码')),
        DataColumn(label: Text('单位')),
        DataColumn(label: Text('单价')),
        DataColumn(label: Text('库存')),
        DataColumn(label: Text('安全库存')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('操作')),
      ],
      rows: materials
          .map(
            (material) => DataRow(
              cells: [
                DataCell(Text(
                  material.name.isNotEmpty ? material.name : _emptyCellText,
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(
                  material.code.isNotEmpty ? material.code : _emptyCellText,
                  style: textStyle,
                )),
                DataCell(
                    Text(material.unit ?? _emptyCellText, style: textStyle)),
                DataCell(
                    Text(_formatAmount(material.unitPrice), style: textStyle)),
                DataCell(Text(_formatAmount(material.stockQuantity),
                    style: textStyle)),
                DataCell(Text(_formatAmount(material.minStockQuantity),
                    style: textStyle)),
                DataCell(
                    Text(_formatStatus(material.isActive), style: textStyle)),
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '编辑',
                      onPressed: () =>
                          _openEditPage(context, viewModel, material),
                    ),
                    RowAction(
                      label: '删除',
                      onPressed: () =>
                          _confirmDelete(context, viewModel, material),
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
    MaterialViewModel viewModel,
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
              onPressed: () => viewModel.loadMaterials(resetPage: true),
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
    MaterialViewModel viewModel,
    MaterialItem material,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final title = material.name;
    final code = material.code.isEmpty ? _emptyCellText : material.code;
    final unit = material.unit ?? _emptyCellText;
    final price = _formatAmount(material.unitPrice);
    final stock = _formatAmount(material.stockQuantity);
    final minStock = _formatAmount(material.minStockQuantity);
    final status = _formatStatus(material.isActive);

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
                    '$code · $unit',
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
                      _SummaryChip(label: '库存', value: stock),
                      _SummaryChip(label: '安全库存', value: minStock),
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
              _SummaryField(label: '物料编码', value: code),
              _SummaryField(label: '单位', value: unit),
              _SummaryField(label: '单价', value: price),
              _SummaryField(label: '库存', value: stock),
              _SummaryField(label: '安全库存', value: minStock),
              _SummaryField(label: '状态', value: status),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openEditPage(context, viewModel, material),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, viewModel, material),
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
