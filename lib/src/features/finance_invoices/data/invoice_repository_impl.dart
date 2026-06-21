import 'package:dio/dio.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_api_service.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_dto.dart';
import 'package:work_order_app/src/features/finance_invoices/data/invoice_form_options_loader.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_form_options.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl(this._apiService, this._formOptionsLoader);

  final InvoiceApiService _apiService;
  final InvoiceFormOptionsLoader _formOptionsLoader;

  @override
  Future<InvoicePageDto> getInvoices({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? status,
    String? approvalStatus,
    String? todo,
    String? ordering,
  }) {
    return _apiService.fetchInvoices(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      approvalStatus: approvalStatus,
      todo: todo,
      ordering: ordering,
    );
  }

  @override
  Future<Invoice> getInvoiceDetail(int id) async {
    final dto = await _apiService.fetchDetail(id);
    return dto.toEntity();
  }

  @override
  Future<Map<String, dynamic>> submit(int id, [Map<String, dynamic>? payload]) {
    return _apiService.submit(id, payload);
  }

  @override
  Future<InvoiceDto> create(Map<String, dynamic> payload) {
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

  @override
  Future<InvoiceFormOptions> loadFormOptions() {
    return _formOptionsLoader.load();
  }
}
