import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

class StatementCreateResult {
  const StatementCreateResult({
    required this.payload,
  });

  final Map<String, dynamic> payload;
}

class StatementGenerateResult {
  const StatementGenerateResult({
    required this.params,
  });

  final Map<String, dynamic> params;
}

Future<StatementCreateResult?> showStatementCreateDialog(
  BuildContext context, {
  required List<Customer> customers,
  required List<Supplier> suppliers,
}) async {
  final formKey = GlobalKey<FormState>();
  final periodController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final openingBalanceController = TextEditingController(text: '0');
  final notesController = TextEditingController();
  String statementType = 'customer';
  int? selectedCustomerId;
  int? selectedSupplierId;
  try {
    StatementCreateResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final showCustomer = statementType == 'customer';

          void submit() {
            if (!(formKey.currentState?.validate() ?? false)) return;
            if (showCustomer && selectedCustomerId == null) return;
            if (!showCustomer && selectedSupplierId == null) return;
            final payload = <String, dynamic>{
              'statement_type': statementType,
              'period': periodController.text.trim(),
              'start_date': startDateController.text.trim(),
              'end_date': endDateController.text.trim(),
              'opening_balance':
                  double.tryParse(openingBalanceController.text.trim()) ?? 0,
              'notes': notesController.text.trim(),
            };
            if (showCustomer) {
              payload['customer'] = selectedCustomerId;
            } else {
              payload['supplier'] = selectedSupplierId;
            }
            result = StatementCreateResult(payload: payload);
            Navigator.of(dialogContext).pop();
          }

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
                      SearchableDropdownFormField<String>(
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
                        onChanged: (value) =>
                            setState(() => statementType = value ?? 'customer'),
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
                            ...customers.map(
                              (customer) => DropdownMenuItem<int?>(
                                value: customer.id,
                                child: Text(customer.name),
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedCustomerId = value),
                        ),
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
                            ...suppliers.map(
                              (supplier) => DropdownMenuItem<int?>(
                                value: supplier.id,
                                child: Text(supplier.name),
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedSupplierId = value),
                        ),
                      const SizedBox(height: 12),
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
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
    periodController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    openingBalanceController.dispose();
    notesController.dispose();
  }
}

Future<StatementGenerateResult?> showStatementGenerateDialog(
  BuildContext context, {
  required List<Customer> customers,
  required List<Supplier> suppliers,
}) async {
  final formKey = GlobalKey<FormState>();
  final periodController = TextEditingController();
  String statementType = 'customer';
  int? selectedCustomerId;
  int? selectedSupplierId;
  try {
    StatementGenerateResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final showCustomer = statementType == 'customer';

          void submit() {
            if (!(formKey.currentState?.validate() ?? false)) return;
            if (showCustomer && selectedCustomerId == null) return;
            if (!showCustomer && selectedSupplierId == null) return;
            final params = <String, dynamic>{
              'period': periodController.text.trim(),
            };
            if (showCustomer) {
              params['customer'] = selectedCustomerId;
            } else {
              params['supplier'] = selectedSupplierId;
            }
            result = StatementGenerateResult(params: params);
            Navigator.of(dialogContext).pop();
          }

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
                      SearchableDropdownFormField<String>(
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
                        onChanged: (value) =>
                            setState(() => statementType = value ?? 'customer'),
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
                            ...customers.map(
                              (customer) => DropdownMenuItem<int?>(
                                value: customer.id,
                                child: Text(customer.name),
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedCustomerId = value),
                        ),
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
                            ...suppliers.map(
                              (supplier) => DropdownMenuItem<int?>(
                                value: supplier.id,
                                child: Text(supplier.name),
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedSupplierId = value),
                        ),
                      const SizedBox(height: 12),
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
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: submit,
                child: const Text('生成'),
              ),
            ],
          );
        },
      ),
    );
    return result;
  } finally {
    periodController.dispose();
  }
}

Future<void> showStatementGeneratePreviewDialog(
  BuildContext context, {
  required Map<String, dynamic> result,
}) {
  final data = result['data'] is Map<String, dynamic>
      ? Map<String, dynamic>.from(result['data'])
      : result;
  final opening = data['opening_balance'] ?? '-';
  final debit = data['total_debit'] ?? '-';
  final credit = data['total_credit'] ?? '-';
  final closing = data['closing_balance'] ?? '-';
  return showDialog<void>(
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

Future<String?> showStatementConfirmDialog(
  BuildContext context, {
  required bool confirmed,
}) async {
  final notesController = TextEditingController();
  try {
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
    if (confirmedResult != true) return null;
    return notesController.text.trim();
  } finally {
    notesController.dispose();
  }
}
