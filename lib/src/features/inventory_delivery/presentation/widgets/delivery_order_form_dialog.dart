import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

typedef DeliverySalesOrderChanged = Future<void> Function(
  int id, {
  StateSetter? setState,
});

typedef DeliveryFormSubmit = Future<void> Function(StateSetter setState);

Future<void> showDeliveryOrderFormDialog(
  BuildContext context, {
  required bool isEdit,
  required String title,
  required String cancelText,
  required String submitText,
  required bool productsLoading,
  required GlobalKey<FormState> formKey,
  required List<SalesOrderDto> salesOrders,
  required List<ProductOption> products,
  required int? selectedSalesOrderId,
  required DateTime? deliveryDate,
  required TextEditingController receiverNameController,
  required TextEditingController receiverPhoneController,
  required TextEditingController addressController,
  required TextEditingController logisticsController,
  required TextEditingController trackingController,
  required TextEditingController freightController,
  required TextEditingController packageCountController,
  required TextEditingController packageWeightController,
  required TextEditingController notesController,
  required List<DeliveryItemDraft> items,
  required DeliverySalesOrderChanged onSalesOrderChanged,
  required ValueChanged<DateTime> onDatePicked,
  required DeliveryFormSubmit onSubmit,
}) {
  bool submitting = false;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> submit() async {
            if (submitting) return;
            setState(() => submitting = true);
            await onSubmit(setState);
            if (dialogContext.mounted) {
              setState(() => submitting = false);
            }
          }

          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 720,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isEdit)
                        SearchableDropdownFormField<int>(
                          key: ValueKey<int?>(selectedSalesOrderId),
                          initialValue: selectedSalesOrderId,
                          decoration: const InputDecoration(
                            labelText: '客户订单',
                            border: OutlineInputBorder(),
                          ),
                          items: salesOrders
                              .map(
                                (order) => DropdownMenuItem(
                                  value: order.id,
                                  child: Text(order.orderNumber),
                                ),
                              )
                              .toList(),
                          onChanged: submitting
                              ? null
                              : (value) {
                                  if (value == null) return;
                                  onSalesOrderChanged(value,
                                      setState: setState);
                                },
                          validator: (value) {
                            if (!isEdit && (value == null || value == 0)) {
                              return '请选择客户订单';
                            }
                            return null;
                          },
                        ),
                      if (!isEdit) SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: receiverNameController,
                        decoration: const InputDecoration(
                          labelText: '收货人',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            (value?.trim().isEmpty ?? true) ? '请输入收货人' : null,
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: receiverPhoneController,
                        decoration: const InputDecoration(
                          labelText: '联系电话',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            (value?.trim().isEmpty ?? true) ? '请输入联系电话' : null,
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: '送货地址',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            (value?.trim().isEmpty ?? true) ? '请输入送货地址' : null,
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      DeliveryDateField(
                        label: '发货日期',
                        value: deliveryDate,
                        onPicked: onDatePicked,
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: logisticsController,
                        decoration: const InputDecoration(
                          labelText: '物流公司',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: trackingController,
                        decoration: const InputDecoration(
                          labelText: '物流单号',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: freightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: const InputDecoration(
                                labelText: '运费',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: LayoutTokens.gapMd),
                          Expanded(
                            child: TextFormField(
                              controller: packageCountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: '包裹数',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: LayoutTokens.gapMd),
                          Expanded(
                            child: TextFormField(
                              controller: packageWeightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: const InputDecoration(
                                labelText: '总重量(kg)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: LayoutTokens.gapMd),
                      TextFormField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: '备注',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: LayoutTokens.gapLg),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '发货明细',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: submitting || productsLoading
                                ? null
                                : () {
                                    setState(() {
                                      items.add(
                                        DeliveryItemDraft(
                                          productId: 0,
                                          productName: '-',
                                          maxQuantity: 0,
                                          initialQuantity: 1,
                                        ),
                                      );
                                    });
                                  },
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('添加明细'),
                          ),
                        ],
                      ),
                      SizedBox(height: LayoutTokens.gapSm),
                      if (items.isEmpty)
                        const Text('暂无明细')
                      else
                        Column(
                          children: items
                              .map(
                                (item) => DeliveryItemRow(
                                  item: item,
                                  enabled: !submitting,
                                  products: products,
                                  onRemove: () {
                                    setState(() {
                                      items.remove(item);
                                      item.dispose();
                                    });
                                  },
                                  onProductChanged: (product) {
                                    setState(() {
                                      item.productId = product.id;
                                      item.productName = product.displayLabel;
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    submitting ? null : () => Navigator.of(dialogContext).pop(),
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
}

class DeliveryItemDraft {
  DeliveryItemDraft({
    required this.productId,
    required this.productName,
    required this.maxQuantity,
    required double initialQuantity,
    double unitPrice = 0,
    String unit = '',
    String stockBatch = '',
  })  : quantityController =
            TextEditingController(text: initialQuantity.toStringAsFixed(2)),
        unitPriceController =
            TextEditingController(text: unitPrice.toStringAsFixed(2)),
        unitController = TextEditingController(text: unit),
        stockBatchController = TextEditingController(text: stockBatch);

  int productId;
  String productName;
  final double maxQuantity;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final TextEditingController unitController;
  final TextEditingController stockBatchController;

  double get quantity => double.tryParse(quantityController.text.trim()) ?? 0;
  double get unitPrice => double.tryParse(unitPriceController.text.trim()) ?? 0;
  String get unit => unitController.text.trim();
  String get stockBatch => stockBatchController.text.trim();

  void dispose() {
    quantityController.dispose();
    unitPriceController.dispose();
    unitController.dispose();
    stockBatchController.dispose();
  }
}

class DeliveryItemRow extends StatelessWidget {
  const DeliveryItemRow({
    super.key,
    required this.item,
    required this.enabled,
    required this.products,
    required this.onRemove,
    required this.onProductChanged,
  });

  final DeliveryItemDraft item;
  final bool enabled;
  final List<ProductOption> products;
  final VoidCallback onRemove;
  final ValueChanged<ProductOption> onProductChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: LayoutTokens.gapSm),
      child: Row(
        children: [
          Expanded(
            child: SearchableDropdownFormField<int>(
              key: ValueKey<int?>(item.productId),
              initialValue: item.productId == 0 ? null : item.productId,
              decoration: const InputDecoration(
                labelText: '产品',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: products
                  .map(
                    (product) => DropdownMenuItem<int>(
                      value: product.id,
                      child: Text(product.displayLabel),
                    ),
                  )
                  .toList(),
              onChanged: enabled
                  ? (value) {
                      if (value == null) return;
                      final selected =
                          products.firstWhere((p) => p.id == value);
                      onProductChanged(selected);
                    }
                  : null,
              validator: (value) {
                if (value == null || value == 0) return '请选择产品';
                return null;
              },
            ),
          ),
          SizedBox(width: LayoutTokens.gapSm),
          SizedBox(
            width: 90,
            child: TextFormField(
              controller: item.quantityController,
              enabled: enabled,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '数量',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed <= 0) {
                  return '无效';
                }
                if (item.maxQuantity > 0 && parsed > item.maxQuantity) {
                  return '最多${item.maxQuantity.toStringAsFixed(2)}';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: LayoutTokens.gapSm),
          SizedBox(
            width: 90,
            child: TextFormField(
              controller: item.unitController,
              enabled: enabled,
              decoration: const InputDecoration(
                labelText: '单位',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: LayoutTokens.gapSm),
          SizedBox(
            width: 110,
            child: TextFormField(
              controller: item.unitPriceController,
              enabled: enabled,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '单价',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: LayoutTokens.gapSm),
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: item.stockBatchController,
              enabled: enabled,
              decoration: const InputDecoration(
                labelText: '批次',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: LayoutTokens.gapSm),
          IconButton(
            onPressed: enabled ? onRemove : null,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class DeliveryDateField extends StatelessWidget {
  const DeliveryDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onPicked,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

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
}
