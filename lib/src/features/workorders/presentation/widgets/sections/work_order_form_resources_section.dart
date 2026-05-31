import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_card.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_draft.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_row_widgets.dart';

/// Resources section (printing, artwork, dies, plates) for work order form.
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
    required this.requiredResources,
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
  /// Which prepress resources are required based on selected processes.
  /// Contains 'die', 'foiling', 'embossing'.
  final Set<String> requiredResources;
  final ValueChanged<String?> onPrintingTypeChanged;
  final ValueChanged<String> onToggleCmyk;
  final VoidCallback onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final showPrintingDetails = printingType != 'none';
    return WorkOrderFormSectionCard(
      title: '印刷与版信息',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < Breakpoints.lg;
          final columnSpacing = LayoutTokens.gapLg;
          final leftColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSelect<String>(
                value: printingType,
                options: const [
                  AppDropdownOption(value: 'none', label: '不需要印刷'),
                  AppDropdownOption(value: 'front', label: '正面印刷'),
                  AppDropdownOption(value: 'back', label: '背面印刷'),
                  AppDropdownOption(value: 'self_reverse', label: '自反印刷'),
                  AppDropdownOption(value: 'reverse_gripper', label: '反咬口印刷'),
                  AppDropdownOption(value: 'register', label: '套版印刷'),
                ],
                decoration: const InputDecoration(labelText: '印刷形式'),
                onChanged: (value) => onPrintingTypeChanged(value),
              ),
              if (showPrintingDetails) ...[
                SizedBox(height: LayoutTokens.gapMd),
                const WorkOrderFormSubsectionTitle(title: '图稿'),
                SizedBox(height: LayoutTokens.gapSm),
                WorkOrderMultiSelectField(
                  items: artworks
                      .map(
                        (item) {
                          final productNames = item.products
                              .map((p) => p.productName)
                              .where((n) => n.isNotEmpty)
                              .take(3)
                              .join(', ');
                          final label = item.fullCode.isNotEmpty
                              ? item.fullCode
                              : item.name;
                          final fullLabel = productNames.isNotEmpty
                              ? '$label ($productNames)'
                              : label;
                          return WorkOrderOptionItem(item.id, fullLabel);
                        },
                      )
                      .toList(),
                  selected: artworkIds,
                  emptyText: '暂无图稿数据',
                  placeholder: '请选择（可多选）',
                  onChanged: onSelectionChanged,
                ),
                SizedBox(height: LayoutTokens.gapMd),
                const WorkOrderFormSubsectionTitle(title: 'CMYK 颜色'),
                SizedBox(height: LayoutTokens.gapSm),
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
                CrudFieldConfig.text(
                  label: '其他颜色（逗号分隔）',
                  controller: printingOtherColorsController,
                ).build(context),
              ],
            ],
          );

          final rightColumnChildren = <Widget>[];

          if (requiredResources.contains('die')) {
            rightColumnChildren.addAll([
              const WorkOrderFormSubsectionTitle(title: '刀模'),
              SizedBox(height: LayoutTokens.gapSm),
              WorkOrderMultiSelectField(
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
                placeholder: '请选择（可多选）',
                onChanged: onSelectionChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
            ]);
          }

          if (requiredResources.contains('foiling')) {
            rightColumnChildren.addAll([
              const WorkOrderFormSubsectionTitle(title: '烫金版'),
              SizedBox(height: LayoutTokens.gapSm),
              WorkOrderMultiSelectField(
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
                placeholder: '请选择（可多选）',
                onChanged: onSelectionChanged,
              ),
              SizedBox(height: LayoutTokens.gapMd),
            ]);
          }

          if (requiredResources.contains('embossing')) {
            rightColumnChildren.addAll([
              const WorkOrderFormSubsectionTitle(title: '压凸版'),
              SizedBox(height: LayoutTokens.gapSm),
              WorkOrderMultiSelectField(
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
                placeholder: '请选择（可多选）',
                onChanged: onSelectionChanged,
              ),
            ]);
          }

          final rightColumn = rightColumnChildren.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rightColumnChildren,
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
