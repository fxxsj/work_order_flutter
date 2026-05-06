import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';

class SalesOrderPaymentUpdateResult {
  const SalesOrderPaymentUpdateResult({
    required this.amountText,
    required this.dateText,
  });

  final String amountText;
  final String dateText;
}

class SalesOrderCreateWorkOrderResult {
  const SalesOrderCreateWorkOrderResult({
    required this.priority,
    required this.deliveryDateText,
    required this.notes,
    required this.selectedItems,
  });

  final String priority;
  final String deliveryDateText;
  final String notes;
  final List<SalesOrderWorkOrderSelection> selectedItems;
}

class SalesOrderBatchCreateWorkOrderResult {
  const SalesOrderBatchCreateWorkOrderResult({
    required this.priority,
    required this.deliveryDateText,
    required this.notes,
  });

  final String priority;
  final String deliveryDateText;
  final String notes;
}

class SalesOrderWorkOrderSelection {
  const SalesOrderWorkOrderSelection({
    required this.salesOrderItemId,
    required this.productionQuantity,
  });

  final int salesOrderItemId;
  final int productionQuantity;
}

class SalesOrderCompleteResult {
  const SalesOrderCompleteResult({
    required this.completionReason,
  });

  final String completionReason;
}

Future<SalesOrderPaymentUpdateResult?> showSalesOrderPaymentDialog(
  BuildContext context, {
  String initialAmountText = '',
  String initialDateText = '',
}) async {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController(text: initialAmountText);
  final dateController = TextEditingController(text: initialDateText);
  try {
    SalesOrderPaymentUpdateResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => FormDialog(
        title: '更新付款信息',
        formKey: formKey,
        submitText: '更新',
        maxWidth: LayoutTokens.dialogWidthSm,
        onSubmit: () async {
          result = SalesOrderPaymentUpdateResult(
            amountText: amountController.text.trim(),
            dateText: dateController.text.trim(),
          );
          Navigator.of(dialogContext).pop();
        },
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CrudFormField.number(
              label: '已付金额',
              controller: amountController,
              decimal: true,
            ).build(dialogContext),
            SizedBox(height: LayoutTokens.gapMd),
            CrudFormField.text(
              label: '付款日期（YYYY-MM-DD）',
              controller: dateController,
            ).build(dialogContext),
          ],
        ),
      ),
    );
    return result;
  } finally {
    amountController.dispose();
    dateController.dispose();
  }
}

Future<SalesOrderCreateWorkOrderResult?> showSalesOrderCreateWorkOrderDialog(
  BuildContext context, {
  required String initialDeliveryDate,
  required List<SalesOrderItem> orderItems,
}) async {
  SalesOrderCreateWorkOrderResult? result;
  await showAdaptiveFilterDrawer(
    context,
    isMobile: BreakpointsUtil.isMobile(context),
    title: '生成施工单',
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: _SalesOrderCreateWorkOrderPanel(
      initialDeliveryDate: initialDeliveryDate,
      orderItems: orderItems,
      onSubmit: (value) {
        result = value;
        Navigator.of(context).maybePop();
      },
    ),
  );
  return result;
}

Future<SalesOrderCompleteResult?> showSalesOrderCompleteDialog(
  BuildContext context, {
  required bool requireReason,
}) async {
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  try {
    SalesOrderCompleteResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => FormDialog(
        title: '完成订单',
        formKey: formKey,
        submitText: '完成',
        maxWidth: LayoutTokens.dialogWidthSm,
        onSubmit: () async {
          result = SalesOrderCompleteResult(
            completionReason: reasonController.text.trim(),
          );
          Navigator.of(dialogContext).pop();
        },
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              requireReason
                  ? '当前订单尚未全部发货。若业务决定先关闭订单，请填写人工完结原因。'
                  : '确认标记该订单为已完成吗？',
            ),
            if (requireReason) ...[
              SizedBox(height: LayoutTokens.gapMd),
              CrudFormField.textarea(
                label: '人工完结原因',
                controller: reasonController,
                maxLines: 3,
                hintText: '例如：客户确认尾差不再补发，按已交付数量结案',
                validator: (value) {
                  if (!requireReason) return null;
                  return (value?.trim().isEmpty ?? true) ? '请填写人工完结原因' : null;
                },
              ).build(dialogContext),
            ],
          ],
        ),
      ),
    );
    return result;
  } finally {
    reasonController.dispose();
  }
}

