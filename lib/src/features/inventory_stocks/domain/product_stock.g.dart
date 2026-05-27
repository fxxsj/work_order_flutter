// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductStock _$ProductStockFromJson(Map<String, dynamic> json) =>
    _ProductStock(
      id: _intFromJson(json['id']),
      productName: _stringOrNullFromJson(json['product_name']),
      productCode: _stringOrNullFromJson(json['product_code']),
      customerName: _stringOrNullFromJson(json['customer_name']),
      batchNo: _stringOrNullFromJson(json['batch_no']),
      workOrderNumber: _stringOrNullFromJson(json['work_order_number']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      quantity: _doubleOrNullFromJson(json['quantity']),
      reservedQuantity: _doubleOrNullFromJson(json['reserved_quantity']),
      availableQuantity: _doubleOrNullFromJson(json['available_quantity']),
      minStockLevel: _intOrNullFromJson(json['min_stock_level']),
      location: _stringOrNullFromJson(json['location']),
      productionDate: _dateTimeOrNullFromJson(json['production_date']),
      unitCost: _doubleOrNullFromJson(json['unit_cost']),
      totalValue: _doubleOrNullFromJson(json['total_value']),
      isLowStock: _boolOrNullFromJson(json['is_low_stock']),
      expiryDate: _dateTimeOrNullFromJson(json['expiry_date']),
      daysUntilExpiry: _intOrNullFromJson(json['days_until_expiry']),
      createdAt: _dateTimeOrNullFromJson(json['created_at']),
      notes: _stringOrNullFromJson(json['notes']),
    );

Map<String, dynamic> _$ProductStockToJson(_ProductStock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'product_code': instance.productCode,
      'customer_name': instance.customerName,
      'batch_no': instance.batchNo,
      'work_order_number': instance.workOrderNumber,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'quantity': instance.quantity,
      'reserved_quantity': instance.reservedQuantity,
      'available_quantity': instance.availableQuantity,
      'min_stock_level': instance.minStockLevel,
      'location': instance.location,
      'production_date': instance.productionDate?.toIso8601String(),
      'unit_cost': instance.unitCost,
      'total_value': instance.totalValue,
      'is_low_stock': instance.isLowStock,
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'days_until_expiry': instance.daysUntilExpiry,
      'created_at': instance.createdAt?.toIso8601String(),
      'notes': instance.notes,
    };
