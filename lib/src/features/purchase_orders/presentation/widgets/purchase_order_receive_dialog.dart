import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_order_detail.dart';

class PurchaseReceiveSubmission {
  const PurchaseReceiveSubmission({
    required this.receivedDate,
    required this.deliveryNoteNumber,
    required this.items,
  });

  final DateTime? receivedDate;
  final String deliveryNoteNumber;
  final List<PurchaseReceiveSubmissionItem> items;
}

class PurchaseReceiveSubmissionItem {
  const PurchaseReceiveSubmissionItem({
    required this.itemId,
    required this.receivedQuantity,
    required this.notes,
  });

  final int itemId;
  final double receivedQuantity;
  final String notes;
}

Future<bool?> showPurchaseReceiveDialog(
  BuildContext context, {
  required PurchaseOrderDetail detail,
  required Future<void> Function(PurchaseReceiveSubmission submission) onSubmit,
  String title = '采购收货',
  String cancelText = '取消',
}) async {
  final receivedDate = ValueNotifier<DateTime?>(DateTime.now());
  final deliveryNoteController = TextEditingController();
  final items = detail.items
      .map(
        (item) => _ReceiveItemDraft(
          itemId: item.id,
          materialName: item.materialName ?? '-',
          materialCode: item.materialCode ?? '-',
          quantity: item.quantity ?? 0,
          receivedQuantity: item.receivedQuantity ?? 0,
          remainingQuantity: item.remainingQuantity ??
              ((item.quantity ?? 0) - (item.receivedQuantity ?? 0)),
        ),
      )
      .toList();

  bool submitting = false;
  final formKey = GlobalKey<FormState>();

  try {
    return await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final selectedItems =
                items.where((item) => item.receiveQuantity > 0).toList();
            final hasReceiveItems = selectedItems.isNotEmpty;
            final totalQty = selectedItems.fold<double>(
              0,
              (sum, item) => sum + item.receiveQuantity,
            );
            final summaryText = hasReceiveItems
                ? '本次收货 ${selectedItems.length} 种物料，共计 ${totalQty.toStringAsFixed(2)} 件'
                : '请输入本次收货数量';

            Future<void> submit() async {
              if (!(formKey.currentState?.validate() ?? false)) {
                return;
              }
              final payloadItems = items
                  .where((item) => item.receiveQuantity > 0)
                  .map(
                    (item) => PurchaseReceiveSubmissionItem(
                      itemId: item.itemId,
                      receivedQuantity: item.receiveQuantity,
                      notes: item.notes,
                    ),
                  )
                  .toList();
              if (payloadItems.isEmpty) {
                throw const FormatException('请输入收货数量');
              }
              setState(() => submitting = true);
              try {
                await onSubmit(
                  PurchaseReceiveSubmission(
                    receivedDate: receivedDate.value,
                    deliveryNoteNumber: deliveryNoteController.text.trim(),
                    items: payloadItems,
                  ),
                );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(true);
                }
              } finally {
                if (dialogContext.mounted) {
                  setState(() => submitting = false);
                }
              }
            }

            return FormDialog(
              title: title,
              formKey: formKey,
              submitText: '确认收货',
              cancelText: cancelText,
              submitting: submitting,
              maxWidth: LayoutTokens.pageWidthXwide,
              onSubmit: submit,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: '采购单号', value: detail.orderNumber),
                  _DetailRow(
                    label: '供应商',
                    value: _displayText(detail.supplierName),
                  ),
                  _DetailRow(
                    label: '状态',
                    value: _displayText(detail.statusDisplay ?? detail.status),
                  ),
                  const SizedBox(height: LayoutTokens.gapSm),
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          label: '收货日期',
                          value: receivedDate.value,
                          onPicked: (picked) =>
                              setState(() => receivedDate.value = picked),
                        ),
                      ),
                      const SizedBox(width: LayoutTokens.gapMd),
                      Expanded(
                        child: TextFormField(
                          controller: deliveryNoteController,
                          decoration: const InputDecoration(
                            labelText: '送货单号',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: LayoutTokens.gapMd),
                  ...items.map(
                    (item) => _ReceiveItemRow(
                      item: item,
                      enabled: !submitting,
                      onChanged: () => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: LayoutTokens.gapSm),
                  Text(
                    summaryText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  } finally {
    deliveryNoteController.dispose();
    receivedDate.dispose();
    for (final item in items) {
      item.dispose();
    }
  }
}

class _ReceiveItemDraft {
  _ReceiveItemDraft({
    required this.itemId,
    required this.materialName,
    required this.materialCode,
    required this.quantity,
    required this.receivedQuantity,
    required this.remainingQuantity,
  })  : receiveController = TextEditingController(text: '0'),
        notesController = TextEditingController();

  final int itemId;
  final String materialName;
  final String materialCode;
  final double quantity;
  final double receivedQuantity;
  final double remainingQuantity;
  final TextEditingController receiveController;
  final TextEditingController notesController;

  double get receiveQuantity =>
      double.tryParse(receiveController.text.trim()) ?? 0;
  String get notes => notesController.text.trim();

  void dispose() {
    receiveController.dispose();
    notesController.dispose();
  }
}

class _ReceiveItemRow extends StatelessWidget {
  const _ReceiveItemRow({
    required this.item,
    required this.enabled,
    this.onChanged,
  });

  final _ReceiveItemDraft item;
  final bool enabled;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || item.remainingQuantity <= 0;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: LayoutTokens.gapSm),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(LayoutTokens.cardPaddingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.materialCode} ${item.materialName}',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: LayoutTokens.gapXxs),
              Wrap(
                spacing: LayoutTokens.gapMd,
                runSpacing: LayoutTokens.gapXs,
                children: [
                  _InlineMeta(
                    label: '采购数量',
                    value: item.quantity.toStringAsFixed(2),
                  ),
                  _InlineMeta(
                    label: '已收货',
                    value: item.receivedQuantity.toStringAsFixed(2),
                  ),
                  _InlineMeta(
                    label: '剩余',
                    value: item.remainingQuantity.toStringAsFixed(2),
                    valueColor: item.remainingQuantity > 0
                        ? theme.colorScheme.error
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: LayoutTokens.gapSm),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: item.receiveController,
                      enabled: !isDisabled,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: '本次收货',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => onChanged?.call(),
                      validator: (value) {
                        if (isDisabled) {
                          return null;
                        }
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed < 0) {
                          return '无效';
                        }
                        if (parsed > item.remainingQuantity) {
                          return '最多${item.remainingQuantity.toStringAsFixed(2)}';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapMd),
                  Expanded(
                    child: TextFormField(
                      controller: item.notesController,
                      enabled: !isDisabled,
                      decoration: const InputDecoration(
                        labelText: '备注',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: _formatDate(value));
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.date_range_outlined),
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 5),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

String _displayText(String? value) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? '-' : text;
}
