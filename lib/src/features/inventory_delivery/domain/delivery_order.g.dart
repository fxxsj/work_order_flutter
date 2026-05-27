// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryOrder _$DeliveryOrderFromJson(Map<String, dynamic> json) =>
    _DeliveryOrder(
      id: _intFromJson(json['id']),
      orderNumber: _stringFromJson(json['order_number']),
      customerId: _intOrNullFromJson(_readCustomerId(json, 'customer_id')),
      customerName: _stringOrNullFromJson(json['customer_name']),
      salesOrderId: _intOrNullFromJson(
        _readSalesOrderId(json, 'sales_order_id'),
      ),
      salesOrderNumber: _stringOrNullFromJson(json['sales_order_number']),
      deliveryDate: _dateTimeOrNullFromJson(json['delivery_date']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      itemsCount: _intOrNullFromJson(json['items_count']),
      totalQuantity: _doubleOrNullFromJson(json['total_quantity']),
      invoiceCount: _intOrNullFromJson(json['invoice_count']),
      logisticsCompany: _stringOrNullFromJson(json['logistics_company']),
      trackingNumber: _stringOrNullFromJson(json['tracking_number']),
      exceptionResolution: _stringOrNullFromJson(json['exception_resolution']),
      exceptionResolutionDisplay: _stringOrNullFromJson(
        json['exception_resolution_display'],
      ),
      exceptionResolutionNotes: _stringOrNullFromJson(
        json['exception_resolution_notes'],
      ),
      exceptionClosed: _boolOrNullFromJson(json['exception_closed']),
    );

Map<String, dynamic> _$DeliveryOrderToJson(_DeliveryOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'customer_id': instance.customerId,
      'customer_name': instance.customerName,
      'sales_order_id': instance.salesOrderId,
      'sales_order_number': instance.salesOrderNumber,
      'delivery_date': instance.deliveryDate?.toIso8601String(),
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'items_count': instance.itemsCount,
      'total_quantity': instance.totalQuantity,
      'invoice_count': instance.invoiceCount,
      'logistics_company': instance.logisticsCompany,
      'tracking_number': instance.trackingNumber,
      'exception_resolution': instance.exceptionResolution,
      'exception_resolution_display': instance.exceptionResolutionDisplay,
      'exception_resolution_notes': instance.exceptionResolutionNotes,
      'exception_closed': instance.exceptionClosed,
    };