Future<bool> showSalesOrderNavigateToWorkOrderDialog(
  BuildContext context,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => BaseDialog(
      title: '查看施工单',
      maxWidth: LayoutTokens.dialogWidthXs,
      scrollable: false,
      content: const Text('施工单已生成，是否立即查看？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('稍后'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('查看'),
        ),
      ],
    ),
  );
  return confirmed == true;
}

Future<SalesOrderBatchCreateWorkOrderResult?>
    showSalesOrderBatchCreateWorkOrdersDialog(
  BuildContext context, {
  required int selectedCount,
}) async {
  final formKey = GlobalKey<FormState>();
  final deliveryController = TextEditingController();
  final notesController = TextEditingController();
  String priority = 'normal';

  try {
    SalesOrderBatchCreateWorkOrderResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => FormDialog(
          title: '批量生成施工单',
          formKey: formKey,
          submitText: '开始生成',
          maxWidth: LayoutTokens.dialogWidthSm,
          onSubmit: () async {
            result = SalesOrderBatchCreateWorkOrderResult(
              priority: priority,
              deliveryDateText: deliveryController.text.trim(),
              notes: notesController.text.trim(),
            );
            Navigator.of(dialogContext).pop();
          },
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('将为已选择的 $selectedCount 张客户订单批量生成施工单。'),
              SizedBox(height: LayoutTokens.gapMd),
              CrudFormField.text(
                label: '统一交货日期（YYYY-MM-DD，可选）',
                controller: deliveryController,
              ).build(dialogContext),
              SizedBox(height: LayoutTokens.gapMd),
              UnifiedDropdown<String>(
                decoration: const InputDecoration(labelText: '统一优先级'),
                value: priority,
                options: const [
                  DropdownOption(value: 'low', label: '低'),
                  DropdownOption(value: 'normal', label: '普通'),
                  DropdownOption(value: 'high', label: '高'),
                  DropdownOption(value: 'urgent', label: '紧急'),
                ],
                onChanged: (value) =>
                    setState(() => priority = value ?? 'normal'),
              ),
              SizedBox(height: LayoutTokens.gapMd),
              CrudFormField.textarea(
                label: '备注（可选）',
                controller: notesController,
                maxLines: 4,
                hintText: '补充本次批量排产的统一说明',
              ).build(dialogContext),
            ],
          ),
        ),
      ),
    );
    return result;
  } finally {
    deliveryController.dispose();
    notesController.dispose();
  }
}

class _SalesOrderWorkOrderItemDraft {
  _SalesOrderWorkOrderItemDraft({
    required this.salesOrderItemId,
    required this.productName,
    required this.productCode,
    required this.orderedQuantity,
    required this.deliveredQuantity,
    required int initialQuantity,
  }) : quantityController =
            TextEditingController(text: initialQuantity.toString());

  factory _SalesOrderWorkOrderItemDraft.fromItem(SalesOrderItem item) {
    final orderedQuantity = item.quantity ?? 0;
    final deliveredQuantity = item.deliveredQuantity ?? 0;
    final remainingQuantity =
        (orderedQuantity - deliveredQuantity).clamp(0, orderedQuantity);
    return _SalesOrderWorkOrderItemDraft(
      salesOrderItemId: item.id,
      productName: item.productName ?? '-',
      productCode: item.productCode ?? '',
      orderedQuantity: orderedQuantity,
      deliveredQuantity: deliveredQuantity,
      initialQuantity: remainingQuantity.round(),
    );
  }

