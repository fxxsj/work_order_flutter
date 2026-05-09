import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

/// Option item for work order forms.
class WorkOrderOptionItem {
  const WorkOrderOptionItem(this.id, this.label);

  final int id;
  final String label;
}

/// Draft model for work order product items.
class WorkOrderProductDraft {
  WorkOrderProductDraft()
      : quantityController = TextEditingController(text: '1'),
        unitController = TextEditingController(text: '件'),
        specController = TextEditingController(),
        sortOrderController = TextEditingController(text: '0');

  WorkOrderProductDraft.fromDetail(WorkOrderProductItem item)
      : productId = item.productId,
        sourceType = item.sourceType ?? 'stock',
        sourceSalesOrderId = item.sourceSalesOrderId,
        salesOrderItemId = item.salesOrderItemId,
        quantityController =
            TextEditingController(text: item.quantity?.toString() ?? '1'),
        unitController = TextEditingController(text: item.unit ?? '件'),
        specController = TextEditingController(text: item.specification ?? ''),
        sortOrderController =
            TextEditingController(text: item.sortOrder?.toString() ?? '0');

  int? productId;
  String sourceType = 'stock';
  int? sourceSalesOrderId;
  int? salesOrderItemId;
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

/// Draft model for work order material items.
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
