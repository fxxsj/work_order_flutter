import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_dto.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_form_options.dart';

abstract class InvoiceRepository {
  Future<InvoicePageDto> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? approvalStatus,
    String? todo,
    String? ordering,
  });

  Future<Map<String, dynamic>> submit(int id, [Map<String, dynamic>? payload]);

  Future<InvoiceDto> create(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> uploadAttachment(
    int id,
    MultipartFile attachment,
  );

  Future<Map<String, dynamic>> approve(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params});

  Future<InvoiceFormOptions> loadFormOptions();
}
