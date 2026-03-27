// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseOrderDetailImpl _$$PurchaseOrderDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseOrderDetailImpl(
      id: _intFromJson(json['id']),
      orderNumber: _stringFromJson(json['order_number']),
      supplierId: _intOrNullFromJson(json['supplier']),
      supplierName: _stringOrNullFromJson(json['supplier_name']),
      supplierContact: _stringOrNullFromJson(json['supplier_contact']),
      supplierPhone: _stringOrNullFromJson(json['supplier_phone']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      totalAmount: _doubleOrNullFromJson(json['total_amount']),
      submittedByName: _stringOrNullFromJson(json['submitted_by_name']),
      submittedAt: _dateTimeOrNullFromJson(json['submitted_at']),
      approvedByName: _stringOrNullFromJson(json['approved_by_name']),
      approvedAt: _dateTimeOrNullFromJson(json['approved_at']),
      workOrderId: _intOrNullFromJson(json['work_order']),
      workOrderNumber: _stringOrNullFromJson(json['work_order_number']),
      expectedDate: _dateTimeOrNullFromJson(json['expected_date']),
      orderedDate: _dateTimeOrNullFromJson(json['ordered_date']),
      actualReceivedDate: _dateTimeOrNullFromJson(json['actual_received_date']),
      notes: _stringOrNullFromJson(json['notes']),
      rejectionReason: _stringOrNullFromJson(json['rejection_reason']),
      createdAt: _dateTimeOrNullFromJson(json['created_at']),
      updatedAt: _dateTimeOrNullFromJson(json['updated_at']),
      items: json['items'] == null
          ? const <PurchaseOrderItemDetail>[]
          : _purchaseOrderItemListFromJson(json['items']),
    );

Map<String, dynamic> _$$PurchaseOrderDetailImplToJson(
        _$PurchaseOrderDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'supplier': instance.supplierId,
      'supplier_name': instance.supplierName,
      'supplier_contact': instance.supplierContact,
      'supplier_phone': instance.supplierPhone,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'total_amount': instance.totalAmount,
      'submitted_by_name': instance.submittedByName,
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'approved_by_name': instance.approvedByName,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'work_order': instance.workOrderId,
      'work_order_number': instance.workOrderNumber,
      'expected_date': instance.expectedDate?.toIso8601String(),
      'ordered_date': instance.orderedDate?.toIso8601String(),
      'actual_received_date': instance.actualReceivedDate?.toIso8601String(),
      'notes': instance.notes,
      'rejection_reason': instance.rejectionReason,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
    };

_$PurchaseOrderItemDetailImpl _$$PurchaseOrderItemDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseOrderItemDetailImpl(
      id: _intFromJson(json['id']),
      materialId: _intOrNullFromJson(json['material']),
      materialName: _stringOrNullFromJson(json['material_name']),
      materialCode: _stringOrNullFromJson(json['material_code']),
      materialUnit:
          _stringOrNullFromJson(_readMaterialUnit(json, 'material_unit')),
      supplierCode: _stringOrNullFromJson(json['supplier_code']),
      quantity: _doubleOrNullFromJson(json['quantity']),
      receivedQuantity: _doubleOrNullFromJson(json['received_quantity']),
      remainingQuantity: _doubleOrNullFromJson(json['remaining_quantity']),
      unitPrice: _doubleOrNullFromJson(json['unit_price']),
      subtotal: _doubleOrNullFromJson(json['subtotal']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      notes: _stringOrNullFromJson(json['notes']),
    );

Map<String, dynamic> _$$PurchaseOrderItemDetailImplToJson(
        _$PurchaseOrderItemDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'material': instance.materialId,
      'material_name': instance.materialName,
      'material_code': instance.materialCode,
      'material_unit': instance.materialUnit,
      'supplier_code': instance.supplierCode,
      'quantity': instance.quantity,
      'received_quantity': instance.receivedQuantity,
      'remaining_quantity': instance.remainingQuantity,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'notes': instance.notes,
    };
