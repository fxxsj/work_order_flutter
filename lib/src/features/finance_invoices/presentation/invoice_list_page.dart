import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_data_table.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_decision_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_list_page.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/expandable_summary_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/row_actions.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/status_hint_chip.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_toolbar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/summary_widgets.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/utils/audit_log_navigation.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/file_link_util.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_invoices/application/invoice_view_model.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_form_options_loader.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_repository_impl.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

/// 发票列表入口，负责创建并缓存依赖，避免页面重建时重复初始化。
class InvoiceListEntry extends StatelessWidget {
  const InvoiceListEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<InvoiceApiService, InvoiceRepository, InvoiceViewModel>(
      createService: (context) => InvoiceApiService(context.read<ApiClient>()),
      createRepository: (context) =>
          InvoiceRepositoryImpl(context.read<InvoiceApiService>()),
      createViewModel: (context) =>
          InvoiceViewModel(context.read<InvoiceRepository>()),
      initialize: (viewModel) => viewModel.initialize(),
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
  static const List<String> _attachmentExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
  ];

  static const String _searchHintText = '搜索发票号/客户';
  static const String _refreshButtonText = '刷新';
  static const String _emptyText = '暂无发票数据';
  static const String _errorFallbackText = '加载失败';
  static const String _retryText = '重新加载';
  static const String _pageInfoTemplate = '第 {page} / {total} 页，共 {count} 条';
  static const String _pageSizeLabel = '每页 {size}';
  static const CrudActionConfig<Invoice> _submitConfig = CrudActionConfig(
    title: '提交发票',
    summaryBuilder: _buildSubmitSummary,
    impactsBuilder: _buildSubmitImpacts,
    auditHintBuilder: _buildSubmitAuditHint,
    confirmText: '提交发票',
    successMessageBuilder: _buildSubmitSuccessMessage,
    errorMessagePrefix: '提交失败: ',
  );

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _optionsLoading = false;
  bool _optionsLoaded = false;
  int? _uploadingInvoiceId;
  bool _pendingPrefill = false;
  int? _prefillSalesOrderId;
  int? _prefillCustomerId;
  String? _lastRouteSignature;
  List<Customer> _customers = [];
  List<SalesOrder> _salesOrders = [];
  List<WorkOrder> _workOrders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    final routeSearch = uri.queryParameters['search']?.trim() ?? '';
    final routeStatus = uri.queryParameters['status']?.trim() ?? '';
    final routeTodo = uri.queryParameters['todo']?.trim() ?? '';
    final createFlag = uri.queryParameters['create'];
    final salesOrderId =
        int.tryParse(uri.queryParameters['sales_order_id'] ?? '');
    final customerId = int.tryParse(uri.queryParameters['customer_id'] ?? '');
    final signature = [
      routeSearch,
      routeStatus,
      routeTodo,
      createFlag ?? '',
      salesOrderId?.toString() ?? '',
      customerId?.toString() ?? '',
    ].join('|');
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    _searchController.text = routeSearch;

