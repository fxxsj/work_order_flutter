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
import 'package:work_order_app/src/features/departments/application/department_view_model.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/data/department_repository_impl.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/departments/domain/department_repository.dart';
import 'package:work_order_app/src/features/departments/presentation/department_edit_page.dart';

/// 部门列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class DepartmentListEntry extends StatefulWidget {
  const DepartmentListEntry({super.key});

  @override
  State<DepartmentListEntry> createState() => _DepartmentListEntryState();
}

class _DepartmentListEntryState extends State<DepartmentListEntry> {
  DepartmentApiService? _apiService;
  DepartmentRepositoryImpl? _repository;
  DepartmentViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = DepartmentApiService(apiClient);
    _repository = DepartmentRepositoryImpl(_apiService!);
    _viewModel = DepartmentViewModel(_repository!);
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
        Provider<DepartmentApiService>.value(value: apiService),
        Provider<DepartmentRepository>.value(value: repository),
        ChangeNotifierProvider<DepartmentViewModel>.value(value: viewModel),
      ],
      child: const DepartmentListPage(),
    );
  }
}

/// 部门列表页视图，只负责渲染。
class DepartmentListPage extends StatelessWidget {
  const DepartmentListPage({super.key});

  @override
  Widget build(BuildContext context) => const _DepartmentListView();
}

class _DepartmentListView extends StatefulWidget {
  const _DepartmentListView();

  @override
  State<_DepartmentListView> createState() => _DepartmentListViewState();
}

