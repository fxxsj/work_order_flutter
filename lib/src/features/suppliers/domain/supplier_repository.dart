import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

abstract class SupplierRepository {
  Future<PageData<Supplier>> getSuppliers({
    required int page,
    required int pageSize,
    String? search,
    String? status,
    String? ordering,
  });

  Future<void> createSupplier(Supplier supplier);

  Future<void> updateSupplier(Supplier supplier);

  Future<void> deleteSupplier(int id);
}
