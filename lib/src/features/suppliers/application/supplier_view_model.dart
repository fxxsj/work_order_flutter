import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';

class SupplierViewModel extends PaginatedViewModel<Supplier> {
  SupplierViewModel(this._repository);

  final SupplierRepository _repository;

  String? _status;
  String? _ordering;

  List<Supplier> get suppliers => items;

  String? get status => _status;

  String? get ordering => _ordering;

  Future<void> initialize() async {
    await loadSuppliers(resetPage: true);
  }

  Future<void> loadSuppliers({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setStatus(String? value) {
    _status = value;
    loadItems(resetPage: true);
  }

  void setOrdering(String? value) {
    _ordering = value;
    loadItems(resetPage: true);
  }

  Future<void> createSupplier(Supplier supplier) async {
    await _repository.createSupplier(supplier);
    await loadItems(resetPage: true);
  }

  Future<void> updateSupplier(Supplier supplier) async {
    await _repository.updateSupplier(supplier);
    await loadItems();
  }

  Future<void> deleteSupplier(int id) async {
    await deleteAndReload(() => _repository.deleteSupplier(id));
  }

  @override
  Future<PageData<Supplier>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getSuppliers(
      page: page,
      pageSize: pageSize,
      search: search,
      status: _status,
      ordering: _ordering,
    );
  }
}
