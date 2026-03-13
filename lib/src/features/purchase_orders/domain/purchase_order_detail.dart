import 'package:work_order_app/src/core/utils/parse_utils.dart';

class PurchaseOrderDetail {
  const PurchaseOrderDetail({
    required this.id,
    required this.orderNumber,
    this.supplierId,
    this.supplierName,
    this.supplierContact,
    this.supplierPhone,
    this.status,
    this.statusDisplay,
    this.totalAmount,
    this.submittedByName,
    this.submittedAt,
    this.approvedByName,
    this.approvedAt,
    this.workOrderId,
    this.workOrderNumber,
    this.expectedDate,
    this.orderedDate,
    this.actualReceivedDate,
    this.notes,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  final int id;
  final String orderNumber;
  final int? supplierId;
  final String? supplierName;
  final String? supplierContact;
  final String? supplierPhone;
  final String? status;
  final String? statusDisplay;
  final double? totalAmount;
  final String? submittedByName;
  final DateTime? submittedAt;
  final String? approvedByName;
  final DateTime? approvedAt;
  final int? workOrderId;
  final String? workOrderNumber;
  final DateTime? expectedDate;
  final DateTime? orderedDate;
  final DateTime? actualReceivedDate;
  final String? notes;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PurchaseOrderItemDetail> items;

  factory PurchaseOrderDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderDetail(
      id: toInt(json['id']) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      supplierId: toInt(json['supplier']),
      supplierName: toStringOrNull(json['supplier_name']),
      supplierContact: toStringOrNull(json['supplier_contact']),
      supplierPhone: toStringOrNull(json['supplier_phone']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      totalAmount: _toDouble(json['total_amount']),
      submittedByName: toStringOrNull(json['submitted_by_name']),
      submittedAt: toDateTime(json['submitted_at']),
      approvedByName: toStringOrNull(json['approved_by_name']),
      approvedAt: toDateTime(json['approved_at']),
      workOrderId: toInt(json['work_order']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      expectedDate: toDateTime(json['expected_date']),
      orderedDate: toDateTime(json['ordered_date']),
      actualReceivedDate: toDateTime(json['actual_received_date']),
      notes: toStringOrNull(json['notes']),
      rejectionReason: toStringOrNull(json['rejection_reason']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
      items: _parseItems(json['items']),
    );
  }

  static List<PurchaseOrderItemDetail> _parseItems(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => PurchaseOrderItemDetail.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class PurchaseOrderItemDetail {
  const PurchaseOrderItemDetail({
    required this.id,
    this.materialId,
    this.materialName,
    this.materialCode,
    this.materialUnit,
    this.supplierCode,
    this.quantity,
    this.receivedQuantity,
    this.remainingQuantity,
    this.unitPrice,
    this.subtotal,
    this.status,
    this.statusDisplay,
    this.notes,
  });

  final int id;
  final int? materialId;
  final String? materialName;
  final String? materialCode;
  final String? materialUnit;
  final String? supplierCode;
  final double? quantity;
  final double? receivedQuantity;
  final double? remainingQuantity;
  final double? unitPrice;
  final double? subtotal;
  final String? status;
  final String? statusDisplay;
  final String? notes;

  factory PurchaseOrderItemDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItemDetail(
      id: toInt(json['id']) ?? 0,
      materialId: toInt(json['material']),
      materialName: toStringOrNull(json['material_name']),
      materialCode: toStringOrNull(json['material_code']),
      materialUnit: toStringOrNull(json['material_unit'] ?? json['unit']),
      supplierCode: toStringOrNull(json['supplier_code']),
      quantity: _toDouble(json['quantity']),
      receivedQuantity: _toDouble(json['received_quantity']),
      remainingQuantity: _toDouble(json['remaining_quantity']),
      unitPrice: _toDouble(json['unit_price']),
      subtotal: _toDouble(json['subtotal']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      notes: toStringOrNull(json['notes']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
