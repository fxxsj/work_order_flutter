import 'package:work_order_app/src/features/inventory_quality/domain/quality_inspection.dart';

class QualityInspectionDto {
  const QualityInspectionDto({
    required this.id,
    required this.inspectionNumber,
    this.workOrderId,
    this.inspectionType,
    this.inspectionTypeDisplay,
    this.result,
    this.resultDisplay,
    this.customerName,
    this.workOrderNumber,
    this.productName,
    this.batchNo,
    this.inspectorName,
    this.inspectionDate,
    this.inspectionQuantity,
    this.passedQuantity,
    this.failedQuantity,
    this.defectiveRateFormatted,
    this.inspectionStandard,
    this.inspectionItems,
    this.defects,
    this.defectDescription,
    this.disposition,
    this.dispositionNotes,
    this.attachmentUrl,
    this.notes,
  });

  final int id;
  final String inspectionNumber;
  final int? workOrderId;
  final String? inspectionType;
  final String? inspectionTypeDisplay;
  final String? result;
  final String? resultDisplay;
  final String? customerName;
  final String? workOrderNumber;
  final String? productName;
  final String? batchNo;
  final String? inspectorName;
  final DateTime? inspectionDate;
  final double? inspectionQuantity;
  final double? passedQuantity;
  final double? failedQuantity;
  final String? defectiveRateFormatted;
  final String? inspectionStandard;
  final List<String>? inspectionItems;
  final List<String>? defects;
  final String? defectDescription;
  final String? disposition;
  final String? dispositionNotes;
  final String? attachmentUrl;
  final String? notes;

  factory QualityInspectionDto.fromJson(Map<String, dynamic> json) {
    return QualityInspection.fromJson(json).toDto();
  }

  QualityInspection toEntity() {
    return QualityInspection(
      id: id,
      inspectionNumber: inspectionNumber,
      workOrderId: workOrderId,
      inspectionType: inspectionType,
      inspectionTypeDisplay: inspectionTypeDisplay,
      result: result,
      resultDisplay: resultDisplay,
      customerName: customerName,
      workOrderNumber: workOrderNumber,
      productName: productName,
      batchNo: batchNo,
      inspectorName: inspectorName,
      inspectionDate: inspectionDate,
      inspectionQuantity: inspectionQuantity,
      passedQuantity: passedQuantity,
      failedQuantity: failedQuantity,
      defectiveRateFormatted: defectiveRateFormatted,
      inspectionStandard: inspectionStandard,
      inspectionItems: inspectionItems ?? const [],
      defects: defects ?? const [],
      defectDescription: defectDescription,
      disposition: disposition,
      dispositionNotes: dispositionNotes,
      attachmentUrl: attachmentUrl,
      notes: notes,
    );
  }
}

extension QualityInspectionMapper on QualityInspection {
  QualityInspectionDto toDto() {
    return QualityInspectionDto(
      id: id,
      inspectionNumber: inspectionNumber,
      workOrderId: workOrderId,
      inspectionType: inspectionType,
      inspectionTypeDisplay: inspectionTypeDisplay,
      result: result,
      resultDisplay: resultDisplay,
      customerName: customerName,
      workOrderNumber: workOrderNumber,
      productName: productName,
      batchNo: batchNo,
      inspectorName: inspectorName,
      inspectionDate: inspectionDate,
      inspectionQuantity: inspectionQuantity,
      passedQuantity: passedQuantity,
      failedQuantity: failedQuantity,
      defectiveRateFormatted: defectiveRateFormatted,
      inspectionStandard: inspectionStandard,
      inspectionItems: inspectionItems,
      defects: defects,
      defectDescription: defectDescription,
      disposition: disposition,
      dispositionNotes: dispositionNotes,
      attachmentUrl: attachmentUrl,
      notes: notes,
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
