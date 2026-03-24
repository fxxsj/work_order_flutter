import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
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
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          void submit() {
            if (!(formKey.currentState?.validate() ?? false)) return;
            final amount = double.tryParse(amountController.text.trim());
            if (amount == null || amount <= 0) return;
            if (selectedCustomerId == null) return;

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
            Navigator.of(dialogContext).pop();
          }

          return AlertDialog(
            title: const Text('新建收款'),
            content: SizedBox(
              width: 720,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          ...customers.map(
                            (customer) => DropdownMenuItem<int?>(
                              value: customer.id,
                              child: Text(customer.name),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedCustomerId = value),
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
                          ...salesOrders.map(
                            (order) => DropdownMenuItem<int?>(
                              value: order.id,
                              child: Text(order.orderNumber),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedSalesOrderId = value),
                      ),
                      const SizedBox(height: 12),
                      SearchableDropdownFormField<int?>(
                        initialValue: selectedInvoiceId,
                        decoration: const InputDecoration(
                          labelText: '关联发票（可选）',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('不关联发票'),
                          ),
                          ...invoices.map(
                            (invoice) => DropdownMenuItem<int?>(
                              value: invoice.id,
                              child: Text(
                                invoice.invoiceNumber ?? '发票 #${invoice.id}',
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedInvoiceId = value),
                      ),
                      const SizedBox(height: 12),
                      SearchableDropdownFormField<String>(
                        initialValue: paymentMethod,
                        decoration: const InputDecoration(
                          labelText: '收款方式',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'cash', child: Text('现金')),
                          DropdownMenuItem(
                              value: 'transfer', child: Text('转账')),
                          DropdownMenuItem(value: 'check', child: Text('支票')),
                          DropdownMenuItem(
                            value: 'acceptance',
                            child: Text('承兑汇票'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => paymentMethod = value ?? 'transfer'),
                      ),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: paymentDateController,
                        decoration: const InputDecoration(
                          labelText: '收款日期（YYYY-MM-DD）',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: bankController,
                        decoration: const InputDecoration(
                          labelText: '收款账户（可选）',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: transactionController,
                        decoration: const InputDecoration(
                          labelText: '交易流水号（可选）',
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
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: submit,
                child: const Text('创建'),
              ),
            ],
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
