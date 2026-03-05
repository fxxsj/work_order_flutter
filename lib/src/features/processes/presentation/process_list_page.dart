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
import 'package:work_order_app/src/features/processes/application/process_view_model.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_repository_impl.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/processes/domain/process_repository.dart';
import 'package:work_order_app/src/features/processes/presentation/process_edit_page.dart';

/// 工序列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class ProcessListEntry extends StatefulWidget {
  const ProcessListEntry({super.key});

  @override
  State<ProcessListEntry> createState() => _ProcessListEntryState();
}

class _ProcessListEntryState extends State<ProcessListEntry> {
  ProcessApiService? _apiService;
  ProcessRepositoryImpl? _repository;
  ProcessViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = ProcessApiService(apiClient);
    _repository = ProcessRepositoryImpl(_apiService!);
    _viewModel = ProcessViewModel(_repository!);
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
        Provider<ProcessApiService>.value(value: apiService),
        Provider<ProcessRepository>.value(value: repository),
        ChangeNotifierProvider<ProcessViewModel>.value(value: viewModel),
      ],
      child: const ProcessListPage(),
    );
  }
}

/// 工序列表页视图，只负责渲染。
class ProcessListPage extends StatelessWidget {
  const ProcessListPage({super.key});

  @override
  Widget build(BuildContext context) => const _ProcessListView();
}

class _ProcessListView extends StatefulWidget {
  const _ProcessListView();

  @override
  State<_ProcessListView> createState() => _ProcessListViewState();
}

