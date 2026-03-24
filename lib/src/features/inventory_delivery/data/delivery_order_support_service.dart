import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_dto.dart';
import 'package:work_order_app/src/features/inventory_delivery/data/delivery_order_api_service.dart';
import 'package:work_order_app/src/features/inventory_delivery/domain/delivery_order_detail.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_detail_dto.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_dto.dart';

class DeliveryOrderSupportData {
  const DeliveryOrderSupportData({
    required this.customers,
    required this.salesOrders,
    required this.products,
  });

  final List<CustomerDto> customers;
  final List<SalesOrderDto> salesOrders;
  final List<ProductOption> products;
}

class DeliveryOrderSupportService {
  DeliveryOrderSupportService(this._client);

  final ApiClient _client;

  Future<DeliveryOrderSupportData> loadFormOptions() async {
    final customerApi = CustomerApiService(_client);
    final salesOrderApi = SalesOrderApiService(_client);
    final productApi = ProductApiService(_client);

    final results = await Future.wait([
      customerApi.fetchCustomers(pageSize: 200),
      salesOrderApi.fetchSalesOrders(pageSize: 200),
      productApi.fetchProducts(pageSize: 300),
    ]);

    final customerPage = results[0] as dynamic;
    final salesOrderPage = results[1] as dynamic;
    final products = results[2] as List<ProductOption>;

    return DeliveryOrderSupportData(
      customers: List<CustomerDto>.from(customerPage.items),
      salesOrders: List<SalesOrderDto>.from(salesOrderPage.items)
          .where((order) => order.status == 'completed')
          .toList(),
      products: products,
    );
  }

  Future<SalesOrderDetailDto> fetchSalesOrderDetail(int id) async {
    final apiService = SalesOrderApiService(_client);
    return apiService.fetchSalesOrder(id);
  }

  Future<DeliveryOrderDetail> fetchDeliveryOrderDetail(int id) async {
    final apiService = DeliveryOrderApiService(_client);
    return apiService.fetchDetail(id);
  }
}
