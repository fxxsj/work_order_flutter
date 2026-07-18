import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_date_picker.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
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
  var submitted = false;

  await showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: title,
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: _PurchaseReceivePanel(
      detail: detail,
      cancelText: cancelText,
      onSubmit: onSubmit,
      onSubmitted: () => submitted = true,
    ),
  );
  return submitted ? true : null;
}

class _PurchaseReceivePanel extends StatefulWidget {
  const _PurchaseReceivePanel({
    required this.detail,
    required this.cancelText,
    required this.onSubmit,
    required this.onSubmitted,
  });

  final PurchaseOrderDetail detail;
  final String cancelText;
  final Future<void> Function(PurchaseReceiveSubmission submission) onSubmit;
  final VoidCallback onSubmitted;

  @override
  State<_PurchaseReceivePanel> createState() => _PurchaseReceivePanelState();
}

class _PurchaseReceivePanelState extends State<_PurchaseReceivePanel> {
  final formKey = GlobalKey<FormState>();
  final deliveryNoteController = TextEditingController();
  late final List<_ReceiveItemDraft> items;
  DateTime? receivedDate = DateTime.now();
  bool submitting = false;
  String? quantityErrorText;

  @override
  void initState() {
    super.initState();
    items = widget.detail.items
        .map(
          (item) => _ReceiveItemDraft(
            itemId: item.id,
            materialName: item.materialName ?? '-',
            materialCode: item.materialCode ?? '-',
            materialSpecification: item.materialSpecification ?? '',
            quantity: item.quantity ?? 0,
            receivedQuantity: item.receivedQuantity ?? 0,
            remainingQuantity:
                item.remainingQuantity ??
                ((item.quantity ?? 0) - (item.receivedQuantity ?? 0)),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    deliveryNoteController.dispose();
    for (final item in items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = items
        .where((item) => item.receiveQuantity > 0)
        .toList();
    final totalQty = selectedItems.fold<double>(
      0,
      (sum, item) => sum + item.receiveQuantity,
    );
    final summaryText = selectedItems.isNotEmpty
        ? '本次收货 ${selectedItems.length} 种物料，共计 ${totalQty.toStringAsFixed(2)} 件'
        : '请输入本次收货数量';
    final supplier = _displayText(widget.detail.supplierName);
    final status = _displayText(
      widget.detail.statusDisplay ?? widget.detail.status,
    );
    final isCompact =
        ResponsiveLayout.isXs(context) || ResponsiveLayout.isSm(context);

    return AdaptiveFormPanel(
      formKey: formKey,
      submitText: '确认收货',
      cancelText: widget.cancelText,
      submitting: submitting,
      onSubmit: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('采购收货', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: SpacingTokens.xxs),
                Text(
                  '按采购明细逐行录入本次收货数量，系统会据此更新后续质检与库存流转。',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SpacingTokens.md),
                Wrap(
                  spacing: SpacingTokens.md,
                  runSpacing: SpacingTokens.sm,
                  children: [
                    _ReceiveSummaryItem(
                      label: '采购单号',
                      value: widget.detail.orderNumber,
                    ),
                    _ReceiveSummaryItem(label: '供应商', value: supplier),
                    _ReceiveSummaryItem(label: '状态', value: status),
                    _ReceiveSummaryItem(
                      label: '本次收货',
                      value: totalQty.toStringAsFixed(2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('收货信息', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: SpacingTokens.md),
                if (isCompact) ...[
                  _DateField(
                    label: '收货日期',
                    value: receivedDate,
                    onPicked: (picked) => setState(() => receivedDate = picked),
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  CrudFieldConfig.text(
                    label: '送货单号',
                    controller: deliveryNoteController,
                  ).build(context),
                ] else
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          label: '收货日期',
                          value: receivedDate,
                          onPicked: (picked) =>
                              setState(() => receivedDate = picked),
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.md),
                      Expanded(
                        child: CrudFieldConfig.text(
                          label: '送货单号',
                          controller: deliveryNoteController,
                        ).build(context),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('收货明细', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: SpacingTokens.xxxs),
                Text(
                  '已选择数量会用于生成本次收货提交。',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SpacingTokens.md),
                ...items.map(
                  (item) => _ReceiveItemRow(
                    item: item,
                    enabled: !submitting,
                    onChanged: () => setState(() => quantityErrorText = null),
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(summaryText, style: Theme.of(context).textTheme.bodySmall),
                if (quantityErrorText != null) ...[
                  const SizedBox(height: SpacingTokens.xxs),
                  Text(
                    quantityErrorText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
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
      setState(() => quantityErrorText = '请输入收货数量');
      return;
    }
    setState(() => submitting = true);
    try {
      await widget.onSubmit(
        PurchaseReceiveSubmission(
          receivedDate: receivedDate,
          deliveryNoteNumber: deliveryNoteController.text.trim(),
          items: payloadItems,
        ),
      );
      if (!mounted) return;
      widget.onSubmitted();
      Navigator.of(context).maybePop(true);
    } finally {
      if (mounted) {
        setState(() => submitting = false);
      }
    }
  }
}

class _ReceiveItemDraft {
  _ReceiveItemDraft({
    required this.itemId,
    required this.materialName,
    required this.materialCode,
    required this.materialSpecification,
    required this.quantity,
    required this.receivedQuantity,
    required this.remainingQuantity,
  }) : receiveController = TextEditingController(text: '0'),
       notesController = TextEditingController();

  final int itemId;
  final String materialName;
  final String materialCode;
  final String materialSpecification;
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

class _ReceiveSummaryItem extends StatelessWidget {
  const _ReceiveSummaryItem({required this.label, required this.value});

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
        const SizedBox(height: SpacingTokens.xxxs),
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
    final isCompact =
        ResponsiveLayout.isXs(context) || ResponsiveLayout.isSm(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: AppCard(
        padding: const EdgeInsets.all(LayoutTokens.cardPaddingSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.materialCode} ${item.materialName}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: SpacingTokens.xxs),
            Text(
              '规格：${item.materialSpecification.trim().isEmpty ? '未填写' : item.materialSpecification}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: SpacingTokens.xxs),
            Wrap(
              spacing: SpacingTokens.md,
              runSpacing: SpacingTokens.xs,
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
            const SizedBox(height: SpacingTokens.sm),
            if (isCompact)
              Column(
                children: [
                  CrudFieldConfig.number(
                    label: '本次收货',
                    controller: item.receiveController,
                    enabled: !isDisabled,
                    decimal: true,
                    isDense: true,
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
                  ).build(context),
                  const SizedBox(height: SpacingTokens.sm),
                  CrudFieldConfig.text(
                    label: '备注',
                    controller: item.notesController,
                    enabled: !isDisabled,
                    isDense: true,
                  ).build(context),
                ],
              )
            else
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: CrudFieldConfig.number(
                      label: '本次收货',
                      controller: item.receiveController,
                      enabled: !isDisabled,
                      decimal: true,
                      isDense: true,
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
                    ).build(context),
                  ),
                  const SizedBox(width: SpacingTokens.md),
                  Expanded(
                    child: CrudFieldConfig.text(
                      label: '备注',
                      controller: item.notesController,
                      enabled: !isDisabled,
                      isDense: true,
                    ).build(context),
                  ),
                ],
              ),
          ],
        ),
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
    final text = _formatDate(value);
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showAppDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 5),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.date_range_outlined),
        ),
        isEmpty: text.isEmpty,
        child: Text(
          text.isEmpty ? '请选择日期' : text,
          style: text.isEmpty
              ? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
              : theme.textTheme.bodyMedium,
        ),
      ),
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
