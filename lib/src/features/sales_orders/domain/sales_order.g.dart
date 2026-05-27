// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesOrder _$SalesOrderFromJson(Map<String, dynamic> json) => _SalesOrder(
  id: _intFromJson(json['id']),
  orderNumber: _stringFromJson(json['order_number']),
  customerName: _stringOrNullFromJson(json['customer_name']),
  customerCode: _stringOrNullFromJson(json['customer_code']),
  status: _stringOrNullFromJson(json['status']),
  statusDisplay: _stringOrNullFromJson(json['status_display']),
  paymentStatus: _stringOrNullFromJson(json['payment_status']),
  paymentStatusDisplay: _stringOrNullFromJson(json['payment_status_display']),
  totalAmount: _doubleOrNullFromJson(json['total_amount']),
  orderDate: _dateTimeOrNullFromJson(json['order_date']),
  deliveryDate: _dateTimeOrNullFromJson(json['delivery_date']),
  itemsCount: _intOrNullFromJson(json['items_count']),
  workOrderCount: _intOrNullFromJson(json['work_order_count']),
);

Map<String, dynamic> _$SalesOrderToJson(_SalesOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'customer_name': instance.customerName,
      'customer_code': instance.customerCode,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'payment_status': instance.paymentStatus,
      'payment_status_display': instance.paymentStatusDisplay,
      'total_amount': instance.totalAmount,
      'order_date': instance.orderDate?.toIso8601String(),
      'delivery_date': instance.deliveryDate?.toIso8601String(),
      'items_count': instance.itemsCount,
      'work_order_count': instance.workOrderCount,
    };
