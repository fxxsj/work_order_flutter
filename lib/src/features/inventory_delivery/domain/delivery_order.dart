// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'delivery_order.freezed.dart';
part 'delivery_order.g.dart';

@freezed
abstract class DeliveryOrder with _$DeliveryOrder {
  const factory DeliveryOrder({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson, name: 'order_number')
    required String orderNumber,
    @JsonKey(
      name: 'customer_id',
      readValue: _readCustomerId,
      fromJson: _intOrNullFromJson,
    )
    int? customerId,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(
      name: 'sales_order_id',
      readValue: _readSalesOrderId,
      fromJson: _intOrNullFromJson,
    )
    int? salesOrderId,
    @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
    String? salesOrderNumber,
    @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? deliveryDate,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,
    @JsonKey(name: 'total_quantity', fromJson: _doubleOrNullFromJson)
    double? totalQuantity,
    @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
    int? invoiceCount,
    @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
    String? logisticsCompany,
    @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
    String? trackingNumber,
    @JsonKey(name: 'exception_resolution', fromJson: _stringOrNullFromJson)
    String? exceptionResolution,
    @JsonKey(
      name: 'exception_resolution_display',
      fromJson: _stringOrNullFromJson,
    )
    String? exceptionResolutionDisplay,
    @JsonKey(
      name: 'exception_resolution_notes',
      fromJson: _stringOrNullFromJson,
    )
    String? exceptionResolutionNotes,
    @JsonKey(name: 'exception_closed', fromJson: _boolOrNullFromJson)
    bool? exceptionClosed,
  }) = _DeliveryOrder;

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

double? _doubleOrNullFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

bool? _boolOrNullFromJson(Object? value) {
  if (value is bool) return value;
  final text = value?.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

Object? _readCustomerId(Map json, String key) => json[key] ?? json['customer'];

Object? _readSalesOrderId(Map json, String key) =>
    json[key] ?? json['sales_order'];
