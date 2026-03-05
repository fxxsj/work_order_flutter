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
import 'package:work_order_app/src/features/embossing_plates/application/embossing_plate_view_model.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_repository_impl.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate_repository.dart';
import 'package:work_order_app/src/features/embossing_plates/presentation/embossing_plate_edit_page.dart';

class EmbossingPlateListEntry extends StatefulWidget {
  const EmbossingPlateListEntry({super.key});

  @override
  State<EmbossingPlateListEntry> createState() => _EmbossingPlateListEntryState();
}

class _EmbossingPlateListEntryState extends State<EmbossingPlateListEntry> {
  EmbossingPlateApiService? _apiService;
  EmbossingPlateRepositoryImpl? _repository;
  EmbossingPlateViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = EmbossingPlateApiService(apiClient);
    _repository = EmbossingPlateRepositoryImpl(_apiService!);
    _viewModel = EmbossingPlateViewModel(_repository!);
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
        Provider<EmbossingPlateApiService>.value(value: apiService),
        Provider<EmbossingPlateRepository>.value(value: repository),
        ChangeNotifierProvider<EmbossingPlateViewModel>.value(value: viewModel),
      ],
      child: const EmbossingPlateListPage(),
    );
  }
}

class EmbossingPlateListPage extends StatelessWidget {
  const EmbossingPlateListPage({super.key});

  @override
  Widget build(BuildContext context) => const _EmbossingPlateListView();
}

class _EmbossingPlateListView extends StatefulWidget {
  const _EmbossingPlateListView();

  @override
  State<_EmbossingPlateListView> createState() => _EmbossingPlateListViewState();
}

