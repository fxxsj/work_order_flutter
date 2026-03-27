// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseOrderImpl _$$PurchaseOrderImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseOrderImpl(
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
      orderDate: _dateTimeOrNullFromJson(json['order_date']),
      submittedByName: _stringOrNullFromJson(json['submitted_by_name']),
      approvedByName: _stringOrNullFromJson(json['approved_by_name']),
      createdAt: _dateTimeOrNullFromJson(json['created_at']),
      submittedAt: _dateTimeOrNullFromJson(json['submitted_at']),
      approvedAt: _dateTimeOrNullFromJson(json['approved_at']),
    );

Map<String, dynamic> _$$PurchaseOrderImplToJson(_$PurchaseOrderImpl instance) =>
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
      'order_date': instance.orderDate?.toIso8601String(),
      'submitted_by_name': instance.submittedByName,
      'approved_by_name': instance.approvedByName,
      'created_at': instance.createdAt?.toIso8601String(),
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'approved_at': instance.approvedAt?.toIso8601String(),
    };
