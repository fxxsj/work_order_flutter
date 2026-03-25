import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/data/generic_repository.dart';
import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';

class GenericRepositoryImpl implements GenericRepository {
  GenericRepositoryImpl(this._api);

  final GenericApiService _api;

  @override
  Future<PageData<GenericRecord>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
    Map<String, dynamic>? extraParams,
  }) {
    return _api.fetchPage(
      page: page,
      pageSize: pageSize,
      search: search,
      extraParams: extraParams,
    );
  }

  @override
  Future<Map<String, dynamic>> fetchSummary({
    Map<String, dynamic>? extraParams,
  }) {
    return _api.fetchSummary(extraParams: extraParams);
  }

  @override
  Future<GenericRecord> createRecord(Map<String, dynamic> payload) {
    return _api.create(payload);
  }

  @override
  Future<GenericRecord> updateRecord(int id, Map<String, dynamic> payload) {
    return _api.update(id, payload);
  }

  @override
  Future<void> deleteRecord(int id) {
    return _api.delete(id);
  }
}
