import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_sections.dart';

class WorkOrderMultiSelectField extends StatelessWidget {
  const WorkOrderMultiSelectField({
    super.key,
    required this.items,
    required this.selected,
    required this.emptyText,
    required this.placeholder,
    required this.onChanged,
  });

  final List<WorkOrderOptionItem> items;
  final Set<int> selected;
  final String emptyText;
  final String placeholder;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    if (items.isEmpty) {
      return Text(
        emptyText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors?.subtleText ?? theme.hintColor,
        ),
      );
    }

    return UnifiedDropdown<dynamic>(
      value: Set<dynamic>.from(selected),
      isMultiSelect: true,
      options: items
          .map(
            (item) => DropdownOption<dynamic>(
              value: item.id,
              label: item.label,
            ),
          )
          .toList(),
      decoration: InputDecoration(
        hintText: placeholder,
      ),
      selectHintText: placeholder,
      searchConfig: const DropdownSearchConfig(
        enabled: true,
        hintText: '搜索',
        highlightMatches: true,
      ),
      emptyText: emptyText,
      noResultsText: '无匹配结果',
      clearText: '清空',
      cancelText: '取消',
      confirmText: '确定',
      selectAllText: '全选',
      onChanged: (value) {
        selected
          ..clear()
          ..addAll((value as Set<dynamic>? ?? const <dynamic>{}).cast<int>());
        onChanged();
      },
    );
  }
}

class WorkOrderProductRow extends StatefulWidget {
  const WorkOrderProductRow({
    super.key,
    required this.draft,
    required this.products,
    required this.salesOrders,
    this.defaultSalesOrderId,
    this.onRemove,
    this.onProductChanged,
    this.onCreateProduct,
  });

  final WorkOrderProductDraft draft;
  final List<ProductOption> products;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final int? defaultSalesOrderId;
  final VoidCallback? onRemove;
  final VoidCallback? onProductChanged;
  final Future<ProductOption?> Function()? onCreateProduct;

  @override
  State<WorkOrderProductRow> createState() => _WorkOrderProductRowState();
}

class _WorkOrderProductRowState extends State<WorkOrderProductRow> {
  WorkOrderSalesOrderCandidate? get _selectedSalesOrder {
    final salesOrderId = widget.draft.sourceSalesOrderId;
    if (salesOrderId == null) return null;
    return widget.salesOrders.cast<WorkOrderSalesOrderCandidate?>().firstWhere(
          (item) => item?.id == salesOrderId,
          orElse: () => null,
        );
  }

  List<WorkOrderSalesOrderCandidateProduct> get _salesOrderItems {
    return _selectedSalesOrder?.availableProducts ?? const [];
  }

  bool get _isSalesOrderSource => widget.draft.sourceType == 'sales_order';

  Future<void> _handleCreateProduct() async {
    final created = await widget.onCreateProduct?.call();
    if (created == null || !mounted) {
      return;
    }
    setState(() => widget.draft.productId = created.id);
    widget.onProductChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSalesOrderSource &&
        widget.draft.sourceSalesOrderId == null &&
        widget.defaultSalesOrderId != null) {
      widget.draft.sourceSalesOrderId = widget.defaultSalesOrderId;
    }

