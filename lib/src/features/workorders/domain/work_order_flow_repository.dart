import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';

abstract class WorkOrderFlowRepository {
  Future<Map<String, dynamic>> createFromSalesOrder(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> createFromSalesOrders(Map<String, dynamic> payload);

  Future<WorkOrderDetailDto> submitApproval(int id, {String? comment});

  Future<WorkOrderDetailDto> approve(int id, {String? comment});

  Future<WorkOrderDetailDto> reject(int id, {required String reason});

  Future<WorkOrderDetailDto> requestReapproval(int id, String reason);

  Future<Map<String, dynamic>> checkCompletion(int id);
}
