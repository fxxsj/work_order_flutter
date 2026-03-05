import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_repository_impl.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_edit_page.dart';

/// 供应商列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class SupplierListEntry extends StatefulWidget {
  const SupplierListEntry({super.key});

  @override
  State<SupplierListEntry> createState() => _SupplierListEntryState();
}

class _SupplierListEntryState extends State<SupplierListEntry> {
  SupplierApiService? _apiService;
  SupplierRepositoryImpl? _repository;
  SupplierViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = SupplierApiService(apiClient);
    _repository = SupplierRepositoryImpl(_apiService!);
    _viewModel = SupplierViewModel(_repository!);
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
        Provider<SupplierApiService>.value(value: apiService),
        Provider<SupplierRepository>.value(value: repository),
        ChangeNotifierProvider<SupplierViewModel>.value(value: viewModel),
      ],
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
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
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
  static const String _clearText = '清空';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';
  static const String _densityComfortLabel = '舒适';
  static const String _densityCompactLabel = '紧凑';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_SupplierColumn> _visibleColumns = {
    _SupplierColumn.code,
    _SupplierColumn.name,
    _SupplierColumn.contact,
    _SupplierColumn.phone,
    _SupplierColumn.status,
    _SupplierColumn.materialCount,
    _SupplierColumn.notes,
    _SupplierColumn.actions,
  };

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

  void _openColumnsMenu(BuildContext context) {
    final menuContext = _columnsMenuKey.currentContext;
    final renderBox = menuContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final overlay = Overlay.of(menuContext!, rootOverlay: true).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<_SupplierColumn>(
      context: menuContext,
      position: position,
      items: _SupplierColumn.optionalValues.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_SupplierColumn>(
          value: value,
          checked: checked,
          child: Text(value.label),
          onTap: () {
            setState(() {
              if (checked && _visibleColumns.length > 2) {
                _visibleColumns.remove(value);
              } else {
                _visibleColumns.add(value);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _openEditPage(BuildContext context, SupplierViewModel viewModel, Supplier? supplier) async {
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
      ToastUtil.showSuccess(supplier == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(BuildContext context, SupplierViewModel viewModel, Supplier supplier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', supplier.name)),
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

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<SupplierViewModel>(
      builder: (context, viewModel, _) {
        final suppliers = viewModel.suppliers;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, suppliers, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
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
    if (viewModel.loading && suppliers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadSuppliers(resetPage: true),
      );
    }
    if (!viewModel.loading && suppliers.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.builder(
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final supplier = suppliers[index];
          return _SupplierListTile(
            supplier: supplier,
            onEdit: () => _openEditPage(context, viewModel, supplier),
            onDelete: () => _confirmDelete(context, viewModel, supplier),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, suppliers);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: _denseTable ? 16 : 24,
                horizontalMargin: _denseTable ? 12 : 16,
                headingRowHeight: _denseTable ? 38 : 44,
                dataRowMinHeight: _denseTable ? 34 : 40,
                dataRowMaxHeight: _denseTable ? 44 : 52,
                columns: columns,
                rows: rows,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    SupplierViewModel viewModel,
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
          final searchField = SizedBox(
            width: isMobile ? constraints.maxWidth : _searchWidth,
            child: SizedBox(
              height: PageActionStyle.height,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  return TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (_) => _scheduleSearch(viewModel),
                    onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
                    decoration: InputDecoration(
                      constraints: const BoxConstraints.tightFor(height: PageActionStyle.height),
                      hintText: _searchHintText,
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: value.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: _clearText,
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _scheduleSearch(viewModel, immediate: true);
                              },
                            ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                  );
                },
              ),
            ),
          );

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchField,
                const SizedBox(height: _spacingSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PageActionButton.outlined(
                      onPressed: () => viewModel.loadSuppliers(resetPage: true),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: _refreshButtonText,
                    ),
                    const SizedBox(width: _spacingSm),
                    PageActionButton.filled(
                      onPressed: () => _openEditPage(context, viewModel, null),
                      icon: const Icon(Icons.add),
                      label: _createButtonText,
                    ),
                  ],
                ),
              ],
            );
          }

          return Wrap(
            spacing: _spacingSm,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              searchField,
              PageActionButton.outlined(
                onPressed: () => viewModel.loadSuppliers(resetPage: true),
                icon: const Icon(Icons.refresh, size: 16),
                label: _refreshButtonText,
              ),
              PageActionButton.outlined(
                key: _columnsMenuKey,
                onPressed: () => _openColumnsMenu(context),
                icon: const Icon(Icons.view_column_outlined, size: 18),
                square: true,
              ),
              ToggleButtons(
                isSelected: [_denseTable == false, _denseTable == true],
                onPressed: (index) {
                  setState(() {
                    _denseTable = index == 1;
                  });
                },
                borderRadius: BorderRadius.circular(_controlRadius),
                constraints: const BoxConstraints(minHeight: _controlHeight, minWidth: 52),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(_densityComfortLabel),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(_densityCompactLabel),
                  ),
                ],
              ),
              PageActionButton.filled(
                onPressed: () => _openEditPage(context, viewModel, null),
                icon: const Icon(Icons.add),
                label: _createButtonText,
              ),
            ],
          );
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = <DataColumn>[];
    if (_visibleColumns.contains(_SupplierColumn.code)) {
      columns.add(const DataColumn(label: Text('供应商编码')));
    }
    if (_visibleColumns.contains(_SupplierColumn.name)) {
      columns.add(const DataColumn(label: Text('供应商名称')));
    }
    if (_visibleColumns.contains(_SupplierColumn.contact)) {
      columns.add(const DataColumn(label: Text('联系人')));
    }
    if (_visibleColumns.contains(_SupplierColumn.phone)) {
      columns.add(const DataColumn(label: Text('联系电话')));
    }
    if (_visibleColumns.contains(_SupplierColumn.email)) {
      columns.add(const DataColumn(label: Text('邮箱')));
    }
    if (_visibleColumns.contains(_SupplierColumn.status)) {
      columns.add(const DataColumn(label: Text('状态')));
    }
    if (_visibleColumns.contains(_SupplierColumn.materialCount)) {
      columns.add(const DataColumn(label: Text('供应物料数')));
    }
    if (_visibleColumns.contains(_SupplierColumn.notes)) {
      columns.add(const DataColumn(label: Text('备注')));
    }
    if (_visibleColumns.contains(_SupplierColumn.actions)) {
      columns.add(const DataColumn(label: Text('操作')));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context, SupplierViewModel viewModel, List<Supplier> suppliers) {
    final theme = Theme.of(context);
    return suppliers.map((supplier) {
      final cells = <DataCell>[];
      if (_visibleColumns.contains(_SupplierColumn.code)) {
        cells.add(DataCell(Text(_displayText(supplier.code))));
      }
      if (_visibleColumns.contains(_SupplierColumn.name)) {
        cells.add(DataCell(Text(_displayText(supplier.name))));
      }
      if (_visibleColumns.contains(_SupplierColumn.contact)) {
        cells.add(DataCell(Text(_displayText(supplier.contactPerson))));
      }
      if (_visibleColumns.contains(_SupplierColumn.phone)) {
        cells.add(DataCell(Text(_displayText(supplier.phone))));
      }
      if (_visibleColumns.contains(_SupplierColumn.email)) {
        cells.add(DataCell(Text(_displayText(supplier.email))));
      }
      if (_visibleColumns.contains(_SupplierColumn.status)) {
        cells.add(DataCell(_statusPill(theme, supplier)));
      }
      if (_visibleColumns.contains(_SupplierColumn.materialCount)) {
        cells.add(DataCell(Text(_displayNumber(supplier.materialCount))));
      }
      if (_visibleColumns.contains(_SupplierColumn.notes)) {
        cells.add(
          DataCell(
            SizedBox(
              width: 200,
              child: Text(
                _displayText(supplier.notes),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }
      if (_visibleColumns.contains(_SupplierColumn.actions)) {
        cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '编辑',
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: () => _openEditPage(context, viewModel, supplier),
                ),
                IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(context, viewModel, supplier),
                ),
              ],
            ),
          ),
        );
      }
      return DataRow(cells: cells);
    }).toList();
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  static String _displayNumber(int? value) {
    if (value == null) return _emptyCellText;
    return value.toString();
  }

  static Widget _statusPill(ThemeData theme, Supplier supplier) {
    final rawStatus = supplier.status?.toLowerCase();
    final label = supplier.statusDisplay ?? supplier.status ?? _emptyCellText;
    if (rawStatus == null || rawStatus.isEmpty) {
      return Text(_displayText(label));
    }
    Color background;
    Color foreground;
    if (rawStatus == 'active' || rawStatus == 'enabled') {
      background = theme.colorScheme.primary.withOpacity(0.12);
      foreground = theme.colorScheme.primary;
    } else if (rawStatus == 'inactive' || rawStatus == 'disabled') {
      background = theme.colorScheme.outline.withOpacity(0.2);
      foreground = theme.colorScheme.outline;
    } else {
      background = theme.colorScheme.secondary.withOpacity(0.12);
      foreground = theme.colorScheme.secondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(color: foreground),
      ),
    );
  }
}

