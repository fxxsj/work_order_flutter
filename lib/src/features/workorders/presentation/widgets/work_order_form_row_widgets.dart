import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_sections.dart';

class WorkOrderMultiSelectChips extends StatefulWidget {
  const WorkOrderMultiSelectChips({
    super.key,
    required this.items,
    required this.selected,
    required this.emptyText,
    required this.title,
    required this.placeholder,
    required this.onChanged,
  });

  final List<WorkOrderOptionItem> items;
  final Set<int> selected;
  final String emptyText;
  final String title;
  final String placeholder;
  final VoidCallback onChanged;

  @override
  State<WorkOrderMultiSelectChips> createState() =>
      _WorkOrderMultiSelectChipsState();
}

class _WorkOrderMultiSelectChipsState extends State<WorkOrderMultiSelectChips> {
  var _expanded = false;

  @override
  void didUpdateWidget(covariant WorkOrderMultiSelectChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected.isEmpty && _expanded) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    if (widget.items.isEmpty) {
      return Text(
        widget.emptyText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors?.subtleText ?? theme.hintColor,
        ),
      );
    }
    final resolvedColors = colors!;
    final selectedItems = widget.items
        .where((item) => widget.selected.contains(item.id))
        .toList();
    final hasSelected = selectedItems.isNotEmpty;
    final summaryText =
        hasSelected ? '已选 ${selectedItems.length} 项' : widget.placeholder;

    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.primary.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.all(LayoutTokens.gapMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  summaryText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: hasSelected
                        ? resolvedColors.sidebarText
                        : resolvedColors.subtleText,
                  ),
                ),
              ),
              if (hasSelected)
                IconButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  tooltip: _expanded ? '收起' : '展开',
                  visualDensity: VisualDensity.compact,
                ),
              IconButton(
                onPressed: () => _openDialog(context),
                icon: const Icon(Icons.edit_outlined),
                tooltip: '选择',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (_expanded && hasSelected) ...[
            const SizedBox(height: LayoutTokens.gapSm),
            Wrap(
              spacing: LayoutTokens.gapSm,
              runSpacing: LayoutTokens.gapSm,
              children: selectedItems
                  .map(
                    (item) => InputChip(
                      label: Text(item.label),
                      visualDensity: VisualDensity.compact,
                      onDeleted: () {
                        widget.selected.remove(item.id);
                        widget.onChanged();
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final original = Set<int>.from(widget.selected);
    var query = '';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final media = MediaQuery.of(context).size;
            final filtered = widget.items
                .where(
                  (item) =>
                      item.label.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal:
                    media.width < Breakpoints.md ? LayoutTokens.gapLg : 40,
                vertical: LayoutTokens.gapXl,
              ),
              title: Text(widget.title),
              content: SizedBox(
                width: media.width < Breakpoints.md
                    ? media.width -
                        (LayoutTokens.gapXl * 2 + LayoutTokens.gapLg * 2)
                    : LayoutTokens.pageWidthNarrow,
                height: media.height < 720 ? media.height * 0.62 : 420,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '搜索名称或编码',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) =>
                          setDialogState(() => query = value.trim()),
                    ),
                    const SizedBox(height: LayoutTokens.gapMd),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                '无匹配项',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          : Scrollbar(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  final isSelected =
                                      widget.selected.contains(item.id);
                                  return CheckboxListTile(
                                    value: isSelected,
                                    dense: true,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(item.label),
                                    onChanged: (value) {
                                      setDialogState(() {
                                        if (value == true) {
                                          widget.selected.add(item.id);
                                        } else {
                                          widget.selected.remove(item.id);
                                        }
                                      });
                                      widget.onChanged();
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    widget.selected
                      ..clear()
                      ..addAll(original);
                    widget.onChanged();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    widget.selected.clear();
                    widget.onChanged();
                    setDialogState(() {});
                  },
                  child: const Text('清空'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
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
                  child: SearchableDropdownFormField<int>(
                    initialValue: widget.draft.productId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: '产品'),
                    items: widget.products
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              item.displayLabel,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                  child: TextFormField(
                    controller: widget.draft.quantityController,
                    decoration: const InputDecoration(labelText: '数量'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: smallWidth,
                  child: TextFormField(
                    controller: widget.draft.unitController,
                    decoration: const InputDecoration(labelText: '单位'),
                  ),
                ),
                SizedBox(
                  width: specWidth,
                  child: TextFormField(
                    controller: widget.draft.specController,
                    decoration: const InputDecoration(labelText: '规格'),
                  ),
                ),
                SizedBox(
                  width: smallWidth,
                  child: TextFormField(
                    controller: widget.draft.sortOrderController,
                    decoration: const InputDecoration(labelText: '排序'),
                    keyboardType: TextInputType.number,
                  ),
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
                  child: SearchableDropdownFormField<int>(
                    initialValue: widget.draft.materialId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: '物料'),
                    items: widget.materials
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              '${item.name} (${item.code})',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => widget.draft.materialId = value),
                  ),
                ),
                SizedBox(
                  width: mediumWidth,
                  child: TextFormField(
                    controller: widget.draft.sizeController,
                    decoration: const InputDecoration(labelText: '规格'),
                  ),
                ),
                SizedBox(
                  width: mediumWidth,
                  child: TextFormField(
                    controller: widget.draft.usageController,
                    decoration: const InputDecoration(labelText: '用量'),
                  ),
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
                  child: TextFormField(
                    controller: widget.draft.notesController,
                    decoration: const InputDecoration(labelText: '备注'),
                  ),
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
