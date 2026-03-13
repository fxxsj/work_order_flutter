import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
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
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索图稿编码、名称、拼版尺寸';
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
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

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

  Future<void> _openEditPage(BuildContext context, ArtworkViewModel viewModel, Artwork? artwork) async {
    Artwork? target = artwork;
    if (artwork != null) {
      try {
        final apiService = context.read<ArtworkApiService>();
        final detail = await apiService.fetchArtwork(artwork.id);
        target = detail.toEntity();
      } catch (err) {
        if (!mounted) return;
        ToastUtil.showError('加载图稿详情失败: $err');
        return;
      }
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ArtworkEditPage(artwork: target),
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

  static String _pageInfoText(ArtworkViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<ArtworkViewModel>(
      builder: (context, viewModel, _) {
        final artworks = viewModel.artworks;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, artworks, isMobile),
          footer: viewModel.total > 0
              ? ResponsivePaginationBar(
                  infoText: _pageInfoText(viewModel),
                  page: viewModel.page,
                  pageSize: viewModel.pageSize,
                  pageSizeOptions: viewModel.pageSizeOptions,
                  onPageSizeChanged: viewModel.setPageSize,
                  onPrev: () => viewModel.setPage(viewModel.page - 1),
                  onNext: () => viewModel.setPage(viewModel.page + 1),
                  hasPrev: viewModel.hasPrev,
                  hasNext: viewModel.hasNext,
                  pageSizeLabelBuilder: (size) =>
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
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
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && artworks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadArtworks(resetPage: true),
      );
    }
    if (!viewModel.loading && artworks.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.image_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, artworks);
    }

    return ListView.separated(
      itemCount: artworks.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final artwork = artworks[index];
        return _buildSummaryCard(context, viewModel, artwork, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    ArtworkViewModel viewModel,
    List<Artwork> artworks,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('稿件')),
        DataColumn(label: Text('编码')),
        DataColumn(label: Text('色数')),
        DataColumn(label: Text('拼版尺寸')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('关联刀模')),
        DataColumn(label: Text('烫金版')),
        DataColumn(label: Text('压凸版')),
        DataColumn(label: Text('包含产品')),
        DataColumn(label: Text('创建时间')),
        DataColumn(label: Text('操作')),
      ],
      rows: artworks
          .map(
            (artwork) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(artwork.name),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(
                  _displayText(
                      artwork.fullCode.isNotEmpty ? artwork.fullCode : artwork.code),
                  style: textStyle,
                )),
                DataCell(
                    Text(_displayText(artwork.colorDisplay), style: textStyle)),
                DataCell(Text(_displayText(artwork.impositionSize),
                    style: textStyle)),
                DataCell(
                    Text(artwork.confirmed ? '已确认' : '未确认',
                        style: textStyle)),
                DataCell(Text(
                  _compactListText(artwork.dieCodes, artwork.dieNames),
                  style: textStyle,
                )),
                DataCell(Text(
                  _compactListText(
                      artwork.foilingPlateCodes, artwork.foilingPlateNames),
                  style: textStyle,
                )),
                DataCell(Text(
                  _compactListText(
                      artwork.embossingPlateCodes, artwork.embossingPlateNames),
                  style: textStyle,
                )),
                DataCell(
                    Text(_productSummary(artwork.products), style: textStyle)),
                DataCell(
                    Text(_formatDateTime(artwork.createdAt), style: textStyle)),
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '编辑',
                      onPressed: () =>
                          _openEditPage(context, viewModel, artwork),
                    ),
                    RowAction(
                      label: '新版本',
                      onPressed: () =>
                          _createVersion(context, viewModel, artwork),
                    ),
                    if (!artwork.confirmed)
                      RowAction(
                        label: '确认',
                        onPressed: () =>
                            _confirmArtwork(context, viewModel, artwork),
                      ),
                    RowAction(
                      label: '删除',
                      onPressed: () =>
                          _confirmDelete(context, viewModel, artwork),
                      destructive: true,
                    ),
                  ],
                )),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    ArtworkViewModel viewModel,
bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: PageActionStyle.height,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            PageActionButton.outlined(
              onPressed: () => viewModel.loadArtworks(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.filled(
              onPressed: () => _openEditPage(context, viewModel, null),
              icon: const Icon(Icons.add),
              label: _createButtonText,
            ),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _spacingSm,
          );
        },
      ),
    );
  }
  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  static String _compactListText(List<String> codes, List<String> names) {
    if (codes.isEmpty) return _emptyCellText;
    final display = <String>[];
    for (var i = 0; i < codes.length; i++) {
      final code = codes[i];
      final name = i < names.length ? names[i] : '';
      display.add(name.isNotEmpty ? '$code - $name' : code);
    }
    return display.join('、');
  }

  static String _productSummary(List<ArtworkProduct> products) {
    if (products.isEmpty) return _emptyCellText;
    final display = products
        .map((item) => '${item.productName}(${item.impositionQuantity ?? 1}拼)')
        .toList();
    return display.join('、');
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

  Widget _buildSummaryCard(
    BuildContext context,
    ArtworkViewModel viewModel,
    Artwork artwork,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final code = _displayText(artwork.fullCode.isNotEmpty ? artwork.fullCode : artwork.code);
    final name = _displayText(artwork.name);
    final color = _displayText(artwork.colorDisplay);
    final size = _displayText(artwork.impositionSize);
    final status = artwork.confirmed ? '已确认' : '未确认';
    final dies = _compactListText(artwork.dieCodes, artwork.dieNames);
    final foiling = _compactListText(artwork.foilingPlateCodes, artwork.foilingPlateNames);
    final embossing = _compactListText(artwork.embossingPlateCodes, artwork.embossingPlateNames);
    final products = _productSummary(artwork.products);
    final notes = _displayText(artwork.notes);
    final createdAt = _formatDateTime(artwork.createdAt);

    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    '$code · $color',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '状态', value: status),
                      _SummaryChip(label: '拼版', value: size),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                size: 20,
                color: colors?.subtleText ?? theme.hintColor,
              ),
            ),
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '编码', value: code),
              _SummaryField(label: '色数', value: color),
              _SummaryField(label: '拼版尺寸', value: size),
              _SummaryField(label: '确认状态', value: status),
              _SummaryField(label: '关联刀模', value: dies),
              _SummaryField(label: '关联烫金版', value: foiling),
              _SummaryField(label: '关联压凸版', value: embossing),
              _SummaryField(label: '包含产品', value: products),
              _SummaryField(label: '备注', value: notes),
              _SummaryField(label: '创建时间', value: createdAt),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openEditPage(context, viewModel, artwork),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
              OutlinedButton.icon(
                onPressed: () => _createVersion(context, viewModel, artwork),
                icon: const Icon(Icons.control_point_duplicate_outlined, size: 16),
                label: const Text('新版本'),
              ),
              if (!artwork.confirmed)
                OutlinedButton.icon(
                  onPressed: () => _confirmArtwork(context, viewModel, artwork),
                  icon: const Icon(Icons.verified_outlined, size: 16),
                  label: const Text('确认'),
                ),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, viewModel, artwork),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('删除'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
