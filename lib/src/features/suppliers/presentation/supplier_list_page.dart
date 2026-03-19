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
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_repository_impl.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_edit_page.dart';

/// 供应商列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class SupplierListEntry extends StatelessWidget {
  const SupplierListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<SupplierApiService, SupplierRepository,
        SupplierViewModel>(
      createService: (context) => SupplierApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          SupplierRepositoryImpl(context.read<SupplierApiService>()),
      createViewModel: (context) =>
          SupplierViewModel(context.read<SupplierRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const SupplierListPage(),
    );
  }
}

/// 供应商列表页视图，只负责渲染。
class SupplierListPage extends StatelessWidget {
  const SupplierListPage({super.key});

  @override
  Widget build(BuildContext context) => const _SupplierListView();
}

class _SupplierListView extends StatefulWidget {
  const _SupplierListView();

  @override
  State<_SupplierListView> createState() => _SupplierListViewState();
}

class _SupplierListViewState extends State<_SupplierListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 300;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索供应商名称/编码';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建供应商';
  static const String _emptyText = '暂无供应商数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除供应商 \"{name}\" 吗？此操作不可恢复。';
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

  void _scheduleSearch(SupplierViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadSuppliers(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadSuppliers(resetPage: true);
    });
  }

  Future<void> _openEditPage(BuildContext context, SupplierViewModel viewModel,
      Supplier? supplier) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: SupplierEditPage(supplier: supplier),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(
          supplier == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(BuildContext context, SupplierViewModel viewModel,
      Supplier supplier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content:
            Text(_deleteDialogContent.replaceFirst('{name}', supplier.name)),
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
      await viewModel.deleteSupplier(supplier.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_deleteSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_deleteFailedText$err');
    }
  }

  static String _pageInfoText(SupplierViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<SupplierViewModel>(
      builder: (context, viewModel, _) {
        final suppliers = viewModel.suppliers;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, suppliers, isMobile),
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
    SupplierViewModel viewModel,
    List<Supplier> suppliers,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && suppliers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadSuppliers(resetPage: true),
      );
    }
    if (!viewModel.loading && suppliers.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.storefront_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, suppliers);
    }

    return ListView.separated(
      itemCount: suppliers.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final supplier = suppliers[index];
        return _buildSummaryCard(context, viewModel, supplier, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    SupplierViewModel viewModel,
    List<Supplier> suppliers,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('供应商')),
        DataColumn(label: Text('编码')),
        DataColumn(label: Text('联系人')),
        DataColumn(label: Text('电话')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('物料数')),
        DataColumn(label: Text('操作')),
      ],
      rows: suppliers
          .map(
            (supplier) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(supplier.name),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(_displayText(supplier.code), style: textStyle)),
                DataCell(Text(_displayText(supplier.contactPerson),
                    style: textStyle)),
                DataCell(Text(_displayText(supplier.phone), style: textStyle)),
                DataCell(Text(_displayStatus(supplier), style: textStyle)),
                DataCell(Text(_displayNumber(supplier.materialCount),
                    style: textStyle)),
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '编辑',
                      onPressed: () =>
                          _openEditPage(context, viewModel, supplier),
                    ),
                    RowAction(
                      label: '删除',
                      onPressed: () =>
                          _confirmDelete(context, viewModel, supplier),
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
    SupplierViewModel viewModel,
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
              onPressed: () => viewModel.loadSuppliers(resetPage: true),
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

  static String _displayNumber(int? value) {
    if (value == null) return _emptyCellText;
    return value.toString();
  }

  Widget _buildSummaryCard(
    BuildContext context,
    SupplierViewModel viewModel,
    Supplier supplier,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final code = _displayText(supplier.code);
    final name = _displayText(supplier.name);
    final contact = _displayText(supplier.contactPerson);
    final phone = _displayText(supplier.phone);
    final email = _displayText(supplier.email);
    final statusText = _displayStatus(supplier);
    final materialCount = _displayNumber(supplier.materialCount);
    final notes = _displayText(supplier.notes);

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
                    '$code · $contact',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '状态', value: statusText),
                      _SummaryChip(label: '物料数', value: materialCount),
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
              _SummaryField(label: '联系人', value: contact),
              _SummaryField(label: '电话', value: phone),
              _SummaryField(label: '邮箱', value: email),
              _SummaryField(label: '状态', value: statusText),
              _SummaryField(label: '供应物料数', value: materialCount),
              _SummaryField(label: '备注', value: notes),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openEditPage(context, viewModel, supplier),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, viewModel, supplier),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('删除'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _displayStatus(Supplier supplier) {
    final label = supplier.statusDisplay ?? supplier.status ?? _emptyCellText;
    return _displayText(label);
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
