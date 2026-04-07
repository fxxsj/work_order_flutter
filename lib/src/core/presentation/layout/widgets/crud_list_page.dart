import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/risk_action_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/viewmodels/paginated_view_model.dart';

typedef CrudLoadItems<VM> = Future<void> Function(
  VM viewModel, {
  bool resetPage,
});
typedef CrudHeaderActionsBuilder<VM> = List<Widget> Function(
  BuildContext context,
  VM viewModel,
);
typedef CrudRowActionsBuilder<T, VM> = List<RowAction> Function(
  BuildContext context,
  VM viewModel,
  T item,
);
typedef CrudItemTextBuilder<T> = String Function(T item);
typedef CrudItemTextListBuilder<T> = List<String> Function(T item);
typedef CrudSummaryFieldsBuilder<T> = List<CrudSummaryFieldData> Function(
    T item);
typedef CrudSummaryChipsBuilder<T> = List<CrudSummaryChipData> Function(T item);

class CrudListConfig<T, VM extends PaginatedViewModel<T>> {
  const CrudListConfig({
    required this.searchHintText,
    required this.emptyText,
    required this.emptyIcon,
    required this.columns,
    required this.loadItems,
    required this.titleBuilder,
    required this.summaryFieldsBuilder,
    this.subtitleBuilder,
    this.summaryChipsBuilder,
    this.headerActionsBuilder,
    this.rowActionsBuilder,
    this.enableSearch = true,
    this.searchWidth = 300,
    this.spacing = LayoutTokens.gapSm,
    this.emptyCellText = CrudValueFormatter.empty,
    this.refreshButtonText = '刷新',
    this.retryText = '重新加载',
    this.errorFallbackText = '加载失败',
    this.pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条',
    this.pageSizeLabel = '每页 {size}',
    this.desktopActionsColumnLabel = '操作',
  });

  final String searchHintText;
  final String emptyText;
  final IconData emptyIcon;
  final List<CrudTableColumn<T>> columns;
  final CrudLoadItems<VM> loadItems;
  final CrudItemTextBuilder<T> titleBuilder;
  final CrudSummaryFieldsBuilder<T> summaryFieldsBuilder;
  final CrudItemTextBuilder<T>? subtitleBuilder;
  final CrudSummaryChipsBuilder<T>? summaryChipsBuilder;
  final CrudHeaderActionsBuilder<VM>? headerActionsBuilder;
  final CrudRowActionsBuilder<T, VM>? rowActionsBuilder;
  final bool enableSearch;
  final double searchWidth;
  final double spacing;
  final String emptyCellText;
  final String refreshButtonText;
  final String retryText;
  final String errorFallbackText;
  final String pageInfoTemplate;
  final String pageSizeLabel;
  final String desktopActionsColumnLabel;
}

class CrudTableColumn<T> {
  const CrudTableColumn({
    required this.label,
    required this.cellBuilder,
    this.numeric = false,
  });

  final String label;
  final Widget Function(BuildContext context, T item) cellBuilder;
  final bool numeric;
}

