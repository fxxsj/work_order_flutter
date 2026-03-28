import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
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

  return showAdaptiveFilterDrawer(
    context,
    isMobile: BreakpointsUtil.isMobile(context),
    title: title,
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: StatefulBuilder(
      builder: (context, setState) {
        final totalAmount = items.fold<double>(
          0,
          (sum, item) => sum + item.quantity * item.unitPrice,
        );
        final workOrderOptions = List<WorkOrderDto>.from(workOrders);
        if (selectedWorkOrderId != null &&
            selectedWorkOrderId != 0 &&
            !workOrderOptions.any((order) => order.id == selectedWorkOrderId)) {
          workOrderOptions.add(
            WorkOrderDto(
              id: selectedWorkOrderId,
              orderNumber:
                  fallbackWorkOrderNumber ?? '施工单 #$selectedWorkOrderId',
            ),
          );
        }

        String? supplierLabel;
        if (selectedSupplierId != null) {
          for (final supplier in suppliers) {
            if (supplier.id == selectedSupplierId) {
              supplierLabel = supplier.name;
              break;
            }
          }
        }

        String workOrderLabel = '不关联';
        if ((selectedWorkOrderId ?? 0) > 0) {
          for (final order in workOrderOptions) {
            if (order.id == selectedWorkOrderId) {
              workOrderLabel = order.orderNumber;
              break;
            }
          }
        }

        Future<void> submit() async {
          if (submitting) return;
          setState(() => submitting = true);
          await onSubmit(setState);
          if (context.mounted) {
            setState(() => submitting = false);
          }
        }

        return AdaptiveFormPanel(
          formKey: formKey,
          submitText: submitText,
          cancelText: cancelText,
          submitting: submitting,
          onSubmit: submit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PurchaseOrderSummaryCard(
                isEdit: isEdit,
                supplierLabel: supplierLabel,
                workOrderLabel: workOrderLabel,
                itemCount: items.length,
                totalAmount: totalAmount,
              ),
              const SizedBox(height: LayoutTokens.gapLg),
              _PurchaseFormSection(
                title: '基础信息',
                child: Column(
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
                    const SizedBox(height: LayoutTokens.gapMd),
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
                    const SizedBox(height: LayoutTokens.gapMd),
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '备注',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LayoutTokens.gapLg),
              _PurchaseFormSection(
                title: '采购明细',
                subtitle: '支持逐行选择物料、调整数量和单价。',
                trailing: TextButton.icon(
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
                child: items.isEmpty
                    ? Text(
                        '暂无明细，请添加需要采购的物料。',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : Column(
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
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _PurchaseOrderSummaryCard extends StatelessWidget {
  const _PurchaseOrderSummaryCard({
    required this.isEdit,
    required this.supplierLabel,
    required this.workOrderLabel,
    required this.itemCount,
    required this.totalAmount,
  });

  final bool isEdit;
  final String? supplierLabel;
  final String workOrderLabel;
  final int itemCount;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEdit ? '正在编辑采购单' : '新建采购单',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: LayoutTokens.gapXxs),
          Text(
            '在当前列表上下文中维护供应商、关联施工单和采购明细。',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: LayoutTokens.gapMd,
            runSpacing: LayoutTokens.gapSm,
            children: [
              _PurchaseSummaryItem(
                label: '供应商',
                value: supplierLabel ?? '未选择',
              ),
              _PurchaseSummaryItem(
                label: '关联施工单',
                value: workOrderLabel,
              ),
              _PurchaseSummaryItem(
                label: '明细行数',
                value: itemCount.toString(),
              ),
              _PurchaseSummaryItem(
                label: '合计金额',
                value: totalAmount.toStringAsFixed(2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PurchaseSummaryItem extends StatelessWidget {
  const _PurchaseSummaryItem({
    required this.label,
    required this.value,
  });

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
        const SizedBox(height: LayoutTokens.gapXxxs),
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

class _PurchaseFormSection extends StatelessWidget {
  const _PurchaseFormSection({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: LayoutTokens.gapXxxs),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: LayoutTokens.gapMd),
          child,
        ],
      ),
    );
  }
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
    final isCompact =
        BreakpointsUtil.isXs(context) || BreakpointsUtil.isSm(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: LayoutTokens.gapSm),
      child: AppCard(
        padding: const EdgeInsets.all(LayoutTokens.gapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: LayoutTokens.gapSm),
                IconButton(
                  onPressed: enabled ? onRemove : null,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: LayoutTokens.gapSm),
            if (isCompact) ...[
              Row(
                children: [
                  Expanded(
                    child: _PurchaseDenseField(
                      controller: item.quantityController,
                      enabled: enabled,
                      label: '数量',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => onChanged?.call(),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) return '无效';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  Expanded(
                    child: _PurchaseDenseField(
                      controller: item.unitController,
                      enabled: false,
                      label: '单位',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LayoutTokens.gapSm),
              _PurchaseDenseField(
                controller: item.unitPriceController,
                enabled: enabled,
                label: '单价',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => onChanged?.call(),
                validator: (value) {
                  final parsed = double.tryParse(value?.trim() ?? '');
                  if (parsed == null || parsed < 0) return '无效';
                  return null;
                },
              ),
            ] else
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: _PurchaseDenseField(
                      controller: item.quantityController,
                      enabled: enabled,
                      label: '数量',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => onChanged?.call(),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) return '无效';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  SizedBox(
                    width: 90,
                    child: _PurchaseDenseField(
                      controller: item.unitController,
                      enabled: false,
                      label: '单位',
                    ),
                  ),
                  const SizedBox(width: LayoutTokens.gapSm),
                  SizedBox(
                    width: 110,
                    child: _PurchaseDenseField(
                      controller: item.unitPriceController,
                      enabled: enabled,
                      label: '单价',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => onChanged?.call(),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed < 0) return '无效';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseDenseField extends StatelessWidget {
  const _PurchaseDenseField({
    required this.controller,
    required this.enabled,
    required this.label,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final bool enabled;
  final String label;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
