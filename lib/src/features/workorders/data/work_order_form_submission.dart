import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_sections.dart';

class WorkOrderFormSubmissionInput {
  const WorkOrderFormSubmissionInput({
    required this.customerId,
    required this.salesOrderId,
    required this.status,
    required this.priority,
    required this.orderDate,
    required this.deliveryDate,
    required this.actualDeliveryDate,
    required this.productionQuantityText,
    required this.defectiveQuantityText,
    required this.notes,
    required this.printingType,
    required this.printingCmyk,
    required this.printingOtherColorsText,
    required this.productDrafts,
    required this.materialDrafts,
    required this.processIds,
    required this.artworkIds,
    required this.dieIds,
    required this.foilingPlateIds,
    required this.embossingPlateIds,
  });

  final int? customerId;
  final int? salesOrderId;
  final String status;
  final String priority;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final DateTime? actualDeliveryDate;
  final String productionQuantityText;
  final String defectiveQuantityText;
  final String notes;
  final String printingType;
  final Set<String> printingCmyk;
  final String printingOtherColorsText;
  final List<WorkOrderProductDraft> productDrafts;
  final List<WorkOrderMaterialDraft> materialDrafts;
  final Set<int> processIds;
  final Set<int> artworkIds;
  final Set<int> dieIds;
  final Set<int> foilingPlateIds;
  final Set<int> embossingPlateIds;
}

class WorkOrderFormSubmission {
  static String? validate(WorkOrderFormSubmissionInput input) {
    if (input.customerId == null && input.salesOrderId == null) {
      return '请选择客户或客户订单';
    }
    if (input.deliveryDate == null) {
      return '请选择交货日期';
    }
    if (input.orderDate != null &&
        input.deliveryDate != null &&
        input.deliveryDate!.isBefore(input.orderDate!)) {
      return '交货日期不能早于下单日期';
    }
    final productionQuantity = int.tryParse(
      input.productionQuantityText.trim(),
    );
    if (productionQuantity == null || productionQuantity <= 0) {
      return '生产数量必须大于 0';
    }
    final defectiveQuantity = int.tryParse(input.defectiveQuantityText.trim());
    if (defectiveQuantity != null && defectiveQuantity < 0) {
      return '预损数量不能小于 0';
    }
    if (input.productDrafts.every((draft) => draft.productId == null)) {
      return '请至少填写一个产品';
    }
    for (final draft in input.productDrafts) {
      if (draft.productId == null) {
        continue;
      }
      if (draft.sourceType == 'sales_order' && draft.salesOrderItemId == null) {
        return '客户订单来源的产品必须选择来源订单产品';
      }
      if (draft.quantityValue <= 0) {
        return '产品数量必须大于 0';
      }
    }
    for (final draft in input.materialDrafts) {
      if (draft.materialId == null) {
        continue;
      }
      if (draft.usageValue.isEmpty) {
        return '请填写物料用量';
      }
    }
    return null;
  }

  /// 新建时强制 status 为 pending，忽略前端传入值
  static Map<String, dynamic> buildPayload(
    WorkOrderFormSubmissionInput input, {
    bool isCreate = false,
  }) {
    final products = input.productDrafts
        .where((draft) => draft.productId != null)
        .map(
          (draft) => {
            'product': draft.productId,
            'quantity': draft.quantityValue,
            'unit': draft.unitValue,
            'specification': draft.specificationValue,
            'source_type': draft.sourceType,
            'sales_order_item': draft.salesOrderItemId,
            'sort_order': draft.sortOrderValue,
          },
        )
        .toList();

    final materials = input.materialDrafts
        .where((draft) => draft.materialId != null)
        .map(
          (draft) => {
            'material': draft.materialId,
            'material_size': draft.sizeValue,
            'material_usage': draft.usageValue,
            'need_cutting': draft.needCutting,
            'notes': draft.notesValue,
          },
        )
        .toList();

    final otherColors = input.printingOtherColorsText
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    final orderDate = _formatDate(input.orderDate);
    final deliveryDate = _formatDate(input.deliveryDate);
    final actualDeliveryDate = _formatDate(input.actualDeliveryDate);
    final productionQuantity = int.tryParse(
      input.productionQuantityText.trim(),
    );
    final defectiveQuantity = int.tryParse(input.defectiveQuantityText.trim());

    return {
      'customer': input.customerId,
      'sales_order': input.salesOrderId,
      'status': isCreate ? 'pending' : input.status,
      'priority': input.priority,
      'order_date': orderDate.isEmpty ? null : orderDate,
      'delivery_date': deliveryDate.isEmpty ? null : deliveryDate,
      'actual_delivery_date': actualDeliveryDate.isEmpty
          ? null
          : actualDeliveryDate,
      'production_quantity': productionQuantity,
      'defective_quantity': defectiveQuantity,
      'notes': input.notes.trim(),
      'printing_type': input.printingType,
      'printing_cmyk_colors': input.printingCmyk.toList(),
      'printing_other_colors': otherColors,
      'products_data': products,
      'materials_data': materials,
      'processes': input.processIds.toList(),
      'artworks': input.artworkIds.toList(),
      'dies': input.dieIds.toList(),
      'foiling_plates': input.foilingPlateIds.toList(),
      'embossing_plates': input.embossingPlateIds.toList(),
    };
  }

  static String _formatDate(DateTime? value) {
    if (value == null) return '';
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
