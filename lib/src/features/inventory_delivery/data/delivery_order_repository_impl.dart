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
  }) {
    return _apiService.fetchDeliveryOrders(page: page, pageSize: pageSize, search: search);
  }
}
