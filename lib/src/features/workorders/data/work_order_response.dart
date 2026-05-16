// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'work_order_response.freezed.dart';
part 'work_order_response.g.dart';

/// Freezed-based WorkOrder response DTO.
///
/// Replaces manual WorkOrder.fromJson() with generated code.
/// Usage:
/// ```dart
/// final workOrder = WorkOrderResponse.fromJson(json);
/// ```
@freezed
class WorkOrderResponse with _$WorkOrderResponse {
  const factory WorkOrderResponse({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'order_number', fromJson: _stringFromJson)
    required String orderNumber,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(name: 'salesperson_name', fromJson: _stringOrNullFromJson)
    String? salespersonName,
    @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
    String? productName,
    @JsonKey(fromJson: _doubleOrNull_fromJson) double? quantity,
    @JsonKey(name: 'unit', fromJson: _stringOrNullFromJson) String? unit,
    @JsonKey(name: 'status', fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'priority', fromJson: _stringOrNullFromJson) String? priority,
    @JsonKey(name: 'priority_display', fromJson: _stringOrNullFromJson)
    String? priorityDisplay,
    @JsonKey(name: 'order_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? orderDate,
    @JsonKey(name: 'delivery_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? deliveryDate,
    @JsonKey(name: 'total_amount', fromJson: _doubleOrNull_fromJson)
    double? totalAmount,
    @JsonKey(name: 'approval_status', fromJson: _stringOrNullFromJson)
    String? approvalStatus,
    @JsonKey(name: 'approval_status_display', fromJson: _stringOrNullFromJson)
    String? approvalStatusDisplay,
    @JsonKey(name: 'manager_name', fromJson: _stringOrNullFromJson)
    String? managerName,
    @JsonKey(name: 'progress_percentage', fromJson: _intOrNull_fromJson)
    int? progressPercentage,
    @JsonKey(name: 'total_task_count', fromJson: _intOrNull_fromJson)
    int? totalTaskCount,
    @JsonKey(name: 'sales_order_id', fromJson: _intOrNull_fromJson)
    int? salesOrderId,
    @JsonKey(name: 'sales_order_number', fromJson: _stringOrNullFromJson)
    String? salesOrderNumber,
  }) = _WorkOrderResponse;

  factory WorkOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderResponseFromJson(json);
}

// Helper functions for JSON parsing
int _intFromJson(dynamic value) => toInt(value) ?? 0;

int? _intOrNull_fromJson(dynamic value) => toInt(value);

double? _doubleOrNull_fromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String _stringFromJson(dynamic value) => value?.toString() ?? '';

String? _stringOrNullFromJson(dynamic value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(dynamic value) => toDateTime(value);