import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/finance_statements/data/statement_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

class StatementOptionsData {
  const StatementOptionsData({
    required this.customers,
    required this.suppliers,
  });

  final List<Customer> customers;
  final List<Supplier> suppliers;
}

class StatementSupportService {
  StatementSupportService(this._client);

  final ApiClient _client;

  Future<StatementOptionsData> loadOptions() async {
    final customerFuture =
        CustomerApiService(_client).fetchCustomers(page: 1, pageSize: 200);
    final supplierFuture =
        SupplierApiService(_client).fetchSuppliers(page: 1, pageSize: 200);

    final customerPage = await customerFuture;
    final supplierPage = await supplierFuture;

    return StatementOptionsData(
      customers: customerPage.items.map((dto) => dto.toEntity()).toList(),
      suppliers: supplierPage.items.map((dto) => dto.toEntity()).toList(),
    );
  }

  Future<void> createStatement(Map<String, dynamic> payload) {
    return StatementApiService(_client).createStatement(payload);
  }

  Future<Map<String, dynamic>> generate(Map<String, dynamic> params) {
    return StatementApiService(_client).generate(params: params);
  }

  Future<void> confirmStatement(
    int statementId, {
    required bool confirmed,
    required String notes,
  }) {
    return StatementApiService(_client).confirm(statementId, {
      'confirmed': confirmed,
      'confirmation_notes': notes,
    });
  }
}
