// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'quality_inspection.freezed.dart';
part 'quality_inspection.g.dart';

@freezed
abstract class QualityInspection with _$QualityInspection {
  const factory QualityInspection({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
    required String inspectionNumber,
    @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,
    @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
    String? inspectionType,
    @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
    String? inspectionTypeDisplay,
    @JsonKey(fromJson: _stringOrNullFromJson) String? result,
    @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
    String? resultDisplay,
    @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
    String? customerName,
    @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
    String? workOrderNumber,
    @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
    String? productName,
    @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? batchNo,
    @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
    String? inspectorName,
    @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
    DateTime? inspectionDate,
    @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
    double? inspectionQuantity,
    @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
    double? passedQuantity,
    @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
    double? failedQuantity,
    @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
    String? defectiveRateFormatted,
    @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
    String? inspectionStandard,
    @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> inspectionItems,
    @JsonKey(name: 'defects', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> defects,
    @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
    String? defectDescription,
    @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
    String? disposition,
    @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
    String? dispositionNotes,
    @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
    String? attachmentUrl,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
  }) = _QualityInspection;

  factory QualityInspection.fromJson(Map<String, dynamic> json) =>
      _$QualityInspectionFromJson(json);
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
