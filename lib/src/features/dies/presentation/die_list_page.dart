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
import 'package:work_order_app/src/features/dies/application/die_view_model.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/data/die_repository_impl.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/dies/domain/die_repository.dart';
import 'package:work_order_app/src/features/dies/presentation/die_edit_page.dart';

class DieListEntry extends StatefulWidget {
  const DieListEntry({super.key});

  @override
  State<DieListEntry> createState() => _DieListEntryState();
}

class _DieListEntryState extends State<DieListEntry> {
  DieApiService? _apiService;
  DieRepositoryImpl? _repository;
  DieViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = DieApiService(apiClient);
    _repository = DieRepositoryImpl(_apiService!);
    _viewModel = DieViewModel(_repository!);
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
        Provider<DieApiService>.value(value: apiService),
        Provider<DieRepository>.value(value: repository),
        ChangeNotifierProvider<DieViewModel>.value(value: viewModel),
      ],
      child: const DieListPage(),
    );
  }
}

class DieListPage extends StatelessWidget {
  const DieListPage({super.key});

  @override
  Widget build(BuildContext context) => const _DieListView();
}

class _DieListView extends StatefulWidget {
  const _DieListView();

  @override
  State<_DieListView> createState() => _DieListViewState();
}

class _DieListViewState extends State<_DieListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 300;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索刀模编码、名称、尺寸、材质';
  static const String _clearText = '清空';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建刀模';
  static const String _emptyText = '暂无刀模数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除刀模 "{name}" 吗？此操作不可恢复。';
  static const String _confirmDialogTitle = '确认刀模';
  static const String _confirmDialogContent = '确定要确认刀模 "{name}" 吗？确认后将不可修改。';
  static const String _cancelText = '取消';
  static const String _okText = '确定';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _confirmSuccessText = '确认成功';
  static const String _confirmFailedText = '确认失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';
  static const String _densityComfortLabel = '舒适';
  static const String _densityCompactLabel = '紧凑';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_DieColumn> _visibleColumns = {
    _DieColumn.code,
    _DieColumn.name,
    _DieColumn.type,
    _DieColumn.size,
    _DieColumn.material,
    _DieColumn.thickness,
    _DieColumn.confirmed,
    _DieColumn.products,
    _DieColumn.notes,
    _DieColumn.createdAt,
    _DieColumn.actions,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(DieViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadDies(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadDies(resetPage: true);
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

    showMenu<_DieColumn>(
      context: menuContext,
      position: position,
      items: _DieColumn.optionalValues.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_DieColumn>(
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

  Future<void> _openEditPage(BuildContext context, DieViewModel viewModel, Die? die) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: DieEditPage(die: die),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(die == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(BuildContext context, DieViewModel viewModel, Die die) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', die.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(_cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(_okText),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await viewModel.deleteDie(die.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_deleteSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_deleteFailedText$err');
    }
  }

  Future<void> _confirmDie(BuildContext context, DieViewModel viewModel, Die die) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_confirmDialogTitle),
        content: Text(_confirmDialogContent.replaceFirst('{name}', die.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(_cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(_okText),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await viewModel.confirmDie(die.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_confirmSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_confirmFailedText$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<DieViewModel>(
      builder: (context, viewModel, _) {
        final dies = viewModel.dies;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, dies, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    DieViewModel viewModel,
    List<Die> dies,
    bool isMobile,
  ) {
    if (viewModel.loading && dies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadDies(resetPage: true),
      );
    }
    if (!viewModel.loading && dies.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.builder(
        itemCount: dies.length,
        itemBuilder: (context, index) {
          final die = dies[index];
          return _DieListTile(
            die: die,
            onEdit: () => _openEditPage(context, viewModel, die),
            onDelete: () => _confirmDelete(context, viewModel, die),
            onConfirm: die.confirmed ? null : () => _confirmDie(context, viewModel, die),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, dies);

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
    DieViewModel viewModel,
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
                      onPressed: () => viewModel.loadDies(resetPage: true),
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
                onPressed: () => viewModel.loadDies(resetPage: true),
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
    if (_visibleColumns.contains(_DieColumn.code)) {
      columns.add(const DataColumn(label: Text('刀模编码')));
    }
    if (_visibleColumns.contains(_DieColumn.name)) {
      columns.add(const DataColumn(label: Text('刀模名称')));
    }
    if (_visibleColumns.contains(_DieColumn.type)) {
      columns.add(const DataColumn(label: Text('刀模类型')));
    }
    if (_visibleColumns.contains(_DieColumn.size)) {
      columns.add(const DataColumn(label: Text('尺寸')));
    }
    if (_visibleColumns.contains(_DieColumn.material)) {
      columns.add(const DataColumn(label: Text('材质')));
    }
    if (_visibleColumns.contains(_DieColumn.thickness)) {
      columns.add(const DataColumn(label: Text('厚度')));
    }
    if (_visibleColumns.contains(_DieColumn.confirmed)) {
      columns.add(const DataColumn(label: Text('确认状态')));
    }
    if (_visibleColumns.contains(_DieColumn.products)) {
      columns.add(const DataColumn(label: Text('包含产品')));
    }
    if (_visibleColumns.contains(_DieColumn.notes)) {
      columns.add(const DataColumn(label: Text('备注')));
    }
    if (_visibleColumns.contains(_DieColumn.createdAt)) {
      columns.add(const DataColumn(label: Text('创建时间')));
    }
    if (_visibleColumns.contains(_DieColumn.actions)) {
      columns.add(const DataColumn(label: Text('操作')));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context, DieViewModel viewModel, List<Die> dies) {
    final theme = Theme.of(context);
    return dies.map((die) {
      final cells = <DataCell>[];
      if (_visibleColumns.contains(_DieColumn.code)) {
        cells.add(DataCell(Text(_displayText(die.code))));
      }
      if (_visibleColumns.contains(_DieColumn.name)) {
        cells.add(DataCell(Text(_displayText(die.name))));
      }
      if (_visibleColumns.contains(_DieColumn.type)) {
        cells.add(DataCell(Text(_displayText(die.dieTypeDisplay ?? _dieTypeLabel(die.dieType)))));
      }
      if (_visibleColumns.contains(_DieColumn.size)) {
        cells.add(DataCell(Text(_displayText(die.size))));
      }
      if (_visibleColumns.contains(_DieColumn.material)) {
        cells.add(DataCell(Text(_displayText(die.material))));
      }
      if (_visibleColumns.contains(_DieColumn.thickness)) {
        cells.add(DataCell(Text(_displayText(die.thickness))));
      }
      if (_visibleColumns.contains(_DieColumn.confirmed)) {
        cells.add(DataCell(_statusPill(theme, die.confirmed)));
      }
      if (_visibleColumns.contains(_DieColumn.products)) {
        cells.add(DataCell(_productCell(die.products)));
      }
      if (_visibleColumns.contains(_DieColumn.notes)) {
        cells.add(DataCell(Text(_displayText(die.notes))));
      }
      if (_visibleColumns.contains(_DieColumn.createdAt)) {
        cells.add(DataCell(Text(_formatDateTime(die.createdAt))));
      }
      if (_visibleColumns.contains(_DieColumn.actions)) {
        cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '编辑',
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: () => _openEditPage(context, viewModel, die),
                ),
                if (!die.confirmed)
                  IconButton(
                    tooltip: '确认',
                    icon: Icon(Icons.verified_outlined, color: theme.colorScheme.tertiary),
                    onPressed: () => _confirmDie(context, viewModel, die),
                  ),
                IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(context, viewModel, die),
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

  static String _dieTypeLabel(String? dieType) {
    switch (dieType) {
      case 'combined':
        return '拼版刀模';
      case 'dedicated':
        return '专用刀模';
      case 'universal':
        return '通用刀模';
      default:
        return _emptyCellText;
    }
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
        isActive ? '已确认' : '待确认',
        style: theme.textTheme.bodySmall?.copyWith(color: foreground),
      ),
    );
  }

  static Widget _productCell(List<DieProduct> products) {
    if (products.isEmpty) {
      return const Text(_emptyCellText);
    }
    final display = products.map((item) => '${item.productName}(${item.quantity ?? 1}拼)').toList();
    return SizedBox(
      width: 220,
      child: Text(
        display.join('、'),
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

enum _DieColumn {
  code,
  name,
  type,
  size,
  material,
  thickness,
  confirmed,
  products,
  notes,
  createdAt,
  actions;

  static const List<_DieColumn> optionalValues = [
    _DieColumn.type,
    _DieColumn.size,
    _DieColumn.material,
    _DieColumn.thickness,
    _DieColumn.confirmed,
    _DieColumn.products,
    _DieColumn.notes,
    _DieColumn.createdAt,
  ];

  String get label {
    switch (this) {
      case _DieColumn.code:
        return '刀模编码';
      case _DieColumn.name:
        return '刀模名称';
      case _DieColumn.type:
        return '刀模类型';
      case _DieColumn.size:
        return '尺寸';
      case _DieColumn.material:
        return '材质';
      case _DieColumn.thickness:
        return '厚度';
      case _DieColumn.confirmed:
        return '确认状态';
      case _DieColumn.products:
        return '包含产品';
      case _DieColumn.notes:
        return '备注';
      case _DieColumn.createdAt:
        return '创建时间';
      case _DieColumn.actions:
        return '操作';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final DieViewModel viewModel;

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

class _DieListTile extends StatelessWidget {
  const _DieListTile({
    required this.die,
    this.onEdit,
    this.onDelete,
    this.onConfirm,
  });

  static const double _verticalMargin = 8;
  static const String _codeLabel = '编码';
  static const String _typeLabel = '类型';
  static const String _statusLabel = '状态';
  static const String _subtitleSeparator = ' · ';
  static const String _emptySubtitle = '暂无更多信息';

  final Die die;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final subtleText = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
    final subtitleLines = <String>[];
    if ((die.code ?? '').trim().isNotEmpty) {
      subtitleLines.add('$_codeLabel：${die.code}');
    }
    subtitleLines.add(
      '$_typeLabel：${die.dieTypeDisplay ?? _DieListViewState._dieTypeLabel(die.dieType)}',
    );
    subtitleLines.add('$_statusLabel：${die.confirmed ? "已确认" : "待确认"}');

    final tile = ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withOpacity(0.12),
        foregroundColor: primary,
        child: Text(die.name.isNotEmpty ? die.name[0].toUpperCase() : '?'),
      ),
      title: Text(
        die.name.isNotEmpty ? die.name : _DieListViewState._emptyCellText,
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
              switch (value) {
                case 'confirm':
                  onConfirm?.call();
                  break;
                case 'delete':
                  onDelete?.call();
                  break;
              }
            },
            itemBuilder: (context) => [
              if (!die.confirmed)
                const PopupMenuItem(
                  value: 'confirm',
                  child: Text('确认'),
                ),
              const PopupMenuItem(
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
          Icon(Icons.cut_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _DieListViewState._spacingSm),
          Text(_DieListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _DieListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _DieListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_DieListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
