import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/filter_drawer.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/features/materials/data/material_dto.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';

typedef PurchaseFormSubmit = Future<void> Function(VoidCallback refresh, [bool autoApprove]);

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
  required Future<SupplierDto?> Function() onCreateSupplier,
  required Future<MaterialDto?> Function() onCreateMaterial,
  required ValueChanged<int?> onSupplierChanged,
  required ValueChanged<int?> onWorkOrderChanged,
  required PurchaseFormSubmit onSubmit,
}) {
  return showAdaptiveFilterDrawer(
    context,
    isMobile: ResponsiveLayout.isMobile(context),
    title: title,
    desktopWidth: LayoutTokens.pageWidthXwide,
    child: _PurchaseOrderFormPanel(
      formKey: formKey,
      cancelText: cancelText,
      submitText: submitText,
      materialsLoading: materialsLoading,
      suppliers: suppliers,
      workOrders: workOrders,
      selectedSupplierId: selectedSupplierId,
      selectedWorkOrderId: selectedWorkOrderId,
      fallbackWorkOrderNumber: fallbackWorkOrderNumber,
      notesController: notesController,
      materials: materials,
      items: items,
      onCreateSupplier: onCreateSupplier,
      onCreateMaterial: onCreateMaterial,
      onSupplierChanged: onSupplierChanged,
      onWorkOrderChanged: onWorkOrderChanged,
      onSubmit: onSubmit,
    ),
  );
}

