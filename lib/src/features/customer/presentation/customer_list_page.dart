import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_edit_page.dart';
import 'package:work_order_app/src/features/customer/presentation/widgets/customer_list_tile.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';

/// 客户列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class CustomerListEntry extends StatefulWidget {
  const CustomerListEntry({super.key});

  @override
  State<CustomerListEntry> createState() => _CustomerListEntryState();
}

class _CustomerListEntryState extends State<CustomerListEntry> {
  CustomerApiService? _apiService;
  CustomerRepositoryImpl? _repository;
  CustomerViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = CustomerApiService(apiClient);
    _repository = CustomerRepositoryImpl(_apiService!);
    _viewModel = CustomerViewModel(_repository!);
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
        Provider<CustomerApiService>.value(value: apiService),
        Provider<CustomerRepository>.value(value: repository),
        ChangeNotifierProvider<CustomerViewModel>.value(value: viewModel),
      ],
      child: const CustomerListPage(),
    );
  }
}

/// 客户列表页视图，只负责渲染。
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) => const _CustomerListView();
}

class _CustomerListView extends StatefulWidget {
  const _CustomerListView();

  @override
  State<_CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<_CustomerListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 260;
  static const double _spacingSm = 8;
  static const double _controlHeight = 36;
  static const double _controlRadius = 4;
  static const double _controlMinWidth = 88;
  static const double _iconButtonSize = 36;
  static const String _emptyCellText = '-';

