import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
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
  required Future<MaterialDto?> Function() onCreateMaterial,
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
              _PurchaseFormSection(
                title: '基础信息',
                child: Column(
                  children: [
                    UnifiedDropdown<int>(
                      key: ValueKey<String>(
                        'purchase_supplier_${selectedSupplierId ?? 'none'}',
                      ),
                      value: selectedSupplierId,
                      decoration: const InputDecoration(
                        labelText: '供应商',
                        border: OutlineInputBorder(),
                      ),
                      options: suppliers
                          .map(
                            (supplier) => DropdownOption<int>(
                              value: supplier.id,
                              label: supplier.name,
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
                    UnifiedDropdown<int>(
                      key: ValueKey<String>(
                        'purchase_workorder_${selectedWorkOrderId ?? 'none'}',
                      ),
                      value: selectedWorkOrderId,
                      decoration: const InputDecoration(
                        labelText: '关联施工单',
                        border: OutlineInputBorder(),
                      ),
                      options: [
                        const DropdownOption<int>(value: 0, label: '不关联'),
                        ...workOrderOptions.map(
                          (order) => DropdownOption<int>(
                            value: order.id,
                            label: order.orderNumber,
                          ),
                        ),
                      ],
                      onChanged: submitting ? null : onWorkOrderChanged,
                    ),
                    const SizedBox(height: LayoutTokens.gapMd),
                    CrudFormField.textarea(
                      label: '备注',
                      controller: notesController,
                      maxLines: 3,
                    ).build(context),
                  ],
                ),
              ),
              const SizedBox(height: LayoutTokens.gapLg),
              _PurchaseFormSection(
                title: '采购明细',
                subtitle: '支持逐行选择物料、调整数量和单价。',
                trailing: PageActionButton.outlined(
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
                  label: '添加明细',
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
                                onCreateMaterial: onCreateMaterial,
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
    required this.onCreateMaterial,
    required this.onRemove,
    required this.onMaterialChanged,
    this.onChanged,
  });

  final PurchaseItemDraft item;
  final bool enabled;
  final List<MaterialDto> materials;
  final Future<MaterialDto?> Function() onCreateMaterial;
  final VoidCallback onRemove;
  final ValueChanged<MaterialDto> onMaterialChanged;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    Future<void> handleCreateMaterial() async {
      final created = await onCreateMaterial();
      if (created == null) return;
      onMaterialChanged(created);
    }

    final materialOptions = materials
        .map(
          (material) => DropdownOption<int>(
            value: material.id,
            label:
                '${material.code.isEmpty ? '-' : material.code} ${material.name}',
          ),
        )
        .toList()
      ..add(
        DropdownOption<int>(
          value: -1,
          label: '新增物料',
          icon: Icons.add,
          onSelected: handleCreateMaterial,
        ),
      );
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
                  child: UnifiedDropdown<int>(
                    key: ValueKey<int?>(item.materialId),
                    value: item.materialId == 0 ? null : item.materialId,
                    decoration: const InputDecoration(
                      labelText: '物料',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    options: materialOptions,
                    selectHintText: materials.isEmpty ? '新增物料' : '请选择',
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
                if (materials.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: LayoutTokens.gapSm),
                    child: TextButton.icon(
                      onPressed: enabled ? handleCreateMaterial : null,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('新增物料'),
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
    return CrudFormField.text(
      label: label,
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      isDense: true,
      onChanged: onChanged,
      validator: validator,
    ).build(context);
  }
}
