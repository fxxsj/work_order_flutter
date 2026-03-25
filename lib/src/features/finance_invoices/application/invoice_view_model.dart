import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';

class InvoiceViewModel extends PaginatedViewModel<Invoice> {
  InvoiceViewModel(this._repository);

  final InvoiceRepository _repository;
  Map<String, dynamic> _summary = const {};
  String _statusFilter = '';
  String _todoFilter = '';

  List<Invoice> get invoices => items;
  Map<String, dynamic> get summary => _summary;
  String get statusFilter => _statusFilter;
  String get todoFilter => _todoFilter;

  Future<void> initialize() => loadInvoices(resetPage: true);

  Future<void> loadInvoices({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    await _loadSummary();
  }

  Future<void> submitInvoice(int id) {
    return _repository.submit(id);
  }

  Future<void> createInvoice(Map<String, dynamic> payload) {
    return _repository.create(payload);
  }

  Future<void> uploadAttachment(int id, MultipartFile attachment) {
    return _repository.uploadAttachment(id, attachment);
  }

  Future<void> approveInvoice(int id, Map<String, dynamic> payload) {
    return _repository.approve(id, payload);
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? status,
    String? todo,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim() ?? '';
    _todoFilter = todo?.trim() ?? '';
    await loadInvoices(resetPage: true);
  }

  Future<void> _loadSummary() async {
    try {
      _summary = await _repository.getSummary();
      safeNotify();
    } catch (_) {
      // Keep the list usable even if the summary endpoint fails.
    }
  }

  @override
  Future<PageData<Invoice>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getInvoices(
      page: page,
      pageSize: pageSize,
      search: search,
      status: _statusFilter.isEmpty ? null : _statusFilter,
      todo: _todoFilter.isEmpty ? null : _todoFilter,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
