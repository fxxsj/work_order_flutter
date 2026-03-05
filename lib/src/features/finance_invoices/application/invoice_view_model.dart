import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice.dart';
import 'package:work_order_app/src/features/finance_invoices/domain/invoice_repository.dart';

class InvoiceViewModel extends PaginatedViewModel<Invoice> {
  InvoiceViewModel(this._repository);

  final InvoiceRepository _repository;

  List<Invoice> get invoices => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadInvoices({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
