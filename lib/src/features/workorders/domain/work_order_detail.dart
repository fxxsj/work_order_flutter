import 'package:work_order_app/src/core/models/traceability_summary_item.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';

class WorkOrderDetail {
  const WorkOrderDetail({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.salesOrderId,
    this.designFileUrl,
    this.customerName,
    this.salespersonName,
    this.managerName,
    this.createdByName,
    this.approvedByName,
    this.status,
    this.statusDisplay,
    this.priority,
    this.priorityDisplay,
    this.approvalStatus,
    this.approvalStatusDisplay,
    this.approvalComment,
    this.rejectionReason,
    this.orderDate,
    this.deliveryDate,
    this.actualDeliveryDate,
    this.productionQuantity,
    this.defectiveQuantity,
    this.totalAmount,
    this.printingType,
    this.printingTypeDisplay,
    this.printingColorsDisplay,
    this.printingCmykColors = const [],
    this.printingOtherColors = const [],
    this.notes,
    this.progressPercentage,
    this.totalTaskCount,
    this.salesOrderNumbers = const [],
    this.qualityInspectionNumbers = const [],
    this.invoiceNumbers = const [],
    this.salesOrderTotalAmount,
    this.salesOrderPaidAmount,
    this.salesOrderUnpaidAmount,
    this.settledSalesOrderCount,
    this.unsettledSalesOrderCount,
    this.invoiceCount,
    this.salesOrderSummaries = const [],
    this.qualityInspectionSummaries = const [],
    this.invoiceSummaries = const [],
    this.purchaseOrderSummaries = const [],
    this.products = const [],
    this.materials = const [],
    this.processes = const [],
    this.approvalLogs = const [],
    this.artworkNames = const [],
    this.artworkCodes = const [],
    this.dieNames = const [],
    this.dieCodes = const [],
    this.foilingPlateNames = const [],
    this.foilingPlateCodes = const [],
    this.embossingPlateNames = const [],
    this.embossingPlateCodes = const [],
    this.artworkIds = const [],
    this.dieIds = const [],
    this.foilingPlateIds = const [],
    this.embossingPlateIds = const [],
  });

  final int id;
  final String orderNumber;
  final int? customerId;
  final int? salesOrderId;
  final String? designFileUrl;
  final String? customerName;
  final String? salespersonName;
  final String? managerName;
  final String? createdByName;
  final String? approvedByName;
  final String? status;
  final String? statusDisplay;
  final String? priority;
  final String? priorityDisplay;
  final String? approvalStatus;
  final String? approvalStatusDisplay;
  final String? approvalComment;
  final String? rejectionReason;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final DateTime? actualDeliveryDate;
  final int? productionQuantity;
  final int? defectiveQuantity;
  final double? totalAmount;
  final String? printingType;
  final String? printingTypeDisplay;
  final String? printingColorsDisplay;
  final List<String> printingCmykColors;
  final List<String> printingOtherColors;
  final String? notes;
  final int? progressPercentage;
  final int? totalTaskCount;
  final List<String> salesOrderNumbers;
  final List<String> qualityInspectionNumbers;
  final List<String> invoiceNumbers;
  final double? salesOrderTotalAmount;
  final double? salesOrderPaidAmount;
  final double? salesOrderUnpaidAmount;
  final int? settledSalesOrderCount;
  final int? unsettledSalesOrderCount;
  final int? invoiceCount;
  final List<TraceabilitySummaryItem> salesOrderSummaries;
  final List<TraceabilitySummaryItem> qualityInspectionSummaries;
  final List<TraceabilitySummaryItem> invoiceSummaries;
  final List<TraceabilitySummaryItem> purchaseOrderSummaries;
  final List<WorkOrderProductItem> products;
  final List<WorkOrderMaterialItem> materials;
  final List<WorkOrderProcessItem> processes;
  final List<WorkOrderApprovalLog> approvalLogs;
  final List<String> artworkNames;
  final List<String> artworkCodes;
  final List<String> dieNames;
  final List<String> dieCodes;
  final List<String> foilingPlateNames;
  final List<String> foilingPlateCodes;
  final List<String> embossingPlateNames;
  final List<String> embossingPlateCodes;
  final List<int> artworkIds;
  final List<int> dieIds;
  final List<int> foilingPlateIds;
  final List<int> embossingPlateIds;

