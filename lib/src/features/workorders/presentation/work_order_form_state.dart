import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_form_submission.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/work_order_form_sections.dart';

class WorkOrderFormDraftState {
  WorkOrderFormDraftState() {
    orderDate = DateTime.now();
    orderDateController.text = formatDate(orderDate);
    addProductDraft();
  }

  final TextEditingController notesController = TextEditingController();
  final TextEditingController printingOtherColorsController =
      TextEditingController();
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController productionQuantityController =
      TextEditingController();
  final TextEditingController defectiveQuantityController =
      TextEditingController();
  final TextEditingController actualDeliveryDateController =
      TextEditingController();

  DateTime? orderDate;
  DateTime? deliveryDate;
  DateTime? actualDeliveryDate;

  int? customerId;
  int? salesOrderId;
  String status = 'pending';
  String priority = 'normal';
  String printingType = 'none';
  final Set<String> printingCmyk = {};

  final List<WorkOrderProductDraft> productDrafts = [];
  final List<WorkOrderMaterialDraft> materialDrafts = [];
  final Set<int> processIds = {};
  final Set<int> initialProcessIds = {};
  final Set<int> artworkIds = {};
  final Set<int> dieIds = {};
  final Set<int> foilingPlateIds = {};
  final Set<int> embossingPlateIds = {};

  void dispose() {
    notesController.dispose();
    printingOtherColorsController.dispose();
    orderDateController.dispose();
    deliveryDateController.dispose();
    productionQuantityController.dispose();
    defectiveQuantityController.dispose();
    actualDeliveryDateController.dispose();
    _disposeProductDrafts();
    _disposeMaterialDrafts();
  }

  void applyDetail(WorkOrderDetail detail) {
    customerId = detail.customerId;
    salesOrderId = detail.salesOrderId;
    status = detail.status ?? status;
    priority = detail.priority ?? priority;
    setOrderDate(detail.orderDate);
    setDeliveryDate(detail.deliveryDate);
    setActualDeliveryDate(detail.actualDeliveryDate);
    productionQuantityController.text =
        detail.productionQuantity?.toString() ?? '';
    defectiveQuantityController.text =
        detail.defectiveQuantity?.toString() ?? '';
    printingType = detail.printingType ?? printingType;
    printingCmyk
      ..clear()
      ..addAll(detail.printingCmykColors);
    printingOtherColorsController.text = detail.printingOtherColors.join(', ');
    notesController.text = detail.notes ?? '';

    _replaceProductDrafts(
      detail.products.map(WorkOrderProductDraft.fromDetail).toList(),
    );
    _replaceMaterialDrafts(
      detail.materials.map(WorkOrderMaterialDraft.fromDetail).toList(),
    );

    processIds
      ..clear()
      ..addAll(detail.processes.map((item) => item.processId).whereType<int>());
    initialProcessIds
      ..clear()
      ..addAll(processIds);
    artworkIds
      ..clear()
      ..addAll(detail.artworkIds);
    dieIds
      ..clear()
      ..addAll(detail.dieIds);
    foilingPlateIds
      ..clear()
      ..addAll(detail.foilingPlateIds);
    embossingPlateIds
      ..clear()
      ..addAll(detail.embossingPlateIds);
  }

  void addProductDraft() {
    productDrafts.add(WorkOrderProductDraft());
  }

  void removeProductDraftAt(int index) {
    final draft = productDrafts.removeAt(index);
    draft.dispose();
  }

  void addMaterialDraft() {
    materialDrafts.add(WorkOrderMaterialDraft());
  }

  void removeMaterialDraftAt(int index) {
    final draft = materialDrafts.removeAt(index);
    draft.dispose();
  }

  void setOrderDate(DateTime? value) {
    orderDate = value;
    orderDateController.text = formatDate(value);
  }

  void setDeliveryDate(DateTime? value) {
    deliveryDate = value;
    deliveryDateController.text = formatDate(value);
  }

  void setActualDeliveryDate(DateTime? value) {
    actualDeliveryDate = value;
    actualDeliveryDateController.text = formatDate(value);
  }

