import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';

class SalesOrderRepositoryImpl implements SalesOrderRepository {
  SalesOrderRepositoryImpl(this._apiService,
      [WorkOrderFlowApiService? workOrderFlowApiService])
      : _workOrderFlowApiService = workOrderFlowApiService;

  final SalesOrderApiService _apiService;
  final WorkOrderFlowApiService? _workOrderFlowApiService;

  @override
  Future<SalesOrderPageDto> getSalesOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? paymentStatus,
  }) {
    return _apiService.fetchSalesOrders(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      paymentStatus: paymentStatus,
    );
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
  Future<SalesOrderDetailDto> updateSalesOrder(
      int id, Map<String, dynamic> payload) {
    return _apiService.updateSalesOrder(id, payload);
  }

  @override
  Future<SalesOrderDetailDto> submit(int id) {
    return _apiService.submit(id);
  }

  @override
  Future<SalesOrderDetailDto> approve(int id, Map<String, dynamic> payload) {
    return _apiService.approve(id, payload);
  }

  @override
  Future<SalesOrderDetailDto> reject(int id, Map<String, dynamic> payload) {
    return _apiService.reject(id, payload);
  }

  @override
  Future<SalesOrderDetailDto> startProduction(int id) {
    return _apiService.startProduction(id);
  }

  @override
  Future<SalesOrderDetailDto> complete(int id) {
    return _apiService.complete(id);
  }

  @override
  Future<SalesOrderDetailDto> cancel(int id, Map<String, dynamic> payload) {
    return _apiService.cancel(id, payload);
  }

  @override
  Future<SalesOrderDetailDto> updatePayment(
      int id, Map<String, dynamic> payload) {
    return _apiService.updatePayment(id, payload);
  }

  @override
  Future<int?> createWorkOrderFromSalesOrder(
      Map<String, dynamic> payload) async {
    final service = _workOrderFlowApiService;
    if (service == null) {
      throw StateError('WorkOrderFlowApiService is not configured.');
    }
    final result = await service.createFromSalesOrder(payload);
    final data = result['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(result['data'])
        : result;
    return toInt(data['id']);
  }

  @override
  Future<void> deleteSalesOrder(int id) {
    return _apiService.deleteSalesOrder(id);
  }
}
