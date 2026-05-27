import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_dto.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl(this._apiService);

  final InvoiceApiService _apiService;

  @override
  Future<InvoicePageDto> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? todo,
    String? ordering,
  }) {
    return _apiService.fetchInvoices(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      todo: todo,
      ordering: ordering,
    );
  }

  @override
  Future<Map<String, dynamic>> submit(int id) {
    return _apiService.submit(id);
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> payload) {
    return _apiService.createInvoice(payload);
  }

  @override
  Future<Map<String, dynamic>> uploadAttachment(
    int id,
    MultipartFile attachment,
  ) {
    return _apiService.uploadAttachment(id, attachment);
  }

  @override
  Future<Map<String, dynamic>> approve(int id, Map<String, dynamic> payload) {
    return _apiService.approve(id, payload);
  }

  @override
  Future<Map<String, dynamic>> getSummary({Map<String, dynamic>? params}) {
    return _apiService.fetchSummary(params: params);
  }
}
