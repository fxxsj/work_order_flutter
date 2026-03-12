import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/nav_config.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
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
  static const double _spacingSm = LayoutTokens.gapSm;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索刀模编码、名称、尺寸、材质';
  static const String _refreshButtonText = '刷新';
  static const String _createButtonText = '新建刀模';
  static const String _emptyText = '暂无刀模数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _deleteDialogTitle = '确认删除';
  static const String _deleteDialogContent = '确定要删除刀模 "{name}" 吗？此操作不可恢复。';
  static const String _cancelText = '取消';
  static const String _okText = '确定';
  static const String _deleteSuccessText = '删除成功';
  static const String _deleteFailedText = '删除失败: ';
  static const String _createSuccessText = '创建成功';
  static const String _updateSuccessText = '更新成功';
  static const String _breadcrumbSeparator = ' / ';
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

  static String _pageInfoText(DieViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  Future<void> _openEditPage(BuildContext context, DieViewModel viewModel, Die? die) async {
    Die? target = die;
    if (die != null) {
      try {
        final apiService = context.read<DieApiService>();
        final detail = await apiService.fetchDie(die.id);
        target = detail.toEntity();
      } catch (err) {
        if (!mounted) return;
        ToastUtil.showError('加载刀模详情失败: $err');
        return;
      }
    }
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: viewModel,
          child: DieEditPage(die: target),
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
    DieViewModel viewModel,
    List<Die> dies,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && dies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadDies(resetPage: true),
      );
    }
    if (!viewModel.loading && dies.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.cut_outlined,
        text: _emptyText,
      );
    }

    return ListView.separated(
      itemCount: dies.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final die = dies[index];
        return _buildSummaryCard(context, viewModel, die, isMobile);
      },
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
              onPressed: () => viewModel.loadDies(resetPage: true),
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
  static String _productSummary(List<DieProduct> products) {
    if (products.isEmpty) return _emptyCellText;
    final display = products
        .map((item) => '${item.productName}(${item.quantity ?? 1}拼)')
        .toList();
    return display.join('、');
  }

  Widget _buildSummaryCard(
    BuildContext context,
    DieViewModel viewModel,
    Die die,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final code = _displayText(die.code);
    final name = _displayText(die.name);
    final type = _displayText(die.dieTypeDisplay ?? _dieTypeLabel(die.dieType));
    final size = _displayText(die.size);
    final material = _displayText(die.material);
    final thickness = _displayText(die.thickness);
    final confirmed = die.confirmed ? '已确认' : '待确认';
    final products = _productSummary(die.products);
    final notes = _displayText(die.notes);
    final createdAt = _formatDateTime(die.createdAt);

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
                    '$code · $type',
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
                      _SummaryChip(label: '尺寸', value: size),
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
              _SummaryField(label: '类型', value: type),
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
                onPressed: () => _openEditPage(context, viewModel, die),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
              ),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context, viewModel, die),
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