    if (salesOrderId != null && (createFlag == '1' || createFlag == 'true')) {
      if (!PermissionUtil.hasPermission(context, 'workorder.add_invoice')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.read<InvoiceViewModel>().applyRoutePrefill(
                search: routeSearch,
                status: routeStatus,
                todo: routeTodo,
              );
        });
        return;
      }
      _prefillSalesOrderId = salesOrderId;
      _prefillCustomerId = customerId;
      _pendingPrefill = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pendingPrefill) return;
        _pendingPrefill = false;
        final viewModel = context.read<InvoiceViewModel>();
        _openCreateDialog(
          viewModel,
          prefillSalesOrderId: _prefillSalesOrderId,
          prefillCustomerId: _prefillCustomerId,
        );
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<InvoiceViewModel>().applyRoutePrefill(
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

  Future<void> _openCreateDialog(
    InvoiceViewModel viewModel, {
    int? prefillSalesOrderId,
    int? prefillCustomerId,
  }) async {
    if (!PermissionUtil.hasPermission(context, 'workorder.add_invoice')) {
      ToastUtil.showError('当前账号无权新建发票');
      return;
    }
    await _loadOptions();
    if (_customers.isEmpty) {
      ToastUtil.showError('请先配置客户信息');
      return;
    }

    final prefillSalesOrder =
        prefillSalesOrderId != null && prefillSalesOrderId > 0
            ? prefillSalesOrderId
            : null;
    final prefillCustomer = prefillCustomerId != null && prefillCustomerId > 0
        ? prefillCustomerId
        : null;

    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final taxRateController = TextEditingController(text: '13');
    final issueDateController = TextEditingController();
    final notesController = TextEditingController();
    String invoiceType = 'vat_normal';
    int? selectedCustomerId = prefillCustomer;
    int? selectedSalesOrderId = prefillSalesOrder;
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
              final taxRate =
                  double.tryParse(taxRateController.text.trim()) ?? 0;
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

                await viewModel.createInvoice(payload);
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
                            DropdownMenuItem(
                                value: 'vat_special', child: Text('增值税专用发票')),
                            DropdownMenuItem(
                                value: 'vat_normal', child: Text('增值税普通发票')),
                            DropdownMenuItem(
                                value: 'electronic', child: Text('电子发票')),
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
                          validator: (value) => value == null ? '请选择客户' : null,
                        ),
                        const SizedBox(height: 12),
                        SearchableDropdownFormField<int?>(
                          initialValue: selectedSalesOrderId,
                          decoration: const InputDecoration(
                            labelText: '关联客户订单（可选）',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('不关联客户订单'),
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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

  Future<void> _submitInvoice(
      InvoiceViewModel viewModel, Invoice invoice) async {
    try {
      await confirmCrudAction(
        context,
        item: invoice,
        onConfirm: (item) async {
          await viewModel.submitInvoice(item.id);
          await viewModel.loadInvoices(resetPage: false);
        },
        config: _submitConfig,
      );
    } catch (err) {
      ToastUtil.showError('提交失败: $err');
    }
  }

  Future<void> _approveInvoice(
    InvoiceViewModel viewModel,
    Invoice invoice, {
    required bool approved,
  }) async {
    final decision = await showActionDecisionDialog<void>(
      context,
      title: approved ? '确认收到' : '作废发票',
      summary: approved
          ? '确认收到后，发票会进入后续收款与对账环节。'
          : '作废后，这张发票将退出后续收款与对账闭环，需要业务和财务重新核对来源单据。',
      impacts: approved
          ? const [
              '请确认票据号码、金额和附件已齐全',
              '错误确认会影响后续收款匹配',
            ]
          : const [
              '如已发送给客户，请先确认是否应走红冲或换票流程',
              '作废后建议同步核对客户订单、施工单和附件资料',
            ],
      auditHint:
          approved ? '确认记录建议保留审批备注，便于后续收款追踪。' : '作废原因会进入审计记录，便于财务复盘和争议处理。',
      destructive: !approved,
      notesLabel: approved ? '确认说明（可选）' : '作废说明（可选）',
      notesMaxLines: 3,
      submitText: approved ? '确认' : '作废',
    );
    if (decision == null) {
      return;
    }
    try {
      await viewModel.approveInvoice(invoice.id, {
        'approved': approved,
        'approval_comment': decision.notes,
      });
      ToastUtil.showSuccess(approved ? '已确认收到' : '已作废');
      await viewModel.loadInvoices(resetPage: false);
    } catch (err) {
      ToastUtil.showError('操作失败: $err');
    }
  }

  Future<void> _uploadAttachment(
    InvoiceViewModel viewModel,
    Invoice invoice,
  ) async {
    if (_uploadingInvoiceId == invoice.id) {
      return;
    }
    final pickedFile = await showFileUploadDialog(
      context,
      title: '上传发票附件',
      label: '发票附件',
      allowedExtensions: _attachmentExtensions,
      fallbackFilename: 'invoice-attachment',
      helperText: '支持 PDF、图片等票据资料',
      submitText: '上传',
    );
    final attachment = pickedFile?.file;
    if (attachment == null) {
      return;
    }

    setState(() => _uploadingInvoiceId = invoice.id);
    try {
      await viewModel.uploadAttachment(invoice.id, attachment);
      if (!mounted) return;
      ToastUtil.showSuccess('发票附件已上传');
      await viewModel.loadInvoices(resetPage: false);
    } catch (err) {
      ToastUtil.showError('上传发票附件失败: $err');
    } finally {
      if (mounted && _uploadingInvoiceId == invoice.id) {
        setState(() => _uploadingInvoiceId = null);
      }
    }
  }

  Future<void> _loadOptions() async {
    if (_optionsLoaded || _optionsLoading) return;
    setState(() => _optionsLoading = true);
    try {
      final data =
          await InvoiceFormOptionsLoader(context.read<ApiClient>()).load();
      if (!mounted) return;
      setState(() {
        _customers = data.customers;
        _salesOrders = data.salesOrders;
        _workOrders = data.workOrders;
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

  static String _invoiceLabel(Invoice invoice) {
    final number = (invoice.invoiceNumber ?? '').trim();
    if (number.isNotEmpty) {
      return number;
    }
    return '发票 #${invoice.id}';
  }

  static String _buildSubmitSummary(Invoice invoice) {
    return '即将提交发票 ${_invoiceLabel(invoice)}。提交后将进入财务流转，后续需根据状态确认收到或作废。';
  }

  static List<String> _buildSubmitImpacts(Invoice invoice) {
    return [
      '客户：${CrudValueFormatter.text(invoice.customerName)}',
      '类型：${_invoiceTypeStaticText(invoice)}',
      '金额：${CrudValueFormatter.amount(invoice.amount)}',
      if ((invoice.salesOrderNumber ?? '').trim().isNotEmpty)
        '关联客户订单：${invoice.salesOrderNumber!.trim()}',
      if ((invoice.workOrderNumber ?? '').trim().isNotEmpty)
        '关联施工单：${invoice.workOrderNumber!.trim()}',
    ];
  }

  static String _buildSubmitAuditHint(Invoice invoice) {
    return '请确认金额、客户信息和附件资料已准备齐全，再执行提交。';
  }

  static String _buildSubmitSuccessMessage(Invoice invoice) {
    return '发票已提交';
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
        DataColumn(label: Text('来源')),
        DataColumn(label: Text('类型')),
        DataColumn(label: Text('金额')),
        DataColumn(label: Text('状态')),
        DataColumn(label: Text('下一步')),
        DataColumn(label: Text('开票日期')),
        DataColumn(label: Text('附件')),
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
                  SizedBox(
                    width: 180,
                    child: Text(
                      _sourceSummary(invoice),
                      style: textStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(_invoiceTypeText(invoice), style: textStyle)),
                DataCell(Text(_formatAmount(invoice.amount), style: textStyle)),
                DataCell(Text(
                  invoice.statusDisplay ?? invoice.status ?? _emptyCellText,
                  style: textStyle,
                )),
                DataCell(Text(_followUpText(invoice), style: textStyle)),
                DataCell(
                    Text(_formatDate(invoice.issueDate), style: textStyle)),
                DataCell(Text(
                  _attachmentStatusText(invoice),
                  style: textStyle,
                )),
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
          final missingAttachmentCount =
              _summaryCount(viewModel.summary, 'pending_attachment_count');
          final pendingReceiptCount =
              _summaryCount(viewModel.summary, 'pending_receipt_count');
          final pendingIssueCount =
              _summaryCount(viewModel.summary, 'pending_issue_count');
          final pendingPaymentCount =
              _summaryCount(viewModel.summary, 'pending_payment_count');
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
            if (pendingIssueCount > 0)
              StatusHintChip(
                label: '待开票',
                count: pendingIssueCount,
                icon: Icons.edit_note_outlined,
                selected: viewModel.statusFilter == 'draft',
                onTap: () => _openQuickFilter(status: 'draft'),
              ),
            if (missingAttachmentCount > 0)
              StatusHintChip(
                label: '待补附件',
                count: missingAttachmentCount,
                icon: Icons.attach_file_outlined,
                selected: viewModel.todoFilter == 'pending_attachment',
                onTap: () => _openQuickFilter(todo: 'pending_attachment'),
              ),
            if (pendingReceiptCount > 0)
              StatusHintChip(
                label: '待确认收到',
                count: pendingReceiptCount,
                icon: Icons.verified_outlined,
                selected: viewModel.todoFilter == 'pending_receipt',
                onTap: () => _openQuickFilter(todo: 'pending_receipt'),
              ),
            if (pendingPaymentCount > 0)
              StatusHintChip(
                label: '待催收款',
                count: pendingPaymentCount,
                icon: Icons.payments_outlined,
                selected: viewModel.todoFilter == 'pending_payment',
                onTap: () => _openQuickFilter(todo: 'pending_payment'),
              ),
            if (_hasActiveFilter(viewModel))
              PageActionButton.outlined(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: '清除筛选',
              ),
            if (PermissionUtil.hasPermission(context, 'workorder.add_invoice'))
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
    final canChangeInvoice =
        PermissionUtil.hasPermission(context, 'workorder.change_invoice');
    final canViewAudit = AuditLogNavigation.canView(context);
    final actions = <RowAction>[];
    final status = invoice.status ?? '';
    if (canChangeInvoice) {
      actions.add(RowAction(
        label: _hasAttachment(invoice) ? '更新附件' : '上传附件',
        icon: Icons.upload_file_outlined,
        onPressed: () => _uploadAttachment(viewModel, invoice),
      ));
    }
    if (_hasAttachment(invoice)) {
      actions.add(RowAction(
        label: '附件',
        icon: Icons.attach_file_outlined,
        onPressed: () => _openAttachment(invoice),
      ));
    }
    if ((invoice.salesOrderId ?? 0) > 0) {
      actions.add(RowAction(
        label: '客户订单',
        icon: Icons.point_of_sale_outlined,
        onPressed: () => _openSalesOrder(invoice),
      ));
    }
    if ((invoice.workOrderId ?? 0) > 0) {
      actions.add(RowAction(
        label: '施工单',
        icon: Icons.assignment_outlined,
        onPressed: () => _openWorkOrder(invoice),
      ));
    }
    final auditKeyword = (invoice.invoiceNumber ?? '').trim();
    if (canViewAudit && auditKeyword.isNotEmpty) {
      actions.add(RowAction(
        label: '审计',
        icon: Icons.history_outlined,
        onPressed: () =>
            AuditLogNavigation.open(context, keyword: auditKeyword),
      ));
    }
    if (canChangeInvoice && status == 'draft') {
      actions.add(RowAction(
        label: '提交',
        icon: Icons.send_outlined,
        onPressed: () => _submitInvoice(viewModel, invoice),
      ));
    }
    if (canChangeInvoice && status == 'issued') {
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

  static String _invoiceTypeStaticText(Invoice invoice) {
    final display = (invoice.invoiceTypeDisplay ?? '').trim();
    if (display.isNotEmpty) {
      return display;
    }
    switch (invoice.invoiceType) {
      case 'vat_special':
        return '增值税专用发票';
      case 'vat_normal':
        return '增值税普通发票';
      case 'electronic':
        return '电子发票';
      default:
        return _emptyCellText;
    }
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
      BuildContext context, Invoice invoice, bool isMobile) {
    final canChangeInvoice =
        PermissionUtil.hasPermission(context, 'workorder.change_invoice');
    final canViewAudit = AuditLogNavigation.canView(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final sectionSpacing = LayoutTokens.sectionSpacing(context);
    final number = _displayText(invoice.invoiceNumber ?? '发票 #${invoice.id}');
    final customer = _displayText(invoice.customerName);
    final source = _sourceSummary(invoice);
    final invoiceType = _invoiceTypeText(invoice);
    final amount = _formatAmount(invoice.amount);
    final status = invoice.statusDisplay ?? invoice.status ?? _emptyCellText;
    final followUp = _followUpText(invoice);
    final issueDate = _formatDate(invoice.issueDate);
    final attachmentStatus = _attachmentStatusText(invoice);

    final actions = <RowAction>[];
    final statusCode = invoice.status ?? '';
    if (canChangeInvoice) {
      actions.add(RowAction(
        label: _hasAttachment(invoice) ? '更新附件' : '上传附件',
        icon: Icons.upload_file_outlined,
        onPressed: () =>
            _uploadAttachment(context.read<InvoiceViewModel>(), invoice),
      ));
    }
    if (_hasAttachment(invoice)) {
      actions.add(RowAction(
        label: '附件',
        icon: Icons.attach_file_outlined,
        onPressed: () => _openAttachment(invoice),
      ));
    }
    if ((invoice.salesOrderId ?? 0) > 0) {
      actions.add(RowAction(
        label: '客户订单',
        icon: Icons.point_of_sale_outlined,
        onPressed: () => _openSalesOrder(invoice),
      ));
    }
    if ((invoice.workOrderId ?? 0) > 0) {
      actions.add(RowAction(
        label: '施工单',
        icon: Icons.assignment_outlined,
        onPressed: () => _openWorkOrder(invoice),
      ));
    }
    final auditKeyword = (invoice.invoiceNumber ?? '').trim();
    if (canViewAudit && auditKeyword.isNotEmpty) {
      actions.add(RowAction(
        label: '审计',
        icon: Icons.history_outlined,
        onPressed: () =>
            AuditLogNavigation.open(context, keyword: auditKeyword),
      ));
    }
    if (canChangeInvoice && statusCode == 'draft') {
      actions.add(RowAction(
        label: '提交',
        icon: Icons.send_outlined,
        onPressed: () =>
            _submitInvoice(context.read<InvoiceViewModel>(), invoice),
      ));
    }
    if (canChangeInvoice && statusCode == 'issued') {
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
              _SummaryField(label: '来源', value: source),
              _SummaryField(label: '发票类型', value: invoiceType),
              _SummaryField(label: '金额', value: amount),
              _SummaryField(label: '状态', value: status),
              _SummaryField(label: '下一步', value: followUp),
              _SummaryField(label: '开票日期', value: issueDate),
              _SummaryField(label: '附件', value: attachmentStatus),
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

  bool _hasAttachment(Invoice invoice) {
    return FileLinkUtil.hasLink(invoice.attachmentUrl);
  }

  bool _shouldHaveAttachment(Invoice invoice) {
    const statuses = {'issued', 'sent', 'received'};
    return statuses.contains(invoice.status ?? '');
  }

  String _attachmentStatusText(Invoice invoice) {
    if (_hasAttachment(invoice)) return '已上传';
    return _shouldHaveAttachment(invoice) ? '待补附件' : _emptyCellText;
  }

  String _invoiceTypeText(Invoice invoice) {
    return _displayText(invoice.invoiceTypeDisplay ?? invoice.invoiceType);
  }

  String _followUpText(Invoice invoice) {
    final text = invoice.followUpText?.trim() ?? '';
    if (text.isNotEmpty) return text;
    final status = invoice.status ?? '';
    if (status == 'draft') return '推进开票提交';
    if (status == 'received' && (invoice.paymentRemainingAmount ?? 0) > 0) {
      return '推进收款 ${_formatAmount(invoice.paymentRemainingAmount)}';
    }
    if (status == 'issued' || status == 'sent') {
      return _hasAttachment(invoice) ? '待确认收票' : '待补开票附件';
    }
    if (status == 'cancelled' || status == 'refunded') {
      return '单据已关闭';
    }
    return _emptyCellText;
  }

  String _sourceSummary(Invoice invoice) {
    final parts = <String>[];
    if ((invoice.salesOrderNumber ?? '').trim().isNotEmpty) {
      parts.add('客户订单 ${invoice.salesOrderNumber!.trim()}');
    }
    if ((invoice.workOrderNumber ?? '').trim().isNotEmpty) {
      parts.add('施工单 ${invoice.workOrderNumber!.trim()}');
    }
    if (parts.isEmpty) return _emptyCellText;
    return parts.join(' / ');
  }

  void _openSalesOrder(Invoice invoice) {
    final id = invoice.salesOrderId;
    if (id == null || id <= 0) {
      ToastUtil.showError('当前发票未关联客户订单');
      return;
    }
    context.go('/sales-orders/$id');
  }

  void _openWorkOrder(Invoice invoice) {
    final id = invoice.workOrderId;
    if (id == null || id <= 0) {
      ToastUtil.showError('当前发票未关联施工单');
      return;
    }
    context.go('/workorders/$id');
  }

  Future<void> _openAttachment(Invoice invoice) async {
    try {
      await FileLinkUtil.open(invoice.attachmentUrl);
    } catch (err) {
      ToastUtil.showError('打开附件失败: $err');
    }
  }

  bool _hasActiveFilter(InvoiceViewModel viewModel) {
    return viewModel.statusFilter.isNotEmpty || viewModel.todoFilter.isNotEmpty;
  }

  void _clearFilters() {
    final search = _searchController.text.trim();
    final query = <String, String>{};
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    context
        .go(Uri(path: '/finance/invoices', queryParameters: query).toString());
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
    context
        .go(Uri(path: '/finance/invoices', queryParameters: query).toString());
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