  factory WorkOrderDetail.fromJson(Map<String, dynamic> json) {
    return WorkOrderDetail(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      customerId: toInt(json['customer']),
      salesOrderId: toInt(json['sales_order']),
      designFileUrl: toStringOrNull(json['design_file']),
      customerName: toStringOrNull(json['customer_name']),
      salespersonName: toStringOrNull(json['salesperson_name']),
      managerName: toStringOrNull(json['manager_name']),
      createdByName: toStringOrNull(json['created_by_name']),
      approvedByName: toStringOrNull(json['approved_by_name']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      priority: toStringOrNull(json['priority']),
      priorityDisplay: toStringOrNull(json['priority_display']),
      approvalStatus: toStringOrNull(json['approval_status']),
      approvalStatusDisplay: toStringOrNull(json['approval_status_display']),
      approvalComment: toStringOrNull(json['approval_comment']),
      rejectionReason: toStringOrNull(json['rejection_reason']),
      orderDate: toDateTime(json['order_date']),
      deliveryDate: toDateTime(json['delivery_date']),
      actualDeliveryDate: toDateTime(json['actual_delivery_date']),
      productionQuantity: toInt(json['production_quantity']),
      defectiveQuantity: toInt(json['defective_quantity']),
      totalAmount: _toDouble(json['total_amount']),
      printingType: toStringOrNull(json['printing_type']),
      printingTypeDisplay: toStringOrNull(json['printing_type_display']),
      printingColorsDisplay: toStringOrNull(json['printing_colors_display']),
      printingCmykColors: _parseStringList(json['printing_cmyk_colors']),
      printingOtherColors: _parseStringList(json['printing_other_colors']),
      notes: toStringOrNull(json['notes']),
      progressPercentage: toInt(json['progress_percentage']),
      totalTaskCount: toInt(json['total_task_count']),
      salesOrderNumbers: _parseStringList(json['sales_order_numbers']),
      qualityInspectionNumbers: _parseStringList(
        json['quality_inspection_numbers'],
      ),
      invoiceNumbers: _parseStringList(json['invoice_numbers']),
      salesOrderTotalAmount: _toDouble(json['sales_order_total_amount']),
      salesOrderPaidAmount: _toDouble(json['sales_order_paid_amount']),
      salesOrderUnpaidAmount: _toDouble(json['sales_order_unpaid_amount']),
      settledSalesOrderCount: toInt(json['settled_sales_order_count']),
      unsettledSalesOrderCount: toInt(json['unsettled_sales_order_count']),
      invoiceCount: toInt(json['invoice_count']),
      salesOrderSummaries: _parseSummaryList(
        json['sales_order_summaries'],
        fallbackNumbers: json['sales_order_numbers'],
      ),
      qualityInspectionSummaries: _parseSummaryList(
        json['quality_inspection_summaries'],
        fallbackNumbers: json['quality_inspection_numbers'],
      ),
      invoiceSummaries: _parseSummaryList(
        json['invoice_summaries'],
        fallbackNumbers: json['invoice_numbers'],
      ),
      purchaseOrderSummaries: _parseSummaryList(
        json['purchase_order_summaries'],
      ),
      products: _parseProducts(json['products']),
      materials: _parseMaterials(json['materials']),
      processes: _parseProcesses(json['order_processes']),
      approvalLogs: _parseApprovalLogs(json['approval_logs']),
      artworkNames: _parseStringList(json['artwork_names']),
      artworkCodes: _parseStringList(json['artwork_codes']),
      dieNames: _parseStringList(json['die_names']),
      dieCodes: _parseStringList(json['die_codes']),
      foilingPlateNames: _parseStringList(json['foiling_plate_names']),
      foilingPlateCodes: _parseStringList(json['foiling_plate_codes']),
      embossingPlateNames: _parseStringList(json['embossing_plate_names']),
      embossingPlateCodes: _parseStringList(json['embossing_plate_codes']),
      artworkIds: _parseIdList(json['artworks']),
      dieIds: _parseIdList(json['dies']),
      foilingPlateIds: _parseIdList(json['foiling_plates']),
      embossingPlateIds: _parseIdList(json['embossing_plates']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static List<int> _parseIdList(dynamic value) {
    if (value is! List) return const [];
    final ids = <int>[];
    for (final item in value) {
      int? id;
      if (item is Map) {
        id = toInt(item['id']) ?? toInt(item['pk']) ?? toInt(item['value']);
      } else {
        id = toInt(item);
      }
      if (id != null && id > 0) ids.add(id);
    }
    return ids;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }

  static List<TraceabilitySummaryItem> _parseSummaryList(
    dynamic value, {
    dynamic fallbackNumbers,
  }) {
    final items = TraceabilitySummaryItem.parseList(value);
    if (items.isNotEmpty) return items;
    return _parseStringList(
      fallbackNumbers,
    ).map((number) => TraceabilitySummaryItem(number: number)).toList();
  }

  static List<WorkOrderProductItem> _parseProducts(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderProductItem>[];
    for (final item in value) {
      if (item is Map) {
        items.add(
          WorkOrderProductItem.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return items;
  }

  static List<WorkOrderMaterialItem> _parseMaterials(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderMaterialItem>[];
    for (final item in value) {
      if (item is Map) {
        items.add(
          WorkOrderMaterialItem.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return items;
  }

  static List<WorkOrderProcessItem> _parseProcesses(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderProcessItem>[];
    for (final item in value) {
      if (item is Map) {
        items.add(
          WorkOrderProcessItem.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return items;
  }

  static List<WorkOrderApprovalLog> _parseApprovalLogs(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderApprovalLog>[];
    for (final item in value) {
      if (item is Map) {
        items.add(
          WorkOrderApprovalLog.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return items;
  }
}

class WorkOrderProductItem {
  const WorkOrderProductItem({
    required this.id,
    this.productId,
    this.sourceType,
    this.sourceTypeDisplay,
    this.salesOrderItemId,
    this.sourceSalesOrderId,
    this.sourceSalesOrderNumber,
    this.productName,
    this.productCode,
    this.quantity,
    this.unit,
    this.specification,
    this.sortOrder,
    this.impositionQuantity,
  });

  final int id;
  final int? productId;
  final String? sourceType;
  final String? sourceTypeDisplay;
  final int? salesOrderItemId;
  final int? sourceSalesOrderId;
  final String? sourceSalesOrderNumber;
  final String? productName;
  final String? productCode;
  final double? quantity;
  final String? unit;
  final String? specification;
  final int? sortOrder;
  final int? impositionQuantity;

  factory WorkOrderProductItem.fromJson(Map<String, dynamic> json) {
    return WorkOrderProductItem(
      id: toInt(json['id']) ?? 0,
      productId: toInt(json['product']),
      sourceType: toStringOrNull(json['source_type']),
      sourceTypeDisplay: toStringOrNull(json['source_type_display']),
      salesOrderItemId: toInt(json['sales_order_item']),
      sourceSalesOrderId: toInt(json['source_sales_order_id']),
      sourceSalesOrderNumber: toStringOrNull(json['source_sales_order_number']),
      productName: toStringOrNull(json['product_name']),
      productCode: toStringOrNull(json['product_code']),
      quantity: WorkOrderDetail._toDouble(json['quantity']),
      unit: toStringOrNull(json['unit']),
      specification: toStringOrNull(json['specification']),
      sortOrder: toInt(json['sort_order']),
      impositionQuantity: toInt(json['imposition_quantity']),
    );
  }
}

class WorkOrderMaterialItem {
  const WorkOrderMaterialItem({
    required this.id,
    this.materialId,
    this.materialName,
    this.materialCode,
    this.materialUnit,
    this.materialSize,
    this.materialUsage,
    this.needCutting,
    this.notes,
    this.purchaseStatus,
    this.purchaseStatusDisplay,
    this.purchaseDate,
    this.receivedDate,
    this.cutDate,
    this.planningRequired = false,
    this.calculationMode = 'fixed',
    this.calculationModeDisplay,
    this.preparationMode = 'direct',
    this.preparationModeDisplay,
    this.planningStatus,
    this.planningStatusDisplay,
    this.purchaseMaterialId,
    this.purchaseMaterialName,
    this.purchaseMaterialIsTemporary = false,
    this.purchaseMaterialSupplier,
    this.purchaseMaterialUnitPrice,
    this.procurementMaterialId,
    this.procurementMaterialName,
    this.procurementMaterialCode,
    this.procurementMaterialSpecification,
    this.procurementMaterialUnit,
    this.procurementSupplierId,
    this.procurementSupplierName,
    this.procurementQuantity,
    this.procurementReady = false,
    this.procurementBlockReason,
    this.parentSheetWidthMm,
    this.parentSheetHeightMm,
    this.cutWidthMm,
    this.cutHeightMm,
    this.requiredCutQuantity,
    this.piecesPerParentSheet,
    this.plannedParentQuantity,
    this.plannedMaterialQuantity,
    this.wastageRate,
    this.reservedQuantity,
    this.purchaseQuantity,
  });

  final int id;
  final int? materialId;
  final String? materialName;
  final String? materialCode;
  final String? materialUnit;
  final String? materialSize;
  final String? materialUsage;
  final bool? needCutting;
  final String? notes;
  final String? purchaseStatus;
  final String? purchaseStatusDisplay;
  final DateTime? purchaseDate;
  final DateTime? receivedDate;
  final DateTime? cutDate;
  final bool planningRequired;
  final String calculationMode;
  final String? calculationModeDisplay;
  final String preparationMode;
  final String? preparationModeDisplay;
  final String? planningStatus;
  final String? planningStatusDisplay;
  final int? purchaseMaterialId;
  final String? purchaseMaterialName;
  final bool purchaseMaterialIsTemporary;
  final int? purchaseMaterialSupplier;
  final double? purchaseMaterialUnitPrice;
  final int? procurementMaterialId;
  final String? procurementMaterialName;
  final String? procurementMaterialCode;
  final String? procurementMaterialSpecification;
  final String? procurementMaterialUnit;
  final int? procurementSupplierId;
  final String? procurementSupplierName;
  final double? procurementQuantity;
  final bool procurementReady;
  final String? procurementBlockReason;
  final double? parentSheetWidthMm;
  final double? parentSheetHeightMm;
  final double? cutWidthMm;
  final double? cutHeightMm;
  final double? requiredCutQuantity;
  final int? piecesPerParentSheet;
  final double? plannedParentQuantity;
  final double? plannedMaterialQuantity;
  final double? wastageRate;
  final double? reservedQuantity;
  final double? purchaseQuantity;

  factory WorkOrderMaterialItem.fromJson(Map<String, dynamic> json) {
    return WorkOrderMaterialItem(
      id: toInt(json['id']) ?? 0,
      materialId: toInt(json['material']),
      materialName: toStringOrNull(json['material_name']),
      materialCode: toStringOrNull(json['material_code']),
      materialUnit: toStringOrNull(json['material_unit']),
      materialSize: toStringOrNull(json['material_size']),
      materialUsage: toStringOrNull(json['material_usage']),
      needCutting: json['need_cutting'] == null
          ? null
          : json['need_cutting'] == true,
      notes: toStringOrNull(json['notes']),
      purchaseStatus: toStringOrNull(json['purchase_status']),
      purchaseStatusDisplay: toStringOrNull(json['purchase_status_display']),
      purchaseDate: toDateTime(json['purchase_date']),
      receivedDate: toDateTime(json['received_date']),
      cutDate: toDateTime(json['cut_date']),
      planningRequired:
          json['calculation_mode'] == 'sheet_imposition' ||
          json['calculation_mode'] == 'specification_selection' ||
          json['planning_required'] == true,
      calculationMode:
          toStringOrNull(json['calculation_mode']) ??
          (json['planning_required'] == true ? 'sheet_imposition' : 'fixed'),
      calculationModeDisplay: toStringOrNull(json['calculation_mode_display']),
      preparationMode:
          toStringOrNull(json['preparation_mode']) ??
          (json['need_cutting'] == true
              ? 'internal_cutting'
              : (json['planning_required'] == true
                    ? 'supplier_cutting'
                    : 'direct')),
      preparationModeDisplay: toStringOrNull(json['preparation_mode_display']),
      planningStatus: toStringOrNull(json['planning_status']),
      planningStatusDisplay: toStringOrNull(json['planning_status_display']),
      purchaseMaterialId: toInt(json['purchase_material']),
      purchaseMaterialName: toStringOrNull(json['purchase_material_name']),
      purchaseMaterialIsTemporary:
          json['purchase_material_is_temporary'] == true,
      purchaseMaterialSupplier: toInt(json['purchase_material_supplier']),
      purchaseMaterialUnitPrice: WorkOrderDetail._toDouble(
        json['purchase_material_unit_price'],
      ),
      procurementMaterialId: toInt(json['procurement_material_id']),
      procurementMaterialName: toStringOrNull(
        json['procurement_material_name'],
      ),
      procurementMaterialCode: toStringOrNull(
        json['procurement_material_code'],
      ),
      procurementMaterialSpecification: toStringOrNull(
        json['procurement_material_specification'],
      ),
      procurementMaterialUnit: toStringOrNull(
        json['procurement_material_unit'],
      ),
      procurementSupplierId: toInt(json['procurement_supplier_id']),
      procurementSupplierName: toStringOrNull(
        json['procurement_supplier_name'],
      ),
      procurementQuantity: WorkOrderDetail._toDouble(
        json['procurement_quantity'],
      ),
      procurementReady: json['procurement_ready'] == true,
      procurementBlockReason: toStringOrNull(json['procurement_block_reason']),
      parentSheetWidthMm: WorkOrderDetail._toDouble(
        json['parent_sheet_width_mm'],
      ),
      parentSheetHeightMm: WorkOrderDetail._toDouble(
        json['parent_sheet_height_mm'],
      ),
      cutWidthMm: WorkOrderDetail._toDouble(json['cut_width_mm']),
      cutHeightMm: WorkOrderDetail._toDouble(json['cut_height_mm']),
      requiredCutQuantity: WorkOrderDetail._toDouble(
        json['required_cut_quantity'],
      ),
      piecesPerParentSheet: toInt(json['pieces_per_parent_sheet']),
      plannedParentQuantity: WorkOrderDetail._toDouble(
        json['planned_parent_quantity'],
      ),
      plannedMaterialQuantity: WorkOrderDetail._toDouble(
        json['planned_material_quantity'],
      ),
      wastageRate: WorkOrderDetail._toDouble(json['wastage_rate']),
      reservedQuantity: WorkOrderDetail._toDouble(json['reserved_quantity']),
      purchaseQuantity: WorkOrderDetail._toDouble(json['purchase_quantity']),
    );
  }
}

class WorkOrderProcessItem {
  const WorkOrderProcessItem({
    required this.id,
    this.processId,
    this.processName,
    this.processCode,
    this.status,
    this.statusDisplay,
    this.operatorName,
    this.departmentName,
    this.canStart,
    this.tasksCount,
    this.sequence,
    this.plannedStartTime,
    this.plannedEndTime,
    this.actualStartTime,
    this.actualEndTime,
    this.tasks = const [],
  });

  final int id;
  final int? processId;
  final String? processName;
  final String? processCode;
  final String? status;
  final String? statusDisplay;
  final String? operatorName;
  final String? departmentName;
  final bool? canStart;
  final int? tasksCount;
  final int? sequence;
  final DateTime? plannedStartTime;
  final DateTime? plannedEndTime;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final List<Task> tasks;

  factory WorkOrderProcessItem.fromJson(Map<String, dynamic> json) {
    final tasks = json['tasks'];
    final count = tasks is List ? tasks.length : null;
    final processId = toInt(json['process']);
    final processName = toStringOrNull(json['process_name']);
    final processCode = toStringOrNull(json['process_code']);
    return WorkOrderProcessItem(
      id: toInt(json['id']) ?? 0,
      processId: processId,
      processName: processName,
      processCode: processCode,
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      operatorName: toStringOrNull(json['operator_name']),
      departmentName: toStringOrNull(json['department_name']),
      canStart: json['can_start'] == null ? null : json['can_start'] == true,
      tasksCount: count,
      sequence: toInt(json['sequence']),
      plannedStartTime: toDateTime(json['planned_start_time']),
      plannedEndTime: toDateTime(json['planned_end_time']),
      actualStartTime: toDateTime(json['actual_start_time']),
      actualEndTime: toDateTime(json['actual_end_time']),
      tasks: tasks is List
          ? tasks.whereType<Map>().map((item) {
              final taskJson = Map<String, dynamic>.from(item);
              taskJson.putIfAbsent('process_id', () => processId);
              taskJson.putIfAbsent('process_name', () => processName);
              taskJson.putIfAbsent('process_code', () => processCode);
              return Task.fromJson(taskJson);
            }).toList()
          : const [],
    );
  }
}

class WorkOrderApprovalLog {
  const WorkOrderApprovalLog({
    required this.id,
    this.approvalStatus,
    this.approvalStatusDisplay,
    this.approvedByName,
    this.approvedAt,
    this.approvalComment,
    this.rejectionReason,
  });

  final int id;
  final String? approvalStatus;
  final String? approvalStatusDisplay;
  final String? approvedByName;
  final DateTime? approvedAt;
  final String? approvalComment;
  final String? rejectionReason;

  factory WorkOrderApprovalLog.fromJson(Map<String, dynamic> json) {
    return WorkOrderApprovalLog(
      id: toInt(json['id']) ?? 0,
      approvalStatus: toStringOrNull(json['approval_status']),
      approvalStatusDisplay: toStringOrNull(json['approval_status_display']),
      approvedByName: toStringOrNull(json['approved_by_name']),
      approvedAt: toDateTime(json['approved_at']),
      approvalComment: toStringOrNull(json['approval_comment']),
      rejectionReason: toStringOrNull(json['rejection_reason']),
    );
  }
}
