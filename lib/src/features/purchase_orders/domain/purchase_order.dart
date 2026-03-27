// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'purchase_order.freezed.dart';
part 'purchase_order.g.dart';

@freezed
class PurchaseOrder with _$PurchaseOrder {
  const factory PurchaseOrder({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'order_number', fromJson: _stringFromJson)
    required String orderNumber,
    @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
    String? supplierName,
    @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
    String? supplierCode,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
    double? totalAmount,
    @JsonKey(name: 'items_count', fromJson: _intOrNullFromJson) int? itemsCount,
    @JsonKey(name: 'received_progress', fromJson: _doubleOrNullFromJson)
    double? receivedProgress,
    @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
    String? workOrderNumber,
    @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? orderDate,
    @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
    String? submittedByName,
    @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
    String? approvedByName,
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? submittedAt,
    @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? approvedAt,
  }) = _PurchaseOrder;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderFromJson(json);
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
