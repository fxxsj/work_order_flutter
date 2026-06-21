import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_form_options.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';

class DeliveryOrderSupportService {
  DeliveryOrderSupportService(this._client);

  final ApiClient _client;

  Future<DeliveryOrderFormOptions> loadFormOptions() async {
    final customerApi = CustomerApiService(_client);
    final salesOrderApi = SalesOrderApiService(_client);
    final productApi = ProductApiService(_client);

    final customerFuture = customerApi.fetchCustomers(pageSize: 50);
    final salesOrderFuture = salesOrderApi.fetchSalesOrders(pageSize: 50);
    final productFuture = productApi.fetchProducts(pageSize: 300);

    final customerPage = await customerFuture;
    final salesOrderPage = await salesOrderFuture;
    final products = await productFuture;

    return DeliveryOrderFormOptions(
      customers: customerPage.items.map((dto) => dto.toEntity()).toList(),
      salesOrders: List<SalesOrderDto>.from(salesOrderPage.items)
          .where(
            (order) =>
                order.status == 'approved' ||
                order.status == 'in_production' ||
                order.status == 'completed',
          )
          .map((dto) => dto.toEntity())
          .toList(),
      products: products,
    );
  }

  Future<SalesOrderDetail> fetchSalesOrderDetail(int id) async {
    final apiService = SalesOrderApiService(_client);
    final dto = await apiService.fetchSalesOrder(id);
    return dto.toEntity();
  }
}
