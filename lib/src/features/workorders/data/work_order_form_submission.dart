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

/// 工序的简化属性，用于前端校验时判断是否需要印前资源。
class ProcessCheckItem {
  const ProcessCheckItem({
    required this.id,
    required this.name,
    this.requiresArtwork = false,
    this.requiresDie = false,
    this.requiresFoilingPlate = false,
    this.requiresEmbossingPlate = false,
  });

  final int id;
  final String name;
  final bool requiresArtwork;
  final bool requiresDie;
  final bool requiresFoilingPlate;
  final bool requiresEmbossingPlate;
}

class WorkOrderFormSubmission {
  /// 校验表单完整性，返回所有错误信息列表。为空则校验通过。
  static List<String> validate(
    WorkOrderFormSubmissionInput input, {
    List<ProcessCheckItem>? processes,
  }) {
    final errors = <String>[];

    // 基本信息
    if (input.customerId == null && input.salesOrderId == null) {
      errors.add('缺少客户信息');
    }
    if (input.deliveryDate == null) {
      errors.add('缺少交货日期');
    }
    if (input.orderDate != null &&
        input.deliveryDate != null &&
        input.deliveryDate!.isBefore(input.orderDate!)) {
      errors.add('交货日期不能早于下单日期');
    }
    final productionQuantity = int.tryParse(
      input.productionQuantityText.trim(),
    );
    if (productionQuantity == null || productionQuantity <= 0) {
      errors.add('缺少生产数量');
    }
    final defectiveQuantity = int.tryParse(input.defectiveQuantityText.trim());
    if (defectiveQuantity != null && defectiveQuantity < 0) {
      errors.add('预损数量不能小于 0');
    }

    // 产品
    final validProducts = input.productDrafts
        .where((draft) => draft.productId != null)
        .toList();
    if (validProducts.isEmpty) {
      errors.add('缺少产品信息');
    } else {
      final totalProductQuantity = validProducts
          .map((d) => d.quantityValue)
          .fold<int>(0, (sum, q) => sum + q);
      if (totalProductQuantity <= 0) {
        errors.add('产品数量总和必须大于0');
      }
      for (final draft in validProducts) {
        if (draft.sourceType == 'sales_order' &&
            draft.salesOrderItemId == null) {
          errors.add('客户订单来源的产品必须选择来源订单产品');
          break;
        }
      }
    }

    // 工序
    if (input.processIds.isEmpty) {
      errors.add('缺少工序信息');
    }

    // 印前资源匹配（需要工序属性）
    if (processes != null && input.processIds.isNotEmpty) {
      final selected = processes
          .where((p) => input.processIds.contains(p.id))
          .toList();

      final artworkProcesses =
          selected.where((p) => p.requiresArtwork).toList();
      if (artworkProcesses.isNotEmpty && input.artworkIds.isEmpty) {
        final names = artworkProcesses.map((p) => p.name).join(', ');
        errors.add('选择了需要图稿的工序（$names），请至少选择一个图稿');
      }

      final dieProcesses = selected.where((p) => p.requiresDie).toList();
      if (dieProcesses.isNotEmpty && input.dieIds.isEmpty) {
        final names = dieProcesses.map((p) => p.name).join(', ');
        errors.add('选择了需要刀模的工序（$names），请至少选择一个刀模');
      }

      final foilingProcesses =
          selected.where((p) => p.requiresFoilingPlate).toList();
      if (foilingProcesses.isNotEmpty && input.foilingPlateIds.isEmpty) {
        final names = foilingProcesses.map((p) => p.name).join(', ');
        errors.add('选择了需要烫金版的工序（$names），请至少选择一个烫金版');
      }

      final embossingProcesses =
          selected.where((p) => p.requiresEmbossingPlate).toList();
      if (embossingProcesses.isNotEmpty && input.embossingPlateIds.isEmpty) {
        final names = embossingProcesses.map((p) => p.name).join(', ');
        errors.add('选择了需要压凸版的工序（$names），请至少选择一个压凸版');
      }
    }

    // 物料用量
    for (final draft in input.materialDrafts) {
      if (draft.materialId == null) continue;
      if (draft.needCutting && draft.usageValue.isEmpty) {
        errors.add('需要开料的物料请填写物料用量');
        break;
      }
    }

    return errors;
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
