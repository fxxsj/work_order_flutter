import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';

class SupplierViewModel extends PaginatedViewModel<Supplier> {
  SupplierViewModel(this._repository);

  final SupplierRepository _repository;

  List<Supplier> get suppliers => items;

  Future<void> initialize() async {
    await loadSuppliers(resetPage: true);
  }

  Future<void> loadSuppliers({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<Supplier>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getSuppliers(page: page, pageSize: pageSize, search: search);
  }
}
