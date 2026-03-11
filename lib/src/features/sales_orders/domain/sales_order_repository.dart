import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

abstract class SalesOrderRepository {
  Future<SalesOrderPageDto> getSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? paymentStatus,
  });

  Future<SalesOrderDetailDto> getSalesOrderDetail(int id);

  Future<SalesOrderDetailDto> createSalesOrder(Map<String, dynamic> payload);

  Future<SalesOrderDetailDto> updateSalesOrder(int id, Map<String, dynamic> payload);

  Future<SalesOrderDetailDto> submit(int id);

  Future<SalesOrderDetailDto> approve(int id, Map<String, dynamic> payload);

  Future<SalesOrderDetailDto> reject(int id, Map<String, dynamic> payload);

  Future<SalesOrderDetailDto> startProduction(int id);

  Future<SalesOrderDetailDto> complete(int id);

  Future<SalesOrderDetailDto> cancel(int id, Map<String, dynamic> payload);

  Future<SalesOrderDetailDto> updatePayment(int id, Map<String, dynamic> payload);

  Future<void> deleteSalesOrder(int id);
}