    final productOptions = widget.products
        .map(
          (item) => DropdownOption<int>(
            value: item.id,
            label: item.displayLabel,
          ),
        )
        .toList();
    if (!_isSalesOrderSource && widget.onCreateProduct != null) {
      productOptions.add(
        DropdownOption<int>(
          value: -1,
          label: '新增产品',
          icon: Icons.add,
          onSelected: _handleCreateProduct,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final useFullWidth = maxWidth < Breakpoints.sm;
        final wideWidth = useFullWidth ? maxWidth : 220.0;
        final mediumWidth = useFullWidth ? maxWidth : 180.0;
        final smallWidth = useFullWidth ? maxWidth : 120.0;
        final specWidth = useFullWidth ? maxWidth : 200.0;
        final sourceOrderOptions = widget.salesOrders
            .map(
              (item) => DropdownOption<int>(
                value: item.id,
                label: item.orderNumber,
                secondaryLabel: item.customerName,
              ),
            )
            .toList();
        final salesOrderItemOptions = _salesOrderItems
            .map(
              (item) => DropdownOption<int>(
                value: item.salesOrderItemId ?? item.productId,
                label: item.productCode?.isNotEmpty == true
                    ? '${item.productName ?? ''} (${item.productCode})'
                    : (item.productName ?? '未命名产品'),
                secondaryLabel:
                    '订单 ${item.quantity ?? 0}${item.unit?.isNotEmpty == true ? item.unit : ''} · 已开 ${item.allocatedQuantity ?? 0} · 剩余 ${item.remainingQuantity ?? 0}',
              ),
            )
            .toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _WorkOrderFormRowCard(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: mediumWidth,
                  child: UnifiedDropdown<String>(
                    value: widget.draft.sourceType,
                    decoration: const InputDecoration(labelText: '产品来源'),
                    options: workOrderProductSourceOptions,
                    onChanged: (value) {
                      setState(() {
                        widget.draft.sourceType = value ?? 'stock';
                        if (widget.draft.sourceType == 'sales_order') {
                          widget.draft.sourceSalesOrderId ??=
                              widget.defaultSalesOrderId;
                        } else {
                          widget.draft.sourceSalesOrderId = null;
                          widget.draft.salesOrderItemId = null;
                        }
                      });
                      widget.onProductChanged?.call();
                    },
                  ),
                ),
                if (_isSalesOrderSource)
                  SizedBox(
                    width: wideWidth,
                    child: UnifiedDropdown<int>(
                      value: widget.draft.sourceSalesOrderId,
                      decoration: const InputDecoration(labelText: '来源客户订单'),
                      options: sourceOrderOptions,
                      selectHintText:
                          sourceOrderOptions.isEmpty ? '暂无可用订单' : '请选择',
                      minOptionsForSearch: 1,
                      onChanged: (value) {
                        setState(() {
                          widget.draft.sourceSalesOrderId = value;
                          widget.draft.salesOrderItemId = null;
                          widget.draft.productId = null;
                        });
                        widget.onProductChanged?.call();
                      },
                      validator: (value) => value == null ? '请选择来源订单' : null,
                    ),
                  ),
                SizedBox(
                  width: wideWidth,
                  child: UnifiedDropdown<int>(
                    value: _isSalesOrderSource
                        ? widget.draft.salesOrderItemId
                        : widget.draft.productId,
                    decoration: InputDecoration(
                      labelText: _isSalesOrderSource ? '来源订单产品' : '产品',
                    ),
                    options: _isSalesOrderSource
                        ? salesOrderItemOptions
                        : productOptions,
                    selectHintText: _isSalesOrderSource
                        ? (salesOrderItemOptions.isEmpty ? '暂无可用订单产品' : '请选择')
                        : (widget.products.isEmpty ? '新增产品' : '请选择'),
                    minOptionsForSearch: 1,
                    onChanged: (value) {
                      setState(() {
                        if (_isSalesOrderSource) {
                          widget.draft.salesOrderItemId = value;
                          final selectedItem = _salesOrderItems
                              .cast<WorkOrderSalesOrderCandidateProduct?>()
                              .firstWhere(
                                (item) =>
                                    (item?.salesOrderItemId ??
                                        item?.productId) ==
                                    value,
                                orElse: () => null,
                              );
                          widget.draft.productId = selectedItem?.productId;
                          if (selectedItem?.unit?.isNotEmpty == true) {
                            widget.draft.unitController.text =
                                selectedItem!.unit!;
                          }
                          final remainingQuantity =
                              selectedItem?.remainingQuantity;
                          if (remainingQuantity != null &&
                              remainingQuantity > 0) {
                            widget.draft.quantityController.text =
                                remainingQuantity.toString();
                          }
                        } else {
                          widget.draft.productId = value;
                        }
                      });
                      widget.onProductChanged?.call();
                    },
                    validator: (value) => value == null
                        ? '请选择${_isSalesOrderSource ? '来源订单产品' : '产品'}'
                        : null,
                  ),
                ),
                if (!_isSalesOrderSource &&
                    widget.products.isEmpty &&
                    widget.onCreateProduct != null)
                  TextButton.icon(
                    onPressed: _handleCreateProduct,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('新增产品'),
                  ),
                SizedBox(
                  width: smallWidth,
                  child: CrudFormField.number(
                    label: '数量',
                    controller: widget.draft.quantityController,
                  ).build(context),
                ),
                SizedBox(
                  width: smallWidth,
                  child: CrudFormField.text(
                    label: '单位',
                    controller: widget.draft.unitController,
                  ).build(context),
                ),
                SizedBox(
                  width: specWidth,
                  child: CrudFormField.text(
                    label: '规格',
                    controller: widget.draft.specController,
                  ).build(context),
                ),
                SizedBox(
                  width: smallWidth,
                  child: CrudFormField.number(
                    label: '排序',
                    controller: widget.draft.sortOrderController,
                  ).build(context),
                ),
                if (widget.onRemove != null)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: '移除',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WorkOrderMaterialRow extends StatefulWidget {
  const WorkOrderMaterialRow({
    super.key,
    required this.draft,
    required this.materials,
    required this.onRemove,
    this.onCreateMaterial,
  });

  final WorkOrderMaterialDraft draft;
  final List<MaterialItem> materials;
  final VoidCallback onRemove;
  final Future<MaterialItem?> Function()? onCreateMaterial;

  @override
  State<WorkOrderMaterialRow> createState() => _WorkOrderMaterialRowState();
}

class _WorkOrderMaterialRowState extends State<WorkOrderMaterialRow> {
  Future<void> _handleCreateMaterial() async {
    final created = await widget.onCreateMaterial?.call();
    if (created == null || !mounted) {
      return;
    }
    setState(() => widget.draft.materialId = created.id);
  }

  @override
  Widget build(BuildContext context) {
    final materialOptions = widget.materials
        .map(
          (item) => DropdownOption<int>(
            value: item.id,
            label: '${item.name} (${item.code})',
          ),
        )
        .toList();
    if (widget.onCreateMaterial != null) {
      materialOptions.add(
        DropdownOption<int>(
          value: -1,
          label: '新增物料',
          icon: Icons.add,
          onSelected: _handleCreateMaterial,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final useFullWidth = maxWidth < Breakpoints.sm;
        final productWidth = useFullWidth ? maxWidth : 220.0;
        final mediumWidth = useFullWidth ? maxWidth : 160.0;
        final notesWidth = useFullWidth ? maxWidth : 200.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _WorkOrderFormRowCard(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: productWidth,
                  child: UnifiedDropdown<int>(
                    value: widget.draft.materialId,
                    decoration: const InputDecoration(labelText: '物料'),
                    options: materialOptions,
                    selectHintText: widget.materials.isEmpty ? '新增物料' : '请选择',
                    minOptionsForSearch: 1,
                    onChanged: (value) =>
                        setState(() => widget.draft.materialId = value),
                  ),
                ),
                if (widget.materials.isEmpty && widget.onCreateMaterial != null)
                  TextButton.icon(
                    onPressed: _handleCreateMaterial,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('新增物料'),
                  ),
                SizedBox(
                  width: mediumWidth,
                  child: CrudFormField.text(
                    label: '规格',
                    controller: widget.draft.sizeController,
                  ).build(context),
                ),
                SizedBox(
                  width: mediumWidth,
                  child: CrudFormField.text(
                    label: '用量',
                    controller: widget.draft.usageController,
                  ).build(context),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: widget.draft.needCutting,
                      onChanged: (value) => setState(
                        () => widget.draft.needCutting = value ?? false,
                      ),
                    ),
                    const Text('需要开料'),
                  ],
                ),
                SizedBox(
                  width: notesWidth,
                  child: CrudFormField.text(
                    label: '备注',
                    controller: widget.draft.notesController,
                  ).build(context),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: '移除',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WorkOrderFormRowCard extends StatelessWidget {
  const _WorkOrderFormRowCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    return AppCard(
      padding: LayoutTokens.cardPadding(context),
      background: theme.colorScheme.primary.withValues(alpha: 0.03),
      borderColor: colors.borderColor,
      radius: LayoutTokens.radiusLg,
      child: child,
    );
  }
}