enum _SupplierColumn {
  code,
  name,
  contact,
  phone,
  email,
  status,
  materialCount,
  notes,
  actions;

  static const List<_SupplierColumn> optionalValues = [
    _SupplierColumn.code,
    _SupplierColumn.contact,
    _SupplierColumn.phone,
    _SupplierColumn.email,
    _SupplierColumn.status,
    _SupplierColumn.materialCount,
    _SupplierColumn.notes,
  ];

  String get label {
    switch (this) {
      case _SupplierColumn.code:
        return '供应商编码';
      case _SupplierColumn.name:
        return '供应商名称';
      case _SupplierColumn.contact:
        return '联系人';
      case _SupplierColumn.phone:
        return '联系电话';
      case _SupplierColumn.email:
        return '邮箱';
      case _SupplierColumn.status:
        return '状态';
      case _SupplierColumn.materialCount:
        return '供应物料数';
      case _SupplierColumn.notes:
        return '备注';
      case _SupplierColumn.actions:
        return '操作';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final SupplierViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(info, style: theme.textTheme.bodySmall),
        const SizedBox(width: 12),
        DropdownButton<int>(
          value: viewModel.pageSize,
          items: viewModel.pageSizeOptions
              .map(
                (size) => DropdownMenuItem<int>(
                  value: size,
                  child: Text(_pageSizeLabel.replaceFirst('{size}', size.toString())),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            viewModel.setPageSize(value);
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: viewModel.hasPrev ? () => viewModel.setPage(viewModel.page - 1) : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text('${viewModel.page}', style: theme.textTheme.bodyMedium),
        IconButton(
          onPressed: viewModel.hasNext ? () => viewModel.setPage(viewModel.page + 1) : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _SupplierListTile extends StatelessWidget {
  const _SupplierListTile({
    required this.supplier,
    this.onEdit,
    this.onDelete,
  });

  static const double _padding = 12;
  static const double _spacing = 6;

  final Supplier supplier;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    supplier.name.isNotEmpty ? supplier.name : _SupplierListViewState._emptyCellText,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _SupplierListViewState._statusPill(theme, supplier),
              ],
            ),
            const SizedBox(height: _spacing),
            _InfoRow(label: '编码', value: supplier.code),
            _InfoRow(label: '联系人', value: supplier.contactPerson),
            _InfoRow(label: '电话', value: supplier.phone),
            _InfoRow(label: '邮箱', value: supplier.email),
            _InfoRow(label: '物料数', value: supplier.materialCount?.toString()),
            if ((supplier.notes ?? '').trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: _spacing),
                child: Text(
                  supplier.notes!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ),
            if (onEdit != null || onDelete != null) ...[
              const SizedBox(height: _spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('编辑'),
                    ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 4),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_outline, size: 16, color: theme.colorScheme.error),
                      label: Text('删除', style: TextStyle(color: theme.colorScheme.error)),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  static const double _spacing = 6;

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = (value ?? '').trim().isEmpty ? _SupplierListViewState._emptyCellText : value!;
    return Padding(
      padding: const EdgeInsets.only(top: _spacing),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  static const double _verticalPadding = 32;
  static const double _borderRadius = 12;
  static const double _iconSize = 36;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: theme.colorScheme.primary.withOpacity(0.05),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Icon(Icons.storefront_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _SupplierListViewState._spacingSm),
          Text(_SupplierListViewState._emptyText, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  static const double _verticalPadding = 32;
  static const double _borderRadius = 12;
  static const double _iconSize = 32;

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: theme.colorScheme.error.withOpacity(0.06),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: _iconSize),
          const SizedBox(height: _SupplierListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _SupplierListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_SupplierListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
