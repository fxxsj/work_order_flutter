import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_feedback.dart';

Future<void> showPurchaseLowStockDialog(
  BuildContext context, {
  required List<Map<String, dynamic>> materials,
  required VoidCallback onCreateOrder,
  String title = '库存不足预警',
  String closeText = '取消',
  String createText = '创建采购单',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => BaseDialog(
      title: title,
      maxWidth: 720,
      content: SizedBox(
        width: 720,
        child: materials.isEmpty
            ? const EmptyStateCard(
                icon: Icons.inventory_outlined,
                text: '暂无库存不足的物料',
              )
            : SizedBox(
                height: 360,
                child: ListView.separated(
                  itemCount: materials.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = materials[index];
                    final name = item['name']?.toString() ?? '-';
                    final code = item['code']?.toString() ?? '-';
                    final stock = item['stock_quantity']?.toString() ?? '-';
                    final minStock =
                        item['min_stock_quantity']?.toString() ?? '-';
                    final needed = item['needed_quantity']?.toString() ?? '-';
                    final supplier =
                        item['default_supplier__name']?.toString() ?? '-';
                    return Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$code $name',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                _InlineMeta(label: '当前库存', value: stock),
                                _InlineMeta(label: '最小库存', value: minStock),
                                _InlineMeta(label: '建议采购', value: needed),
                                _InlineMeta(label: '默认供应商', value: supplier),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(closeText),
        ),
        if (materials.isNotEmpty)
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onCreateOrder();
            },
            child: Text(createText),
          ),
      ],
    ),
  );
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
