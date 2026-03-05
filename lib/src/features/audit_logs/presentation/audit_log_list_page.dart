import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/audit_logs/application/audit_log_view_model.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_api_service.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_repository_impl.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';

/// 审计日志列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class AuditLogListEntry extends StatefulWidget {
  const AuditLogListEntry({super.key});

  @override
  State<AuditLogListEntry> createState() => _AuditLogListEntryState();
}

class _AuditLogListEntryState extends State<AuditLogListEntry> {
  AuditLogApiService? _apiService;
  AuditLogRepositoryImpl? _repository;
  AuditLogViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = AuditLogApiService(apiClient);
    _repository = AuditLogRepositoryImpl(_apiService!);
    _viewModel = AuditLogViewModel(_repository!);
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
        Provider<AuditLogApiService>.value(value: apiService),
        Provider<AuditLogRepository>.value(value: repository),
        ChangeNotifierProvider<AuditLogViewModel>.value(value: viewModel),
      ],
      child: const AuditLogListPage(),
    );
  }
}

/// 审计日志列表页视图，只负责渲染。
class AuditLogListPage extends StatelessWidget {
  const AuditLogListPage({super.key});

  @override
  Widget build(BuildContext context) => const _AuditLogListView();
}

class _AuditLogListView extends StatefulWidget {
  const _AuditLogListView();

  @override
  State<_AuditLogListView> createState() => _AuditLogListViewState();
}

class _AuditLogListViewState extends State<_AuditLogListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索用户/对象/类型';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无审计日志';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_AuditColumn> _visibleColumns = {
    _AuditColumn.id,
    _AuditColumn.actionType,
    _AuditColumn.username,
    _AuditColumn.contentType,
    _AuditColumn.objectRepr,
    _AuditColumn.changedFields,
    _AuditColumn.ipAddress,
    _AuditColumn.createdAt,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(AuditLogViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadLogs(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadLogs(resetPage: true);
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

    showMenu<_AuditColumn>(
      context: menuContext,
      position: position,
      items: _auditOptionalColumns.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_AuditColumn>(
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

    return Consumer<AuditLogViewModel>(
      builder: (context, viewModel, _) {
        final logs = viewModel.logs;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, logs, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    AuditLogViewModel viewModel,
    List<AuditLog> logs,
    bool isMobile,
  ) {
    if (viewModel.loading && logs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadLogs(resetPage: true),
      );
    }
    if (!viewModel.loading && logs.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.separated(
        itemCount: logs.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final log = logs[index];
          return ListTile(
            title: Text(log.objectRepr ?? '日志 #${log.id}'),
            subtitle: Text('${log.username ?? _emptyCellText} · ${log.actionType ?? _emptyCellText}'),
            trailing: Text(_formatDateTime(log.createdAt)),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(logs);

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
    AuditLogViewModel viewModel,
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
                      onPressed: () => viewModel.loadLogs(resetPage: true),
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
                onPressed: () => viewModel.loadLogs(resetPage: true),
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
    return _AuditColumn.values
        .where(_visibleColumns.contains)
        .map(
          (column) => DataColumn(
            label: Text(column.label),
          ),
        )
        .toList();
  }

  List<DataRow> _buildRows(List<AuditLog> logs) {
    return logs.map((log) {
      final cells = _AuditColumn.values
          .where(_visibleColumns.contains)
          .map((column) => DataCell(_buildCell(log, column)))
          .toList();
      return DataRow(cells: cells);
    }).toList();
  }

  Widget _buildCell(AuditLog log, _AuditColumn column) {
    switch (column) {
      case _AuditColumn.id:
        return Text(log.id.toString());
      case _AuditColumn.actionType:
        return Text(log.actionType ?? _emptyCellText);
      case _AuditColumn.username:
        return Text(log.username ?? _emptyCellText);
      case _AuditColumn.contentType:
        return Text(log.contentTypeName ?? _emptyCellText);
      case _AuditColumn.objectRepr:
        return Text(log.objectRepr ?? _emptyCellText);
      case _AuditColumn.changedFields:
        return Text(log.changedFields ?? _emptyCellText);
      case _AuditColumn.ipAddress:
        return Text(log.ipAddress ?? _emptyCellText);
      case _AuditColumn.createdAt:
        return Text(_formatDateTime(log.createdAt));
    }
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final AuditLogViewModel viewModel;

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
          Icon(Icons.manage_search, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _AuditLogListViewState._spacingSm),
          Text(_AuditLogListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _AuditLogListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _AuditLogListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_AuditLogListViewState._retryText),
          ),
        ],
      ),
    );
  }
}

enum _AuditColumn {
  id,
  actionType,
  username,
  contentType,
  objectRepr,
  changedFields,
  ipAddress,
  createdAt,
}

const List<_AuditColumn> _auditOptionalColumns = [
  _AuditColumn.id,
  _AuditColumn.actionType,
  _AuditColumn.username,
  _AuditColumn.contentType,
  _AuditColumn.objectRepr,
  _AuditColumn.changedFields,
  _AuditColumn.ipAddress,
  _AuditColumn.createdAt,
];

extension _AuditColumnLabel on _AuditColumn {
  String get label {
    switch (this) {
      case _AuditColumn.id:
        return 'ID';
      case _AuditColumn.actionType:
        return '操作类型';
      case _AuditColumn.username:
        return '用户';
      case _AuditColumn.contentType:
        return '对象类型';
      case _AuditColumn.objectRepr:
        return '对象';
      case _AuditColumn.changedFields:
        return '变更字段';
      case _AuditColumn.ipAddress:
        return 'IP';
      case _AuditColumn.createdAt:
        return '时间';
    }
  }
}
