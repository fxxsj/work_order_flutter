import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_support_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_form_options.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_repository.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';

class DeliveryOrderRepositoryImpl implements DeliveryOrderRepository {
  DeliveryOrderRepositoryImpl(this._apiService, this._supportService);

  final DeliveryOrderApiService _apiService;
  final DeliveryOrderSupportService _supportService;

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
  Future<DeliveryOrderDetail> getDeliveryOrderDetail(int id) {
    return _apiService.fetchDetail(id);
  }

  @override
  Future<DeliveryOrderDetail> createDeliveryOrder(
    Map<String, dynamic> payload,
  ) {
    return _apiService.createDeliveryOrder(payload);
  }

  @override
  Future<DeliveryOrderDetail> updateDeliveryOrder(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateDeliveryOrder(id, payload);
  }

  @override
  Future<void> deleteDeliveryOrder(int id) {
    return _apiService.deleteDeliveryOrder(id);
  }

  @override
  Future<Map<String, dynamic>> ship(int id, Map<String, dynamic> payload) {
    return _apiService.ship(id, payload);
  }

  @override
  Future<Map<String, dynamic>> receive(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.receive(id, payload);
  }

  @override
  Future<Map<String, dynamic>> reject(int id, Map<String, dynamic> payload) {
    return _apiService.reject(id, payload);
  }

  @override
  Future<Map<String, dynamic>> resolveException(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.resolveException(id, payload);
  }

  @override
  Future<DeliveryOrderDetail> uploadReceiverSignature(
    int id,
    MultipartFile receiverSignature,
  ) {
    return _apiService.uploadReceiverSignature(id, receiverSignature);
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

  @override
  Future<DeliveryOrderFormOptions> loadFormOptions() {
    return _supportService.loadFormOptions();
  }

  @override
  Future<SalesOrderDetail> fetchSalesOrderDetail(int id) {
    return _supportService.fetchSalesOrderDetail(id);
  }
}
