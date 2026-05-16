// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'purchase_order_detail.freezed.dart';
part 'purchase_order_detail.g.dart';

@freezed
class PurchaseOrderDetail with _$PurchaseOrderDetail {
  const factory PurchaseOrderDetail({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'order_number', fromJson: _stringFromJson)
    required String orderNumber,
    @JsonKey(name: 'supplier', fromJson: _intOrNullFromJson) int? supplierId,
    @JsonKey(name: 'supplier_name', fromJson: _stringOrNullFromJson)
    String? supplierName,
    @JsonKey(name: 'supplier_contact', fromJson: _stringOrNullFromJson)
    String? supplierContact,
    @JsonKey(name: 'supplier_phone', fromJson: _stringOrNullFromJson)
    String? supplierPhone,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
    double? totalAmount,
    @JsonKey(name: 'submitted_by_name', fromJson: _stringOrNullFromJson)
    String? submittedByName,
    @JsonKey(name: 'submitted_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? submittedAt,
    @JsonKey(name: 'approved_by_name', fromJson: _stringOrNullFromJson)
    String? approvedByName,
    @JsonKey(name: 'approved_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? approvedAt,
    @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,
    @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
    String? workOrderNumber,
    @JsonKey(name: 'expected_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? expectedDate,
    @JsonKey(name: 'ordered_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? orderedDate,
    @JsonKey(name: 'actual_received_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? actualReceivedDate,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
    @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
    String? rejectionReason,
    @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeOrNullFromJson)
    DateTime? updatedAt,
    @JsonKey(name: 'items', fromJson: _purchaseOrderItemListFromJson)
    @Default(<PurchaseOrderItemDetail>[])
    List<PurchaseOrderItemDetail> items,
  }) = _PurchaseOrderDetail;

  factory PurchaseOrderDetail.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderDetailFromJson(json);
}

@freezed
class PurchaseOrderItemDetail with _$PurchaseOrderItemDetail {
  const factory PurchaseOrderItemDetail({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'material', fromJson: _intOrNullFromJson) int? materialId,
    @JsonKey(name: 'material_name', fromJson: _stringOrNullFromJson)
    String? materialName,
    @JsonKey(name: 'material_code', fromJson: _stringOrNullFromJson)
    String? materialCode,
    @JsonKey(
      name: 'material_unit',
      readValue: _readMaterialUnit,
      fromJson: _stringOrNullFromJson,
    )
    String? materialUnit,
    @JsonKey(name: 'supplier_code', fromJson: _stringOrNullFromJson)
    String? supplierCode,
    @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
    @JsonKey(name: 'received_quantity', fromJson: _doubleOrNullFromJson)
    double? receivedQuantity,
    @JsonKey(name: 'remaining_quantity', fromJson: _doubleOrNullFromJson)
    double? remainingQuantity,
    @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
    double? unitPrice,
    @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
    double? subtotal,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
    @JsonKey(name: 'work_order_material', fromJson: _intOrNullFromJson)
    int? workOrderMaterialId,
  }) = _PurchaseOrderItemDetail;

  factory PurchaseOrderItemDetail.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderItemDetailFromJson(json);
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

List<PurchaseOrderItemDetail> _purchaseOrderItemListFromJson(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map(
        (item) =>
            PurchaseOrderItemDetail.fromJson(Map<String, dynamic>.from(item)),
      )
      .toList(growable: false);
}

Object? _readMaterialUnit(Map json, String key) => json[key] ?? json['unit'];
