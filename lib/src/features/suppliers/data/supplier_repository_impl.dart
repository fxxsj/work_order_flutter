import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
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
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        final items = results
            .whereType<Map>()
            .map((item) {
              final map = Map<String, dynamic>.from(item);
              return Supplier(
                id: toInt(map['id']) ?? 0,
                name: map['name']?.toString() ?? '',
                code: toStringOrNull(map['code']),
                contactPerson: toStringOrNull(map['contact_person']),
                phone: toStringOrNull(map['phone']),
                email: toStringOrNull(map['email']),
                address: toStringOrNull(map['address']),
                status: toStringOrNull(map['status']),
                statusDisplay: toStringOrNull(map['status_display']),
                materialCount: toInt(map['material_count']),
                notes: toStringOrNull(map['notes']),
              );
            })
            .toList();
        return PageData(
          items: items,
          total: toInt(data['count']) ?? items.length,
          page: page,
          pageSize: pageSize,
        );
      }
    }
    return PageData(items: const [], total: 0, page: page, pageSize: pageSize);
  }
}
