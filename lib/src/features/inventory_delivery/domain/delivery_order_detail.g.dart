// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryOrderDetailImpl _$$DeliveryOrderDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$DeliveryOrderDetailImpl(
      id: _intFromJson(json['id']),
      orderNumber: _stringFromJson(json['order_number']),
      salesOrderId: _intOrNullFromJson(json['sales_order']),
      salesOrderNumber: _stringOrNullFromJson(json['sales_order_number']),
      customerId: _intOrNullFromJson(json['customer']),
      customerName: _stringOrNullFromJson(json['customer_name']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      deliveryDate: _dateTimeOrNullFromJson(json['delivery_date']),
      receiverName: _stringOrNullFromJson(json['receiver_name']),
      receiverPhone: _stringOrNullFromJson(json['receiver_phone']),
      deliveryAddress: _stringOrNullFromJson(json['delivery_address']),
      logisticsCompany: _stringOrNullFromJson(json['logistics_company']),
      trackingNumber: _stringOrNullFromJson(json['tracking_number']),
      freight: _doubleOrNullFromJson(json['freight']),
      packageCount: _intOrNullFromJson(json['package_count']),
      packageWeight: _doubleOrNullFromJson(json['package_weight']),
      receivedDate: _dateTimeOrNullFromJson(json['received_date']),
      receivedNotes: _stringOrNullFromJson(json['received_notes']),
      receiverSignatureUrl: _stringOrNullFromJson(json['receiver_signature']),
      notes: _stringOrNullFromJson(json['notes']),
      invoiceCount: _intOrNullFromJson(json['invoice_count']),
      invoiceNumbers: json['invoice_numbers'] == null
          ? const <String>[]
          : _stringListFromJson(json['invoice_numbers']),
      items: json['items'] == null
          ? const <DeliveryOrderItem>[]
          : _deliveryOrderItemListFromJson(json['items']),
      exceptionResolution: _stringOrNullFromJson(json['exception_resolution']),
      exceptionResolutionDisplay:
          _stringOrNullFromJson(json['exception_resolution_display']),
      exceptionResolutionNotes:
          _stringOrNullFromJson(json['exception_resolution_notes']),
      exceptionClosed: _boolOrNullFromJson(json['exception_closed']),
    );

Map<String, dynamic> _$$DeliveryOrderDetailImplToJson(
        _$DeliveryOrderDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'sales_order': instance.salesOrderId,
      'sales_order_number': instance.salesOrderNumber,
      'customer': instance.customerId,
      'customer_name': instance.customerName,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'delivery_date': instance.deliveryDate?.toIso8601String(),
      'receiver_name': instance.receiverName,
      'receiver_phone': instance.receiverPhone,
      'delivery_address': instance.deliveryAddress,
      'logistics_company': instance.logisticsCompany,
      'tracking_number': instance.trackingNumber,
      'freight': instance.freight,
      'package_count': instance.packageCount,
      'package_weight': instance.packageWeight,
      'received_date': instance.receivedDate?.toIso8601String(),
      'received_notes': instance.receivedNotes,
      'receiver_signature': instance.receiverSignatureUrl,
      'notes': instance.notes,
      'invoice_count': instance.invoiceCount,
      'invoice_numbers': instance.invoiceNumbers,
      'items': instance.items,
      'exception_resolution': instance.exceptionResolution,
      'exception_resolution_display': instance.exceptionResolutionDisplay,
      'exception_resolution_notes': instance.exceptionResolutionNotes,
      'exception_closed': instance.exceptionClosed,
    };

_$DeliveryOrderItemImpl _$$DeliveryOrderItemImplFromJson(
        Map<String, dynamic> json) =>
    _$DeliveryOrderItemImpl(
      id: _intFromJson(json['id']),
      productId: _intOrNullFromJson(json['product']),
      productName: _stringOrNullFromJson(json['product_name']),
      productCode: _stringOrNullFromJson(json['product_code']),
      quantity: _doubleOrNullFromJson(json['quantity']),
      unit: _stringOrNullFromJson(json['unit']),
      unitPrice: _doubleOrNullFromJson(json['unit_price']),
      subtotal: _doubleOrNullFromJson(json['subtotal']),
      stockBatch: _stringOrNullFromJson(json['stock_batch']),
      notes: _stringOrNullFromJson(json['notes']),
    );

Map<String, dynamic> _$$DeliveryOrderItemImplToJson(
        _$DeliveryOrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.productId,
      'product_name': instance.productName,
      'product_code': instance.productCode,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
      'stock_batch': instance.stockBatch,
      'notes': instance.notes,
    };
