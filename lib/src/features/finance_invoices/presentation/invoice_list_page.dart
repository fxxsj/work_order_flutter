import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/finance_invoices/application/invoice_view_model.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_repository_impl.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';

/// 发票列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class InvoiceListEntry extends StatefulWidget {
  const InvoiceListEntry({super.key});

  @override
  State<InvoiceListEntry> createState() => _InvoiceListEntryState();
}

class _InvoiceListEntryState extends State<InvoiceListEntry> {
  InvoiceApiService? _apiService;
  InvoiceRepositoryImpl? _repository;
  InvoiceViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = InvoiceApiService(apiClient);
    _repository = InvoiceRepositoryImpl(_apiService!);
    _viewModel = InvoiceViewModel(_repository!);
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
        Provider<InvoiceApiService>.value(value: apiService),
        Provider<InvoiceRepository>.value(value: repository),
        ChangeNotifierProvider<InvoiceViewModel>.value(value: viewModel),
      ],
      child: const InvoiceListPage(),
    );
  }
}

/// 发票列表页视图，只负责渲染。
class InvoiceListPage extends StatelessWidget {
  const InvoiceListPage({super.key});

  @override
  Widget build(BuildContext context) => const _InvoiceListView();
}

class _InvoiceListView extends StatefulWidget {
  const _InvoiceListView();

  @override
  State<_InvoiceListView> createState() => _InvoiceListViewState();
}

class _InvoiceListViewState extends State<_InvoiceListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索发票号/客户';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无发票数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_InvoiceColumn> _visibleColumns = {
    _InvoiceColumn.invoiceNumber,
    _InvoiceColumn.customer,
    _InvoiceColumn.workOrder,
    _InvoiceColumn.amount,
    _InvoiceColumn.status,
    _InvoiceColumn.issueDate,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(InvoiceViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInvoices(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInvoices(resetPage: true);
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

    showMenu<_InvoiceColumn>(
      context: menuContext,
      position: position,
      items: _invoiceOptionalColumns.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_InvoiceColumn>(
          value: value,
          checked: checked,
          child: Text(value.label),
          onTap: () {
            setState(() {
              if (checked && _visibleColumns.length > 3) {
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

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<InvoiceViewModel>(
      builder: (context, viewModel, _) {
        final invoices = viewModel.invoices;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, invoices, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    InvoiceViewModel viewModel,
    List<Invoice> invoices,
    bool isMobile,
  ) {
    if (viewModel.loading && invoices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadInvoices(resetPage: true),
      );
    }
    if (!viewModel.loading && invoices.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.separated(
        itemCount: invoices.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return ListTile(
            title: Text(invoice.invoiceNumber ?? '发票 #${invoice.id}'),
            subtitle: Text('${invoice.customerName ?? _emptyCellText} · ${invoice.statusDisplay ?? _emptyCellText}'),
            trailing: Text(_formatAmount(invoice.amount)),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(invoices);

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
    InvoiceViewModel viewModel,
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
              height: _controlHeight,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  return TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (_) => _scheduleSearch(viewModel),
                    onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
                    decoration: InputDecoration(
                      constraints: const BoxConstraints.tightFor(height: _controlHeight),
                      hintText: _searchHintText,
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: value.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: '清空',
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
                      onPressed: () => viewModel.loadInvoices(resetPage: true),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: _refreshButtonText,
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
                onPressed: () => viewModel.loadInvoices(resetPage: true),
                icon: const Icon(Icons.refresh, size: 16),
                label: _refreshButtonText,
              ),
              PageActionButton.outlined(
                onPressed: () => setState(() => _denseTable = !_denseTable),
                icon: Icon(_denseTable ? Icons.table_rows : Icons.table_chart),
                label: _denseTable ? '舒适' : '紧凑',
              ),
              SizedBox(
                key: _columnsMenuKey,
                height: _controlHeight,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_controlRadius),
                    ),
                  ),
                  onPressed: () => _openColumnsMenu(context),
                  icon: const Icon(Icons.view_column, size: 18),
                  label: const Text('列管理'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return _InvoiceColumn.values
        .where(_visibleColumns.contains)
        .map(
          (column) => DataColumn(
            label: Text(column.label),
          ),
        )
        .toList();
  }

  List<DataRow> _buildRows(List<Invoice> invoices) {
    return invoices.map((invoice) {
      final cells = _InvoiceColumn.values
          .where(_visibleColumns.contains)
          .map((column) => DataCell(_buildCell(invoice, column)))
          .toList();
      return DataRow(cells: cells);
    }).toList();
  }

  Widget _buildCell(Invoice invoice, _InvoiceColumn column) {
    switch (column) {
      case _InvoiceColumn.invoiceNumber:
        return Text(invoice.invoiceNumber ?? '发票 #${invoice.id}');
      case _InvoiceColumn.customer:
        return Text(invoice.customerName ?? _emptyCellText);
      case _InvoiceColumn.workOrder:
        return Text(invoice.workOrderNumber ?? _emptyCellText);
      case _InvoiceColumn.amount:
        return Text(_formatAmount(invoice.amount));
      case _InvoiceColumn.status:
        return Text(invoice.statusDisplay ?? invoice.status ?? _emptyCellText);
      case _InvoiceColumn.issueDate:
        return Text(_formatDate(invoice.issueDate));
    }
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
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final InvoiceViewModel viewModel;

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
          Icon(Icons.receipt_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _InvoiceListViewState._spacingSm),
          Text(_InvoiceListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _InvoiceListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _InvoiceListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_InvoiceListViewState._retryText),
          ),
        ],
      ),
    );
  }
}

enum _InvoiceColumn {
  invoiceNumber,
  customer,
  workOrder,
  amount,
  status,
  issueDate,
}

const List<_InvoiceColumn> _invoiceOptionalColumns = [
  _InvoiceColumn.invoiceNumber,
  _InvoiceColumn.customer,
  _InvoiceColumn.workOrder,
  _InvoiceColumn.amount,
  _InvoiceColumn.status,
  _InvoiceColumn.issueDate,
];

extension _InvoiceColumnLabel on _InvoiceColumn {
  String get label {
    switch (this) {
      case _InvoiceColumn.invoiceNumber:
        return '发票号';
      case _InvoiceColumn.customer:
        return '客户';
      case _InvoiceColumn.workOrder:
        return '施工单号';
      case _InvoiceColumn.amount:
        return '金额';
      case _InvoiceColumn.status:
        return '状态';
      case _InvoiceColumn.issueDate:
        return '开票日期';
    }
  }
}
