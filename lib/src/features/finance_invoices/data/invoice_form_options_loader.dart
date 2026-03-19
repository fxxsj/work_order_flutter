import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order.dart';

class InvoiceFormOptionsData {
  const InvoiceFormOptionsData({
    required this.customers,
    required this.salesOrders,
    required this.workOrders,
  });

  final List<Customer> customers;
  final List<SalesOrder> salesOrders;
  final List<WorkOrder> workOrders;
}

class InvoiceFormOptionsLoader {
  InvoiceFormOptionsLoader(this._client);

  final ApiClient _client;

  Future<InvoiceFormOptionsData> load() async {
    final customerApi = CustomerApiService(_client);
    final salesOrderApi = SalesOrderApiService(_client);
    final workOrderApi = WorkOrderApiService(_client);

    final results = await Future.wait([
      customerApi.fetchCustomers(page: 1, pageSize: 200),
      salesOrderApi.fetchSalesOrders(page: 1, pageSize: 200),
      workOrderApi.fetchWorkOrders(page: 1, pageSize: 200),
    ]);

    final customerPage = results[0] as dynamic;
    final salesOrderPage = results[1] as dynamic;
    final workOrderPage = results[2] as dynamic;

    return InvoiceFormOptionsData(
      customers:
          customerPage.items.map<Customer>((item) => item.toEntity()).toList(),
      salesOrders: salesOrderPage.items
          .map<SalesOrder>((item) => item.toEntity())
          .toList(),
      workOrders: workOrderPage.items
          .map<WorkOrder>((item) => item.toEntity())
          .toList(),
    );
  }
}
