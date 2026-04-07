import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';

class PaymentCreateResult {
  const PaymentCreateResult({
    required this.payload,
  });

  final Map<String, dynamic> payload;
}

Future<PaymentCreateResult?> showPaymentCreateDialog(
  BuildContext context, {
  required List<Customer> customers,
  required List<SalesOrder> salesOrders,
  required List<Invoice> invoices,
}) async {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final paymentDateController = TextEditingController();
  final bankController = TextEditingController();
  final transactionController = TextEditingController();
  final notesController = TextEditingController();
  String paymentMethod = 'transfer';
  int? selectedCustomerId;
  int? selectedSalesOrderId;
  int? selectedInvoiceId;
  try {
    PaymentCreateResult? result;
    await showAdaptiveFilterDrawer(
      context,
      isMobile: BreakpointsUtil.isMobile(context),
      title: '新建收款',
      desktopWidth: LayoutTokens.dialogWidthLg,
      child: StatefulBuilder(
        builder: (context, setState) {
          Future<void> submit() async {
            if (!(formKey.currentState?.validate() ?? false)) return;
            final amount = double.tryParse(amountController.text.trim());
            if (amount == null || amount <= 0) return;

            final payload = <String, dynamic>{
              'customer': selectedCustomerId,
              'amount': amount,
              'payment_method': paymentMethod,
              'payment_date': paymentDateController.text.trim(),
              'bank_account': bankController.text.trim(),
              'transaction_number': transactionController.text.trim(),
              'notes': notesController.text.trim(),
            };
            if (selectedSalesOrderId != null) {
              payload['sales_order'] = selectedSalesOrderId;
            }
            if (selectedInvoiceId != null) {
              payload['invoice'] = selectedInvoiceId;
            }
            result = PaymentCreateResult(payload: payload);
            Navigator.of(context).maybePop();
          }

          String customerLabel = '未选择';
          if (selectedCustomerId != null) {
            for (final customer in customers) {
              if (customer.id == selectedCustomerId) {
                customerLabel = customer.name;
                break;
              }
            }
          }

          String salesOrderLabel = '不关联';
          if (selectedSalesOrderId != null) {
            for (final order in salesOrders) {
              if (order.id == selectedSalesOrderId) {
                salesOrderLabel = order.orderNumber;
                break;
              }
            }
          }

          String invoiceLabel = '不关联';
          if (selectedInvoiceId != null) {
            for (final invoice in invoices) {
              if (invoice.id == selectedInvoiceId) {
                invoiceLabel = invoice.invoiceNumber ?? '发票 #${invoice.id}';
                break;
              }
            }
          }

          return AdaptiveFormPanel(
            formKey: formKey,
            onSubmit: submit,
            submitText: '创建',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '新建收款',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapXxs),
                      Text(
                        '把客户、来源订单和发票信息集中在一个面板里录入。',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      Wrap(
                        spacing: LayoutTokens.gapMd,
                        runSpacing: LayoutTokens.gapSm,
                        children: [
                          _PaymentSummaryItem(
                            label: '客户',
                            value: customerLabel,
                          ),
                          _PaymentSummaryItem(
                            label: '客户订单',
                            value: salesOrderLabel,
                          ),
                          _PaymentSummaryItem(
                            label: '关联发票',
                            value: invoiceLabel,
                          ),
                          _PaymentSummaryItem(
                            label: '收款方式',
                            value: _paymentMethodLabel(paymentMethod),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LayoutTokens.gapLg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '关联信息',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      UnifiedDropdown<int?>(
                        value: selectedCustomerId,
                        decoration: const InputDecoration(
                          labelText: '客户',
                          border: OutlineInputBorder(),
                        ),
                        options: [
                          const DropdownOption<int?>(
                            value: null,
                            label: '请选择客户',
                          ),
                          ...customers.map(
                            (customer) => DropdownOption<int?>(
                              value: customer.id,
                              label: customer.name,
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedCustomerId = value),
                        validator: (value) => value == null ? '请选择客户' : null,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      UnifiedDropdown<int?>(
                        value: selectedSalesOrderId,
                        decoration: const InputDecoration(
                          labelText: '关联客户订单（可选）',
                          border: OutlineInputBorder(),
                        ),
                        options: [
                          const DropdownOption<int?>(
                            value: null,
                            label: '不关联客户订单',
                          ),
                          ...salesOrders.map(
                            (order) => DropdownOption<int?>(
                              value: order.id,
                              label: order.orderNumber,
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedSalesOrderId = value),
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      UnifiedDropdown<int?>(
                        value: selectedInvoiceId,
                        decoration: const InputDecoration(
                          labelText: '关联发票（可选）',
                          border: OutlineInputBorder(),
                        ),
                        options: [
                          const DropdownOption<int?>(
                            value: null,
                            label: '不关联发票',
                          ),
                          ...invoices.map(
                            (invoice) => DropdownOption<int?>(
                              value: invoice.id,
                              label:
                                  invoice.invoiceNumber ?? '发票 #${invoice.id}',
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedInvoiceId = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LayoutTokens.gapLg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '收款信息',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.radioGroup(
                        label: '收款方式',
                        value: paymentMethod,
                        options: const [
                          CrudFieldOption<dynamic>(value: 'cash', label: '现金'),
                          CrudFieldOption<dynamic>(
                              value: 'transfer', label: '转账'),
                          CrudFieldOption<dynamic>(value: 'check', label: '支票'),
                          CrudFieldOption<dynamic>(
                            value: 'acceptance',
                            label: '承兑汇票',
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => paymentMethod = value as String),
                      ).build(context),
                      const SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: '收款金额',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? '请输入金额'
                                : null,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: paymentDateController,
                        decoration: const InputDecoration(
                          labelText: '收款日期（YYYY-MM-DD）',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: bankController,
                        decoration: const InputDecoration(
                          labelText: '收款账户（可选）',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: transactionController,
                        decoration: const InputDecoration(
                          labelText: '交易流水号（可选）',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
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
              ],
            ),
          );
        },
      ),
    );
    return result;
  } finally {
    amountController.dispose();
    paymentDateController.dispose();
    bankController.dispose();
    transactionController.dispose();
    notesController.dispose();
  }
}

String _paymentMethodLabel(String value) {
  switch (value) {
    case 'cash':
      return '现金';
    case 'check':
      return '支票';
    case 'acceptance':
      return '承兑汇票';
    case 'transfer':
    default:
      return '转账';
  }
}

class _PaymentSummaryItem extends StatelessWidget {
  const _PaymentSummaryItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: LayoutTokens.gapXxxs),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
