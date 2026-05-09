import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_card.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_draft.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_row_widgets.dart';

/// Material list section for work order form.
class WorkOrderMaterialListSection extends StatelessWidget {
  const WorkOrderMaterialListSection({
    super.key,
    required this.drafts,
    required this.materials,
    required this.onAdd,
    required this.onRemove,
    this.onCreateMaterial,
  });

  final List<WorkOrderMaterialDraft> drafts;
  final List<MaterialItem> materials;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final Future<MaterialItem?> Function()? onCreateMaterial;

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
              onCreateMaterial: onCreateMaterial,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: PageActionButton.outlined(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 16),
              label: '新增物料',
            ),
          ),
        ],
      ),
    );
  }
}
