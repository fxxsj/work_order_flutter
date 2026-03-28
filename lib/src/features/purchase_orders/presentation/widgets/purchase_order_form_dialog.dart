import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';

typedef PurchaseFormSubmit = Future<void> Function(StateSetter setState);

Future<void> showPurchaseOrderFormDialog(
  BuildContext context, {
  required bool isEdit,
  required String title,
  required String cancelText,
  required String submitText,
  required bool materialsLoading,
  required GlobalKey<FormState> formKey,
  required List<SupplierDto> suppliers,
  required List<WorkOrderDto> workOrders,
  required int? selectedSupplierId,
  required int? selectedWorkOrderId,
  required String? fallbackWorkOrderNumber,
  required TextEditingController notesController,
  required List<MaterialDto> materials,
  required List<PurchaseItemDraft> items,
  required ValueChanged<int?> onSupplierChanged,
  required ValueChanged<int?> onWorkOrderChanged,
  required PurchaseFormSubmit onSubmit,
}) {
  bool submitting = false;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final totalAmount = items.fold<double>(
            0,
            (sum, item) => sum + item.quantity * item.unitPrice,
          );
          final workOrderOptions = List<WorkOrderDto>.from(workOrders);
          if (selectedWorkOrderId != null &&
              selectedWorkOrderId != 0 &&
              !workOrderOptions
                  .any((order) => order.id == selectedWorkOrderId)) {
            workOrderOptions.add(
              WorkOrderDto(
                id: selectedWorkOrderId,
                orderNumber:
                    fallbackWorkOrderNumber ?? '施工单 #$selectedWorkOrderId',
              ),
            );
          }

          Future<void> submit() async {
            if (submitting) return;
            setState(() => submitting = true);
            await onSubmit(setState);
            if (dialogContext.mounted) {
              setState(() => submitting = false);
            }
          }

          return FormDialog(
            title: title,
            formKey: formKey,
            submitText: submitText,
            cancelText: cancelText,
            submitting: submitting,
            maxWidth: LayoutTokens.dialogWidthLg,
            onSubmit: submit,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchableDropdownFormField<int>(
                  key: ValueKey<String>(
                    'purchase_supplier_${selectedSupplierId ?? 'none'}',
                  ),
                  initialValue: selectedSupplierId,
                  decoration: const InputDecoration(
                    labelText: '供应商',
                    border: OutlineInputBorder(),
                  ),
                  items: suppliers
                      .map(
                        (supplier) => DropdownMenuItem<int>(
                          value: supplier.id,
                          child: Text(supplier.name),
                        ),
                      )
                      .toList(),
                  onChanged: submitting ? null : onSupplierChanged,
                  validator: (value) {
                    if (value == null || value == 0) return '请选择供应商';
                    return null;
                  },
                ),
                SizedBox(height: LayoutTokens.gapMd),
                SearchableDropdownFormField<int>(
                  key: ValueKey<String>(
                    'purchase_workorder_${selectedWorkOrderId ?? 'none'}',
                  ),
                  initialValue: selectedWorkOrderId,
                  decoration: const InputDecoration(
                    labelText: '关联施工单',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<int>(
                      value: 0,
                      child: Text('不关联'),
                    ),
                    ...workOrderOptions.map(
                      (order) => DropdownMenuItem<int>(
                        value: order.id,
                        child: Text(order.orderNumber),
                      ),
                    ),
                  ],
                  onChanged: submitting ? null : onWorkOrderChanged,
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
                        '采购明细',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: submitting || materialsLoading
                          ? null
                          : () {
                              setState(() {
                                items.add(
                                  PurchaseItemDraft(
                                    materialId: 0,
                                    materialName: '-',
                                    materialCode: '',
                                    quantity: 1,
                                    unitPrice: 0,
                                    unit: '',
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
                          (item) => PurchaseItemRow(
                            item: item,
                            enabled: !submitting,
                            materials: materials,
                            onRemove: () {
                              setState(() {
                                items.remove(item);
                                item.dispose();
                              });
                            },
                            onMaterialChanged: (material) {
                              setState(() {
                                item.materialId = material.id;
                                item.materialName = material.name;
                                item.materialCode = material.code;
                                item.setUnit(material.unit ?? item.unit);
                                item.setUnitPrice(
                                  material.unitPrice ?? item.unitPrice,
                                );
                              });
                            },
                            onChanged: () => setState(() {}),
                          ),
                        )
                        .toList(),
                  ),
                if (items.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '合计金额: ${totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}

class PurchaseItemDraft {
  PurchaseItemDraft({
    required this.materialId,
    required this.materialName,
    required this.materialCode,
    required double quantity,
    required double unitPrice,
    String unit = '',
  })  : quantityController =
            TextEditingController(text: quantity.toStringAsFixed(2)),
        unitController = TextEditingController(text: unit),
        unitPriceController =
            TextEditingController(text: unitPrice.toStringAsFixed(2));

  int materialId;
  String materialName;
  String materialCode;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController unitPriceController;

  double get quantity => double.tryParse(quantityController.text.trim()) ?? 0;
  double get unitPrice => double.tryParse(unitPriceController.text.trim()) ?? 0;
  String get unit => unitController.text.trim();

  void setUnit(String value) {
    unitController.text = value;
  }

  void setUnitPrice(double value) {
    unitPriceController.text = value.toStringAsFixed(2);
  }

  void dispose() {
    quantityController.dispose();
    unitController.dispose();
    unitPriceController.dispose();
  }
}

class PurchaseItemRow extends StatelessWidget {
  const PurchaseItemRow({
    super.key,
    required this.item,
    required this.enabled,
    required this.materials,
    required this.onRemove,
    required this.onMaterialChanged,
    this.onChanged,
  });

  final PurchaseItemDraft item;
  final bool enabled;
  final List<MaterialDto> materials;
  final VoidCallback onRemove;
  final ValueChanged<MaterialDto> onMaterialChanged;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: SearchableDropdownFormField<int>(
              key: ValueKey<int?>(item.materialId),
              initialValue: item.materialId == 0 ? null : item.materialId,
              decoration: const InputDecoration(
                labelText: '物料',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: materials
                  .map(
                    (material) => DropdownMenuItem<int>(
                      value: material.id,
                      child: Text(
                        '${material.code.isEmpty ? '-' : material.code} ${material.name}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: enabled
                  ? (value) {
                      if (value == null || value == 0) return;
                      final selected =
                          materials.firstWhere((m) => m.id == value);
                      onMaterialChanged(selected);
                    }
                  : null,
              validator: (value) {
                if (value == null || value == 0) return '请选择物料';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
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
              onChanged: (_) => onChanged?.call(),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed <= 0) return '无效';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextFormField(
              controller: item.unitController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: '单位',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
              onChanged: (_) => onChanged?.call(),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed < 0) return '无效';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: enabled ? onRemove : null,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
