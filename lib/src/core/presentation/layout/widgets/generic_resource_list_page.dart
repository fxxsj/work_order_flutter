import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/data/generic_repository_impl.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/dialogs.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/viewmodels/generic_list_view_model.dart';

class GenericResourceConfig {
  const GenericResourceConfig({
    required this.id,
    required this.title,
    required this.endpoint,
    required this.searchHintText,
    required this.emptyText,
    required this.emptyIcon,
    required this.columns,
    required this.summaryFields,
    this.enableSearch = true,
    this.enableDetails = true,
    this.pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条',
    this.pageSizeLabel = '每页 {size}',
    this.refreshLabel = '刷新',
    this.retryLabel = '重新加载',
    this.errorFallbackText = '加载失败',
    this.titleBuilder,
    this.detailTitle,
    this.detailFields,
    this.rowActionsBuilder,
    this.headerActionsBuilder,
    this.extraParamsBuilder,
    this.enableSummary = false,
    this.openDetailsOnPrimaryTap = false,
  });

  final String id;
  final String title;
  final String endpoint;
  final String searchHintText;
  final String emptyText;
  final IconData emptyIcon;
  final List<GenericColumn> columns;
  final List<GenericSummaryField> summaryFields;
  final bool enableSearch;
  final bool enableDetails;
  final String pageInfoTemplate;
  final String pageSizeLabel;
  final String refreshLabel;
  final String retryLabel;
  final String errorFallbackText;
  final String Function(GenericRecord record)? titleBuilder;
  final String? detailTitle;
  final List<GenericDetailField>? detailFields;
  final List<RowAction> Function(
    BuildContext context,
    GenericRecord record,
    VoidCallback openDetails,
  )? rowActionsBuilder;
  final List<Widget> Function(
    BuildContext context,
    GenericListViewModel viewModel,
  )? headerActionsBuilder;
  final Map<String, dynamic> Function(Uri uri)? extraParamsBuilder;
  final bool enableSummary;
  final bool openDetailsOnPrimaryTap;
}

class GenericColumn {
  const GenericColumn({
    required this.label,
    required this.value,
    this.numeric = false,
  });

  final String label;
  final String Function(GenericRecord record) value;
  final bool numeric;
}

class GenericSummaryField {
  const GenericSummaryField({
    required this.label,
    required this.value,
  });

  final String label;
  final String Function(GenericRecord record) value;
}

class GenericDetailField {
  const GenericDetailField({
    required this.label,
    required this.value,
  });

  final String label;
  final String Function(GenericRecord record) value;
}

class GenericValueFormatter {
  static const String empty = '-';

  static String text(dynamic value) {
    if (value == null) return empty;
    final asString = value.toString().trim();
    return asString.isEmpty ? empty : asString;
  }

  static String boolText(bool? value) {
    if (value == null) return empty;
    return value ? '是' : '否';
  }

  static String date(dynamic value) {
    if (value == null) return empty;
    if (value is DateTime) {
      return _formatDate(value);
    }
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed == null ? text(value) : _formatDate(parsed);
    }
    return text(value);
  }

  static String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}

class GenericResourceListEntry extends StatelessWidget {
  const GenericResourceListEntry({super.key, required this.config});

  final GenericResourceConfig config;

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<GenericApiService, GenericRepository,
        GenericListViewModel>(
      createService: (context) => GenericApiService(
        context.read<ApiClient>(),
        resourcePath: config.endpoint,
      ),
      createRepository: (context) =>
          GenericRepositoryImpl(context.read<GenericApiService>()),
      createViewModel: (context) => GenericListViewModel(
        context.read<GenericRepository>(),
        enableSummary: config.enableSummary,
      ),
      initialize: (viewModel) => viewModel.initialize(),
      child: GenericResourceListPage(config: config),
    );
  }
}

class GenericResourceListPage extends StatefulWidget {
  const GenericResourceListPage({super.key, required this.config});

  final GenericResourceConfig config;

  @override
  State<GenericResourceListPage> createState() =>
      _GenericResourceListPageState();
}

