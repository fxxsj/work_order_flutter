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
                      CrudFormField.number(
                        label: '收款金额',
                        controller: amountController,
                        decimal: true,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? '请输入金额'
                                : null,
                      ).build(context),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.text(
                        label: '收款日期（YYYY-MM-DD）',
                        controller: paymentDateController,
                      ).build(context),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.text(
                        label: '收款账户（可选）',
                        controller: bankController,
                      ).build(context),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.text(
                        label: '交易流水号（可选）',
                        controller: transactionController,
                      ).build(context),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.textarea(
                        label: '备注（可选）',
                        controller: notesController,
                        maxLines: 3,
                      ).build(context),
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
