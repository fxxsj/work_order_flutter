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
import 'package:work_order_app/src/features/finance_invoices/application/invoice_view_model.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_repository_impl.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

/// 发票列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class InvoiceListEntry extends StatefulWidget {
  const InvoiceListEntry({super.key});

  @override
  State<InvoiceListEntry> createState() => _InvoiceListEntryState();
}

class _InvoiceListEntryState extends State<InvoiceListEntry> {
  InvoiceApiService? _apiService;
  InvoiceRepositoryImpl? _repository;
  InvoiceViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final apiClient = context.read<ApiClient>();
    _apiService = InvoiceApiService(apiClient);
    _repository = InvoiceRepositoryImpl(_apiService!);
    _viewModel = InvoiceViewModel(_repository!);
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
        Provider<InvoiceApiService>.value(value: apiService),
        Provider<InvoiceRepository>.value(value: repository),
        ChangeNotifierProvider<InvoiceViewModel>.value(value: viewModel),
      ],
      child: const InvoiceListPage(),
    );
  }
}

/// 发票列表页视图，只负责渲染。
class InvoiceListPage extends StatelessWidget {
  const InvoiceListPage({super.key});

  @override
  Widget build(BuildContext context) => const _InvoiceListView();
}

class _InvoiceListView extends StatefulWidget {
  const _InvoiceListView();

  @override
  State<_InvoiceListView> createState() => _InvoiceListViewState();
}

