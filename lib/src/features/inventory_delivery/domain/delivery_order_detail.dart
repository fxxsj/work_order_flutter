// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'delivery_order_detail.freezed.dart';
part 'delivery_order_detail.g.dart';

@freezed
abstract class DeliveryOrderDetail with _$DeliveryOrderDetail {
  const factory DeliveryOrderDetail({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'order_number', fromJson: _stringFromJson)
    required String orderNumber,
    @JsonKey(name: 'sales_order', fromJson: _intOrNullFromJson)
    int? salesOrderId,
    @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
    String? salesOrderNumber,
    @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? deliveryDate,
    @JsonKey(name: 'receiver_name', fromJson: _stringOrNullFromJson)
    String? receiverName,
    @JsonKey(name: 'receiver_phone', fromJson: _stringOrNullFromJson)
    String? receiverPhone,
    @JsonKey(name: 'delivery_address', fromJson: _stringOrNullFromJson)
    String? deliveryAddress,
    @JsonKey(name: 'logistics_company', fromJson: _stringOrNullFromJson)
    String? logisticsCompany,
    @JsonKey(name: 'tracking_number', fromJson: _stringOrNullFromJson)
    String? trackingNumber,
    @JsonKey(fromJson: _doubleOrNullFromJson) double? freight,
    @JsonKey(name: 'package_count', fromJson: _intOrNullFromJson)
    int? packageCount,
    @JsonKey(name: 'package_weight', fromJson: _doubleOrNullFromJson)
    double? packageWeight,
    @JsonKey(name: 'received_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? receivedDate,
    @JsonKey(name: 'received_notes', fromJson: _stringOrNullFromJson)
    String? receivedNotes,
    @JsonKey(name: 'receiver_signature', fromJson: _stringOrNullFromJson)
    String? receiverSignatureUrl,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
    @JsonKey(name: 'invoice_count', fromJson: _intOrNullFromJson)
    int? invoiceCount,
    @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> invoiceNumbers,
    @JsonKey(name: 'items', fromJson: _deliveryOrderItemListFromJson)
    @Default(<DeliveryOrderItem>[])
    List<DeliveryOrderItem> items,
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
  }) = _DeliveryOrderDetail;

  factory DeliveryOrderDetail.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderDetailFromJson(json);
}

@freezed
abstract class DeliveryOrderItem with _$DeliveryOrderItem {
  const factory DeliveryOrderItem({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,
    @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
    String? productName,
    @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
    String? productCode,
    @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
    @JsonKey(fromJson: _stringOrNullFromJson) String? unit,
    @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
    double? unitPrice,
    @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
    double? subtotal,
    @JsonKey(name: 'stock_batch', fromJson: _stringOrNullFromJson)
    String? stockBatch,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
  }) = _DeliveryOrderItem;

  factory DeliveryOrderItem.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderItemFromJson(json);
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

List<DeliveryOrderItem> _deliveryOrderItemListFromJson(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map(
        (item) => DeliveryOrderItem.fromJson(Map<String, dynamic>.from(item)),
      )
      .toList(growable: false);
}

List<String> _stringListFromJson(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList(growable: false);
}
