import 'package:flutter/material.dart';

class ProductStockAdjustResult {
  const ProductStockAdjustResult({
    required this.adjustType,
    required this.quantity,
    required this.reason,
  });

  final String adjustType;
  final double quantity;
  final String reason;
}

Future<void> showProductStockListDialog(
  BuildContext context, {
  required String title,
  required Widget child,
  String closeText = '取消',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: SizedBox(width: 640, child: child),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(closeText),
        ),
      ],
    ),
  );
}

Future<void> showProductStockDetailDialog(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(child: child),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('取消'),
        ),
      ],
    ),
  );
}

Future<ProductStockAdjustResult?> showProductStockAdjustDialog(
  BuildContext context, {
  required String title,
  required String submitText,
  required String cancelText,
}) async {
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final reasonController = TextEditingController();
  String adjustType = 'add';
  bool submitting = false;
  try {
    ProductStockAdjustResult? result;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            void submit() {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final quantity = double.tryParse(quantityController.text.trim());
              if (quantity == null) return;
              result = ProductStockAdjustResult(
                adjustType: adjustType,
                quantity: quantity,
                reason: reasonController.text.trim(),
              );
              setState(() => submitting = true);
              Navigator.of(dialogContext).pop();
            }

            return AlertDialog(
              title: Text(title),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: adjustType,
                          decoration: const InputDecoration(labelText: '调整方式'),
                          items: const [
                            DropdownMenuItem(value: 'add', child: Text('增加库存')),
                            DropdownMenuItem(
                              value: 'subtract',
                              child: Text('减少库存'),
                            ),
                            DropdownMenuItem(value: 'set', child: Text('设定库存')),
                          ],
                          onChanged: submitting
                              ? null
                              : (value) {
                                  if (value == null) return;
                                  setState(() => adjustType = value);
                                },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: quantityController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(labelText: '调整数量'),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            final parsed = double.tryParse(text);
                            if (parsed == null) return '请输入有效数量';
                            if (adjustType == 'set' && parsed < 0) {
                              return '数量不能小于 0';
                            }
                            if (adjustType != 'set' && parsed <= 0) {
                              return '数量必须大于 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: reasonController,
                          maxLines: 3,
                          decoration: const InputDecoration(labelText: '调整原因'),
                          validator: (value) {
                            if ((value?.trim() ?? '').isEmpty) {
                              return '请输入调整原因';
                            }
                            return null;
                          },
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
                  child: Text(cancelText),
                ),
                FilledButton(
                  onPressed: submitting ? null : submit,
                  child: Text(submitting ? '提交中...' : submitText),
                ),
              ],
            );
          },
        );
      },
    );
    return result;
  } finally {
    quantityController.dispose();
    reasonController.dispose();
  }
}

class ProductStockDetailRow extends StatelessWidget {
  const ProductStockDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

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

class ProductStockInlineMeta extends StatelessWidget {
  const ProductStockInlineMeta({
    super.key,
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

class ProductStockFilterDrawerContent extends StatelessWidget {
  const ProductStockFilterDrawerContent({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}
