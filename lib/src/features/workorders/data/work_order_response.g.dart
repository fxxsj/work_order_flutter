// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkOrderResponse _$WorkOrderResponseFromJson(Map<String, dynamic> json) =>
    _WorkOrderResponse(
      id: _intFromJson(json['id']),
      orderNumber: _stringFromJson(json['order_number']),
      customerName: _stringOrNullFromJson(json['customer_name']),
      salespersonName: _stringOrNullFromJson(json['salesperson_name']),
      productName: _stringOrNullFromJson(json['product_name']),
      quantity: _doubleOrNull_fromJson(json['quantity']),
      unit: _stringOrNullFromJson(json['unit']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      priority: _stringOrNullFromJson(json['priority']),
      priorityDisplay: _stringOrNullFromJson(json['priority_display']),
      orderDate: _dateTimeOrNullFromJson(json['order_date']),
      deliveryDate: _dateTimeOrNullFromJson(json['delivery_date']),
      totalAmount: _doubleOrNull_fromJson(json['total_amount']),
      approvalStatus: _stringOrNullFromJson(json['approval_status']),
      approvalStatusDisplay: _stringOrNullFromJson(
        json['approval_status_display'],
      ),
      managerName: _stringOrNullFromJson(json['manager_name']),
      progressPercentage: _intOrNull_fromJson(json['progress_percentage']),
      totalTaskCount: _intOrNull_fromJson(json['total_task_count']),
      salesOrderId: _intOrNull_fromJson(json['sales_order_id']),
      salesOrderNumber: _stringOrNullFromJson(json['sales_order_number']),
    );

Map<String, dynamic> _$WorkOrderResponseToJson(_WorkOrderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'customer_name': instance.customerName,
      'salesperson_name': instance.salespersonName,
      'product_name': instance.productName,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'priority': instance.priority,
      'priority_display': instance.priorityDisplay,
      'order_date': instance.orderDate?.toIso8601String(),
      'delivery_date': instance.deliveryDate?.toIso8601String(),
      'total_amount': instance.totalAmount,
      'approval_status': instance.approvalStatus,
      'approval_status_display': instance.approvalStatusDisplay,
      'manager_name': instance.managerName,
      'progress_percentage': instance.progressPercentage,
      'total_task_count': instance.totalTaskCount,
      'sales_order_id': instance.salesOrderId,
      'sales_order_number': instance.salesOrderNumber,
    };
