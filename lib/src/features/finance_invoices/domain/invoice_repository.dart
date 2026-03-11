import 'package:work_order_app/src/features/finance_invoices/data/invoice_dto.dart';

abstract class InvoiceRepository {
  Future<InvoicePageDto> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? search,
  });

  Future<Map<String, dynamic>> submit(int id);

  Future<Map<String, dynamic>> approve(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getSummary();
}
