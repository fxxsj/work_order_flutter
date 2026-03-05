import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';

abstract class WorkOrderRepository {
  Future<WorkOrderPageDto> getWorkOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
