import 'package:work_order_app/src/core/utils/parse_utils.dart';

class WorkOrderDetail {
  const WorkOrderDetail({
    required this.id,
    required this.orderNumber,
    this.customerId,
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
    this.orderDate,
    this.deliveryDate,
    this.actualDeliveryDate,
    this.productionQuantity,
    this.defectiveQuantity,
    this.totalAmount,
    this.printingType,
    this.printingTypeDisplay,
    this.printingColorsDisplay,
    this.notes,
    this.progressPercentage,
    this.draftTaskCount,
    this.totalTaskCount,
    this.products = const [],
    this.materials = const [],
    this.processes = const [],
    this.approvalLogs = const [],
    this.artworkIds = const [],
    this.dieIds = const [],
    this.foilingPlateIds = const [],
    this.embossingPlateIds = const [],
  });

  final int id;
  final String orderNumber;
  final int? customerId;
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
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final DateTime? actualDeliveryDate;
  final int? productionQuantity;
  final int? defectiveQuantity;
  final double? totalAmount;
  final String? printingType;
  final String? printingTypeDisplay;
  final String? printingColorsDisplay;
  final String? notes;
  final int? progressPercentage;
  final int? draftTaskCount;
  final int? totalTaskCount;
  final List<WorkOrderProductItem> products;
  final List<WorkOrderMaterialItem> materials;
  final List<WorkOrderProcessItem> processes;
  final List<WorkOrderApprovalLog> approvalLogs;
  final List<int> artworkIds;
  final List<int> dieIds;
  final List<int> foilingPlateIds;
  final List<int> embossingPlateIds;

  factory WorkOrderDetail.fromJson(Map<String, dynamic> json) {
    return WorkOrderDetail(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      customerId: toInt(json['customer']),
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
      orderDate: toDateTime(json['order_date']),
      deliveryDate: toDateTime(json['delivery_date']),
      actualDeliveryDate: toDateTime(json['actual_delivery_date']),
      productionQuantity: toInt(json['production_quantity']),
      defectiveQuantity: toInt(json['defective_quantity']),
      totalAmount: _toDouble(json['total_amount']),
      printingType: toStringOrNull(json['printing_type']),
      printingTypeDisplay: toStringOrNull(json['printing_type_display']),
      printingColorsDisplay: toStringOrNull(json['printing_colors_display']),
      notes: toStringOrNull(json['notes']),
      progressPercentage: toInt(json['progress_percentage']),
      draftTaskCount: toInt(json['draft_task_count']),
      totalTaskCount: toInt(json['total_task_count']),
      products: _parseProducts(json['products']),
      materials: _parseMaterials(json['materials']),
      processes: _parseProcesses(json['order_processes']),
      approvalLogs: _parseApprovalLogs(json['approval_logs']),
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

  static List<WorkOrderProductItem> _parseProducts(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderProductItem>[];
    for (final item in value) {
      if (item is Map) {
        items.add(WorkOrderProductItem.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }

  static List<WorkOrderMaterialItem> _parseMaterials(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderMaterialItem>[];
    for (final item in value) {
      if (item is Map) {
        items.add(WorkOrderMaterialItem.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }

  static List<WorkOrderProcessItem> _parseProcesses(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderProcessItem>[];
    for (final item in value) {
      if (item is Map) {
        items.add(WorkOrderProcessItem.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }

  static List<WorkOrderApprovalLog> _parseApprovalLogs(dynamic value) {
    if (value is! List) return const [];
    final items = <WorkOrderApprovalLog>[];
    for (final item in value) {
      if (item is Map) {
        items.add(WorkOrderApprovalLog.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }
}

class WorkOrderProductItem {
  const WorkOrderProductItem({
    required this.id,
    this.productId,
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

  factory WorkOrderMaterialItem.fromJson(Map<String, dynamic> json) {
    return WorkOrderMaterialItem(
      id: toInt(json['id']) ?? 0,
      materialId: toInt(json['material']),
      materialName: toStringOrNull(json['material_name']),
      materialCode: toStringOrNull(json['material_code']),
      materialUnit: toStringOrNull(json['material_unit']),
      materialSize: toStringOrNull(json['material_size']),
      materialUsage: toStringOrNull(json['material_usage']),
      needCutting: json['need_cutting'] == null ? null : json['need_cutting'] == true,
      notes: toStringOrNull(json['notes']),
      purchaseStatus: toStringOrNull(json['purchase_status']),
      purchaseStatusDisplay: toStringOrNull(json['purchase_status_display']),
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

  factory WorkOrderProcessItem.fromJson(Map<String, dynamic> json) {
    final tasks = json['tasks'];
    final count = tasks is List ? tasks.length : null;
    return WorkOrderProcessItem(
      id: toInt(json['id']) ?? 0,
      processId: toInt(json['process']),
      processName: toStringOrNull(json['process_name']),
      processCode: toStringOrNull(json['process_code']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      operatorName: toStringOrNull(json['operator_name']),
      departmentName: toStringOrNull(json['department_name']),
      canStart: json['can_start'] == null ? null : json['can_start'] == true,
      tasksCount: count,
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
