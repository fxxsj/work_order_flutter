import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/finance_statements/application/statement_view_model.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_api_service.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_repository_impl.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';

/// 对账单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class StatementListEntry extends StatefulWidget {
  const StatementListEntry({super.key});

  @override
  State<StatementListEntry> createState() => _StatementListEntryState();
}

class _StatementListEntryState extends State<StatementListEntry> {
  StatementApiService? _apiService;
  StatementRepositoryImpl? _repository;
  StatementViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = StatementApiService(apiClient);
    _repository = StatementRepositoryImpl(_apiService!);
    _viewModel = StatementViewModel(_repository!);
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
        Provider<StatementApiService>.value(value: apiService),
        Provider<StatementRepository>.value(value: repository),
        ChangeNotifierProvider<StatementViewModel>.value(value: viewModel),
      ],
      child: const StatementListPage(),
    );
  }
}

/// 对账单列表页视图，只负责渲染。
class StatementListPage extends StatelessWidget {
  const StatementListPage({super.key});

  @override
  Widget build(BuildContext context) => const _StatementListView();
}

class _StatementListView extends StatefulWidget {
  const _StatementListView();

  @override
  State<_StatementListView> createState() => _StatementListViewState();
}

class _StatementListViewState extends State<_StatementListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索对账单号/客户';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无对账单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_StatementColumn> _visibleColumns = {
    _StatementColumn.statementNumber,
    _StatementColumn.customer,
    _StatementColumn.period,
    _StatementColumn.totalAmount,
    _StatementColumn.status,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(StatementViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStatements(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStatements(resetPage: true);
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

    showMenu<_StatementColumn>(
      context: menuContext,
      position: position,
      items: _statementOptionalColumns.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_StatementColumn>(
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

    return Consumer<StatementViewModel>(
      builder: (context, viewModel, _) {
        final statements = viewModel.statements;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, statements, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    StatementViewModel viewModel,
    List<Statement> statements,
    bool isMobile,
  ) {
    if (viewModel.loading && statements.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadStatements(resetPage: true),
      );
    }
    if (!viewModel.loading && statements.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.separated(
        itemCount: statements.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final statement = statements[index];
          return ListTile(
            title: Text(statement.statementNumber ?? '对账单 #${statement.id}'),
            subtitle: Text('${statement.customerName ?? _emptyCellText} · ${statement.statusDisplay ?? _emptyCellText}'),
            trailing: Text(_formatAmount(statement.totalAmount)),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(statements);

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
    StatementViewModel viewModel,
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
                      onPressed: () => viewModel.loadStatements(resetPage: true),
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
                onPressed: () => viewModel.loadStatements(resetPage: true),
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
    return _StatementColumn.values
        .where(_visibleColumns.contains)
        .map(
          (column) => DataColumn(
            label: Text(column.label),
          ),
        )
        .toList();
  }

  List<DataRow> _buildRows(List<Statement> statements) {
    return statements.map((statement) {
      final cells = _StatementColumn.values
          .where(_visibleColumns.contains)
          .map((column) => DataCell(_buildCell(statement, column)))
          .toList();
      return DataRow(cells: cells);
    }).toList();
  }

  Widget _buildCell(Statement statement, _StatementColumn column) {
    switch (column) {
      case _StatementColumn.statementNumber:
        return Text(statement.statementNumber ?? '对账单 #${statement.id}');
      case _StatementColumn.customer:
        return Text(statement.customerName ?? _emptyCellText);
      case _StatementColumn.period:
        return Text(_formatPeriod(statement.periodStart, statement.periodEnd));
      case _StatementColumn.totalAmount:
        return Text(_formatAmount(statement.totalAmount));
      case _StatementColumn.status:
        return Text(statement.statusDisplay ?? statement.status ?? _emptyCellText);
    }
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }

  String _formatPeriod(DateTime? start, DateTime? end) {
    if (start == null && end == null) return _emptyCellText;
    final startText = _formatDate(start);
    final endText = _formatDate(end);
    return '$startText ~ $endText';
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

  final StatementViewModel viewModel;

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
          Icon(Icons.summarize_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _StatementListViewState._spacingSm),
          Text(_StatementListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _StatementListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _StatementListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_StatementListViewState._retryText),
          ),
        ],
      ),
    );
  }
}

enum _StatementColumn {
  statementNumber,
  customer,
  period,
  totalAmount,
  status,
}

const List<_StatementColumn> _statementOptionalColumns = [
  _StatementColumn.statementNumber,
  _StatementColumn.customer,
  _StatementColumn.period,
  _StatementColumn.totalAmount,
  _StatementColumn.status,
];

extension _StatementColumnLabel on _StatementColumn {
  String get label {
    switch (this) {
      case _StatementColumn.statementNumber:
        return '对账单号';
      case _StatementColumn.customer:
        return '客户';
      case _StatementColumn.period:
        return '对账周期';
      case _StatementColumn.totalAmount:
        return '金额';
      case _StatementColumn.status:
        return '状态';
    }
  }
}
