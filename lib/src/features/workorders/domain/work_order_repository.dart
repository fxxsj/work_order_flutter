import 'package:work_order_app/src/features/workorders/data/work_order_dto.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_detail_dto.dart';

abstract class WorkOrderRepository {
  Future<WorkOrderPageDto> getWorkOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? priority,
    String? approvalStatus,
    int? customerId,
    int? productId,
    int? processId,
    String? ordering,
  });

  Future<WorkOrderDetailDto> getWorkOrderDetail(int id);

  Future<WorkOrderDetailDto> createWorkOrder(Map<String, dynamic> payload);

  Future<WorkOrderDetailDto> updateWorkOrder(int id, Map<String, dynamic> payload);

  Future<void> deleteWorkOrder(int id);

  Future<WorkOrderDetailDto> updateStatus(int id, String status);

  Future<WorkOrderDetailDto> approve({
    required int id,
    required String approvalStatus,
    String? approvalComment,
    String? rejectionReason,
  });

  Future<WorkOrderDetailDto> resubmitForApproval(int id);

  Future<WorkOrderDetailDto> requestReapproval(int id, String reason);

  Future<WorkOrderDetailDto> addProcess(int id, Map<String, dynamic> payload);

  Future<WorkOrderDetailDto> addMaterial(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getStatistics({Map<String, dynamic>? params});

  Future<dynamic> export({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> checkSyncNeeded(int id, {List<int>? processIds});

  Future<Map<String, dynamic>> syncTasksPreview(int id, {List<int>? processIds});

  Future<Map<String, dynamic>> syncTasksExecute(int id, {List<int>? processIds});
}
