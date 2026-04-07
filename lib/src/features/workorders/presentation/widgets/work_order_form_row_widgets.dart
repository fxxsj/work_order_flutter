import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
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
    this.onRemove,
  });

  final WorkOrderProductDraft draft;
  final List<ProductOption> products;
  final VoidCallback? onRemove;

  @override
  State<WorkOrderProductRow> createState() => _WorkOrderProductRowState();
}

class _WorkOrderProductRowState extends State<WorkOrderProductRow> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final useFullWidth = maxWidth < Breakpoints.sm;
        final productWidth = useFullWidth ? maxWidth : 220.0;
        final smallWidth = useFullWidth ? maxWidth : 120.0;
        final specWidth = useFullWidth ? maxWidth : 200.0;

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
                    value: widget.draft.productId,
                    decoration: const InputDecoration(labelText: '产品'),
                    options: widget.products
                        .map(
                          (item) => DropdownOption(
                            value: item.id,
                            label: item.displayLabel,
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => widget.draft.productId = value),
                    validator: (value) => value == null ? '请选择产品' : null,
                  ),
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
  });

  final WorkOrderMaterialDraft draft;
  final List<MaterialItem> materials;
  final VoidCallback onRemove;

  @override
  State<WorkOrderMaterialRow> createState() => _WorkOrderMaterialRowState();
}

class _WorkOrderMaterialRowState extends State<WorkOrderMaterialRow> {
  @override
  Widget build(BuildContext context) {
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
                    options: widget.materials
                        .map(
                          (item) => DropdownOption(
                            value: item.id,
                            label: '${item.name} (${item.code})',
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => widget.draft.materialId = value),
                  ),
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
