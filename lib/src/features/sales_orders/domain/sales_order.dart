// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'sales_order.freezed.dart';
part 'sales_order.g.dart';

@freezed
abstract class SalesOrder with _$SalesOrder {
  const factory SalesOrder({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'order_number', fromJson: _stringFromJson)
    required String orderNumber,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(name: 'customer_code', fromJson: _stringOrNullFromJson)
    String? customerCode,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
    String? paymentStatus,
    @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
    String? paymentStatusDisplay,
    @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
    double? totalAmount,
    @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? orderDate,
    @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? deliveryDate,
    @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,
    @JsonKey(name: 'work_order_count', fromJson: _intOrNullFromJson)
    int? workOrderCount,
  }) = _SalesOrder;

  factory SalesOrder.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderFromJson(json);
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