class _ProcessListViewState extends State<_ProcessListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 300;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索工序名称、编码';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建工序';
  static const String _emptyText = '暂无工序数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除工序 "{name}" 吗？此操作不可恢复。';
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
  final Set<_ProcessColumn> _visibleColumns = {
    _ProcessColumn.code,
    _ProcessColumn.name,
    _ProcessColumn.description,
    _ProcessColumn.standardDuration,
    _ProcessColumn.sortOrder,
    _ProcessColumn.status,
    _ProcessColumn.actions,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(ProcessViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadProcesses(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadProcesses(resetPage: true);
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

    showMenu<_ProcessColumn>(
      context: menuContext,
      position: position,
      items: _ProcessColumn.optionalValues.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_ProcessColumn>(
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

  Future<void> _openEditPage(BuildContext context, ProcessViewModel viewModel, Process? process) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ProcessEditPage(process: process),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(process == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(BuildContext context, ProcessViewModel viewModel, Process process) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', process.name)),
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
      await viewModel.deleteProcess(process.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_deleteSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_deleteFailedText$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<ProcessViewModel>(
      builder: (context, viewModel, _) {
        final processes = viewModel.processes;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, processes, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    ProcessViewModel viewModel,
    List<Process> processes,
    bool isMobile,
  ) {
    if (viewModel.loading && processes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadProcesses(resetPage: true),
      );
    }
    if (!viewModel.loading && processes.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.builder(
        itemCount: processes.length,
        itemBuilder: (context, index) {
          final process = processes[index];
          return _ProcessListTile(
            process: process,
            onEdit: () => _openEditPage(context, viewModel, process),
            onDelete: () => _confirmDelete(context, viewModel, process),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, processes);

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
    ProcessViewModel viewModel,
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
                      onPressed: () => viewModel.loadProcesses(resetPage: true),
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
                onPressed: () => viewModel.loadProcesses(resetPage: true),
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
    if (_visibleColumns.contains(_ProcessColumn.code)) {
      columns.add(const DataColumn(label: Text('工序编码')));
    }
    if (_visibleColumns.contains(_ProcessColumn.name)) {
      columns.add(const DataColumn(label: Text('工序名称')));
    }
    if (_visibleColumns.contains(_ProcessColumn.description)) {
      columns.add(const DataColumn(label: Text('描述')));
    }
    if (_visibleColumns.contains(_ProcessColumn.standardDuration)) {
      columns.add(const DataColumn(label: Text('标准工时(小时)')));
    }
    if (_visibleColumns.contains(_ProcessColumn.sortOrder)) {
      columns.add(const DataColumn(label: Text('排序')));
    }
    if (_visibleColumns.contains(_ProcessColumn.status)) {
      columns.add(const DataColumn(label: Text('状态')));
    }
    if (_visibleColumns.contains(_ProcessColumn.actions)) {
      columns.add(const DataColumn(label: Text('操作')));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context, ProcessViewModel viewModel, List<Process> processes) {
    final theme = Theme.of(context);
    return processes.map((process) {
      final cells = <DataCell>[];
      if (_visibleColumns.contains(_ProcessColumn.code)) {
        cells.add(DataCell(Text(_displayText(process.code))));
      }
      if (_visibleColumns.contains(_ProcessColumn.name)) {
        cells.add(DataCell(Text(_displayText(process.name))));
      }
      if (_visibleColumns.contains(_ProcessColumn.description)) {
        cells.add(
          DataCell(
            SizedBox(
              width: 220,
              child: Text(
                _displayText(process.description),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }
      if (_visibleColumns.contains(_ProcessColumn.standardDuration)) {
        cells.add(DataCell(Text(_displayDuration(process.standardDuration))));
      }
      if (_visibleColumns.contains(_ProcessColumn.sortOrder)) {
        cells.add(DataCell(Text(_displayNumber(process.sortOrder))));
      }
      if (_visibleColumns.contains(_ProcessColumn.status)) {
        cells.add(DataCell(_statusPill(theme, process.isActive)));
      }
      if (_visibleColumns.contains(_ProcessColumn.actions)) {
        cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '编辑',
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: () => _openEditPage(context, viewModel, process),
                ),
                IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(context, viewModel, process),
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

  static String _displayDuration(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }

  static Widget _statusPill(ThemeData theme, bool isActive) {
    final background = isActive
        ? theme.colorScheme.primary.withOpacity(0.12)
        : theme.colorScheme.outline.withOpacity(0.2);
    final foreground = isActive ? theme.colorScheme.primary : theme.colorScheme.outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isActive ? '启用' : '禁用',
        style: theme.textTheme.bodySmall?.copyWith(color: foreground),
      ),
    );
  }
}

enum _ProcessColumn {
  code,
  name,
  description,
  standardDuration,
  sortOrder,
  status,
  actions;

  static const List<_ProcessColumn> optionalValues = [
    _ProcessColumn.code,
    _ProcessColumn.description,
    _ProcessColumn.standardDuration,
    _ProcessColumn.sortOrder,
    _ProcessColumn.status,
  ];

  String get label {
    switch (this) {
      case _ProcessColumn.code:
        return '工序编码';
      case _ProcessColumn.name:
        return '工序名称';
      case _ProcessColumn.description:
        return '描述';
      case _ProcessColumn.standardDuration:
        return '标准工时(小时)';
      case _ProcessColumn.sortOrder:
        return '排序';
      case _ProcessColumn.status:
        return '状态';
      case _ProcessColumn.actions:
        return '操作';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final ProcessViewModel viewModel;

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

class _ProcessListTile extends StatelessWidget {
  const _ProcessListTile({
    required this.process,
    this.onEdit,
    this.onDelete,
  });

  static const double _verticalMargin = 8;
  static const String _codeLabel = '编码';
  static const String _descLabel = '描述';
  static const String _durationLabel = '工时';
  static const String _statusLabel = '状态';
  static const String _subtitleSeparator = ' · ';
  static const String _emptySubtitle = '暂无更多信息';

  final Process process;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final subtleText = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
    final subtitleLines = <String>[];
    if (process.code.trim().isNotEmpty) {
      subtitleLines.add('$_codeLabel：${process.code}');
    }
    if ((process.description ?? '').trim().isNotEmpty) {
      subtitleLines.add('$_descLabel：${process.description}');
    }
    if (process.standardDuration != null) {
      subtitleLines.add('$_durationLabel：${process.standardDuration}h');
    }
    subtitleLines.add('$_statusLabel：${process.isActive ? "启用" : "禁用"}');

    final tile = ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withOpacity(0.12),
        foregroundColor: primary,
        child: Text(process.name.isNotEmpty ? process.name[0].toUpperCase() : '?'),
      ),
      title: Text(
        process.name.isNotEmpty ? process.name : _ProcessListViewState._emptyCellText,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitleLines.isEmpty
          ? Text(_emptySubtitle, style: subtleText)
          : Text(subtitleLines.join(_subtitleSeparator), style: subtleText),
      isThreeLine: subtitleLines.length > 2,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: '编辑',
            icon: Icon(Icons.edit, color: primary),
            onPressed: onEdit,
          ),
          PopupMenuButton<String>(
            tooltip: '更多',
            onSelected: (value) {
              if (value == 'delete') {
                onDelete?.call();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'delete',
                child: Text('删除'),
              ),
            ],
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      onTap: onEdit,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: _verticalMargin),
      child: tile,
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
          Icon(Icons.account_tree_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _ProcessListViewState._spacingSm),
          Text(_ProcessListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _ProcessListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _ProcessListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_ProcessListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
