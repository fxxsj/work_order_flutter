import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
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
import 'package:work_order_app/src/core/utils/audit_log_navigation.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/domain/customer_repository.dart';
import 'package:work_order_app/src/features/customer/presentation/widgets/quick_customer_create_dialog.dart';
import 'package:work_order_app/src/features/finance_statements/application/statement_view_model.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';
import 'package:work_order_app/src/features/finance_statements/presentation/widgets/statement_list_dialogs.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';
import 'package:work_order_app/src/features/suppliers/presentation/widgets/quick_supplier_create_dialog.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';

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
  static const double _searchWidth = 320;
  static const double _spacingSm = SpacingTokens.sm;
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
  final _debounce = DebounceController();
  bool _optionsLoading = false;
  bool _optionsLoaded = false;
  List<Customer> _customers = [];
  List<Supplier> _suppliers = [];
  String? _lastRouteSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeStatementType =
        uri.queryParameters['statement_type']?.trim() ??
        uri.queryParameters['type']?.trim() ??
        '';
    final routeStatus = uri.queryParameters['status']?.trim() ?? '';
    final routeTodo = uri.queryParameters['todo']?.trim() ?? '';
    final routeCustomer =
        uri.queryParameters['customer']?.trim() ??
        uri.queryParameters['partner']?.trim() ??
        '';
    final routeSupplier = uri.queryParameters['supplier']?.trim() ?? '';
    final routePeriodStart = uri.queryParameters['period_start']?.trim() ?? '';
    final routePeriodEnd = uri.queryParameters['period_end']?.trim() ?? '';
    final routeOrdering = uri.queryParameters['ordering']?.trim() ?? '';
    final signature = [
      routeSearch,
      routeStatementType,
      routeStatus,
      routeTodo,
      routeCustomer,
      routeSupplier,
      routePeriodStart,
      routePeriodEnd,
      routeOrdering,
    ].join('|');
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    _searchController.text = routeSearch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<StatementViewModel>().applyRoutePrefill(
        search: routeSearch,
        statementType: routeStatementType,
        status: routeStatus,
        todo: routeTodo,
        customer: routeCustomer,
        supplier: routeSupplier,
        periodStart: routePeriodStart,
        periodEnd: routePeriodEnd,
        ordering: routeOrdering,
      );
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(StatementViewModel viewModel, {bool immediate = false}) {
    _debounce.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStatements(resetPage: true);
      return;
    }
    _debounce.run(() {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadStatements(resetPage: true);
    });
  }

  Future<void> _loadOptions() async {
    if (_optionsLoaded || _optionsLoading) return;
    setState(() => _optionsLoading = true);
    try {
      final repository = context.read<StatementRepository>();
      final options = await repository.loadOptions();
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
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_statement')) {
      ToastUtil.showError('当前账号无权新建对账单');
      return;
    }
    await _loadOptions();
    final result = await showStatementCreateDialog(
      context,
      customers: _customers,
      suppliers: _suppliers,
      onCreateCustomer: _createCustomer,
      onCreateSupplier: _createSupplier,
    );
    if (result == null) return;
    try {
      final repository = context.read<StatementRepository>();
      await repository.createStatement(result.payload);
      ToastUtil.showSuccess('对账单已创建');
      await viewModel.loadStatements(resetPage: false);
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  Future<void> _openGenerateDialog() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_statement')) {
      ToastUtil.showError('当前账号无权生成对账数据');
      return;
    }
    await _loadOptions();
    final result = await showStatementGenerateDialog(
      context,
      customers: _customers,
      suppliers: _suppliers,
      onCreateCustomer: _createCustomer,
      onCreateSupplier: _createSupplier,
    );
    if (result == null) return;
    try {
      final repository = context.read<StatementRepository>();
      final preview = await repository.generate(params: result.params);
      if (!mounted) return;
      await showStatementGeneratePreviewDialog(context, result: preview);
    } catch (err) {
      ToastUtil.showError('生成失败: $err');
    }
  }

  Future<Customer?> _createCustomer() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_customer')) {
      ToastUtil.showError('当前账号无权新增客户');
      return null;
    }

    final repository = context.read<CustomerRepository>();
    final created = await showQuickCustomerCreateDialogWithRepository(
      context: context,
      customerRepository: repository,
    );
    if (created == null || !mounted) {
      return created;
    }

    setState(() {
      _customers = List<Customer>.from(_customers)
        ..removeWhere((item) => item.id == created.id)
        ..add(created)
        ..sort((left, right) => left.name.compareTo(right.name));
      _optionsLoaded = true;
    });
    ToastUtil.showSuccess('客户已新增');
    return created;
  }

  Future<Supplier?> _createSupplier() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_supplier')) {
      ToastUtil.showError('当前账号无权新增供应商');
      return null;
    }

    final repository = context.read<SupplierRepository>();
    final created = await showQuickSupplierCreateDialogWithRepository(
      context: context,
      supplierRepository: repository,
    );
    if (created == null || !mounted) {
      return created;
    }

    setState(() {
      _suppliers = List<Supplier>.from(_suppliers)
        ..removeWhere((item) => item.id == created.id)
        ..add(created)
        ..sort((left, right) => left.name.compareTo(right.name));
      _optionsLoaded = true;
    });
    ToastUtil.showSuccess('供应商已新增');
    return created;
  }

  Future<void> _confirmStatement(
    StatementViewModel viewModel,
    Statement statement, {
    required bool confirmed,
  }) async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.change_statement')) {
      ToastUtil.showError('当前账号无权处理对账状态');
      return;
    }
    final notes = await showStatementConfirmDialog(
      context,
      confirmed: confirmed,
    );
    if (notes == null) return;
    try {
      final repository = context.read<StatementRepository>();
      await repository.confirmStatement(
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
    final isMobile = ResponsiveLayout.isMobile(context);

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
        DataColumn(label: Text('下一步')),
        DataColumn(label: Text('操作')),
      ],
      rows: statements
          .map(
            (statement) => DataRow(
              cells: [
                DataCell(
                  Text(
                    _displayText(
                      statement.statementNumber ?? '对账单 #${statement.id}',
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(_displayText(statement.customerName), style: textStyle),
                ),
                DataCell(Text(_statementTypeText(statement), style: textStyle)),
                DataCell(
                  Text(
                    _formatPeriod(statement.periodStart, statement.periodEnd),
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Text(
                    _formatAmount(statement.closingBalance),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    statement.statusDisplay ??
                        statement.status ??
                        _emptyCellText,
                    style: textStyle,
                  ),
                ),
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
    final permissions = PermissionUtil.snapshot(context);
    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final pendingConfirmCount = _summaryCount(
            viewModel.summary,
            'pending_confirm_count',
          );
          final disputedCount = _summaryCount(
            viewModel.summary,
            'disputed_count',
          );
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
                selected:
                    viewModel.statusFilter == 'disputed' ||
                    viewModel.todoFilter == 'disputed',
                onTap: () => _openQuickFilter(status: 'disputed'),
              ),
            if (_hasActiveFilter(viewModel))
              PageActionButton.outlined(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除筛选',
              ),
            if (permissions.has('workorder.add_statement'))
              PageActionButton.filled(
                onPressed: () => _openCreateDialog(viewModel),
                icon: const Icon(Icons.add, size: 16),
                label: '新建对账单',
              ),
            if (permissions.has('workorder.add_statement'))
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
    final permissions = PermissionUtil.snapshot(context);
    final canChangeStatement = permissions.has('workorder.change_statement');
    final canViewAudit = AuditLogNavigation.canView(context);
    final actions = <RowAction>[];
    final status = statement.status ?? '';
    if (canChangeStatement && (status == 'draft' || status == 'sent')) {
      actions.add(
        RowAction(
          label: '确认',
          icon: Icons.verified_outlined,
          onPressed: () =>
              _confirmStatement(viewModel, statement, confirmed: true),
        ),
      );
      actions.add(
        RowAction(
          label: '有异议',
          icon: Icons.report_outlined,
          destructive: true,
          onPressed: () =>
              _confirmStatement(viewModel, statement, confirmed: false),
        ),
      );
    }
    final auditKeyword = (statement.statementNumber ?? '').trim();
    if (canViewAudit && auditKeyword.isNotEmpty) {
      actions.add(
        RowAction(
          label: '审计',
          icon: Icons.history_outlined,
          onPressed: () =>
              AuditLogNavigation.open(context, keyword: auditKeyword),
        ),
      );
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

  Widget _mobileRow(
    BuildContext context,
    TextStyle? labelStyle,
    String label,
    String value, {
    bool last = false,
  }) {
    final theme = Theme.of(context);
    final spacing = LayoutTokens.sectionSpacing(context) * 0.6;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: Text(label, style: labelStyle)),
          Expanded(
            child: Text(
              value.isEmpty ? _emptyCellText : value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFields(
    BuildContext context,
    TextStyle? labelStyle, {
    required String number,
    required String customer,
    required String statementType,
    required String period,
    required String amount,
    required String closingBalance,
    required String status,
    required String followUp,
    String? confirmedByName,
    String? confirmedAt,
    String? confirmationNotes,
  }) {
    final rows = <Widget>[
      _mobileRow(context, labelStyle, '对账单号', number),
      _mobileRow(context, labelStyle, '对方单位', customer),
      _mobileRow(context, labelStyle, '对账类型', statementType),
      _mobileRow(context, labelStyle, '对账周期', period),
      _mobileRow(context, labelStyle, '本期金额', amount),
      _mobileRow(context, labelStyle, '期末余额', closingBalance),
      _mobileRow(context, labelStyle, '状态', status),
      _mobileRow(context, labelStyle, '下一步', followUp),
      if (confirmedByName != null)
        _mobileRow(context, labelStyle, '确认人', confirmedByName),
      if (confirmedAt != null)
        _mobileRow(context, labelStyle, '确认时间', confirmedAt),
      if (confirmationNotes != null)
        _mobileRow(context, labelStyle, '确认备注', confirmationNotes, last: true),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    Statement statement,
    bool isMobile,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    final canChangeStatement = permissions.has('workorder.change_statement');
    final canViewAudit = AuditLogNavigation.canView(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = _displayText(
      statement.statementNumber ?? '对账单 #${statement.id}',
    );
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
      actions.add(
        RowAction(
          label: '确认',
          icon: Icons.verified_outlined,
          onPressed: () => _confirmStatement(
            context.read<StatementViewModel>(),
            statement,
            confirmed: true,
          ),
        ),
      );
      actions.add(
        RowAction(
          label: '有异议',
          icon: Icons.report_outlined,
          destructive: true,
          onPressed: () => _confirmStatement(
            context.read<StatementViewModel>(),
            statement,
            confirmed: false,
          ),
        ),
      );
    }
    final auditKeyword = (statement.statementNumber ?? '').trim();
    if (canViewAudit && auditKeyword.isNotEmpty) {
      actions.add(
        RowAction(
          label: '审计',
          icon: Icons.history_outlined,
          onPressed: () =>
              AuditLogNavigation.open(context, keyword: auditKeyword),
        ),
      );
    }
    if ((statement.statementType ?? '') == 'customer') {
      actions.add(
        RowAction(
          label: '客户订单',
          icon: Icons.point_of_sale_outlined,
          onPressed: () => context.go('/sales-orders'),
        ),
      );
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
                      _SummaryChip(label: '下一步', value: followUp),
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
                  duration: AnimationTokens.expandDuration,
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
          _buildMobileFields(
            context,
            theme.textTheme.labelSmall?.copyWith(
              color: colors?.subtleText ?? theme.hintColor,
            ),
            number: number,
            customer: customer,
            statementType: statementType,
            period: period,
            amount: amount,
            closingBalance: closingBalance,
            status: status,
            followUp: followUp,
            confirmedByName: (statement.confirmedByName ?? '').trim().isNotEmpty
                ? _displayText(statement.confirmedByName)
                : null,
            confirmedAt: statement.confirmedAt != null
                ? _formatDate(statement.confirmedAt)
                : null,
            confirmationNotes:
                (statement.confirmationNotes ?? '').trim().isNotEmpty
                ? _displayText(statement.confirmationNotes)
                : null,
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
      return '推进对账确认';
    }
    if (status == 'disputed') {
      return '推进异议处理';
    }
    return '对账已闭环';
  }

  void _clearFilters() {
    final search = _searchController.text.trim();
    final query = <String, String>{};
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    final viewModel = context.read<StatementViewModel>();
    if (viewModel.ordering != '-period') {
      query['ordering'] = viewModel.ordering;
    }
    context.go(
      Uri(path: '/finance/statements', queryParameters: query).toString(),
    );
  }

  void _openQuickFilter({String? status, String? todo}) {
    final query = <String, String>{};
    final search = _searchController.text.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    final viewModel = context.read<StatementViewModel>();
    if (viewModel.statementTypeFilter.isNotEmpty) {
      query['statement_type'] = viewModel.statementTypeFilter;
    }
    if (viewModel.ordering != '-period') {
      query['ordering'] = viewModel.ordering;
    }
    if ((status ?? '').trim().isNotEmpty) {
      query['status'] = status!.trim();
    }
    if ((todo ?? '').trim().isNotEmpty) {
      query['todo'] = todo!.trim();
    }
    context.go(
      Uri(path: '/finance/statements', queryParameters: query).toString(),
    );
  }

  bool _hasActiveFilter(StatementViewModel viewModel) {
    return viewModel.statementTypeFilter.isNotEmpty ||
        viewModel.statusFilter.isNotEmpty ||
        viewModel.todoFilter.isNotEmpty ||
        viewModel.customerFilter.isNotEmpty ||
        viewModel.supplierFilter.isNotEmpty ||
        viewModel.periodStartFilter.isNotEmpty ||
        viewModel.periodEndFilter.isNotEmpty ||
        viewModel.ordering != '-period';
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

typedef _SummaryChip = SummaryChip;
