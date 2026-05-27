import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';

class DeliveryOrderRepositoryImpl implements DeliveryOrderRepository {
  DeliveryOrderRepositoryImpl(this._apiService);

  final DeliveryOrderApiService _apiService;

  @override
  Future<DeliveryOrderPageDto> getDeliveryOrders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    int? customerId,
    int? departmentId,
    String? todo,
    String? startDate,
    String? endDate,
    String? ordering,
  }) {
    return _apiService.fetchDeliveryOrders(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      customerId: customerId,
      departmentId: departmentId,
      todo: todo,
      startDate: startDate,
      endDate: endDate,
      ordering: ordering,
    );
  }

  @override
  Future<Map<String, dynamic>> ship(int id, Map<String, dynamic> payload) {
    return _apiService.ship(id, payload);
  }

  @override
  Future<Map<String, dynamic>> receive(int id, Map<String, dynamic> payload) {
    return _apiService.receive(id, payload);
  }

  @override
  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload) {
    return _apiService.reject(id, payload);
  }

  @override
  Future<Map<String, dynamic>> getSummary({
    int? departmentId,
    String? status,
    int? customerId,
    String? todo,
    String? startDate,
    String? endDate,
  }) {
    return _apiService.fetchSummary(
      departmentId: departmentId,
      status: status,
      customerId: customerId,
      todo: todo,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
