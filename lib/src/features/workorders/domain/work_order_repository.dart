import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';

abstract class WorkOrderRepository {
  Future<WorkOrderPageDto> getWorkOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  Future<WorkOrderDetailDto> getWorkOrderDetail(int id);

  Future<WorkOrderDetailDto> createWorkOrder(Map<String, dynamic> payload);

  Future<WorkOrderDetailDto> updateWorkOrder(int id, Map<String, dynamic> payload);
}
