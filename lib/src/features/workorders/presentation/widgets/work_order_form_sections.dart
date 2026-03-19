import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_row_widgets.dart';

class WorkOrderFormSectionCard extends StatelessWidget {
  const WorkOrderFormSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DetailSectionCard(title: title, child: child);
  }
}

class WorkOrderFormSubsectionTitle extends StatelessWidget {
  const WorkOrderFormSubsectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: colors?.sidebarText,
      ),
    );
  }
}

class WorkOrderOptionItem {
  const WorkOrderOptionItem(this.id, this.label);

  final int id;
  final String label;
}

class WorkOrderProductDraft {
  WorkOrderProductDraft()
      : quantityController = TextEditingController(text: '1'),
        unitController = TextEditingController(text: '件'),
        specController = TextEditingController(),
        sortOrderController = TextEditingController(text: '0');

  WorkOrderProductDraft.fromDetail(WorkOrderProductItem item)
      : productId = item.productId,
        quantityController =
            TextEditingController(text: item.quantity?.toString() ?? '1'),
        unitController = TextEditingController(text: item.unit ?? '件'),
        specController = TextEditingController(text: item.specification ?? ''),
        sortOrderController =
            TextEditingController(text: item.sortOrder?.toString() ?? '0');

  int? productId;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController specController;
  final TextEditingController sortOrderController;

  int get quantityValue => int.tryParse(quantityController.text.trim()) ?? 1;
  String get unitValue =>
      unitController.text.trim().isEmpty ? '件' : unitController.text.trim();
  String get specificationValue => specController.text.trim();
  int get sortOrderValue => int.tryParse(sortOrderController.text.trim()) ?? 0;

  void dispose() {
    quantityController.dispose();
    unitController.dispose();
    specController.dispose();
    sortOrderController.dispose();
  }
}

class WorkOrderMaterialDraft {
  WorkOrderMaterialDraft()
      : sizeController = TextEditingController(),
        usageController = TextEditingController(),
        notesController = TextEditingController();

  WorkOrderMaterialDraft.fromDetail(WorkOrderMaterialItem item)
      : materialId = item.materialId,
        sizeController = TextEditingController(text: item.materialSize ?? ''),
        usageController = TextEditingController(text: item.materialUsage ?? ''),
        notesController = TextEditingController(text: item.notes ?? ''),
        needCutting = item.needCutting ?? false;

  int? materialId;
  final TextEditingController sizeController;
  final TextEditingController usageController;
  final TextEditingController notesController;
  bool needCutting = false;

  String get sizeValue => sizeController.text.trim();
  String get usageValue => usageController.text.trim();
  String get notesValue => notesController.text.trim();

  void dispose() {
    sizeController.dispose();
    usageController.dispose();
    notesController.dispose();
  }
}

class WorkOrderBasicInfoSection extends StatelessWidget {
  const WorkOrderBasicInfoSection({
    super.key,
    required this.mode,
    required this.customerId,
    required this.customers,
    required this.status,
    required this.priority,
    required this.orderDateController,
    required this.deliveryDateController,
    required this.productionQuantityController,
    required this.defectiveQuantityController,
    required this.actualDeliveryDateController,
    required this.notesController,
    required this.onCustomerChanged,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onPickOrderDate,
    required this.onPickDeliveryDate,
    required this.onPickActualDeliveryDate,
  });