  static const String _titleText = '客户管理';
  static const String _createButtonText = '新建客户';
  static const String _searchHintText = '搜索客户名称、联系人、电话';
  static const String _searchButtonText = '搜索';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无客户数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除客户 \"{name}\" 吗？此操作不可恢复。';
  static const String _cancelText = '取消';
  static const String _deleteText = '删除';
  static const String _clearText = '清空';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';
  static const String _densityComfortLabel = '舒适';
  static const String _densityCompactLabel = '紧凑';
  static const String _columnsLabel = '列管理';
  static const String _totalLabel = '共 {count} 条';
  static const String _pageLabel = '第 {page} / {total} 页';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_CustomerColumn> _visibleColumns = {
    _CustomerColumn.name,
    _CustomerColumn.contact,
    _CustomerColumn.phone,
    _CustomerColumn.email,
    _CustomerColumn.salesperson,
    _CustomerColumn.updatedAt,
    _CustomerColumn.actions,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(CustomerViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadCustomers(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadCustomers(resetPage: true);
    });
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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

    showMenu<_CustomerColumn>(
      context: menuContext,
      position: position,
      items: _CustomerColumn.optionalValues.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_CustomerColumn>(
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

  Future<void> _openEditPage(BuildContext context, CustomerViewModel viewModel, Customer? customer) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: CustomerEditPage(customer: customer),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(customer == null ? _createSuccessText : _updateSuccessText)),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, CustomerViewModel viewModel, Customer customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', customer.name)),
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
      await viewModel.deleteCustomer(customer.id);
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
    final theme = Theme.of(context);
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<CustomerViewModel>(
      builder: (context, viewModel, _) {
        final customers = viewModel.customers;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(
              context,
              theme,
              viewModel,
              breadcrumb,
              isMobile,
            ),
            const SizedBox(height: _spacingSm),
            Expanded(
              child: _buildListBody(context, viewModel, customers, isMobile),
            ),
            if (viewModel.total > 0) ...[
              const SizedBox(height: _spacingSm),
              _PaginationBar(viewModel: viewModel),
            ],
          ],
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    CustomerViewModel viewModel,
    List<Customer> customers,
    bool isMobile,
  ) {
    if (viewModel.loading && customers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadCustomers(resetPage: true),
      );
    }
    if (!viewModel.loading && customers.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return CustomerListTile(
            customer: customer,
            onTap: () => _openEditPage(context, viewModel, customer),
            onDelete: () => _confirmDelete(context, viewModel, customer),
            useCard: isMobile,
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, customers);

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
    ThemeData theme,
    CustomerViewModel viewModel,
    List<String> breadcrumb,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumb.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              breadcrumb.join(_breadcrumbSeparator),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: _spacingSm,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: _searchWidth,
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, _) {
                          return TextField(
                            controller: _searchController,
                            onChanged: (_) => _scheduleSearch(viewModel),
                            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
                            decoration: InputDecoration(
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: _controlHeight,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(_controlMinWidth, _controlHeight),
                          fixedSize: const Size(_controlMinWidth, _controlHeight),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_controlRadius),
                          ),
                        ),
                        onPressed: () => viewModel.loadCustomers(resetPage: true),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text(_refreshButtonText),
                      ),
                    ),
                    if (!isMobile)
                      SizedBox(
                        height: _controlHeight,
                        width: _iconButtonSize,
                        child: OutlinedButton(
                          key: _columnsMenuKey,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(_iconButtonSize, _controlHeight),
                            fixedSize: const Size(_iconButtonSize, _controlHeight),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_controlRadius),
                            ),
                          ),
                          onPressed: () => _openColumnsMenu(context),
                          child: const Icon(Icons.view_column_outlined, size: 18),
                        ),
                      ),
                    if (!isMobile)
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
                    SizedBox(
                      height: _controlHeight,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, _controlHeight),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_controlRadius),
                          ),
                        ),
                        onPressed: () => _openEditPage(context, viewModel, null),
                        icon: const Icon(Icons.add),
                        label: const Text(_createButtonText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = <DataColumn>[];
    if (_visibleColumns.contains(_CustomerColumn.name)) {
      columns.add(const DataColumn(label: Text('客户名称')));
    }
    if (_visibleColumns.contains(_CustomerColumn.contact)) {
      columns.add(const DataColumn(label: Text('联系人')));
    }
    if (_visibleColumns.contains(_CustomerColumn.phone)) {
      columns.add(const DataColumn(label: Text('电话')));
    }
    if (_visibleColumns.contains(_CustomerColumn.email)) {
      columns.add(const DataColumn(label: Text('邮箱')));
    }
    if (_visibleColumns.contains(_CustomerColumn.salesperson)) {
      columns.add(const DataColumn(label: Text('业务员')));
    }
    if (_visibleColumns.contains(_CustomerColumn.updatedAt)) {
      columns.add(const DataColumn(label: Text('最近更新')));
    }
    if (_visibleColumns.contains(_CustomerColumn.actions)) {
      columns.add(const DataColumn(label: Text('操作')));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context, CustomerViewModel viewModel, List<Customer> customers) {
    final theme = Theme.of(context);
    return customers.map((customer) {
      final cells = <DataCell>[];
      if (_visibleColumns.contains(_CustomerColumn.name)) {
        cells.add(DataCell(Text(customer.name.isNotEmpty ? customer.name : _emptyCellText)));
      }
      if (_visibleColumns.contains(_CustomerColumn.contact)) {
        cells.add(DataCell(Text(customer.contactPerson?.trim().isNotEmpty == true
            ? customer.contactPerson!
            : _emptyCellText)));
      }
      if (_visibleColumns.contains(_CustomerColumn.phone)) {
        cells.add(DataCell(Text(customer.phone?.trim().isNotEmpty == true ? customer.phone! : _emptyCellText)));
      }
      if (_visibleColumns.contains(_CustomerColumn.email)) {
        cells.add(DataCell(Text(customer.email?.trim().isNotEmpty == true ? customer.email! : _emptyCellText)));
      }
      if (_visibleColumns.contains(_CustomerColumn.salesperson)) {
        cells.add(DataCell(Text(customer.salespersonName?.trim().isNotEmpty == true
            ? customer.salespersonName!
            : _emptyCellText)));
      }
      if (_visibleColumns.contains(_CustomerColumn.updatedAt)) {
        cells.add(DataCell(Text(_formatDate(customer.updatedAt))));
      }
      if (_visibleColumns.contains(_CustomerColumn.actions)) {
        cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '编辑',
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: () => _openEditPage(context, viewModel, customer),
                ),
                IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(context, viewModel, customer),
                ),
              ],
            ),
          ),
        );
      }
      return DataRow(cells: cells);
    }).toList();
  }
}

enum _CustomerColumn {
  name,
  contact,
  phone,
  email,
  salesperson,
  updatedAt,
  actions;

  static const List<_CustomerColumn> optionalValues = [
    _CustomerColumn.contact,
    _CustomerColumn.phone,
    _CustomerColumn.email,
    _CustomerColumn.salesperson,
    _CustomerColumn.updatedAt,
  ];

  String get label {
    switch (this) {
      case _CustomerColumn.name:
        return '客户名称';
      case _CustomerColumn.contact:
        return '联系人';
      case _CustomerColumn.phone:
        return '电话';
      case _CustomerColumn.email:
        return '邮箱';
      case _CustomerColumn.salesperson:
        return '业务员';
      case _CustomerColumn.updatedAt:
        return '最近更新';
      case _CustomerColumn.actions:
        return '操作';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final CustomerViewModel viewModel;

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
          Icon(Icons.people_outline, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _CustomerListViewState._spacingSm),
          Text(_CustomerListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _CustomerListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _CustomerListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_CustomerListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
