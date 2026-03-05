import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/finance_payments/application/payment_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_repository_impl.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';

/// 收款列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class PaymentListEntry extends StatefulWidget {
  const PaymentListEntry({super.key});

  @override
  State<PaymentListEntry> createState() => _PaymentListEntryState();
}

class _PaymentListEntryState extends State<PaymentListEntry> {
  PaymentApiService? _apiService;
  PaymentRepositoryImpl? _repository;
  PaymentViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = PaymentApiService(apiClient);
    _repository = PaymentRepositoryImpl(_apiService!);
    _viewModel = PaymentViewModel(_repository!);
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
        Provider<PaymentApiService>.value(value: apiService),
        Provider<PaymentRepository>.value(value: repository),
        ChangeNotifierProvider<PaymentViewModel>.value(value: viewModel),
      ],
      child: const PaymentListPage(),
    );
  }
}

/// 收款列表页视图，只负责渲染。
class PaymentListPage extends StatelessWidget {
  const PaymentListPage({super.key});

  @override
  Widget build(BuildContext context) => const _PaymentListView();
}

class _PaymentListView extends StatefulWidget {
  const _PaymentListView();

  @override
  State<_PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<_PaymentListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索收款单号/客户';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无收款数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_PaymentColumn> _visibleColumns = {
    _PaymentColumn.paymentNumber,
    _PaymentColumn.customer,
    _PaymentColumn.workOrder,
    _PaymentColumn.amount,
    _PaymentColumn.status,
    _PaymentColumn.paymentDate,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(PaymentViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPayments(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPayments(resetPage: true);
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

    showMenu<_PaymentColumn>(
      context: menuContext,
      position: position,
      items: _paymentOptionalColumns.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_PaymentColumn>(
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

    return Consumer<PaymentViewModel>(
      builder: (context, viewModel, _) {
        final payments = viewModel.payments;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, payments, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    PaymentViewModel viewModel,
    List<Payment> payments,
    bool isMobile,
  ) {
    if (viewModel.loading && payments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadPayments(resetPage: true),
      );
    }
    if (!viewModel.loading && payments.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.separated(
        itemCount: payments.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final payment = payments[index];
          return ListTile(
            title: Text(payment.paymentNumber ?? '收款 #${payment.id}'),
            subtitle: Text('${payment.customerName ?? _emptyCellText} · ${payment.statusDisplay ?? _emptyCellText}'),
            trailing: Text(_formatAmount(payment.amount)),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(payments);

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
    PaymentViewModel viewModel,
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
                      onPressed: () => viewModel.loadPayments(resetPage: true),
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
                onPressed: () => viewModel.loadPayments(resetPage: true),
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
    return _PaymentColumn.values
        .where(_visibleColumns.contains)
        .map(
          (column) => DataColumn(
            label: Text(column.label),
          ),
        )
        .toList();
  }

  List<DataRow> _buildRows(List<Payment> payments) {
    return payments.map((payment) {
      final cells = _PaymentColumn.values
          .where(_visibleColumns.contains)
          .map((column) => DataCell(_buildCell(payment, column)))
          .toList();
      return DataRow(cells: cells);
    }).toList();
  }

  Widget _buildCell(Payment payment, _PaymentColumn column) {
    switch (column) {
      case _PaymentColumn.paymentNumber:
        return Text(payment.paymentNumber ?? '收款 #${payment.id}');
      case _PaymentColumn.customer:
        return Text(payment.customerName ?? _emptyCellText);
      case _PaymentColumn.workOrder:
        return Text(payment.workOrderNumber ?? _emptyCellText);
      case _PaymentColumn.amount:
        return Text(_formatAmount(payment.amount));
      case _PaymentColumn.status:
        return Text(payment.statusDisplay ?? payment.status ?? _emptyCellText);
      case _PaymentColumn.paymentDate:
        return Text(_formatDate(payment.paymentDate));
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

  final PaymentViewModel viewModel;

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
          Icon(Icons.payments_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _PaymentListViewState._spacingSm),
          Text(_PaymentListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _PaymentListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _PaymentListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_PaymentListViewState._retryText),
          ),
        ],
      ),
    );
  }
}

enum _PaymentColumn {
  paymentNumber,
  customer,
  workOrder,
  amount,
  status,
  paymentDate,
}

const List<_PaymentColumn> _paymentOptionalColumns = [
  _PaymentColumn.paymentNumber,
  _PaymentColumn.customer,
  _PaymentColumn.workOrder,
  _PaymentColumn.amount,
  _PaymentColumn.status,
  _PaymentColumn.paymentDate,
];

extension _PaymentColumnLabel on _PaymentColumn {
  String get label {
    switch (this) {
      case _PaymentColumn.paymentNumber:
        return '收款单号';
      case _PaymentColumn.customer:
        return '客户';
      case _PaymentColumn.workOrder:
        return '施工单号';
      case _PaymentColumn.amount:
        return '金额';
      case _PaymentColumn.status:
        return '状态';
      case _PaymentColumn.paymentDate:
        return '收款日期';
    }
  }
}
