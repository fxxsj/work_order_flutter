import 'package:work_order_app/src/core/utils/parse_utils.dart';

class QualityInspection {
  const QualityInspection({
    required this.id,
    required this.inspectionNumber,
    this.inspectionType,
    this.inspectionTypeDisplay,
    this.result,
    this.resultDisplay,
    this.workOrderNumber,
    this.productName,
    this.inspectorName,
    this.inspectionDate,
    this.inspectionQuantity,
    this.passedQuantity,
    this.failedQuantity,
    this.defectiveRateFormatted,
  });

  final int id;
  final String inspectionNumber;
  final String? inspectionType;
  final String? inspectionTypeDisplay;
  final String? result;
  final String? resultDisplay;
  final String? workOrderNumber;
  final String? productName;
  final String? inspectorName;
  final DateTime? inspectionDate;
  final double? inspectionQuantity;
  final double? passedQuantity;
  final double? failedQuantity;
  final String? defectiveRateFormatted;

  factory QualityInspection.fromJson(Map<String, dynamic> json) {
    return QualityInspection(
      id: toInt(json['id']) ?? 0,
      inspectionNumber: json['inspection_number']?.toString() ?? '',
      inspectionType: toStringOrNull(json['inspection_type']),
      inspectionTypeDisplay: toStringOrNull(json['inspection_type_display']),
      result: toStringOrNull(json['result']),
      resultDisplay: toStringOrNull(json['result_display']),
      workOrderNumber: toStringOrNull(json['work_order_number']),
      productName: toStringOrNull(json['product_name']),
      inspectorName: toStringOrNull(json['inspector_name']),
      inspectionDate: toDateTime(json['inspection_date']),
      inspectionQuantity: _toDouble(json['inspection_quantity']),
      passedQuantity: _toDouble(json['passed_quantity']),
      failedQuantity: _toDouble(json['failed_quantity']),
      defectiveRateFormatted: toStringOrNull(json['defective_rate_formatted']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
