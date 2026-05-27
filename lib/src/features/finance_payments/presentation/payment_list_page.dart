import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_payments/application/payment_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_repository_impl.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_support_service.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_payments/presentation/widgets/payment_list_dialogs.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/core/utils/debounce_controller.dart';

/// 收款列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class PaymentListEntry extends StatelessWidget {
  const PaymentListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<PaymentApiService, PaymentRepository, PaymentViewModel>(
      createService: (context) => PaymentApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          PaymentRepositoryImpl(context.read<PaymentApiService>()),
      createViewModel: (context) =>
          PaymentViewModel(context.read<PaymentRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
      child: const PaymentListPage(),
    );
  }
}

/// 收款列表页视图，只负责渲染。
class PaymentListPage extends StatelessWidget {
  const PaymentListPage({super.key});

  @override
  Widget build(BuildContext context) => const _PaymentListView();
}

class _PaymentListView extends StatefulWidget {
  const _PaymentListView();

  @override
  State<_PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<_PaymentListView> {
  static const double _searchWidth = 320;
  static const double _spacingSm = LayoutTokens.gapSm;
  static const double _controlHeight = PageActionStyle.height;
  static const String _emptyCellText = '-';

  static const String _searchHintText = '搜索收款单号/客户';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无收款数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';
  static const String _customerFilterLabel = '客户';
  static const String _paymentMethodFilterLabel = '收款方式';
  static const String _todoFilterLabel = '待办事项';
  static const String _orderingLabel = '排序';
  static const String _resetButtonText = '重置筛选';

  final TextEditingController _searchController = TextEditingController();
  final _debounce = DebounceController();
  bool _optionsLoading = false;
  bool _optionsLoaded = false;
  List<Customer> _customers = [];
  List<SalesOrder> _salesOrders = [];
  List<Invoice> _invoices = [];
  PaymentSupportService? _supportService;
  String? _lastRouteSignature;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= PaymentSupportService(context.read<ApiClient>());
    final uri = GoRouterState.of(context).uri;
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeCustomer = uri.queryParameters['customer']?.trim() ?? '';
    final routePaymentMethod =
        uri.queryParameters['payment_method']?.trim() ?? '';
    final routeTodo = uri.queryParameters['todo']?.trim() ?? '';
    final routeOrdering = uri.queryParameters['ordering']?.trim() ?? '';
    final routeStartDate = uri.queryParameters['start_date']?.trim() ?? '';
    final routeEndDate = uri.queryParameters['end_date']?.trim() ?? '';
    final signature = [
      routeSearch,
      routeCustomer,
      routePaymentMethod,
      routeTodo,
      routeOrdering,
      routeStartDate,
      routeEndDate,
    ].join('|');
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    _searchController.text = routeSearch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PaymentViewModel>().applyRoutePrefill(
        search: routeSearch,
        customer: routeCustomer,
        paymentMethod: routePaymentMethod,
        todo: routeTodo,
        ordering: routeOrdering,
        startDate: routeStartDate,
        endDate: routeEndDate,
      );
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(PaymentViewModel viewModel, {bool immediate = false}) {
    _debounce.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPayments(resetPage: true);
      return;
    }
    _debounce.run(() {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPayments(resetPage: true);
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
        _salesOrders = options.salesOrders;
        _invoices = options.invoices;
        _optionsLoaded = true;
      });
    } catch (err) {
      if (!mounted) return;
      ToastUtil.showError('加载基础数据失败: $err');
    } finally {
      if (mounted) setState(() => _optionsLoading = false);
    }
  }

  Future<void> _openCreateDialog(PaymentViewModel viewModel) async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_payment')) {
      ToastUtil.showError('当前账号无权新建收款');
      return;
    }
    await _loadOptions();
    if (_customers.isEmpty) {
      ToastUtil.showError('请先配置客户信息');
      return;
    }
    final result = await showPaymentCreateDialog(
      context,
      customers: _customers,
      salesOrders: _salesOrders,
      invoices: _invoices,
    );
    if (result == null) return;
    try {
      await _supportService!.createPayment(result.payload);
      ToastUtil.showSuccess('收款已登记');
      await viewModel.loadPayments(resetPage: false);
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  static String _pageInfoText(PaymentViewModel viewModel) {
    return _pageInfoTemplate
        .replaceFirst('{page}', viewModel.page.toString())
        .replaceFirst('{total}', viewModel.totalPages.toString())
        .replaceFirst('{count}', viewModel.total.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Consumer<PaymentViewModel>(
      builder: (context, viewModel, _) {
        final payments = viewModel.payments;
        return ListPageScaffold(
          spacing: _spacingSm,
          header: _buildPageHeader(context, viewModel, isMobile),
          body: _buildListBody(context, viewModel, payments, isMobile),
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
    PaymentViewModel viewModel,
    List<Payment> payments,
    bool isMobile,
  ) {
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    if (viewModel.loading && payments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null && !viewModel.loading) {
      return ErrorStateCard(
        message: viewModel.errorMessage ?? _errorFallbackText,
        retryLabel: _retryText,
        onRetry: () => viewModel.loadPayments(resetPage: true),
      );
    }
    if (!viewModel.loading && payments.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.payments_outlined,
        text: _emptyText,
      );
    }

    if (!isMobile) {
      return _buildDesktopTable(context, viewModel, payments);
    }

    return ListView.separated(
      itemCount: payments.length,
      separatorBuilder: (_, __) => SizedBox(height: sectionSpacing),
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildSummaryCard(context, payment, isMobile);
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    PaymentViewModel viewModel,
    List<Payment> payments,
  ) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall;
    return AppDataTable(
      columns: const [
        DataColumn(label: Text('收款单号')),
        DataColumn(label: Text('客户')),
        DataColumn(label: Text('来源单据')),
        DataColumn(label: Text('收款方式')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('下一步')),
        DataColumn(label: Text('收款日期')),
        DataColumn(label: Text('操作')),
      ],
      rows: payments
          .map(
            (payment) => DataRow(
              cells: [
                DataCell(
                  Text(
                    _displayText(payment.paymentNumber ?? '收款 #${payment.id}'),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(_displayText(payment.customerName), style: textStyle),
                ),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(
                      _sourceSummary(payment),
                      style: textStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(_paymentMethodText(payment), style: textStyle)),
                DataCell(Text(_formatAmount(payment.amount), style: textStyle)),
                DataCell(Text(_followUpText(payment), style: textStyle)),
                DataCell(
                  Text(_formatDate(payment.paymentDate), style: textStyle),
                ),
                DataCell(_buildRowActions(payment)),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    PaymentViewModel viewModel,
    bool isMobile,
  ) {
    final permissions = PermissionUtil.snapshot(context);
    Future<void> openFilterDrawer() async {
      await _loadOptions();
      if (!mounted) return;
      showAdaptiveFilterDrawer(
        context,
        isMobile: isMobile,
        child: _buildFilterPanel(
          context,
          viewModel,
          bottomSpacing: isMobile ? 16 : 20,
        ),
      );
    }

    return PageHeaderBar(
      breadcrumb: null,
      useSurface: false,
      showDivider: false,
      padding: EdgeInsets.zero,
      actions: LayoutBuilder(
        builder: (context, constraints) {
          final pendingWriteOffCount = _summaryCount(
            viewModel.summary,
            'pending_writeoff_count',
          );
          final missingInvoiceLinkCount = _summaryCount(
            viewModel.summary,
            'missing_invoice_link_count',
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
            if (pendingWriteOffCount > 0)
              StatusHintChip(
                label: '待核销收款',
                count: pendingWriteOffCount,
                icon: Icons.rule_folder_outlined,
                selected: viewModel.todoFilter == 'pending_writeoff',
                onTap: () => _openQuickFilter(todo: 'pending_writeoff'),
              ),
            if (missingInvoiceLinkCount > 0)
              StatusHintChip(
                label: '待关联发票',
                count: missingInvoiceLinkCount,
                icon: Icons.receipt_long_outlined,
                selected: viewModel.todoFilter == 'missing_invoice_link',
                onTap: () => _openQuickFilter(todo: 'missing_invoice_link'),
              ),
            if (_hasActiveFilter(viewModel))
              PageActionButton.outlined(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除筛选',
              ),
            if (permissions.has('workorder.add_payment'))
              PageActionButton.filled(
                onPressed: () => _openCreateDialog(viewModel),
                icon: const Icon(Icons.add, size: 16),
                label: '新建收款',
              ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadPayments(resetPage: true),
              icon: const Icon(Icons.refresh, size: 16),
              label: _refreshButtonText,
            ),
            PageActionButton.outlined(
              onPressed: _optionsLoading ? null : openFilterDrawer,
              icon: const Icon(Icons.filter_alt_outlined, size: 16),
              label: _activeFilterCount(viewModel) > 0
                  ? '筛选 ${_activeFilterCount(viewModel)}'
                  : '筛选',
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

  Widget _buildFilterPanel(
    BuildContext context,
    PaymentViewModel viewModel, {
    required double bottomSpacing,
  }) {
    final customerValue = viewModel.customerFilter.isEmpty
        ? ''
        : viewModel.customerFilter;
    final methodValue = viewModel.paymentMethodFilter.isEmpty
        ? ''
        : viewModel.paymentMethodFilter;
    final todoValue = viewModel.todoFilter.isEmpty ? '' : viewModel.todoFilter;
    return FilterPanelBody(
      bottomSpacing: bottomSpacing,
      resetLabel: _resetButtonText,
      onReset: () => _resetFilters(context, viewModel),
      fields: [
        AppSelect<String>(
          key: ValueKey<String>('payment-customer-$customerValue'),
          value: customerValue,
          decoration: const InputDecoration(labelText: _customerFilterLabel),
          options: [
            const AppDropdownOption(value: '', label: '全部客户'),
            ..._customers.map(
              (customer) => AppDropdownOption(
                value: customer.id.toString(),
                label: customer.name,
              ),
            ),
          ],
          onChanged: (value) => viewModel.setCustomerFilter(value ?? ''),
        ),
        AppSelect<String>(
          key: ValueKey<String>('payment-method-$methodValue'),
          value: methodValue,
          decoration: const InputDecoration(
            labelText: _paymentMethodFilterLabel,
          ),
          options: const [
            AppDropdownOption(value: '', label: '全部方式'),
            AppDropdownOption(value: 'cash', label: '现金'),
            AppDropdownOption(value: 'transfer', label: '转账'),
            AppDropdownOption(value: 'check', label: '支票'),
            AppDropdownOption(value: 'acceptance', label: '承兑汇票'),
          ],
          onChanged: (value) => viewModel.setPaymentMethodFilter(value ?? ''),
        ),
        AppSelect<String>(
          key: ValueKey<String>('payment-todo-$todoValue'),
          value: todoValue,
          decoration: const InputDecoration(labelText: _todoFilterLabel),
          options: const [
            AppDropdownOption(value: '', label: '全部待办'),
            AppDropdownOption(value: 'pending_writeoff', label: '待核销'),
            AppDropdownOption(value: 'missing_invoice_link', label: '待关联发票'),
          ],
          onChanged: (value) => viewModel.setTodoFilter(value ?? ''),
        ),
        AppSelect<String>(
          key: ValueKey<String>(viewModel.ordering),
          value: viewModel.ordering,
          decoration: const InputDecoration(labelText: _orderingLabel),
          options: const [
            AppDropdownOption(value: '-payment_date', label: '收款日期降序'),
            AppDropdownOption(value: 'payment_date', label: '收款日期升序'),
            AppDropdownOption(value: 'payment_number', label: '收款单号升序'),
            AppDropdownOption(value: '-payment_number', label: '收款单号降序'),
            AppDropdownOption(value: 'customer__name', label: '客户名称升序'),
            AppDropdownOption(value: '-customer__name', label: '客户名称降序'),
            AppDropdownOption(value: 'amount', label: '收款金额升序'),
            AppDropdownOption(value: '-amount', label: '收款金额降序'),
            AppDropdownOption(value: 'remaining_amount', label: '未核销升序'),
            AppDropdownOption(value: '-remaining_amount', label: '未核销降序'),
          ],
          onChanged: (value) => viewModel.setOrdering(value ?? '-payment_date'),
        ),
      ],
    );
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

  Widget _buildSummaryCard(
    BuildContext context,
    Payment payment,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = _displayText(payment.paymentNumber ?? '收款 #${payment.id}');
    final customer = _displayText(payment.customerName);
    final source = _sourceSummary(payment);
    final amount = _formatAmount(payment.amount);
    final paymentMethod = _paymentMethodText(payment);
    final paymentDate = _formatDate(payment.paymentDate);
    final followUp = _followUpText(payment);
    final actions = _buildActions(payment);

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
                      _SummaryChip(label: '收款方式', value: paymentMethod),
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
                  paymentDate,
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
            number: number,
            customer: customer,
            source: source,
            paymentMethod: paymentMethod,
            amount: amount,
            appliedRemaining:
                '${_formatAmount(payment.appliedAmount)} / ${_formatAmount(payment.remainingAmount)}',
            paymentDate: paymentDate,
            followUp: followUp,
          ),
          if (actions.isNotEmpty) ...[
            SizedBox(height: sectionSpacing),
            RowActionGroup(actions: actions, primaryCount: 2),
          ],
        ],
      ),
    );
  }

  Widget _buildRowActions(Payment payment) {
    final actions = _buildActions(payment);
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return RowActionGroup(actions: actions, primaryCount: 2);
  }

  List<RowAction> _buildActions(Payment payment) {
    final actions = <RowAction>[];
    if ((payment.invoiceId ?? 0) > 0) {
      actions.add(
        RowAction(
          label: '发票',
          icon: Icons.receipt_long_outlined,
          onPressed: () => context.go('/finance/invoices'),
        ),
      );
    }
    if ((payment.salesOrderId ?? 0) > 0) {
      actions.add(
        RowAction(
          label: '客户订单',
          icon: Icons.point_of_sale_outlined,
          onPressed: () => context.go('/sales-orders/${payment.salesOrderId}'),
        ),
      );
    }
    return actions;
  }

  String _sourceSummary(Payment payment) {
    final parts = <String>[];
    if ((payment.salesOrderNumber ?? '').trim().isNotEmpty) {
      parts.add('客户订单 ${payment.salesOrderNumber!.trim()}');
    }
    if ((payment.invoiceNumber ?? '').trim().isNotEmpty) {
      parts.add('发票 ${payment.invoiceNumber!.trim()}');
    }
    if ((payment.workOrderNumber ?? '').trim().isNotEmpty) {
      parts.add('施工单 ${payment.workOrderNumber!.trim()}');
    }
    return parts.isEmpty ? _emptyCellText : parts.join(' / ');
  }

  String _paymentMethodText(Payment payment) {
    return _displayText(payment.paymentMethodDisplay ?? payment.paymentMethod);
  }

  String _followUpText(Payment payment) {
    final backendText = payment.followUpText?.trim() ?? '';
    if (backendText.isNotEmpty) {
      return backendText;
    }
    final remaining = payment.remainingAmount ?? 0;
    if (remaining > 0) {
      return '推进收款核销 ${_formatAmount(remaining)}';
    }
    if ((payment.invoiceId ?? 0) <= 0 && (payment.salesOrderId ?? 0) > 0) {
      return '待关联发票';
    }
    return '收款已完成';
  }

  void _clearFilters() {
    final search = _searchController.text.trim();
    final query = <String, String>{};
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    context.go(
      Uri(path: '/finance/payments', queryParameters: query).toString(),
    );
  }

  void _openQuickFilter({String? todo}) {
    final query = <String, String>{};
    final search = _searchController.text.trim();
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    final viewModel = context.read<PaymentViewModel>();
    if (viewModel.customerFilter.isNotEmpty) {
      query['customer'] = viewModel.customerFilter;
    }
    if (viewModel.paymentMethodFilter.isNotEmpty) {
      query['payment_method'] = viewModel.paymentMethodFilter;
    }
    if (viewModel.ordering != '-payment_date') {
      query['ordering'] = viewModel.ordering;
    }
    if ((todo ?? '').trim().isNotEmpty) {
      query['todo'] = todo!.trim();
    }
    context.go(
      Uri(path: '/finance/payments', queryParameters: query).toString(),
    );
  }

  bool _hasActiveFilter(PaymentViewModel viewModel) {
    return viewModel.customerFilter.isNotEmpty ||
        viewModel.paymentMethodFilter.isNotEmpty ||
        viewModel.todoFilter.isNotEmpty ||
        viewModel.ordering != '-payment_date' ||
        viewModel.startDateFilter.isNotEmpty ||
        viewModel.endDateFilter.isNotEmpty;
  }

  int _activeFilterCount(PaymentViewModel viewModel) {
    var count = 0;
    if (_searchController.text.trim().isNotEmpty) count += 1;
    if (viewModel.customerFilter.isNotEmpty) count += 1;
    if (viewModel.paymentMethodFilter.isNotEmpty) count += 1;
    if (viewModel.todoFilter.isNotEmpty) count += 1;
    if (viewModel.ordering != '-payment_date') count += 1;
    if (viewModel.startDateFilter.isNotEmpty) count += 1;
    if (viewModel.endDateFilter.isNotEmpty) count += 1;
    return count;
  }

  void _resetFilters(BuildContext context, PaymentViewModel viewModel) {
    if (_searchController.text.trim().isNotEmpty) {
      context.go('/finance/payments');
      return;
    }
    viewModel
      ..setSearchText('')
      ..setFiltersSilently(
        customer: '',
        paymentMethod: '',
        todo: '',
        ordering: '-payment_date',
        startDate: '',
        endDate: '',
      );
    viewModel.loadPayments(resetPage: true);
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

  static Widget _buildMobileFields(
    BuildContext context, {
    required String number,
    required String customer,
    required String source,
    required String paymentMethod,
    required String amount,
    required String appliedRemaining,
    required String paymentDate,
    required String followUp,
  }) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.extension<AppColors>()?.subtleText ?? theme.hintColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileRow(context, labelStyle, '收款单号', number),
        _mobileRow(context, labelStyle, '客户', customer),
        _mobileRow(context, labelStyle, '来源单据', source),
        _mobileRow(context, labelStyle, '收款方式', paymentMethod),
        _mobileRow(context, labelStyle, '金额', amount),
        _mobileRow(context, labelStyle, '已核销/待核销', appliedRemaining),
        _mobileRow(context, labelStyle, '收款日期', paymentDate),
        _mobileRow(context, labelStyle, '下一步', followUp, last: true),
      ],
    );
  }

  static Widget _mobileRow(
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
}

typedef _SummaryChip = SummaryChip;
