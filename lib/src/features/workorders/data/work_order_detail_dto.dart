import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class WorkOrderDetailDto {
  const WorkOrderDetailDto({
    required this.entity,
    this.taskGeneration,
    this.procurementSummary,
  });

  final WorkOrderDetail entity;
  final Map<String, dynamic>? taskGeneration;
  final Map<String, dynamic>? procurementSummary;

  factory WorkOrderDetailDto.fromJson(Map<String, dynamic> json) {
    return WorkOrderDetailDto(
      entity: WorkOrderDetail.fromJson(json),
      taskGeneration: _mapOrNull(json['task_generation']),
      procurementSummary: _mapOrNull(json['procurement_summary']),
    );
  }

  WorkOrderDetail toEntity() => entity;
}

Map<String, dynamic>? _mapOrNull(dynamic value) {
  if (value is Map<String, dynamic>) return Map<String, dynamic>.from(value);
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
