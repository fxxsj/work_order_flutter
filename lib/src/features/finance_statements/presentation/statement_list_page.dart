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
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/audit_log_navigation.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_statements/application/statement_view_model.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_api_service.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_repository_impl.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_support_service.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';
import 'package:work_order_app/src/features/finance_statements/presentation/widgets/statement_list_dialogs.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

/// 对账单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class StatementListEntry extends StatelessWidget {
  const StatementListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<StatementApiService, StatementRepository,
        StatementViewModel>(
      createService: (context) =>
          StatementApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          StatementRepositoryImpl(context.read<StatementApiService>()),
      createViewModel: (context) =>
          StatementViewModel(context.read<StatementRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const StatementListPage(),
    );
  }
}

/// 对账单列表页视图，只负责渲染。
class StatementListPage extends StatelessWidget {
  const StatementListPage({super.key});

  @override
  Widget build(BuildContext context) => const _StatementListView();
}

class _StatementListView extends StatefulWidget {
  const _StatementListView();

  @override
  State<_StatementListView> createState() => _StatementListViewState();
}

class _StatementListViewState extends State<_StatementListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索对账单号/对方单位';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无对账单数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _optionsLoading = false;
  bool _optionsLoaded = false;
  List<Customer> _customers = [];
  List<Supplier> _suppliers = [];
  StatementSupportService? _supportService;
  String? _lastRouteSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= StatementSupportService(context.read<ApiClient>());
    final uri = GoRouterState.of(context).uri;
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeStatus = uri.queryParameters['status']?.trim() ?? '';
    final routeTodo = uri.queryParameters['todo']?.trim() ?? '';
    final signature = '$routeSearch|$routeStatus|$routeTodo';
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    _searchController.text = routeSearch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<StatementViewModel>().applyRoutePrefill(
            search: routeSearch,
            status: routeStatus,
            todo: routeTodo,
          );
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(StatementViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStatements(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStatements(resetPage: true);
    });
  }

  Future<void> _loadOptions() async {
    if (_optionsLoaded || _optionsLoading) return;
    setState(() => _optionsLoading = true);
    try {
      final options = await _supportService!.loadOptions();
      if (!mounted) return;
      setState(() {
        _customers = options.customers;
        _suppliers = options.suppliers;
        _optionsLoaded = true;
      });
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('加载基础数据失败: $err');
    } finally {
      if (mounted) setState(() => _optionsLoading = false);
    }
  }

  Future<void> _openCreateDialog(StatementViewModel viewModel) async {
    if (!PermissionUtil.hasPermission(context, 'workorder.add_statement')) {
      ToastUtil.showError('当前账号无权新建对账单');
      return;
    }
    await _loadOptions();
    if (_customers.isEmpty && _suppliers.isEmpty) {
      ToastUtil.showError('请先配置客户或供应商信息');
      return;
    }
    final result = await showStatementCreateDialog(
      context,
      customers: _customers,
      suppliers: _suppliers,
    );
    if (result == null) return;
    try {
      await _supportService!.createStatement(result.payload);
      ToastUtil.showSuccess('对账单已创建');
      await viewModel.loadStatements(resetPage: false);
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  Future<void> _openGenerateDialog() async {
    if (!PermissionUtil.hasPermission(context, 'workorder.add_statement')) {
      ToastUtil.showError('当前账号无权生成对账数据');
      return;
    }
    await _loadOptions();
    final result = await showStatementGenerateDialog(
      context,
      customers: _customers,
      suppliers: _suppliers,
    );
    if (result == null) return;
    try {
      final preview = await _supportService!.generate(result.params);
      if (!mounted) return;
      await showStatementGeneratePreviewDialog(context, result: preview);
    } catch (err) {
      ToastUtil.showError('生成失败: $err');
    }
  }

  Future<void> _confirmStatement(
    StatementViewModel viewModel,
    Statement statement, {
    required bool confirmed,
  }) async {
    if (!PermissionUtil.hasPermission(context, 'workorder.change_statement')) {
      ToastUtil.showError('当前账号无权处理对账状态');
      return;
    }
    final notes = await showStatementConfirmDialog(
      context,
      confirmed: confirmed,
    );
    if (notes == null) return;
    try {
      await _supportService!.confirmStatement(
        statement.id,
        confirmed: confirmed,
        notes: notes,
      );
      ToastUtil.showSuccess(confirmed ? '已确认' : '已标记为有异议');
      await viewModel.loadStatements(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    }
  }

  static String _pageInfoText(StatementViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<StatementViewModel>(
      builder: (context, viewModel, _) {
        final statements = viewModel.statements;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, statements, isMobile),
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
    StatementViewModel viewModel,
    List<Statement> statements,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && statements.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadStatements(resetPage: true),
      );
    }
    if (!viewModel.loading && statements.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.summarize_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, statements);
    }

    return ListView.separated(
      itemCount: statements.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final statement = statements[index];
        return _buildSummaryCard(context, statement, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    StatementViewModel viewModel,
    List<Statement> statements,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('对账单号')),
        DataColumn(label: Text('对方单位')),
        DataColumn(label: Text('类型')),
        DataColumn(label: Text('对账周期')),
        DataColumn(label: Text('期末余额')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('待办')),
        DataColumn(label: Text('操作')),
      ],
      rows: statements
          .map(
            (statement) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(
                      statement.statementNumber ?? '对账单 #${statement.id}'),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(Text(_displayText(statement.customerName),
                    style: textStyle)),
                DataCell(Text(_statementTypeText(statement), style: textStyle)),
                DataCell(Text(
                    _formatPeriod(statement.periodStart, statement.periodEnd),
                    style: textStyle)),
                DataCell(Text(_formatAmount(statement.closingBalance),
                    style: theme.textTheme.bodyMedium)),
                DataCell(Text(
                  statement.statusDisplay ?? statement.status ?? _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(_followUpText(statement), style: textStyle)),
                DataCell(_buildRowActions(viewModel, statement)),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    StatementViewModel viewModel,
    bool isMobile,
  ) {
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final pendingConfirmCount =
              _summaryCount(viewModel.summary, 'pending_confirm_count');
          final disputedCount =
              _summaryCount(viewModel.summary, 'disputed_count');
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
            if (pendingConfirmCount > 0)
              StatusHintChip(
                label: '待确认对账',
                count: pendingConfirmCount,
                icon: Icons.fact_check_outlined,
                selected: viewModel.todoFilter == 'pending_confirm',
                onTap: () => _openQuickFilter(todo: 'pending_confirm'),
              ),
            if (disputedCount > 0)
              StatusHintChip(
                label: '异议待处理',
                count: disputedCount,
                icon: Icons.report_problem_outlined,
                selected: viewModel.statusFilter == 'disputed' ||
                    viewModel.todoFilter == 'disputed',
                onTap: () => _openQuickFilter(status: 'disputed'),
              ),
            if (viewModel.statusFilter.isNotEmpty ||
                viewModel.todoFilter.isNotEmpty)
              PageActionButton.outlined(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除筛选',
              ),
            if (PermissionUtil.hasPermission(
                context, 'workorder.add_statement'))
              PageActionButton.filled(
                onPressed: () => _openCreateDialog(viewModel),
                icon: const Icon(Icons.add, size: 16),
                label: '新建对账单',
              ),
            if (PermissionUtil.hasPermission(
                context, 'workorder.add_statement'))
              PageActionButton.outlined(
                onPressed: _openGenerateDialog,
                icon: const Icon(Icons.auto_fix_high_outlined, size: 16),
                label: '生成对账数据',
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadStatements(resetPage: true),
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

  Widget _buildRowActions(StatementViewModel viewModel, Statement statement) {
    final canChangeStatement =
        PermissionUtil.hasPermission(context, 'workorder.change_statement');
    final canViewAudit = AuditLogNavigation.canView(context);
    final actions = <RowAction>[];
    final status = statement.status ?? '';
    if (canChangeStatement && (status == 'draft' || status == 'sent')) {
      actions.add(RowAction(
        label: '确认',
        icon: Icons.verified_outlined,
        onPressed: () =>
            _confirmStatement(viewModel, statement, confirmed: true),
      ));
      actions.add(RowAction(
        label: '有异议',
        icon: Icons.report_outlined,
        destructive: true,
        onPressed: () =>
            _confirmStatement(viewModel, statement, confirmed: false),
      ));
    }
    final auditKeyword = (statement.statementNumber ?? '').trim();
    if (canViewAudit && auditKeyword.isNotEmpty) {
      actions.add(RowAction(
        label: '审计',
        icon: Icons.history_outlined,
        onPressed: () =>
            AuditLogNavigation.open(context, keyword: auditKeyword),
      ));
    }
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return RowActionGroup(actions: actions, primaryCount: 2);
  }

  static String _displayText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? _emptyCellText : text;
  }

  String _formatAmount(double? value) {
    if (value == null) return _emptyCellText;
    return value.toStringAsFixed(2);
  }

  String _formatPeriod(DateTime? start, DateTime? end) {
    if (start == null && end == null) return _emptyCellText;
    final startText = _formatDate(start);
    final endText = _formatDate(end);
    return '$startText ~ $endText';
  }

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Widget _buildSummaryCard(
      BuildContext context, Statement statement, bool isMobile) {
    final canChangeStatement =
        PermissionUtil.hasPermission(context, 'workorder.change_statement');
    final canViewAudit = AuditLogNavigation.canView(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number =
        _displayText(statement.statementNumber ?? '对账单 #${statement.id}');
    final customer = _displayText(statement.customerName);
    final statementType = _statementTypeText(statement);
    final period = _formatPeriod(statement.periodStart, statement.periodEnd);
    final amount = _formatAmount(statement.totalAmount);
    final closingBalance = _formatAmount(statement.closingBalance);
    final status =
        statement.statusDisplay ?? statement.status ?? _emptyCellText;
    final followUp = _followUpText(statement);

    final actions = <RowAction>[];
    final statusCode = statement.status ?? '';
    if (canChangeStatement && (statusCode == 'draft' || statusCode == 'sent')) {
      actions.add(RowAction(
        label: '确认',
        icon: Icons.verified_outlined,
        onPressed: () => _confirmStatement(
          context.read<StatementViewModel>(),
          statement,
          confirmed: true,
        ),
      ));
      actions.add(RowAction(
        label: '有异议',
        icon: Icons.report_outlined,
        destructive: true,
        onPressed: () => _confirmStatement(
          context.read<StatementViewModel>(),
          statement,
          confirmed: false,
        ),
      ));
    }
    final auditKeyword = (statement.statementNumber ?? '').trim();
    if (canViewAudit && auditKeyword.isNotEmpty) {
      actions.add(RowAction(
        label: '审计',
        icon: Icons.history_outlined,
        onPressed: () =>
            AuditLogNavigation.open(context, keyword: auditKeyword),
      ));
    }
    if ((statement.statementType ?? '') == 'customer') {
      actions.add(RowAction(
        label: '客户订单',
        icon: Icons.point_of_sale_outlined,
        onPressed: () => context.go('/sales-orders'),
      ));
    }

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
                    number,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors?.sidebarText,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Text(
                    customer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors?.subtleText ?? theme.hintColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryChip(label: '金额', value: amount),
                      _SummaryChip(label: '状态', value: status),
                      _SummaryChip(label: '待办', value: followUp),
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
                  period,
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
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryFieldWrap(
            isMobile: isMobile,
            children: [
              _SummaryField(label: '对账单号', value: number),
              _SummaryField(label: '对方单位', value: customer),
              _SummaryField(label: '对账类型', value: statementType),
              _SummaryField(label: '对账周期', value: period),
              _SummaryField(label: '本期金额', value: amount),
              _SummaryField(label: '期末余额', value: closingBalance),
              _SummaryField(label: '状态', value: status),
              _SummaryField(label: '待办', value: followUp),
              if ((statement.confirmedByName ?? '').trim().isNotEmpty)
                _SummaryField(
                  label: '确认人',
                  value: _displayText(statement.confirmedByName),
                ),
              if (statement.confirmedAt != null)
                _SummaryField(
                  label: '确认时间',
                  value: _formatDate(statement.confirmedAt),
                ),
              if ((statement.confirmationNotes ?? '').trim().isNotEmpty)
                _SummaryField(
                  label: '确认备注',
                  value: _displayText(statement.confirmationNotes),
                ),
            ],
          ),
          if (actions.isNotEmpty) ...[
            SizedBox(height: sectionSpacing),
            RowActionGroup(actions: actions, primaryCount: 2),
          ],
        ],
      ),
    );
  }

  String _statementTypeText(Statement statement) {
    return _displayText(
      statement.statementTypeDisplay ?? statement.statementType,
    );
  }

  String _followUpText(Statement statement) {
    final backendText = statement.followUpText?.trim() ?? '';
    if (backendText.isNotEmpty) {
      return backendText;
    }
    final status = statement.status ?? '';
    if (status == 'draft' || status == 'sent') {
      return '待对方确认';
    }
    if (status == 'disputed') {
      return '待财务处理异议';
    }
    return '已闭环';
  }

  void _clearFilters() {
    final search = _searchController.text.trim();
    final query = <String, String>{};
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    context.go(
        Uri(path: '/finance/statements', queryParameters: query).toString());
  }

  void _openQuickFilter({
    String? status,
    String? todo,
  }) {
    final query = <String, String>{};
    final search = _searchController.text.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    if ((status ?? '').trim().isNotEmpty) {
      query['status'] = status!.trim();
    }
    if ((todo ?? '').trim().isNotEmpty) {
      query['todo'] = todo!.trim();
    }
    context.go(
        Uri(path: '/finance/statements', queryParameters: query).toString());
  }

  int _summaryCount(Map<String, dynamic> payload, String key) {
    final summary = _summaryMap(payload);
    final value = summary[key];
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> _summaryMap(Map<String, dynamic> payload) {
    final summary = payload['summary'];
    if (summary is Map<String, dynamic>) {
      return summary;
    }
    if (summary is Map) {
      return Map<String, dynamic>.from(summary);
    }
    return const {};
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
