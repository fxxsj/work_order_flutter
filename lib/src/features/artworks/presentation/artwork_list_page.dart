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
import 'package:work_order_app/src/features/artworks/application/artwork_view_model.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_repository_impl.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork_repository.dart';
import 'package:work_order_app/src/features/artworks/presentation/artwork_edit_page.dart';

class ArtworkListEntry extends StatefulWidget {
  const ArtworkListEntry({super.key});

  @override
  State<ArtworkListEntry> createState() => _ArtworkListEntryState();
}

class _ArtworkListEntryState extends State<ArtworkListEntry> {
  ArtworkApiService? _apiService;
  ArtworkRepositoryImpl? _repository;
  ArtworkViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = ArtworkApiService(apiClient);
    _repository = ArtworkRepositoryImpl(_apiService!);
    _viewModel = ArtworkViewModel(_repository!);
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
        Provider<ArtworkApiService>.value(value: apiService),
        Provider<ArtworkRepository>.value(value: repository),
        ChangeNotifierProvider<ArtworkViewModel>.value(value: viewModel),
      ],
      child: const ArtworkListPage(),
    );
  }
}

class ArtworkListPage extends StatelessWidget {
  const ArtworkListPage({super.key});

  @override
  Widget build(BuildContext context) => const _ArtworkListView();
}

class _ArtworkListView extends StatefulWidget {
  const _ArtworkListView();

  @override
  State<_ArtworkListView> createState() => _ArtworkListViewState();
}

