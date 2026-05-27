// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseOrder _$PurchaseOrderFromJson(Map<String, dynamic> json) =>
    _PurchaseOrder(
      id: _intFromJson(json['id']),
      orderNumber: _stringFromJson(json['order_number']),
      supplierName: _stringOrNullFromJson(json['supplier_name']),
      supplierCode: _stringOrNullFromJson(json['supplier_code']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      totalAmount: _doubleOrNullFromJson(json['total_amount']),
      itemsCount: _intOrNullFromJson(json['items_count']),
      receivedProgress: _doubleOrNullFromJson(json['received_progress']),
      workOrderNumber: _stringOrNullFromJson(json['work_order_number']),
      orderedDate: _dateTimeOrNullFromJson(json['ordered_date']),
      expectedDate: _dateTimeOrNullFromJson(json['expected_date']),
      actualReceivedDate: _dateTimeOrNullFromJson(json['actual_received_date']),
      submittedByName: _stringOrNullFromJson(json['submitted_by_name']),
      approvedByName: _stringOrNullFromJson(json['approved_by_name']),
      createdAt: _dateTimeOrNullFromJson(json['created_at']),
      submittedAt: _dateTimeOrNullFromJson(json['submitted_at']),
      approvedAt: _dateTimeOrNullFromJson(json['approved_at']),
    );

Map<String, dynamic> _$PurchaseOrderToJson(_PurchaseOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'supplier_name': instance.supplierName,
      'supplier_code': instance.supplierCode,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'total_amount': instance.totalAmount,
      'items_count': instance.itemsCount,
      'received_progress': instance.receivedProgress,
      'work_order_number': instance.workOrderNumber,
      'ordered_date': instance.orderedDate?.toIso8601String(),
      'expected_date': instance.expectedDate?.toIso8601String(),
      'actual_received_date': instance.actualReceivedDate?.toIso8601String(),
      'submitted_by_name': instance.submittedByName,
      'approved_by_name': instance.approvedByName,
      'created_at': instance.createdAt?.toIso8601String(),
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'approved_at': instance.approvedAt?.toIso8601String(),
    };
