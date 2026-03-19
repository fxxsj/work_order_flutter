import 'package:flutter/material.dart';
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