class _EmbossingPlateListViewState extends State<_EmbossingPlateListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 300;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索压凸版编码、名称、尺寸、材质';
  static const String _clearText = '清空';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建压凸版';
  static const String _emptyText = '暂无压凸版数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除压凸版 "{name}" 吗？此操作不可恢复。';
  static const String _confirmDialogTitle = '确认压凸版';
  static const String _confirmDialogContent = '确定要确认压凸版 "{name}" 吗？确认后将不可修改。';
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
  final Set<_EmbossingPlateColumn> _visibleColumns = {
    _EmbossingPlateColumn.code,
    _EmbossingPlateColumn.name,
    _EmbossingPlateColumn.size,
    _EmbossingPlateColumn.material,
    _EmbossingPlateColumn.thickness,
    _EmbossingPlateColumn.confirmed,
    _EmbossingPlateColumn.products,
    _EmbossingPlateColumn.notes,
    _EmbossingPlateColumn.createdAt,
    _EmbossingPlateColumn.actions,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(EmbossingPlateViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadEmbossingPlates(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadEmbossingPlates(resetPage: true);
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

    showMenu<_EmbossingPlateColumn>(
      context: menuContext,
      position: position,
      items: _EmbossingPlateColumn.optionalValues.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_EmbossingPlateColumn>(
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

  Future<void> _openEditPage(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate? plate,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: EmbossingPlateEditPage(plate: plate),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(plate == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate plate,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', plate.name)),
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
      await viewModel.deleteEmbossingPlate(plate.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_deleteSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_deleteFailedText$err');
    }
  }

  Future<void> _confirmPlate(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate plate,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_confirmDialogTitle),
        content: Text(_confirmDialogContent.replaceFirst('{name}', plate.name)),
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
      await viewModel.confirmEmbossingPlate(plate.id);
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

    return Consumer<EmbossingPlateViewModel>(
      builder: (context, viewModel, _) {
        final plates = viewModel.embossingPlates;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, plates, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    List<EmbossingPlate> plates,
    bool isMobile,
  ) {
    if (viewModel.loading && plates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadEmbossingPlates(resetPage: true),
      );
    }
    if (!viewModel.loading && plates.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.builder(
        itemCount: plates.length,
        itemBuilder: (context, index) {
          final plate = plates[index];
          return _EmbossingPlateListTile(
            plate: plate,
            onEdit: () => _openEditPage(context, viewModel, plate),
            onDelete: () => _confirmDelete(context, viewModel, plate),
            onConfirm: plate.confirmed ? null : () => _confirmPlate(context, viewModel, plate),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, plates);

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
    EmbossingPlateViewModel viewModel,
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
                      onPressed: () => viewModel.loadEmbossingPlates(resetPage: true),
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
                onPressed: () => viewModel.loadEmbossingPlates(resetPage: true),
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
    if (_visibleColumns.contains(_EmbossingPlateColumn.code)) {
      columns.add(const DataColumn(label: Text('压凸版编码')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.name)) {
      columns.add(const DataColumn(label: Text('压凸版名称')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.size)) {
      columns.add(const DataColumn(label: Text('尺寸')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.material)) {
      columns.add(const DataColumn(label: Text('材质')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.thickness)) {
      columns.add(const DataColumn(label: Text('厚度')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.confirmed)) {
      columns.add(const DataColumn(label: Text('确认状态')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.products)) {
      columns.add(const DataColumn(label: Text('包含产品')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.notes)) {
      columns.add(const DataColumn(label: Text('备注')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.createdAt)) {
      columns.add(const DataColumn(label: Text('创建时间')));
    }
    if (_visibleColumns.contains(_EmbossingPlateColumn.actions)) {
      columns.add(const DataColumn(label: Text('操作')));
    }
    return columns;
  }

  List<DataRow> _buildRows(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    List<EmbossingPlate> plates,
  ) {
    final theme = Theme.of(context);
    return plates.map((plate) {
      final cells = <DataCell>[];
      if (_visibleColumns.contains(_EmbossingPlateColumn.code)) {
        cells.add(DataCell(Text(_displayText(plate.code))));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.name)) {
        cells.add(DataCell(Text(_displayText(plate.name))));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.size)) {
        cells.add(DataCell(Text(_displayText(plate.size))));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.material)) {
        cells.add(DataCell(Text(_displayText(plate.material))));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.thickness)) {
        cells.add(DataCell(Text(_displayText(plate.thickness))));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.confirmed)) {
        cells.add(DataCell(_statusPill(theme, plate.confirmed)));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.products)) {
        cells.add(DataCell(_productCell(plate.products)));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.notes)) {
        cells.add(DataCell(Text(_displayText(plate.notes))));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.createdAt)) {
        cells.add(DataCell(Text(_formatDateTime(plate.createdAt))));
      }
      if (_visibleColumns.contains(_EmbossingPlateColumn.actions)) {
        cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '编辑',
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: () => _openEditPage(context, viewModel, plate),
                ),
                if (!plate.confirmed)
                  IconButton(
                    tooltip: '确认',
                    icon: Icon(Icons.verified_outlined, color: theme.colorScheme.tertiary),
                    onPressed: () => _confirmPlate(context, viewModel, plate),
                  ),
                IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(context, viewModel, plate),
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

  static Widget _productCell(List<EmbossingPlateProduct> products) {
    if (products.isEmpty) {
      return const Text(_emptyCellText);
    }
    final display = products.map((item) => '${item.productName}(${item.quantity ?? 1}个)').toList();
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

enum _EmbossingPlateColumn {
  code,
  name,
  size,
  material,
  thickness,
  confirmed,
  products,
  notes,
  createdAt,
  actions;

  static const List<_EmbossingPlateColumn> optionalValues = [
    _EmbossingPlateColumn.size,
    _EmbossingPlateColumn.material,
    _EmbossingPlateColumn.thickness,
    _EmbossingPlateColumn.confirmed,
    _EmbossingPlateColumn.products,
    _EmbossingPlateColumn.notes,
    _EmbossingPlateColumn.createdAt,
  ];

  String get label {
    switch (this) {
      case _EmbossingPlateColumn.code:
        return '压凸版编码';
      case _EmbossingPlateColumn.name:
        return '压凸版名称';
      case _EmbossingPlateColumn.size:
        return '尺寸';
      case _EmbossingPlateColumn.material:
        return '材质';
      case _EmbossingPlateColumn.thickness:
        return '厚度';
      case _EmbossingPlateColumn.confirmed:
        return '确认状态';
      case _EmbossingPlateColumn.products:
        return '包含产品';
      case _EmbossingPlateColumn.notes:
        return '备注';
      case _EmbossingPlateColumn.createdAt:
        return '创建时间';
      case _EmbossingPlateColumn.actions:
        return '操作';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final EmbossingPlateViewModel viewModel;

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

class _EmbossingPlateListTile extends StatelessWidget {
  const _EmbossingPlateListTile({
    required this.plate,
    this.onEdit,
    this.onDelete,
    this.onConfirm,
  });

  static const double _verticalMargin = 8;
  static const String _codeLabel = '编码';
  static const String _statusLabel = '状态';
  static const String _subtitleSeparator = ' · ';
  static const String _emptySubtitle = '暂无更多信息';

  final EmbossingPlate plate;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final subtleText = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
    final subtitleLines = <String>[];
    if ((plate.code ?? '').trim().isNotEmpty) {
      subtitleLines.add('$_codeLabel：${plate.code}');
    }
    subtitleLines.add('$_statusLabel：${plate.confirmed ? "已确认" : "待确认"}');

    final tile = ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withOpacity(0.12),
        foregroundColor: primary,
        child: Text(plate.name.isNotEmpty ? plate.name[0].toUpperCase() : '?'),
      ),
      title: Text(
        plate.name.isNotEmpty ? plate.name : _EmbossingPlateListViewState._emptyCellText,
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
              if (!plate.confirmed)
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
          Icon(Icons.dashboard_customize_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _EmbossingPlateListViewState._spacingSm),
          Text(_EmbossingPlateListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _EmbossingPlateListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _EmbossingPlateListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_EmbossingPlateListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