class _ArtworkListViewState extends State<_ArtworkListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 300;
  static const double _spacingSm = 8;
  static const double _controlHeight = PageActionStyle.height;
  static const double _controlRadius = PageActionStyle.radius;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索图稿编码、名称、拼版尺寸';
  static const String _clearText = '清空';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建图稿';
  static const String _emptyText = '暂无图稿数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除图稿 "{name}" 吗？此操作不可恢复。';
  static const String _confirmDialogTitle = '确认图稿';
  static const String _confirmDialogContent = '确定要确认图稿 "{name}" 吗？确认后将不可修改。';
  static const String _versionDialogTitle = '创建新版本';
  static const String _versionDialogContent = '确定要基于 "{code}" 创建新版本吗？';
  static const String _cancelText = '取消';
  static const String _okText = '确定';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _confirmSuccessText = '图稿已确认';
  static const String _confirmFailedText = '确认失败: ';
  static const String _versionSuccessText = '新版本创建成功';
  static const String _versionFailedText = '创建新版本失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';
  static const String _densityComfortLabel = '舒适';
  static const String _densityCompactLabel = '紧凑';
  static const String _breadcrumbSeparator = ' / ';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _denseTable = false;
  final GlobalKey _columnsMenuKey = GlobalKey();
  final Set<_ArtworkColumn> _visibleColumns = {
    _ArtworkColumn.code,
    _ArtworkColumn.name,
    _ArtworkColumn.color,
    _ArtworkColumn.impositionSize,
    _ArtworkColumn.confirmed,
    _ArtworkColumn.die,
    _ArtworkColumn.foiling,
    _ArtworkColumn.embossing,
    _ArtworkColumn.products,
    _ArtworkColumn.notes,
    _ArtworkColumn.createdAt,
    _ArtworkColumn.actions,
  };

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(ArtworkViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadArtworks(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadArtworks(resetPage: true);
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

    showMenu<_ArtworkColumn>(
      context: menuContext,
      position: position,
      items: _ArtworkColumn.optionalValues.map((value) {
        final checked = _visibleColumns.contains(value);
        return CheckedPopupMenuItem<_ArtworkColumn>(
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

  Future<void> _openEditPage(BuildContext context, ArtworkViewModel viewModel, Artwork? artwork) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ArtworkEditPage(artwork: artwork),
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ToastUtil.showSuccess(artwork == null ? _createSuccessText : _updateSuccessText);
    }
  }

  Future<void> _confirmDelete(BuildContext context, ArtworkViewModel viewModel, Artwork artwork) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_deleteDialogTitle),
        content: Text(_deleteDialogContent.replaceFirst('{name}', artwork.name)),
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
      await viewModel.deleteArtwork(artwork.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_deleteSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_deleteFailedText$err');
    }
  }

  Future<void> _confirmArtwork(BuildContext context, ArtworkViewModel viewModel, Artwork artwork) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_confirmDialogTitle),
        content: Text(_confirmDialogContent.replaceFirst('{name}', artwork.name)),
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
      await viewModel.confirmArtwork(artwork.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_confirmSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_confirmFailedText$err');
    }
  }

  Future<void> _createVersion(BuildContext context, ArtworkViewModel viewModel, Artwork artwork) async {
    final fullCode = artwork.fullCode.isNotEmpty ? artwork.fullCode : artwork.name;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_versionDialogTitle),
        content: Text(_versionDialogContent.replaceFirst('{code}', fullCode)),
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
      await viewModel.createVersion(artwork.id);
      if (!mounted) return;
      ToastUtil.showSuccess(_versionSuccessText);
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('$_versionFailedText$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);
    final breadcrumb = buildBreadcrumbForPathWith(
      GoRouterState.of(context).uri.path,
      buildPathToIdMap(),
    );

    return Consumer<ArtworkViewModel>(
      builder: (context, viewModel, _) {
        final artworks = viewModel.artworks;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, breadcrumb, isMobile),
          body: _buildListBody(context, viewModel, artworks, isMobile),
          footer: viewModel.total > 0 ? _PaginationBar(viewModel: viewModel) : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    ArtworkViewModel viewModel,
    List<Artwork> artworks,
    bool isMobile,
  ) {
    if (viewModel.loading && artworks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return _ErrorState(
        message: viewModel.errorMessage ?? _errorFallbackText,
        onRetry: () => viewModel.loadArtworks(resetPage: true),
      );
    }
    if (!viewModel.loading && artworks.isEmpty) {
      return const _EmptyState();
    }

    if (isMobile) {
      return ListView.builder(
        itemCount: artworks.length,
        itemBuilder: (context, index) {
          final artwork = artworks[index];
          return _ArtworkListTile(
            artwork: artwork,
            onEdit: () => _openEditPage(context, viewModel, artwork),
            onDelete: () => _confirmDelete(context, viewModel, artwork),
            onConfirm: artwork.confirmed ? null : () => _confirmArtwork(context, viewModel, artwork),
            onCreateVersion: () => _createVersion(context, viewModel, artwork),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _buildColumns();
          final rows = _buildRows(context, viewModel, artworks);

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
    ArtworkViewModel viewModel,
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
                      onPressed: () => viewModel.loadArtworks(resetPage: true),
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
                onPressed: () => viewModel.loadArtworks(resetPage: true),
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
    if (_visibleColumns.contains(_ArtworkColumn.code)) {
      columns.add(const DataColumn(label: Text('图稿编码')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.name)) {
      columns.add(const DataColumn(label: Text('图稿名称')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.color)) {
      columns.add(const DataColumn(label: Text('色数')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.impositionSize)) {
      columns.add(const DataColumn(label: Text('拼版尺寸')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.confirmed)) {
      columns.add(const DataColumn(label: Text('确认状态')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.die)) {
      columns.add(const DataColumn(label: Text('关联刀模')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.foiling)) {
      columns.add(const DataColumn(label: Text('关联烫金版')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.embossing)) {
      columns.add(const DataColumn(label: Text('关联压凸版')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.products)) {
      columns.add(const DataColumn(label: Text('包含产品')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.notes)) {
      columns.add(const DataColumn(label: Text('备注')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.createdAt)) {
      columns.add(const DataColumn(label: Text('创建时间')));
    }
    if (_visibleColumns.contains(_ArtworkColumn.actions)) {
      columns.add(const DataColumn(label: Text('操作')));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context, ArtworkViewModel viewModel, List<Artwork> artworks) {
    final theme = Theme.of(context);
    return artworks.map((artwork) {
      final cells = <DataCell>[];
      if (_visibleColumns.contains(_ArtworkColumn.code)) {
        cells.add(DataCell(Text(_displayText(artwork.fullCode.isEmpty ? artwork.code : artwork.fullCode))));
      }
      if (_visibleColumns.contains(_ArtworkColumn.name)) {
        cells.add(DataCell(Text(_displayText(artwork.name))));
      }
      if (_visibleColumns.contains(_ArtworkColumn.color)) {
        cells.add(DataCell(Text(_displayText(artwork.colorDisplay))));
      }
      if (_visibleColumns.contains(_ArtworkColumn.impositionSize)) {
        cells.add(DataCell(Text(_displayText(artwork.impositionSize))));
      }
      if (_visibleColumns.contains(_ArtworkColumn.confirmed)) {
        cells.add(DataCell(_statusPill(theme, artwork.confirmed)));
      }
      if (_visibleColumns.contains(_ArtworkColumn.die)) {
        cells.add(DataCell(_compactList(artwork.dieCodes, artwork.dieNames)));
      }
      if (_visibleColumns.contains(_ArtworkColumn.foiling)) {
        cells.add(DataCell(_compactList(artwork.foilingPlateCodes, artwork.foilingPlateNames)));
      }
      if (_visibleColumns.contains(_ArtworkColumn.embossing)) {
        cells.add(DataCell(_compactList(artwork.embossingPlateCodes, artwork.embossingPlateNames)));
      }
      if (_visibleColumns.contains(_ArtworkColumn.products)) {
        cells.add(DataCell(_productCell(artwork.products)));
      }
      if (_visibleColumns.contains(_ArtworkColumn.notes)) {
        cells.add(DataCell(Text(_displayText(artwork.notes))));
      }
      if (_visibleColumns.contains(_ArtworkColumn.createdAt)) {
        cells.add(DataCell(Text(_formatDateTime(artwork.createdAt))));
      }
      if (_visibleColumns.contains(_ArtworkColumn.actions)) {
        cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '编辑',
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: () => _openEditPage(context, viewModel, artwork),
                ),
                IconButton(
                  tooltip: '新版本',
                  icon: Icon(Icons.control_point_duplicate_outlined, color: theme.colorScheme.primary),
                  onPressed: () => _createVersion(context, viewModel, artwork),
                ),
                if (!artwork.confirmed)
                  IconButton(
                    tooltip: '确认',
                    icon: Icon(Icons.verified_outlined, color: theme.colorScheme.tertiary),
                    onPressed: () => _confirmArtwork(context, viewModel, artwork),
                  ),
                IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(context, viewModel, artwork),
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
        isActive ? '已确认' : '未确认',
        style: theme.textTheme.bodySmall?.copyWith(color: foreground),
      ),
    );
  }

  static Widget _compactList(List<String> codes, List<String> names) {
    if (codes.isEmpty) {
      return const Text(_emptyCellText);
    }
    final display = <String>[];
    for (var i = 0; i < codes.length; i++) {
      final code = codes[i];
      final name = i < names.length ? names[i] : '';
      display.add(name.isNotEmpty ? '$code - $name' : code);
    }
    return SizedBox(
      width: 200,
      child: Text(
        display.join('、'),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Widget _productCell(List<ArtworkProduct> products) {
    if (products.isEmpty) {
      return const Text(_emptyCellText);
    }
    final display = products
        .map((item) => '${item.productName}(${item.impositionQuantity ?? 1}拼)')
        .toList();
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

enum _ArtworkColumn {
  code,
  name,
  color,
  impositionSize,
  confirmed,
  die,
  foiling,
  embossing,
  products,
  notes,
  createdAt,
  actions;

  static const List<_ArtworkColumn> optionalValues = [
    _ArtworkColumn.color,
    _ArtworkColumn.impositionSize,
    _ArtworkColumn.confirmed,
    _ArtworkColumn.die,
    _ArtworkColumn.foiling,
    _ArtworkColumn.embossing,
    _ArtworkColumn.products,
    _ArtworkColumn.notes,
    _ArtworkColumn.createdAt,
  ];

  String get label {
    switch (this) {
      case _ArtworkColumn.code:
        return '图稿编码';
      case _ArtworkColumn.name:
        return '图稿名称';
      case _ArtworkColumn.color:
        return '色数';
      case _ArtworkColumn.impositionSize:
        return '拼版尺寸';
      case _ArtworkColumn.confirmed:
        return '确认状态';
      case _ArtworkColumn.die:
        return '关联刀模';
      case _ArtworkColumn.foiling:
        return '关联烫金版';
      case _ArtworkColumn.embossing:
        return '关联压凸版';
      case _ArtworkColumn.products:
        return '包含产品';
      case _ArtworkColumn.notes:
        return '备注';
      case _ArtworkColumn.createdAt:
        return '创建时间';
      case _ArtworkColumn.actions:
        return '操作';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.viewModel});

  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final ArtworkViewModel viewModel;

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

class _ArtworkListTile extends StatelessWidget {
  const _ArtworkListTile({
    required this.artwork,
    this.onEdit,
    this.onDelete,
    this.onConfirm,
    this.onCreateVersion,
  });

  static const double _verticalMargin = 8;
  static const String _codeLabel = '编码';
  static const String _colorLabel = '色数';
  static const String _sizeLabel = '拼版';
  static const String _statusLabel = '状态';
  static const String _subtitleSeparator = ' · ';
  static const String _emptySubtitle = '暂无更多信息';

  final Artwork artwork;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onConfirm;
  final VoidCallback? onCreateVersion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final subtleText = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
    final subtitleLines = <String>[];
    final fullCode = artwork.fullCode.isNotEmpty ? artwork.fullCode : artwork.code ?? '';
    if (fullCode.isNotEmpty) {
      subtitleLines.add('$_codeLabel：$fullCode');
    }
    if ((artwork.colorDisplay ?? '').trim().isNotEmpty) {
      subtitleLines.add('$_colorLabel：${artwork.colorDisplay}');
    }
    if ((artwork.impositionSize ?? '').trim().isNotEmpty) {
      subtitleLines.add('$_sizeLabel：${artwork.impositionSize}');
    }
    subtitleLines.add('$_statusLabel：${artwork.confirmed ? "已确认" : "未确认"}');

    final tile = ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withOpacity(0.12),
        foregroundColor: primary,
        child: Text(artwork.name.isNotEmpty ? artwork.name[0].toUpperCase() : '?'),
      ),
      title: Text(
        artwork.name.isNotEmpty ? artwork.name : _ArtworkListViewState._emptyCellText,
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
                case 'version':
                  onCreateVersion?.call();
                  break;
                case 'delete':
                  onDelete?.call();
                  break;
              }
            },
            itemBuilder: (context) => [
              if (!artwork.confirmed)
                const PopupMenuItem(
                  value: 'confirm',
                  child: Text('确认'),
                ),
              const PopupMenuItem(
                value: 'version',
                child: Text('创建新版本'),
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
          Icon(Icons.image_outlined, color: theme.colorScheme.primary, size: _iconSize),
          const SizedBox(height: _ArtworkListViewState._spacingSm),
          Text(_ArtworkListViewState._emptyText, style: theme.textTheme.bodyMedium),
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
          const SizedBox(height: _ArtworkListViewState._spacingSm),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: _ArtworkListViewState._spacingSm),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(_ArtworkListViewState._retryText),
          ),
        ],
      ),
    );
  }
}
