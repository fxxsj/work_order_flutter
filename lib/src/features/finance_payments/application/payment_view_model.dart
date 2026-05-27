import 'dart:async';

import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment.dart';
import 'package:work_order_app/src/features/finance_payments/domain/payment_repository.dart';

class PaymentViewModel extends PaginatedViewModel<Payment> {
  PaymentViewModel(this._repository);

  final PaymentRepository _repository;
  Map<String, dynamic> _summary = const {};
  String _customerFilter = '';
  String _paymentMethodFilter = '';
  String _todoFilter = '';
  String _ordering = '-payment_date';
  String _startDateFilter = '';
  String _endDateFilter = '';
  int _summaryRequestToken = 0;

  List<Payment> get payments => items;
  Map<String, dynamic> get summary => _summary;
  String get customerFilter => _customerFilter;
  String get paymentMethodFilter => _paymentMethodFilter;
  String get todoFilter => _todoFilter;
  String get ordering => _ordering;
  String get startDateFilter => _startDateFilter;
  String get endDateFilter => _endDateFilter;

  Future<void> initialize() => loadPayments(resetPage: true);

  Future<void> loadPayments({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    unawaited(_loadSummary());
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? customer,
    String? paymentMethod,
    String? todo,
    String? ordering,
    String? startDate,
    String? endDate,
  }) async {
    setSearchText(search?.trim() ?? '');
    _customerFilter = customer?.trim() ?? '';
    _paymentMethodFilter = paymentMethod?.trim() ?? '';
    _todoFilter = todo?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-payment_date';
    _startDateFilter = startDate?.trim() ?? '';
    _endDateFilter = endDate?.trim() ?? '';
    await loadPayments(resetPage: true);
  }

  Future<void> setCustomerFilter(String value) async {
    _customerFilter = value.trim();
    await loadPayments(resetPage: true);
  }

  Future<void> setPaymentMethodFilter(String value) async {
    _paymentMethodFilter = value.trim();
    await loadPayments(resetPage: true);
  }

  Future<void> setTodoFilter(String value) async {
    _todoFilter = value.trim();
    await loadPayments(resetPage: true);
  }

  Future<void> setOrdering(String value) async {
    final next = value.trim().isEmpty ? '-payment_date' : value.trim();
    if (_ordering == next) return;
    _ordering = next;
    await loadPayments(resetPage: true);
  }

  void setFiltersSilently({
    String? customer,
    String? paymentMethod,
    String? todo,
    String? ordering,
    String? startDate,
    String? endDate,
  }) {
    _customerFilter = customer?.trim() ?? '';
    _paymentMethodFilter = paymentMethod?.trim() ?? '';
    _todoFilter = todo?.trim() ?? '';
    _ordering = ordering?.trim().isNotEmpty == true
        ? ordering!.trim()
        : '-payment_date';
    _startDateFilter = startDate?.trim() ?? '';
    _endDateFilter = endDate?.trim() ?? '';
  }

  Future<void> _loadSummary() async {
    final token = ++_summaryRequestToken;
    try {
      final params = <String, dynamic>{};
      final trimmedSearch = searchText.trim();
      if (trimmedSearch.isNotEmpty) params['search'] = trimmedSearch;
      if (_customerFilter.isNotEmpty) params['customer'] = _customerFilter;
      if (_paymentMethodFilter.isNotEmpty) {
        params['payment_method'] = _paymentMethodFilter;
      }
      if (_todoFilter.isNotEmpty) params['todo'] = _todoFilter;
      if (_startDateFilter.isNotEmpty) params['start_date'] = _startDateFilter;
      if (_endDateFilter.isNotEmpty) params['end_date'] = _endDateFilter;
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
  Future<PageData<Payment>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getPayments(
      page: page,
      pageSize: pageSize,
      search: search,
      customer: _customerFilter.isEmpty ? null : _customerFilter,
      paymentMethod: _paymentMethodFilter.isEmpty ? null : _paymentMethodFilter,
      todo: _todoFilter.isEmpty ? null : _todoFilter,
      ordering: _ordering,
      startDate: _startDateFilter.isEmpty ? null : _startDateFilter,
      endDate: _endDateFilter.isEmpty ? null : _endDateFilter,
    );
    return result;
  }
}
