import 'package:work_order_app/src/features/finance_invoices/data/invoice_dto.dart';

abstract class InvoiceRepository {
  Future<InvoicePageDto> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
