import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/data/payment_api_service.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_form_options.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';

class PaymentSupportService {
  PaymentSupportService(this._client);

  final ApiClient _client;

  Future<PaymentFormOptions> loadOptions() async {
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

    return PaymentFormOptions(
      customers: customerPage.items.map((dto) => dto.toEntity()).toList(),
      salesOrders: salesPage.items.map((dto) => dto.toEntity()).toList(),
      invoices: invoicePage.items.map((dto) => dto.toEntity()).toList(),
    );
  }

  Future<void> createPayment(Map<String, dynamic> payload) {
    return PaymentApiService(_client).createPayment(payload);
  }
}
