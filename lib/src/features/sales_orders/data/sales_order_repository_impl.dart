import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';

class SalesOrderRepositoryImpl implements SalesOrderRepository {
  SalesOrderRepositoryImpl(this._apiService);

  final SalesOrderApiService _apiService;

  @override
  Future<SalesOrderPageDto> getSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchSalesOrders(page: page, pageSize: pageSize, search: search);
  }

  @override
  Future<SalesOrderDetailDto> getSalesOrderDetail(int id) {
    return _apiService.fetchSalesOrder(id);
  }

  @override
  Future<SalesOrderDetailDto> createSalesOrder(Map<String, dynamic> payload) {
    return _apiService.createSalesOrder(payload);
  }

  @override
  Future<SalesOrderDetailDto> updateSalesOrder(int id, Map<String, dynamic> payload) {
    return _apiService.updateSalesOrder(id, payload);
  }
}