class _InvoiceListViewState extends State<_InvoiceListView> {
  static const _searchDebounceDuration = Duration(milliseconds: 450);
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索发票号/客户';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无发票数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _optionsLoading = false;
  bool _optionsLoaded = false;
  List<Customer> _customers = [];
  List<SalesOrder> _salesOrders = [];
  List<WorkOrder> _workOrders = [];

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(InvoiceViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInvoices(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadInvoices(resetPage: true);
    });
  }

  Future<void> _openCreateDialog(InvoiceViewModel viewModel) async {
    await _loadOptions();
    if (_customers.isEmpty) {
      ToastUtil.showError('请先配置客户信息');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final taxRateController = TextEditingController(text: '13');
    final issueDateController = TextEditingController();
    final notesController = TextEditingController();
    String invoiceType = 'vat_normal';
    int? selectedCustomerId;
    int? selectedSalesOrderId;
    int? selectedWorkOrderId;
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
              final amountText = amountController.text.trim();
              final amount = double.tryParse(amountText);
              if (amount == null || amount <= 0) {
                ToastUtil.showError('请输入正确的金额');
                return;
              }
              final taxRate = double.tryParse(taxRateController.text.trim()) ?? 0;
              if (taxRate < 0 || taxRate > 100) {
                ToastUtil.showError('税率应在 0-100 之间');
                return;
              }
              if (selectedCustomerId == null) {
                ToastUtil.showError('请选择客户');
                return;
              }

              setState(() => submitting = true);
              try {
                final payload = <String, dynamic>{
                  'invoice_type': invoiceType,
                  'customer': selectedCustomerId,
                  'amount': amount,
                  'tax_rate': taxRate,
                  'notes': notesController.text.trim(),
                };
                final issueDate = issueDateController.text.trim();
                if (issueDate.isNotEmpty) {
                  payload['issue_date'] = issueDate;
                }
                if (selectedSalesOrderId != null) {
                  payload['sales_order'] = selectedSalesOrderId;
                }
                if (selectedWorkOrderId != null) {
                  payload['work_order'] = selectedWorkOrderId;
                }

                final apiService = context.read<InvoiceApiService>();
                await apiService.createInvoice(payload);
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
                ToastUtil.showSuccess('发票已创建');
                await viewModel.loadInvoices(resetPage: false);
              } catch (err) {
                if (!mounted) return;
                setState(() => submitting = false);
                ToastUtil.showError('提交失败: $err');
              }
            }

            return AlertDialog(
              title: const Text('新建发票'),
              content: SizedBox(
                width: 720,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SearchableDropdownFormField<String>(
                          initialValue: invoiceType,
                          decoration: const InputDecoration(
                            labelText: '发票类型',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'vat_special', child: Text('增值税专用发票')),
                            DropdownMenuItem(value: 'vat_normal', child: Text('增值税普通发票')),
                            DropdownMenuItem(value: 'electronic', child: Text('电子发票')),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) => setState(
                                    () => invoiceType = value ?? 'vat_normal',
                                  ),
                        ),
                        const SizedBox(height: 12),
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
                          validator: (value) =>
                              value == null ? '请选择客户' : null,
                        ),
                        const SizedBox(height: 12),
                        SearchableDropdownFormField<int?>(
                          initialValue: selectedSalesOrderId,
                          decoration: const InputDecoration(
                            labelText: '关联销售订单（可选）',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('不关联销售订单'),
                            ),
                            ..._salesOrders.map(
                              (order) => DropdownMenuItem<int?>(
                                value: order.id,
                                child: Text(order.orderNumber),
                              ),
                            ),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) => setState(
                                    () => selectedSalesOrderId = value,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        SearchableDropdownFormField<int?>(
                          initialValue: selectedWorkOrderId,
                          decoration: const InputDecoration(
                            labelText: '关联施工单（可选）',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('不关联施工单'),
                            ),
                            ..._workOrders.map(
                              (order) => DropdownMenuItem<int?>(
                                value: order.id,
                                child: Text(order.orderNumber),
                              ),
                            ),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) => setState(
                                    () => selectedWorkOrderId = value,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: amountController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: '金额（不含税）',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? '请输入金额'
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: taxRateController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: '税率(%)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: issueDateController,
                          decoration: const InputDecoration(
                            labelText: '开票日期（YYYY-MM-DD，可选）',
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

    amountController.dispose();
    taxRateController.dispose();
    issueDateController.dispose();
    notesController.dispose();
  }

  Future<void> _submitInvoice(InvoiceViewModel viewModel, Invoice invoice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提交发票'),
        content: const Text('确认提交该发票吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('提交'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final apiService = context.read<InvoiceApiService>();
      await apiService.submit(invoice.id);
      ToastUtil.showSuccess('发票已提交');
      await viewModel.loadInvoices(resetPage: false);
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  Future<void> _approveInvoice(
    InvoiceViewModel viewModel,
    Invoice invoice, {
    required bool approved,
  }) async {
    final commentController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(approved ? '确认收到' : '作废发票'),
        content: TextField(
          controller: commentController,
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
            child: Text(approved ? '确认' : '作废'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      commentController.dispose();
      return;
    }
    try {
      final apiService = context.read<InvoiceApiService>();
      await apiService.approve(invoice.id, {
        'approved': approved,
        'approval_comment': commentController.text.trim(),
      });
      ToastUtil.showSuccess(approved ? '已确认收到' : '已作废');
      await viewModel.loadInvoices(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    } finally {
      commentController.dispose();
    }
  }

  Future<void> _loadOptions() async {
    if (_optionsLoaded || _optionsLoading) return;
    setState(() => _optionsLoading = true);
    try {
      final apiClient = context.read<ApiClient>();
      final customerApi = CustomerApiService(apiClient);
      final salesApi = SalesOrderApiService(apiClient);
      final workOrderApi = WorkOrderApiService(apiClient);
      final results = await Future.wait([
        customerApi.fetchCustomers(page: 1, pageSize: 200),
        salesApi.fetchSalesOrders(page: 1, pageSize: 200),
        workOrderApi.fetchWorkOrders(page: 1, pageSize: 200),
      ]);
      final customerPage = results[0] as CustomerPageDto;
      final salesPage = results[1] as SalesOrderPageDto;
      final workOrderPage = results[2] as WorkOrderPageDto;
      if (!mounted) return;
      setState(() {
        _customers = customerPage.items.map((dto) => dto.toEntity()).toList();
        _salesOrders = salesPage.items.map((dto) => dto.toEntity()).toList();
        _workOrders = workOrderPage.items.map((dto) => dto.toEntity()).toList();
        _optionsLoaded = true;
      });
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('加载基础数据失败: $err');
    } finally {
      if (mounted) setState(() => _optionsLoading = false);
    }
  }

  static String _pageInfoText(InvoiceViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = BreakpointsUtil.isMobile(context);

    return Consumer<InvoiceViewModel>(
      builder: (context, viewModel, _) {
        final invoices = viewModel.invoices;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, invoices, isMobile),
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
    InvoiceViewModel viewModel,
    List<Invoice> invoices,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && invoices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadInvoices(resetPage: true),
      );
    }
    if (!viewModel.loading && invoices.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.receipt_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, invoices);
    }

    return ListView.separated(
      itemCount: invoices.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return _buildSummaryCard(context, invoice, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    InvoiceViewModel viewModel,
    List<Invoice> invoices,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('发票号')),
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('开票日期')),
        DataColumn(label: Text('操作')),
      ],
      rows: invoices
          .map(
            (invoice) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(invoice.invoiceNumber ?? '发票 #${invoice.id}'),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(
                    Text(_displayText(invoice.customerName), style: textStyle)),
                DataCell(
                    Text(_displayText(invoice.workOrderNumber), style: textStyle)),
                DataCell(Text(_formatAmount(invoice.amount), style: textStyle)),
                DataCell(Text(
                  invoice.statusDisplay ??
                      invoice.status ??
                      _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(_formatDate(invoice.issueDate), style: textStyle)),
                DataCell(_buildRowActions(viewModel, invoice)),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    InvoiceViewModel viewModel,
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
              label: '新建发票',
            ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadInvoices(resetPage: true),
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

  Widget _buildRowActions(InvoiceViewModel viewModel, Invoice invoice) {
    final actions = <RowAction>[];
    final status = invoice.status ?? '';
    if (status == 'draft') {
      actions.add(RowAction(
        label: '提交',
        icon: Icons.send_outlined,
        onPressed: () => _submitInvoice(viewModel, invoice),
      ));
    }
    if (status == 'issued') {
      actions.add(RowAction(
        label: '确认收到',
        icon: Icons.verified_outlined,
        onPressed: () => _approveInvoice(viewModel, invoice, approved: true),
      ));
      actions.add(RowAction(
        label: '作废',
        icon: Icons.cancel_outlined,
        destructive: true,
        onPressed: () => _approveInvoice(viewModel, invoice, approved: false),
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

  String _formatDate(DateTime? value) {
    if (value == null) return _emptyCellText;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Widget _buildSummaryCard(BuildContext context, Invoice invoice, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = _displayText(invoice.invoiceNumber ?? '发票 #${invoice.id}');
    final customer = _displayText(invoice.customerName);
    final workOrder = _displayText(invoice.workOrderNumber);
    final amount = _formatAmount(invoice.amount);
    final status = invoice.statusDisplay ?? invoice.status ?? _emptyCellText;
    final issueDate = _formatDate(invoice.issueDate);

    final actions = <RowAction>[];
    final statusCode = invoice.status ?? '';
    if (statusCode == 'draft') {
      actions.add(RowAction(
        label: '提交',
        icon: Icons.send_outlined,
        onPressed: () =>
            _submitInvoice(context.read<InvoiceViewModel>(), invoice),
      ));
    }
    if (statusCode == 'issued') {
      actions.add(RowAction(
        label: '确认收到',
        icon: Icons.verified_outlined,
        onPressed: () => _approveInvoice(
          context.read<InvoiceViewModel>(),
          invoice,
          approved: true,
        ),
      ));
      actions.add(RowAction(
        label: '作废',
        icon: Icons.cancel_outlined,
        destructive: true,
        onPressed: () => _approveInvoice(
          context.read<InvoiceViewModel>(),
          invoice,
          approved: false,
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
                  issueDate,
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
              _SummaryField(label: '发票号', value: number),
              _SummaryField(label: '客户', value: customer),
              _SummaryField(label: '施工单号', value: workOrder),
              _SummaryField(label: '金额', value: amount),
              _SummaryField(label: '状态', value: status),
              _SummaryField(label: '开票日期', value: issueDate),
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
