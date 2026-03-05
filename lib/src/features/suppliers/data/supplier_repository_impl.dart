import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_dto.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  SupplierRepositoryImpl(this._api);

  final SupplierApiService _api;

  @override
  Future<PageData<Supplier>> getSuppliers({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final response = await _api.fetchSuppliers(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return PageData(
      items: response.items.map((item) => item.toEntity()).toList(),
      total: response.total,
      page: response.page,
      pageSize: response.pageSize,
    );
  }

  @override
  Future<void> createSupplier(Supplier supplier) async {
    await _api.createSupplier(SupplierDto.fromEntity(supplier));
  }

  @override
  Future<void> updateSupplier(Supplier supplier) async {
    await _api.updateSupplier(SupplierDto.fromEntity(supplier));
  }

  @override
  Future<void> deleteSupplier(int id) async {
    await _api.deleteSupplier(id);
  }
}
