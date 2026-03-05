import 'package:work_order_app/src/features/workorders/domain/work_order_detail.dart';

class WorkOrderDetailDto {
  const WorkOrderDetailDto({required this.entity});

  final WorkOrderDetail entity;

  factory WorkOrderDetailDto.fromJson(Map<String, dynamic> json) {
    return WorkOrderDetailDto(entity: WorkOrderDetail.fromJson(json));
  }

  WorkOrderDetail toEntity() => entity;
}