class _GenericResourceListPageState extends State<GenericResourceListPage> {
  static const _searchDebounceDuration = AnimationTokens.slower;
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _prefillKeyword;
  Map<String, dynamic> _prefillExtraParams = const {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    final keyword = uri.queryParameters['search'];
    final extraParams = Map<String, dynamic>.from(
      widget.config.extraParamsBuilder?.call(uri) ?? const {},
    );
    final trimmed = keyword?.trim() ?? '';
    if (_prefillKeyword == null &&
        trimmed.isEmpty &&
        _prefillExtraParams.isEmpty &&
        extraParams.isEmpty) {
      _prefillKeyword = '';
      return;
    }
    if (trimmed == _prefillKeyword &&
        mapEquals(extraParams, _prefillExtraParams)) {
      return;
    }
    _prefillKeyword = trimmed;
    _prefillExtraParams = extraParams;
    _searchController.text = trimmed;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GenericListViewModel>().applyRoutePrefill(
            search: trimmed,
            extraParams: extraParams,
          );
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(GenericListViewModel viewModel,
      {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.reload(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.reload(resetPage: true);
    });
  }

  String _pageInfoText(GenericListViewModel viewModel) {
    return widget.config.pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<GenericListViewModel>(
      builder: (context, viewModel, _) {
        final records = viewModel.records;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, records, isMobile),
          footer: viewModel.totalPages > 1
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
                  pageSizeLabelBuilder: (size) => widget.config.pageSizeLabel
                      .replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    GenericListViewModel viewModel,
    bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final searchField = widget.config.enableSearch
              ? ListSearchField(
                  controller: _searchController,
                  hintText: widget.config.searchHintText,
                  height: PageActionStyle.height,
                  width: isMobile ? constraints.maxWidth : _searchWidth,
                  onChanged: (_) => _scheduleSearch(viewModel),
                  onSubmitted: (_) =>
                      _scheduleSearch(viewModel, immediate: true),
                  onClear: () {
                    _searchController.clear();
                    _scheduleSearch(viewModel, immediate: true);
                  },
                )
              : null;

          final actions = <Widget>[
            PageActionButton.outlined(
              onPressed: () => viewModel.reload(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: widget.config.refreshLabel,
            ),
            ...?widget.config.headerActionsBuilder?.call(context, viewModel),
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

  Widget _buildListBody(
    BuildContext context,
    GenericListViewModel viewModel,
    List<GenericRecord> records,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && records.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? widget.config.errorFallbackText,
        retryLabel: widget.config.retryLabel,
        onRetry: () => viewModel.reload(resetPage: true),
      );
    }
    if (!viewModel.loading && records.isEmpty) {
      return EmptyStateCard(
        icon: widget.config.emptyIcon,
        text: widget.config.emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, records);
    }

    return ListView.separated(
      itemCount: records.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final record = records[index];
        return _buildSummaryCard(context, record, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<GenericRecord> records) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    final hasActions =
        widget.config.enableDetails || widget.config.rowActionsBuilder != null;
    final columns = [
      for (final column in widget.config.columns)
        DataColumn(
          label: Text(column.label),
          numeric: column.numeric,
        ),
      if (hasActions) const DataColumn(label: Text('操作')),
    ];

    return AppDataTable(
      columns: columns,
      rows: records.map((record) {
        final actions = _resolveRowActions(context, record);
        return DataRow(
          cells: [
            for (var index = 0; index < widget.config.columns.length; index++)
              DataCell(
                index == 0 && widget.config.openDetailsOnPrimaryTap
                    ? InkWell(
                        onTap: () => _openDetails(context, record),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            widget.config.columns[index].value(record),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        widget.config.columns[index].value(record),
                        style: textStyle,
                      ),
              ),
            if (hasActions)
              DataCell(
                actions.isEmpty
                    ? const SizedBox.shrink()
                    : RowActionGroup(actions: actions),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    GenericRecord record,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final titleBuilder = widget.config.titleBuilder ??
        (GenericRecord record) =>
            record.getString('name') ??
            record.getString('title') ??
            record.id.toString();
    final summaryFields = widget.config.summaryFields
        .map((field) => SummaryField(
              label: field.label,
              value: field.value(record),
            ))
        .toList();

    final actions = _resolveRowActions(context, record);
    return ExpandableSummaryCard(
      headerBuilder: (context, expanded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.config.openDetailsOnPrimaryTap
                ? InkWell(
                    onTap: () => _openDetails(context, record),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        titleBuilder(record),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                : Text(
                    titleBuilder(record),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
            if (widget.config.enableDetails) ...[
              const SizedBox(height: LayoutTokens.gapSm),
              Text(
                '查看详情',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors?.subtleText,
                ),
              ),
            ],
          ],
        );
      },
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(isMobile: isMobile, children: summaryFields),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            Align(
              alignment: Alignment.centerLeft,
              child: RowActionGroup(actions: actions),
            ),
          ],
        ],
      ),
    );
  }

  List<RowAction> _resolveRowActions(
    BuildContext context,
    GenericRecord record,
  ) {
    final defaultAction = widget.config.enableDetails
        ? RowAction(
            label: '查看',
            onPressed: () => _openDetails(context, record),
          )
        : null;
    final custom = widget.config.rowActionsBuilder
        ?.call(context, record, () => _openDetails(context, record));
    if (custom != null && custom.isNotEmpty) {
      return custom;
    }
    return defaultAction == null ? const [] : [defaultAction];
  }

  Future<void> _openDetails(BuildContext context, GenericRecord record) async {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final title = widget.config.detailTitle ?? widget.config.title;
    final detailFields = widget.config.detailFields ??
        record.data.keys
            .map((key) => GenericDetailField(
                  label: key,
                  value: (record) => _formatDetailValue(record.data[key]),
                ))
            .toList();

    await showDialog<void>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        maxWidth: 520,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final field in detailFields) ...[
              Text(
                field.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors?.subtleText ?? theme.hintColor,
                ),
              ),
              const SizedBox(height: LayoutTokens.gapXs),
              Text(
                field.value(record),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: LayoutTokens.gapSm),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  String _formatDetailValue(dynamic value) {
    if (value == null) return GenericValueFormatter.empty;
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final preferKeys = ['name', 'title', 'label', 'order_number', 'code'];
      for (final key in preferKeys) {
        final candidate = map[key];
        if (candidate != null) return GenericValueFormatter.text(candidate);
      }
      return GenericValueFormatter.text(map);
    }
    if (value is List) {
      if (value.isEmpty) return GenericValueFormatter.empty;
      return value.map(_formatDetailValue).join(' / ');
    }
    return GenericValueFormatter.text(value);
  }
}