class _PurchaseOrderFormPanel extends StatefulWidget {
  const _PurchaseOrderFormPanel({
    required this.formKey,
    required this.cancelText,
    required this.submitText,
    required this.materialsLoading,
    required this.suppliers,
    required this.workOrders,
    required this.selectedSupplierId,
    required this.selectedWorkOrderId,
    required this.fallbackWorkOrderNumber,
    required this.notesController,
    required this.materials,
    required this.items,
    required this.onCreateSupplier,
    required this.onCreateMaterial,
    required this.onSupplierChanged,
    required this.onWorkOrderChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final String cancelText;
  final String submitText;
  final bool materialsLoading;
  final List<SupplierDto> suppliers;
  final List<WorkOrderDto> workOrders;
  final int? selectedSupplierId;
  final int? selectedWorkOrderId;
  final String? fallbackWorkOrderNumber;
  final TextEditingController notesController;
  final List<MaterialDto> materials;
  final List<PurchaseItemDraft> items;
  final Future<SupplierDto?> Function() onCreateSupplier;
  final Future<MaterialDto?> Function() onCreateMaterial;
  final ValueChanged<int?> onSupplierChanged;
  final ValueChanged<int?> onWorkOrderChanged;
  final PurchaseFormSubmit onSubmit;

  @override
  State<_PurchaseOrderFormPanel> createState() =>
      _PurchaseOrderFormPanelState();
}

class _PurchaseOrderFormPanelState extends State<_PurchaseOrderFormPanel> {
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    final workOrderOptions = List<WorkOrderDto>.from(widget.workOrders);
    final selectedWorkOrderId = widget.selectedWorkOrderId;
    if (selectedWorkOrderId != null &&
        selectedWorkOrderId != 0 &&
        !workOrderOptions.any((order) => order.id == selectedWorkOrderId)) {
      workOrderOptions.add(
        WorkOrderDto(
          id: selectedWorkOrderId,
          orderNumber:
              widget.fallbackWorkOrderNumber ?? '施工单 #$selectedWorkOrderId',
        ),
      );
    }

    return AdaptiveFormPanel(
      formKey: widget.formKey,
      submitText: widget.submitText == '创建' ? '存为草稿' : widget.submitText,
      submitIcon: widget.submitText == '创建' ? const Icon(Icons.save, size: 16) : const Icon(Icons.save, size: 16),
      secondarySubmitText: widget.submitText == '创建' ? '直接发布' : null,
      secondarySubmitIcon: widget.submitText == '创建' ? const Icon(Icons.send, size: 16) : null,
      cancelText: widget.cancelText,
      submitting: submitting,
      onSubmit: () => _submit(false),
      onSecondarySubmit: () => _submit(true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PurchaseFormSection(
            title: '基础信息',
            child: Column(
              children: [
                _buildSupplierSelect(),
                const SizedBox(height: LayoutTokens.gapMd),
                AppSelect<int>(
                  key: ValueKey<String>(
                    'purchase_workorder_${widget.selectedWorkOrderId ?? 'none'}',
                  ),
                  value: widget.selectedWorkOrderId,
                  decoration: const InputDecoration(
                    labelText: '关联施工单',
                    border: OutlineInputBorder(),
                  ),
                  options: [
                    const AppDropdownOption<int>(value: 0, label: '不关联'),
                    ...workOrderOptions.map(
                      (order) => AppDropdownOption<int>(
                        value: order.id,
                        label: order.orderNumber,
                      ),
                    ),
                  ],
                  onChanged: submitting ? null : widget.onWorkOrderChanged,
                ),
                const SizedBox(height: LayoutTokens.gapMd),
                CrudFieldConfig.textarea(
                  label: '备注',
                  controller: widget.notesController,
                  enabled: !submitting,
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
              onPressed: submitting || widget.materialsLoading
                  ? null
                  : () {
                      setState(() {
                        widget.items.add(
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
            child: widget.items.isEmpty
                ? Text(
                    '暂无明细，请添加需要采购的物料。',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : Column(
                    children: widget.items
                        .map(
                          (item) => PurchaseItemRow(
                            item: item,
                            enabled: !submitting,
                            materials: widget.materials,
                            onCreateMaterial: widget.onCreateMaterial,
                            onRemove: () {
                              setState(() {
                                widget.items.remove(item);
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
                            onChanged: _refresh,
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierSelect() {
    Future<void> handleCreateSupplier() async {
      final created = await widget.onCreateSupplier();
      if (created == null) return;
      widget.onSupplierChanged(created.id);
      _refresh();
    }

    final supplierOptions = widget.suppliers
        .map(
          (supplier) => AppDropdownOption<int>(
            value: supplier.id,
            label: supplier.name,
          ),
        )
        .toList()
      ..add(
        AppDropdownOption<int>(
          value: -1,
          label: '新增供应商',
          icon: Icons.add,
          onSelected: handleCreateSupplier,
        ),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSelect<int>(
          key: ValueKey<String>(
            'purchase_supplier_${widget.selectedSupplierId ?? 'none'}',
          ),
          value: widget.selectedSupplierId,
          decoration: const InputDecoration(
            labelText: '供应商',
            border: OutlineInputBorder(),
          ),
          options: supplierOptions,
          selectHintText: widget.suppliers.isEmpty ? '新增供应商' : '请选择',
          onChanged: submitting ? null : widget.onSupplierChanged,
          validator: (value) {
            if (value == null || value == 0) return '请选择供应商';
            return null;
          },
        ),
        if (widget.suppliers.isEmpty) ...[
          const SizedBox(height: LayoutTokens.gapSm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: submitting ? null : handleCreateSupplier,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('新增供应商'),
            ),
          ),
        ],
      ],
    );
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _submit([bool autoApprove = false]) async {
    if (submitting) return;
    setState(() => submitting = true);
    await widget.onSubmit(_refresh, autoApprove);
    if (mounted) {
      setState(() => submitting = false);
    }
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
          (material) => AppDropdownOption<int>(
            value: material.id,
            label:
                '${material.code.isEmpty ? '-' : material.code} ${material.name}',
          ),
        )
        .toList()
      ..add(
        AppDropdownOption<int>(
          value: -1,
          label: '新增物料',
          icon: Icons.add,
          onSelected: handleCreateMaterial,
        ),
      );
    final isCompact =
        ResponsiveLayout.isXs(context) || ResponsiveLayout.isSm(context);
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
                  child: AppSelect<int>(
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
    return CrudFieldConfig.text(
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
