import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_form_options.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';

class InvoiceFormOptionsLoader {
  InvoiceFormOptionsLoader(this._client);

  final ApiClient _client;

  Future<InvoiceFormOptions> load() async {
    final customerApi = CustomerApiService(_client);
    final salesOrderApi = SalesOrderApiService(_client);
    final workOrderApi = WorkOrderApiService(_client);

    final customerFuture = customerApi.fetchCustomers(page: 1, pageSize: 50);
    final salesOrderFuture = salesOrderApi.fetchSalesOrders(
      page: 1,
      pageSize: 50,
    );
    final workOrderFuture = workOrderApi.fetchWorkOrders(page: 1, pageSize: 50);

    final customerPage = await customerFuture;
    final salesOrderPage = await salesOrderFuture;
    final workOrderPage = await workOrderFuture;

    return InvoiceFormOptions(
      customers: customerPage.items.map((item) => item.toEntity()).toList(),
      salesOrders: salesOrderPage.items.map((item) => item.toEntity()).toList(),
      workOrders: workOrderPage.items.map((item) => item.toEntity()).toList(),
    );
  }
}
