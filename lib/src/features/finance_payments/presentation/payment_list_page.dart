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
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_payments/application/payment_view_model.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_repository_impl.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_support_service.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/finance_payments/presentation/widgets/payment_list_dialogs.dart';

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
  static const _searchDebounceDuration = Duration(milliseconds: 450);
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

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _optionsLoading = false;
  bool _optionsLoaded = false;
  List<Customer> _customers = [];
  List<SalesOrder> _salesOrders = [];
  List<Invoice> _invoices = [];
  PaymentSupportService? _supportService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService ??= PaymentSupportService(context.read<ApiClient>());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _scheduleSearch(PaymentViewModel viewModel, {bool immediate = false}) {
    _searchDebounce?.cancel();
    if (immediate) {
      viewModel.setSearchText(_searchController.text.trim());
      viewModel.loadPayments(resetPage: true);
      return;
    }
    _searchDebounce = Timer(_searchDebounceDuration, () {
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
    final isMobile = BreakpointsUtil.isMobile(context);

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
        DataColumn(label: Text('施工单号')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('收款日期')),
      ],
      rows: payments
          .map(
            (payment) => DataRow(
              cells: [
                DataCell(Text(
                  _displayText(payment.paymentNumber ?? '收款 #${payment.id}'),
                  style: theme.textTheme.bodyMedium,
                )),
                DataCell(
                    Text(_displayText(payment.customerName), style: textStyle)),
                DataCell(Text(_displayText(payment.workOrderNumber),
                    style: textStyle)),
                DataCell(Text(_formatAmount(payment.amount), style: textStyle)),
                DataCell(Text(
                  payment.statusDisplay ?? payment.status ?? _emptyCellText,
                  style: textStyle,
                )),
                DataCell(
                    Text(_formatDate(payment.paymentDate), style: textStyle)),
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
              label: '新建收款',
            ),
            PageActionButton.outlined(
              onPressed: () => viewModel.loadPayments(resetPage: true),
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
      BuildContext context, Payment payment, bool isMobile) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = _displayText(payment.paymentNumber ?? '收款 #${payment.id}');
    final customer = _displayText(payment.customerName);
    final workOrder = _displayText(payment.workOrderNumber);
    final amount = _formatAmount(payment.amount);
    final status = payment.statusDisplay ?? payment.status ?? _emptyCellText;
    final paymentDate = _formatDate(payment.paymentDate);

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
                  paymentDate,
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
        children: [
          _SummaryField(label: '收款单号', value: number),
          _SummaryField(label: '客户', value: customer),
          _SummaryField(label: '施工单号', value: workOrder),
          _SummaryField(label: '金额', value: amount),
          _SummaryField(label: '状态', value: status),
          _SummaryField(label: '收款日期', value: paymentDate),
        ],
      ),
    );
  }
}

typedef _SummaryField = SummaryField;
typedef _SummaryChip = SummaryChip;