  final int salesOrderItemId;
  final String productName;
  final String productCode;
  final int orderedQuantity;
  final double deliveredQuantity;
  bool selected = false;
  final TextEditingController quantityController;

  int get remainingQuantity =>
      (orderedQuantity - deliveredQuantity).clamp(0, orderedQuantity).round();

  void dispose() {
    quantityController.dispose();
  }
}

class _SalesOrderWorkOrderItemList extends StatelessWidget {
  const _SalesOrderWorkOrderItemList({
    required this.items,
    required this.onChanged,
  });

  final List<_SalesOrderWorkOrderItemDraft> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: LayoutTokens.gapMd),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
              ),
              child: Padding(
                padding: const EdgeInsets.all(LayoutTokens.gapLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: item.selected,
                      onChanged: (value) {
                        item.selected = value ?? false;
                        onChanged();
                      },
                      title: Text(item.productName),
                      subtitle: Text(
                        item.productCode.trim().isEmpty
                            ? '订单数量 ${item.orderedQuantity}，已发货 ${item.deliveredQuantity}'
                            : '${item.productCode} · 订单数量 ${item.orderedQuantity}，已发货 ${item.deliveredQuantity}',
                      ),
                    ),
                    CrudFormField.number(
                      label: '生产数量',
                      controller: item.quantityController,
                      enabled: item.selected,
                      helperText: '建议按待交付数量填写，当前剩余 ${item.remainingQuantity}',
                      validator: (_) {
                        if (!item.selected) return null;
                        final value =
                            int.tryParse(item.quantityController.text.trim());
                        if (value == null || value <= 0) {
                          return '请输入正确的生产数量';
                        }
                        if (value > item.remainingQuantity) {
                          return '不能超过待交付数量 ${item.remainingQuantity}';
                        }
                        return null;
                      },
                    ).build(context),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SalesOrderCreateWorkOrderPanel extends StatefulWidget {
  const _SalesOrderCreateWorkOrderPanel({
    required this.initialDeliveryDate,
    required this.orderItems,
    required this.onSubmit,
  });

  final String initialDeliveryDate;
  final List<SalesOrderItem> orderItems;
  final ValueChanged<SalesOrderCreateWorkOrderResult> onSubmit;

  @override
  State<_SalesOrderCreateWorkOrderPanel> createState() =>
      _SalesOrderCreateWorkOrderPanelState();
}

class _SalesOrderCreateWorkOrderPanelState
    extends State<_SalesOrderCreateWorkOrderPanel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _deliveryController;
  late final TextEditingController _notesController;
  late final List<_SalesOrderWorkOrderItemDraft> _itemDrafts;
  String _priority = 'normal';

  @override
  void initState() {
    super.initState();
    _deliveryController =
        TextEditingController(text: widget.initialDeliveryDate);
    _notesController = TextEditingController();
    _itemDrafts = widget.orderItems
        .map((item) => _SalesOrderWorkOrderItemDraft.fromItem(item))
        .toList(growable: false);
  }

  @override
  void dispose() {
    _deliveryController.dispose();
    _notesController.dispose();
    for (final item in _itemDrafts) {
      item.dispose();
    }
    super.dispose();
  }

  int get _selectedCount => _itemDrafts.where((item) => item.selected).length;

  int get _selectedQuantity => _itemDrafts.where((item) => item.selected).fold(
        0,
        (total, item) =>
            total + (int.tryParse(item.quantityController.text.trim()) ?? 0),
      );

  int get _remainingQuantity => _itemDrafts.fold(
        0,
        (total, item) => total + item.remainingQuantity,
      );

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final selectedItems = _itemDrafts
        .where((item) => item.selected)
        .map(
          (item) => SalesOrderWorkOrderSelection(
            salesOrderItemId: item.salesOrderItemId,
            productionQuantity:
                int.tryParse(item.quantityController.text.trim()) ?? 0,
          ),
        )
        .toList(growable: false);
    if (selectedItems.isEmpty) {
      ToastUtil.showError('请至少选择一个需要转施工单的订单产品');
      return;
    }
    widget.onSubmit(
      SalesOrderCreateWorkOrderResult(
        priority: _priority,
        deliveryDateText: _deliveryController.text.trim(),
        notes: _notesController.text.trim(),
        selectedItems: selectedItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = LayoutTokens.formSectionSpacing(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                LayoutTokens.gapLg,
                LayoutTokens.gapMd,
                LayoutTokens.gapLg,
                LayoutTokens.gapLg,
              ),
              children: [
                _SalesOrderWorkOrderSummaryCard(
                  selectedCount: _selectedCount,
                  selectedQuantity: _selectedQuantity,
                  remainingQuantity: _remainingQuantity,
                ),
                SizedBox(height: spacing),
                AppCard(
                  shadowLevel: ShadowLevel.sm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '选择转入施工单的订单产品',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: LayoutTokens.gapXs),
                      Text(
                        '按实际排产需要选择产品。库存充足的产品可直接发货，不必强制生成施工单。',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: spacing),
                      if (_itemDrafts.isEmpty)
                        const Text('订单暂无可生产的产品明细')
                      else
                        _SalesOrderWorkOrderItemList(
                          items: _itemDrafts,
                          onChanged: () => setState(() {}),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: spacing),
                AppCard(
                  shadowLevel: ShadowLevel.sm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '生产参数',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: spacing),
                      CrudFormField.text(
                        label: '交货日期（YYYY-MM-DD，可选）',
                        controller: _deliveryController,
                      ).build(context),
                      SizedBox(height: LayoutTokens.gapMd),
                      UnifiedDropdown<String>(
                        decoration: const InputDecoration(labelText: '优先级'),
                        value: _priority,
                        options: const [
                          DropdownOption(value: 'low', label: '低'),
                          DropdownOption(value: 'normal', label: '普通'),
                          DropdownOption(value: 'high', label: '高'),
                          DropdownOption(value: 'urgent', label: '紧急'),
                        ],
                        onChanged: (value) =>
                            setState(() => _priority = value ?? 'normal'),
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      CrudFormField.textarea(
                        label: '备注（可选）',
                        controller: _notesController,
                        maxLines: 4,
                        hintText: '补充说明本次排产、拼版或图稿要求',
                      ).build(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LayoutTokens.gapLg,
              LayoutTokens.gapMd,
              LayoutTokens.gapLg,
              LayoutTokens.gapLg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedCount == 0
                        ? '请选择需要转施工单的产品'
                        : '已选择 $_selectedCount 个产品，计划生产 $_selectedQuantity',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('取消'),
                ),
                SizedBox(width: LayoutTokens.gapSm),
                FilledButton(
                  onPressed: _submit,
                  child: const Text('生成施工单'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesOrderWorkOrderSummaryCard extends StatelessWidget {
  const _SalesOrderWorkOrderSummaryCard({
    required this.selectedCount,
    required this.selectedQuantity,
    required this.remainingQuantity,
  });

  final int selectedCount;
  final int selectedQuantity;
  final int remainingQuantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      shadowLevel: ShadowLevel.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '排产摘要',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: LayoutTokens.gapSm,
            runSpacing: LayoutTokens.gapSm,
            children: [
              _SummaryChip(label: '已选产品', value: '$selectedCount 项'),
              _SummaryChip(label: '计划生产', value: '$selectedQuantity'),
              _SummaryChip(label: '待交付总量', value: '$remainingQuantity'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LayoutTokens.gapMd,
        vertical: LayoutTokens.gapSm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
                text: '$label ',
                style: const TextStyle(fontWeight: FontWeight.w500)),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
