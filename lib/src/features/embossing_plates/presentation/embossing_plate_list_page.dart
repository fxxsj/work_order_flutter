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
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索压凸版编码、名称、尺寸、材质';
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

  Future<void> _openEditPage(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    EmbossingPlate? plate,
  ) async {
    EmbossingPlate? target = plate;
    if (plate != null) {
      try {
        final apiService = context.read<EmbossingPlateApiService>();
        final detail = await apiService.fetchEmbossingPlate(plate.id);
        target = detail.toEntity();
      } catch (err) {
        if (!mounted) return;
        ToastUtil.showError('加载压凸版详情失败: $err');
        return;
      }
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: EmbossingPlateEditPage(plate: target),
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

  static String _pageInfoText(EmbossingPlateViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<EmbossingPlateViewModel>(
      builder: (context, viewModel, _) {
        final plates = viewModel.embossingPlates;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, plates, isMobile),
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
    EmbossingPlateViewModel viewModel,
    List<EmbossingPlate> plates,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && plates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadEmbossingPlates(resetPage: true),
      );
    }
    if (!viewModel.loading && plates.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.dashboard_customize_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, plates);
    }

    return ListView.separated(
      itemCount: plates.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final plate = plates[index];
        return _buildSummaryCard(context, viewModel, plate, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    EmbossingPlateViewModel viewModel,
    List<EmbossingPlate> plates,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('压凸版')),
        DataColumn(label: Text('编码')),
        DataColumn(label: Text('尺寸')),
        DataColumn(label: Text('材质')),
        DataColumn(label: Text('厚度')),
        DataColumn(label: Text('确认状态')),
        DataColumn(label: Text('包含产品')),
        DataColumn(label: Text('创建时间')),
        DataColumn(label: Text('操作')),
      ],
      rows: plates
          .map(
            (plate) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(plate.name),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(_displayText(plate.code), style: textStyle)),
                DataCell(Text(_displayText(plate.size), style: textStyle)),
                DataCell(Text(_displayText(plate.material), style: textStyle)),
                DataCell(Text(_displayText(plate.thickness), style: textStyle)),
                DataCell(Text(plate.confirmed ? '已确认' : '待确认',
                    style: textStyle)),
                DataCell(
                    Text(_productSummary(plate.products), style: textStyle)),
                DataCell(
                    Text(_formatDateTime(plate.createdAt), style: textStyle)),
                DataCell(RowActionGroup(
                  actions: [
                    RowAction(
                      label: '编辑',
                      onPressed: () =>
                          _openEditPage(context, viewModel, plate),
                    ),
                    if (!plate.confirmed)
                      RowAction(
                        label: '确认',
                        onPressed: () =>
                            _confirmPlate(context, viewModel, plate),
                      ),
                    RowAction(
                      label: '删除',
                      onPressed: () =>
                          _confirmDelete(context, viewModel, plate),
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
    EmbossingPlateViewModel viewModel,
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
              onPressed: () => viewModel.loadEmbossingPlates(resetPage: true),
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

  static String _productSummary(List<EmbossingPlateProduct> products) {
    if (products.isEmpty) return _emptyCellText;
    final display = products.map((item) => '${item.productName}(${item.quantity ?? 1}个)').toList();
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
    EmbossingPlateViewModel viewModel,
    EmbossingPlate plate,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final code = _displayText(plate.code);
    final name = _displayText(plate.name);
    final size = _displayText(plate.size);
    final material = _displayText(plate.material);
    final thickness = _displayText(plate.thickness);
    final confirmed = plate.confirmed ? '已确认' : '待确认';
    final products = _productSummary(plate.products);
    final notes = _displayText(plate.notes);
    final createdAt = _formatDateTime(plate.createdAt);

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
                    '$code · $size',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '状态', value: confirmed),
                      _SummaryChip(label: '材质', value: material),
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
              _SummaryField(label: '尺寸', value: size),
              _SummaryField(label: '材质', value: material),
              _SummaryField(label: '厚度', value: thickness),
              _SummaryField(label: '确认状态', value: confirmed),
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
                onPressed: () => _openEditPage(context, viewModel, plate),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
              if (!plate.confirmed)
                OutlinedButton.icon(
                  onPressed: () => _confirmPlate(context, viewModel, plate),
                  icon: const Icon(Icons.verified_outlined, size: 16),
                  label: const Text('确认'),
                ),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, viewModel, plate),
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