class CrudSummaryFieldData {
  const CrudSummaryFieldData({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class CrudSummaryChipData {
  const CrudSummaryChipData({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class CrudDeleteConfig<T> {
  const CrudDeleteConfig({
    required this.title,
    required this.summaryBuilder,
    this.impactsBuilder,
    this.auditHintBuilder,
    this.confirmText = '确认删除',
    this.successMessageBuilder,
    this.errorMessagePrefix = '删除失败: ',
  });

  final String title;
  final CrudItemTextBuilder<T> summaryBuilder;
  final CrudItemTextListBuilder<T>? impactsBuilder;
  final CrudItemTextBuilder<T>? auditHintBuilder;
  final String confirmText;
  final CrudItemTextBuilder<T>? successMessageBuilder;
  final String errorMessagePrefix;
}

class CrudActionConfig<T> {
  const CrudActionConfig({
    required this.title,
    required this.summaryBuilder,
    this.impactsBuilder,
    this.auditHintBuilder,
    this.confirmText = '确认',
    this.successMessageBuilder,
    this.errorMessagePrefix,
    this.destructive = false,
  });

  final String title;
  final CrudItemTextBuilder<T> summaryBuilder;
  final CrudItemTextListBuilder<T>? impactsBuilder;
  final CrudItemTextBuilder<T>? auditHintBuilder;
  final String confirmText;
  final CrudItemTextBuilder<T>? successMessageBuilder;
  final String? errorMessagePrefix;
  final bool destructive;
}

/// Generic paginated list page for CRUD modules with shared search and actions.
class CrudListPage<T, VM extends PaginatedViewModel<T>> extends StatefulWidget {
  const CrudListPage({
    super.key,
    required this.config,
  });

  final CrudListConfig<T, VM> config;

  @override
  State<CrudListPage<T, VM>> createState() => _CrudListPageState<T, VM>();
}

class _CrudListPageState<T, VM extends PaginatedViewModel<T>>
    extends State<CrudListPage<T, VM>> {
  static const _searchDebounceDuration = AnimationTokens.slower;

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  CrudListConfig<T, VM> get _config => widget.config;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(VM viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      _config.loadItems(viewModel, resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      _config.loadItems(viewModel, resetPage: true);
    });
  }

  String _pageInfoText(VM viewModel) {
    return _config.pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<VM>(
      builder: (context, viewModel, _) {
        final items = viewModel.items;
        return ListPageScaffold(
          spacing: _config.spacing,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, items, isMobile),
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
                  pageSizeLabelBuilder: (size) =>
                      _config.pageSizeLabel.replaceFirst(
                    '{size}',
                    size.toString(),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    VM viewModel,
    List<T> items,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _config.errorFallbackText,
        retryLabel: _config.retryText,
        onRetry: () => _config.loadItems(viewModel, resetPage: true),
      );
    }
    if (!viewModel.loading && items.isEmpty) {
      return EmptyStateCard(
        icon: _config.emptyIcon,
        text: _config.emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, items);
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) => _buildSummaryCard(
        context,
        viewModel,
        items[index],
        isMobile,
      ),
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    VM viewModel,
    List<T> items,
  ) {
    final columns = [
      ..._config.columns.map(
        (column) => DataColumn(
          label: Text(column.label),
          numeric: column.numeric,
        ),
      ),
      if (_config.rowActionsBuilder != null)
        DataColumn(label: Text(_config.desktopActionsColumnLabel)),
    ];

    return AppDataTable(
      columns: columns,
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                ..._config.columns.map(
                  (column) => DataCell(column.cellBuilder(context, item)),
                ),
                if (_config.rowActionsBuilder != null)
                  DataCell(
                    RowActionGroup(
                      actions: _config.rowActionsBuilder!(
                        context,
                        viewModel,
                        item,
                      ),
                    ),
                  ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    VM viewModel,
    T item,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final subtitle = _config.subtitleBuilder?.call(item).trim() ?? '';
    final chips = _config.summaryChipsBuilder?.call(item) ?? const [];
    final fields = _config.summaryFieldsBuilder(item);
    final actions = _config.rowActionsBuilder?.call(context, viewModel, item) ??
        const <RowAction>[];
    final hasExpandedContent = fields.isNotEmpty || actions.isNotEmpty;

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
                    _config.titleBuilder(item),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: sectionSpacing),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors?.subtleText ?? theme.hintColor,
                      ),
                    ),
                  ],
                  if (chips.isNotEmpty) ...[
                    SizedBox(height: sectionSpacing),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: chips
                          .map(
                            (chip) => SummaryChip(
                              label: chip.label,
                              value: chip.value,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            if (hasExpandedContent) ...[
              SizedBox(width: sectionSpacing),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0.0,
                duration: AnimationTokens.expandDuration,
                child: Icon(
                  Icons.expand_more,
                  size: 20,
                  color: colors?.subtleText ?? theme.hintColor,
                ),
              ),
            ],
          ],
        );
      },
      expandedChild: hasExpandedContent
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fields.isNotEmpty)
                  SummaryFieldWrap(
                    isMobile: isMobile,
                    children: fields
                        .map(
                          (field) => SummaryField(
                            label: field.label,
                            value: field.value,
                          ),
                        )
                        .toList(),
                  ),
                if (actions.isNotEmpty) ...[
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: actions
                        .where((action) => action.onPressed != null)
                        .map(
                          (action) => OutlinedButton.icon(
                            onPressed: action.onPressed,
                            icon: Icon(
                              action.icon ?? resolveRowActionIcon(action.label),
                              size: 16,
                            ),
                            label: Text(action.label),
                            style: action.destructive
                                ? OutlinedButton.styleFrom(
                                    foregroundColor: theme.colorScheme.error,
                                  )
                                : null,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            )
          : null,
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    VM viewModel,
    bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final searchField = _config.enableSearch
              ? ListSearchField(
                  controller: _searchController,
                  hintText: _config.searchHintText,
                  height: PageActionStyle.height,
                  width: isMobile ? constraints.maxWidth : _config.searchWidth,
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
              onPressed: () => _config.loadItems(viewModel, resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _config.refreshButtonText,
            ),
            ...?_config.headerActionsBuilder?.call(context, viewModel),
          ];

          return ListToolbar(
            isMobile: isMobile,
            searchField: searchField,
            actions: actions,
            spacing: _config.spacing,
          );
        },
      ),
    );
  }
}

Future<void> confirmCrudDeletion<T>(
  BuildContext context, {
  required T item,
  required Future<void> Function(T item) onDelete,
  required CrudDeleteConfig<T> config,
}) async {
  return confirmCrudAction(
    context,
    item: item,
    onConfirm: onDelete,
    config: CrudActionConfig(
      title: config.title,
      summaryBuilder: config.summaryBuilder,
      impactsBuilder: config.impactsBuilder,
      auditHintBuilder: config.auditHintBuilder,
      confirmText: config.confirmText,
      successMessageBuilder: config.successMessageBuilder,
      errorMessagePrefix: config.errorMessagePrefix,
      destructive: true,
    ),
  );
}

Future<void> confirmCrudAction<T>(
  BuildContext context, {
  required T item,
  required Future<void> Function(T item) onConfirm,
  required CrudActionConfig<T> config,
}) async {
  final confirmed = await showRiskActionConfirmDialog(
    context,
    title: config.title,
    summary: config.summaryBuilder(item),
    impacts: config.impactsBuilder?.call(item) ?? const [],
    auditHint: config.auditHintBuilder?.call(item),
    confirmText: config.confirmText,
    destructive: config.destructive,
  );
  if (!confirmed) {
    return;
  }

  try {
    await onConfirm(item);
    ToastUtil.showSuccess(
      config.successMessageBuilder?.call(item) ??
          (config.destructive ? '删除成功' : '操作成功'),
    );
  } catch (err) {
    final message = err.toString().replaceFirst('Exception: ', '');
    final prefix =
        config.errorMessagePrefix ?? (config.destructive ? '删除失败: ' : '操作失败: ');
    ToastUtil.showError('$prefix$message');
  }
}

class CrudValueFormatter {
  static const String empty = '-';

  static String text(String? value, {String fallback = empty}) {
    final resolved = value?.trim() ?? '';
    return resolved.isEmpty ? fallback : resolved;
  }

  static String number(num? value, {String fallback = empty}) {
    if (value == null) {
      return fallback;
    }
    return value.toString();
  }

  static String amount(
    num? value, {
    int fractionDigits = 2,
    String fallback = empty,
  }) {
    if (value == null) {
      return fallback;
    }
    return value.toStringAsFixed(fractionDigits);
  }

  static String date(DateTime? value, {String fallback = empty}) {
    if (value == null) {
      return fallback;
    }
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String dateTime(DateTime? value, {String fallback = empty}) {
    if (value == null) {
      return fallback;
    }
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}
