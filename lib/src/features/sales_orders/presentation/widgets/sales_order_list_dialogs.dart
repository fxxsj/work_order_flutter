import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
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
            TextFormField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: '已付金额'),
            ),
            SizedBox(height: LayoutTokens.gapMd),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: '付款日期（YYYY-MM-DD）',
              ),
            ),
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
  final formKey = GlobalKey<FormState>();
  String priority = 'normal';
  final deliveryController = TextEditingController(text: initialDeliveryDate);
  final notesController = TextEditingController();
  final itemDrafts = orderItems
      .map((item) => _SalesOrderWorkOrderItemDraft.fromItem(item))
      .toList(growable: false);
  try {
    SalesOrderCreateWorkOrderResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return FormDialog(
            title: '生成施工单',
            formKey: formKey,
            submitText: '生成',
            maxWidth: LayoutTokens.dialogWidthLg,
            onSubmit: () async {
              final selectedItems = itemDrafts
                  .where((item) => item.selected)
                  .map(
                    (item) => SalesOrderWorkOrderSelection(
                      salesOrderItemId: item.salesOrderItemId,
                      productionQuantity:
                          int.tryParse(item.quantityController.text.trim()) ??
                              0,
                    ),
                  )
                  .toList(growable: false);
              if (selectedItems.isEmpty) {
                return;
              }
              result = SalesOrderCreateWorkOrderResult(
                priority: priority,
                deliveryDateText: deliveryController.text.trim(),
                notes: notesController.text.trim(),
                selectedItems: selectedItems,
              );
              Navigator.of(dialogContext).pop();
            },
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (itemDrafts.isEmpty)
                  const Text('订单暂无可生产的产品明细')
                else
                  _SalesOrderWorkOrderItemList(
                    items: itemDrafts,
                    onChanged: () => setState(() {}),
                  ),
                SizedBox(height: LayoutTokens.gapLg),
                TextFormField(
                  controller: deliveryController,
                  decoration: const InputDecoration(
                    labelText: '交货日期（YYYY-MM-DD，可选）',
                  ),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                SearchableDropdownButton(
                  value: priority,
                  onChanged: (value) => setState(() => priority = value),
                ),
                SizedBox(height: LayoutTokens.gapMd),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: '备注（可选）'),
                  maxLines: 3,
                ),
              ],
            ),
          );
        },
      ),
    );
    return result;
  } finally {
    deliveryController.dispose();
    notesController.dispose();
    for (final item in itemDrafts) {
      item.dispose();
    }
  }
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
              TextFormField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '人工完结原因',
                  hintText: '例如：客户确认尾差不再补发，按已交付数量结案',
                ),
                validator: (value) {
                  if (!requireReason) return null;
                  return (value?.trim().isEmpty ?? true) ? '请填写人工完结原因' : null;
                },
              ),
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

class SearchableDropdownButton extends StatelessWidget {
  const SearchableDropdownButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: '优先级'),
      items: const [
        DropdownMenuItem(value: 'low', child: Text('低')),
        DropdownMenuItem(value: 'normal', child: Text('普通')),
        DropdownMenuItem(value: 'high', child: Text('高')),
        DropdownMenuItem(value: 'urgent', child: Text('紧急')),
      ],
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
    );
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
                    TextFormField(
                      controller: item.quantityController,
                      enabled: item.selected,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '生产数量',
                        helperText: '建议按待交付数量填写，当前剩余 ${item.remainingQuantity}',
                      ),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
