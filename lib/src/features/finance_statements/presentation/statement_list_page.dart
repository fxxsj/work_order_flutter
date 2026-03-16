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
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_statements/application/statement_view_model.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_api_service.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_repository_impl.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement.dart';
import 'package:work_order_app/src/features/finance_statements/domain/statement_repository.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

/// 对账单列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class StatementListEntry extends StatefulWidget {
  const StatementListEntry({super.key});

  @override
  State<StatementListEntry> createState() => _StatementListEntryState();
}

class _StatementListEntryState extends State<StatementListEntry> {
  StatementApiService? _apiService;
  StatementRepositoryImpl? _repository;
  StatementViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = StatementApiService(apiClient);
    _repository = StatementRepositoryImpl(_apiService!);
    _viewModel = StatementViewModel(_repository!);
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
        Provider<StatementApiService>.value(value: apiService),
        Provider<StatementRepository>.value(value: repository),
        ChangeNotifierProvider<StatementViewModel>.value(value: viewModel),
      ],
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
      final apiClient = context.read<ApiClient>();
      final customerApi = CustomerApiService(apiClient);
      final supplierApi = SupplierApiService(apiClient);
      final results = await Future.wait([
        customerApi.fetchCustomers(page: 1, pageSize: 200),
        supplierApi.fetchSuppliers(page: 1, pageSize: 200),
      ]);
      final customerPage = results[0] as CustomerPageDto;
      final supplierPage = results[1] as SupplierPageDto;
      if (!mounted) return;
      setState(() {
        _customers = customerPage.items.map((dto) => dto.toEntity()).toList();
        _suppliers = supplierPage.items.map((dto) => dto.toEntity()).toList();
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
    await _loadOptions();
    if (_customers.isEmpty && _suppliers.isEmpty) {
      ToastUtil.showError('请先配置客户或供应商信息');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final periodController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final openingBalanceController = TextEditingController(text: '0');
    final notesController = TextEditingController();
    String statementType = 'customer';
    int? selectedCustomerId;
    int? selectedSupplierId;
    bool submitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> submit() async {
              if (submitting) return;
              if (!(formKey.currentState?.validate() ?? false)) {
                return;
              }
              if (statementType == 'customer' && selectedCustomerId == null) {
                ToastUtil.showError('请选择客户');
                return;
              }
              if (statementType == 'supplier' && selectedSupplierId == null) {
                ToastUtil.showError('请选择供应商');
                return;
              }
              setState(() => submitting = true);
              try {
                final payload = <String, dynamic>{
                  'statement_type': statementType,
                  'period': periodController.text.trim(),
                  'start_date': startDateController.text.trim(),
                  'end_date': endDateController.text.trim(),
                  'opening_balance':
                      double.tryParse(openingBalanceController.text.trim()) ?? 0,
                  'notes': notesController.text.trim(),
                };
                if (statementType == 'customer') {
                  payload['customer'] = selectedCustomerId;
                } else {
                  payload['supplier'] = selectedSupplierId;
                }

                final apiService = context.read<StatementApiService>();
                await apiService.createStatement(payload);
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
                ToastUtil.showSuccess('对账单已创建');
                await viewModel.loadStatements(resetPage: false);
              } catch (err) {
                if (!mounted) return;
                setState(() => submitting = false);
                ToastUtil.showError('提交失败: $err');
              }
            }

            final showCustomer = statementType == 'customer';

            return AlertDialog(
              title: const Text('新建对账单'),
              content: SizedBox(
                width: 720,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          key: ValueKey(statementType),
                          initialValue: statementType,
                          decoration: const InputDecoration(
                            labelText: '对账单类型',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'customer',
                              child: Text('客户对账单'),
                            ),
                            DropdownMenuItem(
                              value: 'supplier',
                              child: Text('供应商对账单'),
                            ),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) => setState(
                                    () => statementType = value ?? 'customer',
                                  ),
                        ),
                        const SizedBox(height: 12),
                        if (showCustomer)
                          SearchableDropdownFormField<int?>(
                            initialValue: selectedCustomerId,
                            decoration: const InputDecoration(
                              labelText: '客户',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('请选择客户'),
                              ),
                              ..._customers.map(
                                (customer) => DropdownMenuItem<int?>(
                                  value: customer.id,
                                  child: Text(customer.name),
                                ),
                              ),
                            ],
                            onChanged: submitting
                                ? null
                                : (value) => setState(
                                      () => selectedCustomerId = value,
                                    ),
                          ),
                        if (showCustomer) const SizedBox(height: 12),
                        if (!showCustomer)
                          SearchableDropdownFormField<int?>(
                            initialValue: selectedSupplierId,
                            decoration: const InputDecoration(
                              labelText: '供应商',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('请选择供应商'),
                              ),
                              ..._suppliers.map(
                                (supplier) => DropdownMenuItem<int?>(
                                  value: supplier.id,
                                  child: Text(supplier.name),
                                ),
                              ),
                            ],
                            onChanged: submitting
                                ? null
                                : (value) => setState(
                                      () => selectedSupplierId = value,
                                    ),
                          ),
                        if (!showCustomer) const SizedBox(height: 12),
                        TextFormField(
                          controller: periodController,
                          decoration: const InputDecoration(
                            labelText: '对账周期（YYYY-MM）',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? '请输入对账周期'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: startDateController,
                          decoration: const InputDecoration(
                            labelText: '开始日期（YYYY-MM-DD）',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? '请输入开始日期'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: endDateController,
                          decoration: const InputDecoration(
                            labelText: '结束日期（YYYY-MM-DD）',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? '请输入结束日期'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: openingBalanceController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: '期初余额',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: '备注（可选）',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: submitting ? null : submit,
                  child: Text(submitting ? '提交中' : '创建'),
                ),
              ],
            );
          },
        );
      },
    );

    periodController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    openingBalanceController.dispose();
    notesController.dispose();
  }

  Future<void> _openGenerateDialog() async {
    await _loadOptions();
    final formKey = GlobalKey<FormState>();
    final periodController = TextEditingController();
    String statementType = 'customer';
    int? selectedCustomerId;
    int? selectedSupplierId;
    bool submitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> submit() async {
              if (submitting) return;
              if (!(formKey.currentState?.validate() ?? false)) {
                return;
              }
              if (statementType == 'customer' && selectedCustomerId == null) {
                ToastUtil.showError('请选择客户');
                return;
              }
              if (statementType == 'supplier' && selectedSupplierId == null) {
                ToastUtil.showError('请选择供应商');
                return;
              }
              setState(() => submitting = true);
              try {
                final params = <String, dynamic>{
                  'period': periodController.text.trim(),
                };
                if (statementType == 'customer') {
                  params['customer'] = selectedCustomerId;
                } else {
                  params['supplier'] = selectedSupplierId;
                }
                final apiService = context.read<StatementApiService>();
                final result = await apiService.generate(params: params);
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
                await _showGenerateResult(result);
              } catch (err) {
                if (!mounted) return;
                setState(() => submitting = false);
                ToastUtil.showError('生成失败: $err');
              }
            }

            final showCustomer = statementType == 'customer';

            return AlertDialog(
              title: const Text('生成对账数据'),
              content: SizedBox(
                width: 640,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          key: ValueKey(statementType),
                          initialValue: statementType,
                          decoration: const InputDecoration(
                            labelText: '对账单类型',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'customer',
                              child: Text('客户对账单'),
                            ),
                            DropdownMenuItem(
                              value: 'supplier',
                              child: Text('供应商对账单'),
                            ),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) => setState(
                                    () => statementType = value ?? 'customer',
                                  ),
                        ),
                        const SizedBox(height: 12),
                        if (showCustomer)
                          SearchableDropdownFormField<int?>(
                            initialValue: selectedCustomerId,
                            decoration: const InputDecoration(
                              labelText: '客户',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('请选择客户'),
                              ),
                              ..._customers.map(
                                (customer) => DropdownMenuItem<int?>(
                                  value: customer.id,
                                  child: Text(customer.name),
                                ),
                              ),
                            ],
                            onChanged: submitting
                                ? null
                                : (value) => setState(
                                      () => selectedCustomerId = value,
                                    ),
                          ),
                        if (showCustomer) const SizedBox(height: 12),
                        if (!showCustomer)
                          SearchableDropdownFormField<int?>(
                            initialValue: selectedSupplierId,
                            decoration: const InputDecoration(
                              labelText: '供应商',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('请选择供应商'),
                              ),
                              ..._suppliers.map(
                                (supplier) => DropdownMenuItem<int?>(
                                  value: supplier.id,
                                  child: Text(supplier.name),
                                ),
                              ),
                            ],
                            onChanged: submitting
                                ? null
                                : (value) => setState(
                                      () => selectedSupplierId = value,
                                    ),
                          ),
                        if (!showCustomer) const SizedBox(height: 12),
                        TextFormField(
                          controller: periodController,
                          decoration: const InputDecoration(
                            labelText: '对账周期（YYYY-MM）',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? '请输入对账周期'
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: submitting ? null : submit,
                  child: Text(submitting ? '生成中' : '生成'),
                ),
              ],
            );
          },
        );
      },
    );

    periodController.dispose();
  }

  Future<void> _showGenerateResult(Map<String, dynamic> result) async {
    if (!mounted) return;
    final data = result['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(result['data'])
        : result;
    final opening = data['opening_balance'] ?? '-';
    final debit = data['total_debit'] ?? '-';
    final credit = data['total_credit'] ?? '-';
    final closing = data['closing_balance'] ?? '-';
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('对账数据预览'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('期初余额: $opening'),
            const SizedBox(height: 6),
            Text('本期借方: $debit'),
            const SizedBox(height: 6),
            Text('本期贷方: $credit'),
            const SizedBox(height: 6),
            Text('期末余额: $closing'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmStatement(
    StatementViewModel viewModel,
    Statement statement, {
    required bool confirmed,
  }) async {
    final notesController = TextEditingController();
    final confirmedResult = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(confirmed ? '确认对账单' : '标记为有异议'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(labelText: '备注（可选）'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmed ? '确认' : '提交'),
          ),
        ],
      ),
    );
    if (confirmedResult != true) {
      notesController.dispose();
      return;
    }
    try {
      final apiService = context.read<StatementApiService>();
      await apiService.confirm(statement.id, {
        'confirmed': confirmed,
        'confirmation_notes': notesController.text.trim(),
      });
      ToastUtil.showSuccess(confirmed ? '已确认' : '已标记为有异议');
      await viewModel.loadStatements(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    } finally {
      notesController.dispose();
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
          footer: viewModel.totalPages > 1 ? ResponsivePaginationBar(
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
        DataColumn(label: Text('对账周期')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('状态')),
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
                DataCell(
                    Text(_displayText(statement.customerName), style: textStyle)),
                DataCell(Text(_formatPeriod(statement.periodStart,
                    statement.periodEnd), style: textStyle)),
                DataCell(Text(_formatAmount(statement.totalAmount),
                    style: theme.textTheme.bodyMedium)),
                DataCell(Text(
                  statement.statusDisplay ??
                      statement.status ??
                      _emptyCellText,
                  style: textStyle,
                )),
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
            PageActionButton.filled(
              onPressed: () => _openCreateDialog(viewModel),
              icon: const Icon(Icons.add, size: 16),
              label: '新建对账单',
            ),
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
    final actions = <RowAction>[];
    final status = statement.status ?? '';
    if (status == 'draft' || status == 'sent') {
      actions.add(RowAction(
        label: '确认',
        icon: Icons.verified_outlined,
        onPressed: () => _confirmStatement(viewModel, statement, confirmed: true),
      ));
      actions.add(RowAction(
        label: '有异议',
        icon: Icons.report_outlined,
        destructive: true,
        onPressed: () => _confirmStatement(viewModel, statement, confirmed: false),
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

  Widget _buildSummaryCard(BuildContext context, Statement statement, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = _displayText(statement.statementNumber ?? '对账单 #${statement.id}');
    final customer = _displayText(statement.customerName);
    final period = _formatPeriod(statement.periodStart, statement.periodEnd);
    final amount = _formatAmount(statement.totalAmount);
    final status = statement.statusDisplay ?? statement.status ?? _emptyCellText;

    final actions = <RowAction>[];
    final statusCode = statement.status ?? '';
    if (statusCode == 'draft' || statusCode == 'sent') {
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
              _SummaryField(label: '对账周期', value: period),
              _SummaryField(label: '金额', value: amount),
              _SummaryField(label: '状态', value: status),
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
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