  WorkOrderFormSubmissionInput submissionInput() {
    return WorkOrderFormSubmissionInput(
      customerId: customerId,
      salesOrderId: salesOrderId,
      status: status,
      priority: priority,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      actualDeliveryDate: actualDeliveryDate,
      productionQuantityText: productionQuantityController.text,
      defectiveQuantityText: defectiveQuantityController.text,
      notes: notesController.text,
      printingType: printingType,
      printingCmyk: printingCmyk,
      printingOtherColorsText: printingOtherColorsController.text,
      productDrafts: productDrafts,
      materialDrafts: materialDrafts,
      processIds: processIds,
      artworkIds: artworkIds,
      dieIds: dieIds,
      foilingPlateIds: foilingPlateIds,
      embossingPlateIds: embossingPlateIds,
    );
  }

  void autoFillFromArtworks(
    List<Artwork> selectedArtworks,
    List<Product> fullProducts,
  ) {
    if (selectedArtworks.isEmpty) return;

    // 1. Merge CMYK colors
    for (final artwork in selectedArtworks) {
      for (final color in artwork.cmykColors) {
        printingCmyk.add(color);
      }
    }

    // 2. Merge other colors
    final existingOther = printingOtherColorsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();
    for (final artwork in selectedArtworks) {
      for (final color in artwork.otherColors) {
        existingOther.add(color);
      }
    }
    printingOtherColorsController.text = existingOther.join(', ');

    // 3. Merge die IDs
    for (final artwork in selectedArtworks) {
      dieIds.addAll(artwork.dieIds);
    }

    // 4. Merge foiling plate IDs
    for (final artwork in selectedArtworks) {
      foilingPlateIds.addAll(artwork.foilingPlateIds);
    }

    // 5. Merge embossing plate IDs
    for (final artwork in selectedArtworks) {
      embossingPlateIds.addAll(artwork.embossingPlateIds);
    }

    // 6. Auto-add products from artworks
    final existingProductIds =
        productDrafts.map((d) => d.productId).whereType<int>().toSet();
    for (final artwork in selectedArtworks) {
      for (final ap in artwork.products) {
        if (!existingProductIds.contains(ap.productId)) {
          final draft = WorkOrderProductDraft()..productId = ap.productId;
          productDrafts.add(draft);
          existingProductIds.add(ap.productId);
        }
      }
    }

    // 7. Auto-fill processes & materials from all current products
    _autoFillProcessesAndMaterials(fullProducts);
  }

  void autoFillFromProducts(List<Product> fullProducts) {
    _autoFillProcessesAndMaterials(fullProducts);
  }

  void _autoFillProcessesAndMaterials(List<Product> fullProducts) {
    final selectedProductIds =
        productDrafts.map((d) => d.productId).whereType<int>().toSet();

    final productMap = <int, Product>{};
    for (final p in fullProducts) {
      productMap[p.id] = p;
    }

    // Merge process IDs
    for (final pid in selectedProductIds) {
      final product = productMap[pid];
      if (product != null) {
        processIds.addAll(product.defaultProcessIds);
      }
    }

    // Merge material drafts
    final existingMaterialIds =
        materialDrafts.map((d) => d.materialId).whereType<int>().toSet();
    for (final pid in selectedProductIds) {
      final product = productMap[pid];
      if (product != null) {
        for (final dm in product.defaultMaterials) {
          if (!existingMaterialIds.contains(dm.materialId)) {
            final draft = WorkOrderMaterialDraft()
              ..materialId = dm.materialId
              ..sizeController.text = dm.materialSize ?? ''
              ..usageController.text = dm.materialUsage ?? ''
              ..needCutting = dm.needCutting ?? false
              ..notesController.text = dm.notes ?? '';
            materialDrafts.add(draft);
            existingMaterialIds.add(dm.materialId);
          }
        }
      }
    }
  }

  bool hasProcessChanges() {
    if (initialProcessIds.length != processIds.length) {
      return true;
    }
    for (final id in processIds) {
      if (!initialProcessIds.contains(id)) {
        return true;
      }
    }
    return false;
  }

  static String formatDate(DateTime? value) {
    if (value == null) {
      return '';
    }
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void _replaceProductDrafts(List<WorkOrderProductDraft> drafts) {
    _disposeProductDrafts();
    productDrafts
      ..clear()
      ..addAll(drafts);
    if (productDrafts.isEmpty) {
      addProductDraft();
    }
  }

  void _replaceMaterialDrafts(List<WorkOrderMaterialDraft> drafts) {
    _disposeMaterialDrafts();
    materialDrafts
      ..clear()
      ..addAll(drafts);
  }

  void _disposeProductDrafts() {
    for (final draft in productDrafts) {
      draft.dispose();
    }
  }

  void _disposeMaterialDrafts() {
    for (final draft in materialDrafts) {
      draft.dispose();
    }
  }
}