class _DepartmentListViewState extends State<_DepartmentListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 300;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索部门名称、编码';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建部门';
  static const String _emptyText = '暂无部门数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除部门 "{name}" 吗？此操作不可恢复。';
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
  final Set<_DepartmentColumn> _visibleColumns = {
    _DepartmentColumn.code,
    _DepartmentColumn.name,
    _DepartmentColumn.parent,
    _DepartmentColumn.childrenCount,
    _DepartmentColumn.processes,
    _DepartmentColumn.sortOrder,
    _DepartmentColumn.status,
    _DepartmentColumn.createdAt,
    _DepartmentColumn.actions,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(DepartmentViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadDepartments(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadDepartments(resetPage: true);
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

    showMenu<_DepartmentColumn>(
      context: menuContext,
      position: position,
      items: _DepartmentColumn.optionalValues.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_DepartmentColumn>(
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

  Future<void> _openEditPage(BuildContext context, DepartmentViewModel viewModel, Department? department) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: DepartmentEditPage(department: department),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(department == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(BuildContext context, DepartmentViewModel viewModel, Department department) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', department.name)),
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
      await viewModel.deleteDepartment(department.id);
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

    return Consumer<DepartmentViewModel>(
      builder: (context, viewModel, _) {
        final departments = viewModel.departments;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, departments, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    DepartmentViewModel viewModel,
    List<Department> departments,
    bool isMobile,
  ) {
    if (viewModel.loading && departments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadDepartments(resetPage: true),
      );
    }
    if (!viewModel.loading && departments.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          return _DepartmentListTile(
            department: department,
            onEdit: () => _openEditPage(context, viewModel, department),
            onDelete: () => _confirmDelete(context, viewModel, department),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, departments);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: _denseTable ? 16 : 24,
                horizontalMargin: _denseTable ? 12 : 16,
                headingRowHeight: _denseTable ? 38 : 44,
                dataRowMinHeight: _denseTable ? 34 : 40,
                dataRowMaxHeight: _denseTable ? 44 : 56,
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
    DepartmentViewModel viewModel,
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
                      onPressed: () => viewModel.loadDepartments(resetPage: true),
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
                onPressed: () => viewModel.loadDepartments(resetPage: true),
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
    if (_visibleColumns.contains(_DepartmentColumn.code)) {
      columns.add(const DataColumn(label: Text('部门编码')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.name)) {
      columns.add(const DataColumn(label: Text('部门名称')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.parent)) {
      columns.add(const DataColumn(label: Text('上级部门')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.childrenCount)) {
      columns.add(const DataColumn(label: Text('子部门')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.processes)) {
      columns.add(const DataColumn(label: Text('工序')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.sortOrder)) {
      columns.add(const DataColumn(label: Text('排序')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.status)) {
      columns.add(const DataColumn(label: Text('状态')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.createdAt)) {
      columns.add(const DataColumn(label: Text('创建时间')));
    }
    if (_visibleColumns.contains(_DepartmentColumn.actions)) {
      columns.add(const DataColumn(label: Text('操作')));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context, DepartmentViewModel viewModel, List<Department> departments) {
    final theme = Theme.of(context);
    return departments.map((department) {
      final cells = <DataCell>[];
      if (_visibleColumns.contains(_DepartmentColumn.code)) {
        cells.add(DataCell(Text(_displayText(department.code))));
      }
      if (_visibleColumns.contains(_DepartmentColumn.name)) {
        cells.add(DataCell(Text(_displayText(department.name))));
      }
      if (_visibleColumns.contains(_DepartmentColumn.parent)) {
        cells.add(DataCell(Text(_displayText(department.parentName))));
      }
      if (_visibleColumns.contains(_DepartmentColumn.childrenCount)) {
        cells.add(DataCell(Text(_displayNumber(department.childrenCount))));
      }
      if (_visibleColumns.contains(_DepartmentColumn.processes)) {
        cells.add(DataCell(_processCell(department.processNames)));
      }
      if (_visibleColumns.contains(_DepartmentColumn.sortOrder)) {
        cells.add(DataCell(Text(_displayNumber(department.sortOrder))));
      }
      if (_visibleColumns.contains(_DepartmentColumn.status)) {
        cells.add(DataCell(_statusPill(theme, department.isActive)));
      }
      if (_visibleColumns.contains(_DepartmentColumn.createdAt)) {
        cells.add(DataCell(Text(_formatDateTime(department.createdAt))));
      }
      if (_visibleColumns.contains(_DepartmentColumn.actions)) {
        cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '编辑',
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: () => _openEditPage(context, viewModel, department),
                ),
                IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(context, viewModel, department),
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

  static Widget _processCell(List<String> names) {
    if (names.isEmpty) {
      return const Text(_emptyCellText);
    }
    return SizedBox(
      width: 220,
      child: Text(
        names.join('、'),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static String _formatDateTime(DateTime? value) {
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

enum _DepartmentColumn {
  code,
  name,
  parent,
  childrenCount,
  processes,
  sortOrder,
  status,
  createdAt,
  actions;

  static const List<_DepartmentColumn> optionalValues = [
    _DepartmentColumn.code,
    _DepartmentColumn.parent,
    _DepartmentColumn.childrenCount,
    _DepartmentColumn.processes,
    _DepartmentColumn.sortOrder,
    _DepartmentColumn.status,
    _DepartmentColumn.createdAt,
  ];

  String get label {
    switch (this) {
      case _DepartmentColumn.code:
        return '部门编码';
      case _DepartmentColumn.name:
        return '部门名称';
      case _DepartmentColumn.parent:
        return '上级部门';
      case _DepartmentColumn.childrenCount:
        return '子部门';
      case _DepartmentColumn.processes:
        return '工序';
      case _DepartmentColumn.sortOrder:
        return '排序';
      case _DepartmentColumn.status:
        return '状态';
      case _DepartmentColumn.createdAt:
        return '创建时间';
      case _DepartmentColumn.actions:
        return '操作';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final DepartmentViewModel viewModel;

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

class _DepartmentListTile extends StatelessWidget {
  const _DepartmentListTile({
    required this.department,
    this.onEdit,
    this.onDelete,
  });

  static const double _verticalMargin = 8;
  static const String _codeLabel = '编码';
  static const String _parentLabel = '上级';
  static const String _childrenLabel = '子部门';
  static const String _processLabel = '工序';
  static const String _statusLabel = '状态';
  static const String _subtitleSeparator = ' · ';
  static const String _emptySubtitle = '暂无更多信息';

  final Department department;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final subtleText = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
    final subtitleLines = <String>[];
    if (department.code.trim().isNotEmpty) {
      subtitleLines.add('$_codeLabel：${department.code}');
    }
    if ((department.parentName ?? '').trim().isNotEmpty) {
      subtitleLines.add('$_parentLabel：${department.parentName}');
    }
    if (department.childrenCount != null) {
      subtitleLines.add('$_childrenLabel：${department.childrenCount}');
    }
    if (department.processNames.isNotEmpty) {
      subtitleLines.add('$_processLabel：${department.processNames.join("、")}');
    }
    subtitleLines.add('$_statusLabel：${department.isActive ? "启用" : "禁用"}');

    final tile = ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withOpacity(0.12),
        foregroundColor: primary,
        child: Text(department.name.isNotEmpty ? department.name[0].toUpperCase() : '?'),
      ),
      title: Text(
        department.name.isNotEmpty ? department.name : _DepartmentListViewState._emptyCellText,
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
          Icon(Icons.apartment_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _DepartmentListViewState._spacingSm),
          Text(_DepartmentListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _DepartmentListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _DepartmentListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_DepartmentListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
