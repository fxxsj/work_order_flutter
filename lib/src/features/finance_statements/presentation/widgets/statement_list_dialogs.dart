import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/action_decision_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
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
    await showAdaptiveFilterDrawer(
      context,
      isMobile: BreakpointsUtil.isMobile(context),
      title: '新建对账单',
      desktopWidth: LayoutTokens.dialogWidthLg,
      child: StatefulBuilder(
        builder: (context, setState) {
          final showCustomer = statementType == 'customer';

          Future<void> submit() async {
            if (!(formKey.currentState?.validate() ?? false)) return;
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
                        '基础信息',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.radioGroup(
                        label: '对账单类型',
                        value: statementType,
                        options: const [
                          CrudFieldOption<dynamic>(
                            value: 'customer',
                            label: '客户对账单',
                          ),
                          CrudFieldOption<dynamic>(
                            value: 'supplier',
                            label: '供应商对账单',
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => statementType = value as String),
                      ).build(context),
                      const SizedBox(height: LayoutTokens.gapMd),
                      if (showCustomer)
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
                      if (!showCustomer)
                        UnifiedDropdown<int?>(
                          value: selectedSupplierId,
                          decoration: const InputDecoration(
                            labelText: '供应商',
                            border: OutlineInputBorder(),
                          ),
                          options: [
                            const DropdownOption<int?>(
                              value: null,
                              label: '请选择供应商',
                            ),
                            ...suppliers.map(
                              (supplier) => DropdownOption<int?>(
                                value: supplier.id,
                                label: supplier.name,
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => selectedSupplierId = value),
                          validator: (value) => value == null ? '请选择供应商' : null,
                        ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.text(
                        label: '对账周期（YYYY-MM）',
                        controller: periodController,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? '请输入对账周期'
                                : null,
                      ).build(context),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.dateRange(
                        label: '对账日期范围',
                        startController: startDateController,
                        endController: endDateController,
                        hintText: '请选择开始和结束日期',
                        helperText: '会自动回填开始日期和结束日期',
                        validator: (range) =>
                            range == null ? '请选择对账日期范围' : null,
                      ).build(context),
                    ],
                  ),
                ),
                const SizedBox(height: LayoutTokens.gapLg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '补充信息',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.number(
                        label: '期初余额',
                        controller: openingBalanceController,
                        decimal: true,
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

          Future<void> submit() async {
            if (!(formKey.currentState?.validate() ?? false)) return;
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

          return FormDialog(
            title: '生成对账数据',
            formKey: formKey,
            onSubmit: submit,
            submitText: '生成',
            maxWidth: 640,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CrudFormField.radioGroup(
                  label: '对账单类型',
                  value: statementType,
                  options: const [
                    CrudFieldOption<dynamic>(
                      value: 'customer',
                      label: '客户对账单',
                    ),
                    CrudFieldOption<dynamic>(
                      value: 'supplier',
                      label: '供应商对账单',
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => statementType = value as String),
                ).build(context),
                SizedBox(height: LayoutTokens.gapMd),
                if (showCustomer)
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
                if (!showCustomer)
                  UnifiedDropdown<int?>(
                    value: selectedSupplierId,
                    decoration: const InputDecoration(
                      labelText: '供应商',
                      border: OutlineInputBorder(),
                    ),
                    options: [
                      const DropdownOption<int?>(
                        value: null,
                        label: '请选择供应商',
                      ),
                      ...suppliers.map(
                        (supplier) => DropdownOption<int?>(
                          value: supplier.id,
                          label: supplier.name,
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => selectedSupplierId = value),
                    validator: (value) => value == null ? '请选择供应商' : null,
                  ),
                SizedBox(height: LayoutTokens.gapMd),
                CrudFormField.text(
                  label: '对账周期（YYYY-MM）',
                  controller: periodController,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? '请输入对账周期'
                      : null,
                ).build(context),
              ],
            ),
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
    builder: (context) => BaseDialog(
      title: '对账数据预览',
      scrollable: false,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('知道了'),
        ),
      ],
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
    ),
  );
}

Future<String?> showStatementConfirmDialog(
  BuildContext context, {
  required bool confirmed,
}) async {
  final result = await showActionDecisionDialog<void>(
    context,
    title: confirmed ? '确认对账单' : '标记为有异议',
    summary: confirmed
        ? '确认后，这张对账单会作为当前往来结论进入后续财务跟进。'
        : '标记为有异议后，这张对账单需要重新核差，相关收款或付款判断应暂缓。',
    impacts: confirmed
        ? const [
            '请先确认期初、借贷方和期末余额已核对完成',
            '错误确认会影响后续收付款和经营分析',
          ]
        : const [
            '请在备注中写清差异原因和下一步责任人',
            '如果只是待补资料，建议说明预计补齐时间',
          ],
    auditHint: confirmed ? '确认说明可作为后续财务追踪依据。' : '异议说明会保留在审计与对账处理记录中。',
    destructive: !confirmed,
    notesLabel: confirmed ? '确认说明（可选）' : '异议说明（可选）',
    notesMaxLines: 3,
    submitText: confirmed ? '确认' : '提交',
  );
  return result?.notes;
}
