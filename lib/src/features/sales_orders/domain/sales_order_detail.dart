// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/models/traceability_summary_item.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'sales_order_detail.freezed.dart';
part 'sales_order_detail.g.dart';

@freezed
class SalesOrderDetail with _$SalesOrderDetail {
  const factory SalesOrderDetail({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'order_number', fromJson: _stringFromJson)
    required String orderNumber,
    @JsonKey(name: 'customer', fromJson: _intOrNullFromJson) int? customerId,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(name: 'customer_contact', fromJson: _stringOrNullFromJson)
    String? customerContact,
    @JsonKey(name: 'customer_phone', fromJson: _stringOrNullFromJson)
    String? customerPhone,
    @JsonKey(name: 'customer_address', fromJson: _stringOrNullFromJson)
    String? customerAddress,
    @JsonKey(name: 'contract_number', fromJson: _stringOrNullFromJson)
    String? contractNumber,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'approval_comment', fromJson: _stringOrNullFromJson)
    String? approvalComment,
    @JsonKey(name: 'rejection_reason', fromJson: _stringOrNullFromJson)
    String? rejectionReason,
    @JsonKey(name: 'payment_status', fromJson: _stringOrNullFromJson)
    String? paymentStatus,
    @JsonKey(name: 'payment_status_display', fromJson: _stringOrNullFromJson)
    String? paymentStatusDisplay,
    @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? orderDate,
    @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? deliveryDate,
    @JsonKey(name: 'actual_delivery_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? actualDeliveryDate,
    @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
    double? subtotal,
    @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? taxRate,
    @JsonKey(name: 'tax_amount', fromJson: _doubleOrNullFromJson)
    double? taxAmount,
    @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
    double? discountAmount,
    @JsonKey(name: 'total_amount', fromJson: _doubleOrNullFromJson)
    double? totalAmount,
    @JsonKey(name: 'deposit_amount', fromJson: _doubleOrNullFromJson)
    double? depositAmount,
    @JsonKey(name: 'paid_amount', fromJson: _doubleOrNullFromJson)
    double? paidAmount,
    @JsonKey(name: 'payment_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? paymentDate,
    @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
    String? contactPerson,
    @JsonKey(name: 'contact_phone', fromJson: _stringOrNullFromJson)
    String? contactPhone,
    @JsonKey(name: 'shipping_address', fromJson: _stringOrNullFromJson)
    String? shippingAddress,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
    @JsonKey(name: 'payment_count', fromJson: _intOrNullFromJson)
    int? paymentCount,
    @JsonKey(name: 'pending_payment_plan_count', fromJson: _intOrNullFromJson)
    int? pendingPaymentPlanCount,
    @JsonKey(
      name: 'pending_payment_plan_amount',
      fromJson: _doubleOrNullFromJson,
    )
    double? pendingPaymentPlanAmount,
    @JsonKey(name: 'unpaid_amount', fromJson: _doubleOrNullFromJson)
    double? unpaidAmount,
    @JsonKey(name: 'work_order_numbers', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> workOrderNumbers,
    @JsonKey(name: 'delivery_order_numbers', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> deliveryOrderNumbers,
    @JsonKey(name: 'invoice_numbers', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> invoiceNumbers,
    @JsonKey(
      name: 'work_order_summaries',
      readValue: _readWorkOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson,
    )
    @Default(<TraceabilitySummaryItem>[])
    List<TraceabilitySummaryItem> workOrderSummaries,
    @JsonKey(
      name: 'delivery_order_summaries',
      readValue: _readDeliveryOrderSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson,
    )
    @Default(<TraceabilitySummaryItem>[])
    List<TraceabilitySummaryItem> deliveryOrderSummaries,
    @JsonKey(
      name: 'invoice_summaries',
      readValue: _readInvoiceSummaries,
      fromJson: _traceabilitySummaryListFromJson,
      toJson: _traceabilitySummaryListToJson,
    )
    @Default(<TraceabilitySummaryItem>[])
    List<TraceabilitySummaryItem> invoiceSummaries,
    @JsonKey(name: 'items', fromJson: _salesOrderItemListFromJson)
    @Default(<SalesOrderItem>[])
    List<SalesOrderItem> items,
  }) = _SalesOrderDetail;

  factory SalesOrderDetail.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderDetailFromJson(json);
}

@freezed
class SalesOrderItem with _$SalesOrderItem {
  const factory SalesOrderItem({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'product', fromJson: _intOrNullFromJson) int? productId,
    @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
    String? productName,
    @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
    String? productCode,
    @JsonKey(name: 'quantity', fromJson: _intOrNullFromJson) int? quantity,
    @JsonKey(name: 'delivered_quantity', fromJson: _doubleOrNullFromJson)
    double? deliveredQuantity,
    @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,
    @JsonKey(name: 'unit_price', fromJson: _doubleOrNullFromJson)
    double? unitPrice,
    @JsonKey(name: 'tax_rate', fromJson: _doubleOrNullFromJson) double? taxRate,
    @JsonKey(name: 'discount_amount', fromJson: _doubleOrNullFromJson)
    double? discountAmount,
    @JsonKey(name: 'subtotal', fromJson: _doubleOrNullFromJson)
    double? subtotal,
    @JsonKey(name: 'notes', fromJson: _stringOrNullFromJson) String? notes,
  }) = _SalesOrderItem;

  factory SalesOrderItem.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderItemFromJson(json);
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

List<String> _stringListFromJson(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList(growable: false);
}

List<TraceabilitySummaryItem> _traceabilitySummaryListFromJson(Object? value) {
  if (value is! List) return const [];
  final items = <TraceabilitySummaryItem>[];
  for (final item in value) {
    if (item is Map) {
      final summary =
          TraceabilitySummaryItem.fromJson(Map<String, dynamic>.from(item));
      if (summary.number.trim().isNotEmpty) {
        items.add(summary);
      }
      continue;
    }
    final number = item.toString().trim();
    if (number.isNotEmpty) {
      items.add(TraceabilitySummaryItem(number: number));
    }
  }
  return items;
}

List<Map<String, dynamic>> _traceabilitySummaryListToJson(
  List<TraceabilitySummaryItem> items,
) {
  return items
      .map(
        (item) => {
          'number': item.number,
          'id': item.id,
          'status_display': item.statusDisplay,
          'source_label': item.sourceLabel,
          'batch_no': item.batchNo,
        },
      )
      .toList(growable: false);
}

List<SalesOrderItem> _salesOrderItemListFromJson(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => SalesOrderItem.fromJson(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}

Object? _readWorkOrderSummaries(Map json, String key) {
  final value = json[key];
  if (value is List && value.isNotEmpty) return value;
  return json['work_order_numbers'];
}

Object? _readDeliveryOrderSummaries(Map json, String key) {
  final value = json[key];
  if (value is List && value.isNotEmpty) return value;
  return json['delivery_order_numbers'];
}

Object? _readInvoiceSummaries(Map json, String key) {
  final value = json[key];
  if (value is List && value.isNotEmpty) return value;
  return json['invoice_numbers'];
}
