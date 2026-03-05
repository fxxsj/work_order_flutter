import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';

class QualityInspectionDto {
  const QualityInspectionDto({
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

  factory QualityInspectionDto.fromJson(Map<String, dynamic> json) {
    return QualityInspection.fromJson(json).toDto();
  }

  QualityInspection toEntity() {
    return QualityInspection(
      id: id,
      inspectionNumber: inspectionNumber,
      inspectionType: inspectionType,
      inspectionTypeDisplay: inspectionTypeDisplay,
      result: result,
      resultDisplay: resultDisplay,
      workOrderNumber: workOrderNumber,
      productName: productName,
      inspectorName: inspectorName,
      inspectionDate: inspectionDate,
      inspectionQuantity: inspectionQuantity,
      passedQuantity: passedQuantity,
      failedQuantity: failedQuantity,
      defectiveRateFormatted: defectiveRateFormatted,
    );
  }
}

extension QualityInspectionMapper on QualityInspection {
  QualityInspectionDto toDto() {
    return QualityInspectionDto(
      id: id,
      inspectionNumber: inspectionNumber,
      inspectionType: inspectionType,
      inspectionTypeDisplay: inspectionTypeDisplay,
      result: result,
      resultDisplay: resultDisplay,
      workOrderNumber: workOrderNumber,
      productName: productName,
      inspectorName: inspectorName,
      inspectionDate: inspectionDate,
      inspectionQuantity: inspectionQuantity,
      passedQuantity: passedQuantity,
      failedQuantity: failedQuantity,
      defectiveRateFormatted: defectiveRateFormatted,
    );
  }
}

class QualityInspectionPageDto {
  const QualityInspectionPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<QualityInspectionDto> items;
  final int total;
  final int page;
  final int pageSize;
}
