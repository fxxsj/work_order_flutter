import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/audit_logs/application/audit_log_view_model.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_api_service.dart';
import 'package:work_order_app/src/features/audit_logs/data/audit_log_repository_impl.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';
import 'package:work_order_app/src/features/audit_logs/domain/audit_log_repository.dart';

/// 审计日志列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class AuditLogListEntry extends StatelessWidget {
  const AuditLogListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<AuditLogApiService, AuditLogRepository,
        AuditLogViewModel>(
      createService: (context) => AuditLogApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          AuditLogRepositoryImpl(context.read<AuditLogApiService>()),
      createViewModel: (context) =>
          AuditLogViewModel(context.read<AuditLogRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const AuditLogListPage(),
    );
  }
}

/// 审计日志列表页视图，只负责渲染。
class AuditLogListPage extends StatelessWidget {
  const AuditLogListPage({super.key});

  @override
  Widget build(BuildContext context) => const _AuditLogListView();
}

class _AuditLogListView extends StatefulWidget {
  const _AuditLogListView();

  @override
  State<_AuditLogListView> createState() => _AuditLogListViewState();
}

class _AuditLogListViewState extends State<_AuditLogListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索用户/对象/类型';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无审计日志';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _prefillKeyword;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final keyword = GoRouterState.of(context).uri.queryParameters['search'];
    final trimmed = keyword?.trim() ?? '';
    if (trimmed == _prefillKeyword) return;
    _prefillKeyword = trimmed;
    _searchController.text = trimmed;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final viewModel = context.read<AuditLogViewModel>();
      viewModel.setSearchText(trimmed);
      viewModel.loadLogs(resetPage: true);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(AuditLogViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadLogs(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadLogs(resetPage: true);
    });
  }

  static String _pageInfoText(AuditLogViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<AuditLogViewModel>(
      builder: (context, viewModel, _) {
        final logs = viewModel.logs;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, logs, isMobile),
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
                      _pageSizeLabel.replaceFirst('{size}', size.toString()),
                )
              : null,
        );
      },
    );
  }

  Widget _buildListBody(
    BuildContext context,
    AuditLogViewModel viewModel,
    List<AuditLog> logs,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && logs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadLogs(resetPage: true),
      );
    }
    if (!viewModel.loading && logs.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.manage_search,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, logs);
    }

    return ListView.separated(
      itemCount: logs.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildSummaryCard(context, log, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    AuditLogViewModel viewModel,
    List<AuditLog> logs,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('日志ID')),
        DataColumn(label: Text('操作类型')),
        DataColumn(label: Text('用户')),
        DataColumn(label: Text('对象类型')),
        DataColumn(label: Text('对象')),
        DataColumn(label: Text('变更字段')),
        DataColumn(label: Text('IP')),
        DataColumn(label: Text('时间')),
      ],
      rows: logs
          .map(
            (log) => DataRow(
              cells: [
                DataCell(
                    Text(log.id.toString(), style: theme.textTheme.bodyMedium)),
                DataCell(Text(_displayText(log.actionType), style: textStyle)),
                DataCell(Text(_displayText(log.username), style: textStyle)),
                DataCell(
                    Text(_displayText(log.contentTypeName), style: textStyle)),
                DataCell(Text(_displayText(log.objectRepr), style: textStyle)),
                DataCell(
                    Text(_displayText(log.changedFields), style: textStyle)),
                DataCell(Text(_displayText(log.ipAddress), style: textStyle)),
                DataCell(
                    Text(_formatDateTime(log.createdAt), style: textStyle)),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    AuditLogViewModel viewModel,
    bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final activeSearch = viewModel.searchText.trim();
          final searchField = ListSearchField(
            controller: _searchController,
            hintText: _searchHintText,
            height: _controlHeight,
            width: isMobile ? constraints.maxWidth : _searchWidth,
            onChanged: (_) => _scheduleSearch(viewModel),
            onSubmitted: (_) => _scheduleSearch(viewModel, immediate: true),
            onClear: () {
              _searchController.clear();
              _scheduleSearch(viewModel, immediate: true);
            },
          );

          final actions = <Widget>[
            if (activeSearch.isNotEmpty)
              PageActionButton.outlined(
                onPressed: () {
                  _searchController.clear();
                  _scheduleSearch(viewModel, immediate: true);
                },
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除筛选',
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadLogs(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
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

  Widget _buildSummaryCard(BuildContext context, AuditLog log, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final objectRepr = log.objectRepr?.trim().isNotEmpty == true
        ? log.objectRepr!
        : '日志 #${log.id}';
    final actionType = _displayText(log.actionType);
    final username = _displayText(log.username);
    final contentType = _displayText(log.contentTypeName);
    final changedFields = _displayText(log.changedFields);
    final ipAddress = _displayText(log.ipAddress);
    final createdAt = _formatDateTime(log.createdAt);

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
                    objectRepr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    '$username · $actionType',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '对象类型', value: contentType),
                      _SummaryChip(label: 'IP', value: ipAddress),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: sectionSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  createdAt,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors?.subtleText ?? theme.hintColor,
                  ),
                ),
                SizedBox(height: sectionSpacing),
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
            ),
          ],
        );
      },
      expandedChild: SummaryFieldWrap(
        isMobile: isMobile,
        desktopWidth: 240,
        children: [
          _SummaryField(label: '日志ID', value: log.id.toString()),
          _SummaryField(label: '操作类型', value: actionType),
          _SummaryField(label: '用户', value: username),
          _SummaryField(label: '对象类型', value: contentType),
          _SummaryField(label: '对象', value: _displayText(log.objectRepr)),
          _SummaryField(label: '变更字段', value: changedFields),
          _SummaryField(label: 'IP', value: ipAddress),
          _SummaryField(label: '时间', value: createdAt),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? value) {
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

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
