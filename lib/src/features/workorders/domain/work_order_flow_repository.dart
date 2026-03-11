abstract class WorkOrderFlowRepository {
  Future<Map<String, dynamic>> createFromSalesOrder(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> createFromSalesOrders(Map<String, dynamic> payload);
}
