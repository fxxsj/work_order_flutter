// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QualityInspection _$QualityInspectionFromJson(Map<String, dynamic> json) =>
    _QualityInspection(
      id: _intFromJson(json['id']),
      inspectionNumber: _stringFromJson(json['inspection_number']),
      workOrderId: _intOrNullFromJson(json['work_order']),
      inspectionType: _stringOrNullFromJson(json['inspection_type']),
      inspectionTypeDisplay: _stringOrNullFromJson(
        json['inspection_type_display'],
      ),
      result: _stringOrNullFromJson(json['result']),
      resultDisplay: _stringOrNullFromJson(json['result_display']),
      customerName: _stringOrNullFromJson(json['customer_name']),
      workOrderNumber: _stringOrNullFromJson(json['work_order_number']),
      productName: _stringOrNullFromJson(json['product_name']),
      batchNo: _stringOrNullFromJson(json['batch_no']),
      inspectorName: _stringOrNullFromJson(json['inspector_name']),
      inspectionDate: _dateTimeOrNullFromJson(json['inspection_date']),
      inspectionQuantity: _doubleOrNullFromJson(json['inspection_quantity']),
      passedQuantity: _doubleOrNullFromJson(json['passed_quantity']),
      failedQuantity: _doubleOrNullFromJson(json['failed_quantity']),
      defectiveRateFormatted: _stringOrNullFromJson(
        json['defective_rate_formatted'],
      ),
      inspectionStandard: _stringOrNullFromJson(json['inspection_standard']),
      inspectionItems: json['inspection_items'] == null
          ? const <String>[]
          : _stringListFromJson(json['inspection_items']),
      defects: json['defects'] == null
          ? const <String>[]
          : _stringListFromJson(json['defects']),
      defectDescription: _stringOrNullFromJson(json['defect_description']),
      disposition: _stringOrNullFromJson(json['disposition']),
      dispositionNotes: _stringOrNullFromJson(json['disposition_notes']),
      attachmentUrl: _stringOrNullFromJson(json['attachment']),
      notes: _stringOrNullFromJson(json['notes']),
    );

Map<String, dynamic> _$QualityInspectionToJson(_QualityInspection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inspection_number': instance.inspectionNumber,
      'work_order': instance.workOrderId,
      'inspection_type': instance.inspectionType,
      'inspection_type_display': instance.inspectionTypeDisplay,
      'result': instance.result,
      'result_display': instance.resultDisplay,
      'customer_name': instance.customerName,
      'work_order_number': instance.workOrderNumber,
      'product_name': instance.productName,
      'batch_no': instance.batchNo,
      'inspector_name': instance.inspectorName,
      'inspection_date': instance.inspectionDate?.toIso8601String(),
      'inspection_quantity': instance.inspectionQuantity,
      'passed_quantity': instance.passedQuantity,
      'failed_quantity': instance.failedQuantity,
      'defective_rate_formatted': instance.defectiveRateFormatted,
      'inspection_standard': instance.inspectionStandard,
      'inspection_items': instance.inspectionItems,
      'defects': instance.defects,
      'defect_description': instance.defectDescription,
      'disposition': instance.disposition,
      'disposition_notes': instance.dispositionNotes,
      'attachment': instance.attachmentUrl,
      'notes': instance.notes,
    };