  final WorkOrderFormMode mode;
  final int? customerId;
  final List<Customer> customers;
  final String status;
  final String priority;
  final TextEditingController orderDateController;
  final TextEditingController deliveryDateController;
  final TextEditingController productionQuantityController;
  final TextEditingController defectiveQuantityController;
  final TextEditingController actualDeliveryDateController;
  final TextEditingController notesController;
  final ValueChanged<int?> onCustomerChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;
  final VoidCallback onPickOrderDate;
  final VoidCallback onPickDeliveryDate;
  final VoidCallback onPickActualDeliveryDate;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '基本信息',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchableDropdownFormField<int>(
            initialValue: customerId,
            decoration: const InputDecoration(labelText: '客户'),
            items: customers
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.name),
                  ),
                )
                .toList(),
            onChanged: onCustomerChanged,
            validator: (value) => value == null ? '请选择客户' : null,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final fieldSpacing = LayoutTokens.gapLg;
              final fieldWidth = maxWidth < Breakpoints.sm
                  ? maxWidth
                  : (maxWidth - fieldSpacing) / 2;
              return Wrap(
                spacing: fieldSpacing,
                runSpacing: LayoutTokens.gapMd,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: SearchableDropdownFormField<String>(
                      initialValue: status,
                      decoration: const InputDecoration(labelText: '状态'),
                      items: const [
                        DropdownMenuItem(value: 'pending', child: Text('待开始')),
                        DropdownMenuItem(
                          value: 'in_progress',
                          child: Text('进行中'),
                        ),
                        DropdownMenuItem(value: 'paused', child: Text('已暂停')),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('已完成'),
                        ),
                        DropdownMenuItem(
                          value: 'cancelled',
                          child: Text('已取消'),
                        ),
                      ],
                      onChanged: onStatusChanged,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: SearchableDropdownFormField<String>(
                      initialValue: priority,
                      decoration: const InputDecoration(labelText: '优先级'),
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('低')),
                        DropdownMenuItem(value: 'normal', child: Text('普通')),
                        DropdownMenuItem(value: 'high', child: Text('高')),
                        DropdownMenuItem(value: 'urgent', child: Text('紧急')),
                      ],
                      onChanged: onPriorityChanged,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      readOnly: true,
                      controller: orderDateController,
                      decoration: const InputDecoration(labelText: '下单日期'),
                      onTap: onPickOrderDate,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      readOnly: true,
                      controller: deliveryDateController,
                      decoration: const InputDecoration(labelText: '交货日期'),
                      onTap: onPickDeliveryDate,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? '请选择交货日期' : null,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: productionQuantityController,
                      decoration: const InputDecoration(labelText: '生产数量'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        final parsed = int.tryParse(text);
                        if (parsed == null || parsed <= 0) {
                          return '请输入有效数量';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: TextFormField(
                      controller: defectiveQuantityController,
                      decoration: const InputDecoration(labelText: '预损数量'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        final parsed = int.tryParse(text);
                        if (parsed == null || parsed < 0) {
                          return '请输入有效数量';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (mode == WorkOrderFormMode.edit)
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        readOnly: true,
                        controller: actualDeliveryDateController,
                        decoration: const InputDecoration(labelText: '实际交货日期'),
                        onTap: onPickActualDeliveryDate,
                      ),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: LayoutTokens.gapMd),
          TextFormField(
            controller: notesController,
            decoration: const InputDecoration(labelText: '备注'),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class WorkOrderProductListSection extends StatelessWidget {
  const WorkOrderProductListSection({
    super.key,
    required this.drafts,
    required this.products,
    required this.onAdd,
    required this.onRemove,
  });

  final List<WorkOrderProductDraft> drafts;
  final List<ProductOption> products;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '产品清单',
      child: Column(
        children: [
          for (var index = 0; index < drafts.length; index++)
            WorkOrderProductRow(
              draft: drafts[index],
              products: products,
              onRemove: drafts.length > 1 ? () => onRemove(index) : null,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('新增产品'),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkOrderMaterialListSection extends StatelessWidget {
  const WorkOrderMaterialListSection({
    super.key,
    required this.drafts,
    required this.materials,
    required this.onAdd,
    required this.onRemove,
  });

  final List<WorkOrderMaterialDraft> drafts;
  final List<MaterialItem> materials;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '物料清单',
      child: Column(
        children: [
          for (var index = 0; index < drafts.length; index++)
            WorkOrderMaterialRow(
              draft: drafts[index],
              materials: materials,
              onRemove: () => onRemove(index),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('新增物料'),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkOrderResourcesSection extends StatelessWidget {
  const WorkOrderResourcesSection({
    super.key,
    required this.printingType,
    required this.printingCmyk,
    required this.printingOtherColorsController,
    required this.artworks,
    required this.artworkIds,
    required this.dies,
    required this.dieIds,
    required this.foilingPlates,
    required this.foilingPlateIds,
    required this.embossingPlates,
    required this.embossingPlateIds,
    required this.onPrintingTypeChanged,
    required this.onToggleCmyk,
    required this.onSelectionChanged,
  });

  final String printingType;
  final Set<String> printingCmyk;
  final TextEditingController printingOtherColorsController;
  final List<Artwork> artworks;
  final Set<int> artworkIds;
  final List<Die> dies;
  final Set<int> dieIds;
  final List<FoilingPlate> foilingPlates;
  final Set<int> foilingPlateIds;
  final List<EmbossingPlate> embossingPlates;
  final Set<int> embossingPlateIds;
  final ValueChanged<String?> onPrintingTypeChanged;
  final ValueChanged<String> onToggleCmyk;
  final VoidCallback onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '印刷与版信息',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < Breakpoints.lg;
          final columnSpacing = LayoutTokens.gapLg;
          final leftColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchableDropdownFormField<String>(
                initialValue: printingType,
                decoration: const InputDecoration(labelText: '印刷形式'),
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('不需要印刷')),
                  DropdownMenuItem(value: 'front', child: Text('正面印刷')),
                  DropdownMenuItem(value: 'back', child: Text('背面印刷')),
                  DropdownMenuItem(
                    value: 'self_reverse',
                    child: Text('自反印刷'),
                  ),
                  DropdownMenuItem(
                    value: 'reverse_gripper',
                    child: Text('反咬口印刷'),
                  ),
                  DropdownMenuItem(value: 'register', child: Text('套版印刷')),
                ],
                onChanged: onPrintingTypeChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
              const WorkOrderFormSubsectionTitle(title: 'CMYK 颜色'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['C', 'M', 'Y', 'K']
                    .map(
                      (color) => FilterChip(
                        label: Text(color),
                        selected: printingCmyk.contains(color),
                        onSelected: (_) => onToggleCmyk(color),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: LayoutTokens.gapMd),
              TextFormField(
                controller: printingOtherColorsController,
                decoration: const InputDecoration(labelText: '其他颜色（逗号分隔）'),
              ),
            ],
          );

          final rightColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WorkOrderFormSubsectionTitle(title: '图稿'),
              const SizedBox(height: 8),
              WorkOrderMultiSelectChips(
                items: artworks
                    .map(
                      (item) => WorkOrderOptionItem(
                        item.id,
                        item.fullCode.isNotEmpty ? item.fullCode : item.name,
                      ),
                    )
                    .toList(),
                selected: artworkIds,
                emptyText: '暂无图稿数据',
                title: '图稿',
                placeholder: '请选择图稿（可多选）',
                onChanged: onSelectionChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
              const WorkOrderFormSubsectionTitle(title: '刀模'),
              const SizedBox(height: 8),
              WorkOrderMultiSelectChips(
                items: dies
                    .map(
                      (item) => WorkOrderOptionItem(
                        item.id,
                        item.code?.isNotEmpty == true
                            ? '${item.name} (${item.code})'
                            : item.name,
                      ),
                    )
                    .toList(),
                selected: dieIds,
                emptyText: '暂无刀模数据',
                title: '刀模',
                placeholder: '请选择刀模（可多选）',
                onChanged: onSelectionChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
              const WorkOrderFormSubsectionTitle(title: '烫金版'),
              const SizedBox(height: 8),
              WorkOrderMultiSelectChips(
                items: foilingPlates
                    .map(
                      (item) => WorkOrderOptionItem(
                        item.id,
                        item.code?.isNotEmpty == true
                            ? '${item.name} (${item.code})'
                            : item.name,
                      ),
                    )
                    .toList(),
                selected: foilingPlateIds,
                emptyText: '暂无烫金版数据',
                title: '烫金版',
                placeholder: '请选择烫金版（可多选）',
                onChanged: onSelectionChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
              const WorkOrderFormSubsectionTitle(title: '压凸版'),
              const SizedBox(height: 8),
              WorkOrderMultiSelectChips(
                items: embossingPlates
                    .map(
                      (item) => WorkOrderOptionItem(
                        item.id,
                        item.code?.isNotEmpty == true
                            ? '${item.name} (${item.code})'
                            : item.name,
                      ),
                    )
                    .toList(),
                selected: embossingPlateIds,
                emptyText: '暂无压凸版数据',
                title: '压凸版',
                placeholder: '请选择压凸版（可多选）',
                onChanged: onSelectionChanged,
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftColumn,
                SizedBox(height: columnSpacing),
                rightColumn,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: leftColumn),
              SizedBox(width: columnSpacing),
              Expanded(child: rightColumn),
            ],
          );
        },
      ),
    );
  }
}
