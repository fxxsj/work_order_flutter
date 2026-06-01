import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order.dart';

class PaymentOptionsData {
  const PaymentOptionsData({
    required this.customers,
    required this.salesOrders,
    required this.invoices,
  });

  final List<Customer> customers;
  final List<SalesOrder> salesOrders;
  final List<Invoice> invoices;
}

class PaymentSupportService {
  PaymentSupportService(this._client);

  final ApiClient _client;

  Future<PaymentOptionsData> loadOptions() async {
    final customerFuture = CustomerApiService(
      _client,
    ).fetchCustomers(page: 1, pageSize: 50);
    final salesOrderFuture = SalesOrderApiService(
      _client,
    ).fetchSalesOrders(page: 1, pageSize: 50);
    final invoiceFuture = InvoiceApiService(
      _client,
    ).fetchInvoices(page: 1, pageSize: 50);

    final customerPage = await customerFuture;
    final salesPage = await salesOrderFuture;
    final invoicePage = await invoiceFuture;

    return PaymentOptionsData(
      customers: customerPage.items.map((dto) => dto.toEntity()).toList(),
      salesOrders: salesPage.items.map((dto) => dto.toEntity()).toList(),
      invoices: invoicePage.items.map((dto) => dto.toEntity()).toList(),
    );
  }

  Future<void> createPayment(Map<String, dynamic> payload) {
    return PaymentApiService(_client).createPayment(payload);
  }
}
