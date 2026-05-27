import 'dart:async';

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
  String _ordering = '-created_at';
  int _summaryRequestToken = 0;

  List<Invoice> get invoices => items;
  Map<String, dynamic> get summary => _summary;
  String get statusFilter => _statusFilter;
  String get todoFilter => _todoFilter;
  String get ordering => _ordering;

  Future<void> initialize() => loadInvoices(resetPage: true);

  Future<void> loadInvoices({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    unawaited(_loadSummary());
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
    String? ordering,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim() ?? '';
    _todoFilter = todo?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-created_at';
    await loadInvoices(resetPage: true);
  }

  Future<void> setStatusFilter(String value) async {
    _statusFilter = value.trim();
    await loadInvoices(resetPage: true);
  }

  Future<void> setTodoFilter(String value) async {
    _todoFilter = value.trim();
    await loadInvoices(resetPage: true);
  }

  Future<void> setOrdering(String value) async {
    final next = value.trim().isEmpty ? '-created_at' : value.trim();
    if (_ordering == next) return;
    _ordering = next;
    await loadInvoices(resetPage: true);
  }

  void setFiltersSilently({String? status, String? todo, String? ordering}) {
    _statusFilter = status?.trim() ?? '';
    _todoFilter = todo?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-created_at';
  }

  Future<void> _loadSummary() async {
    final token = ++_summaryRequestToken;
    try {
      final params = <String, dynamic>{};
      final trimmedSearch = searchText.trim();
      if (trimmedSearch.isNotEmpty) {
        params['search'] = trimmedSearch;
      }
      if (_statusFilter.isNotEmpty) {
        params['status'] = _statusFilter;
      }
      if (_todoFilter.isNotEmpty) {
        params['todo'] = _todoFilter;
      }
      _summary = await _repository.getSummary(
        params: params.isEmpty ? null : params,
      );
      if (token != _summaryRequestToken) return;
      safeNotify();
    } catch (_) {
      if (token != _summaryRequestToken) return;
      _summary = const {};
      safeNotify();
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
      ordering: _ordering,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
