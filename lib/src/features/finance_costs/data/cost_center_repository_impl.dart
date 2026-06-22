import 'package:work_order_app/src/core/data/generic_api_service.dart';
import 'package:work_order_app/src/core/models/generic_record.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/finance_costs/domain/cost_center_repository.dart';

class CostCenterRepositoryImpl implements CostCenterRepository {
  CostCenterRepositoryImpl(ApiClient client)
      : _apiService = GenericApiService(
          client,
          resourcePath: '/cost-centers/',
        );

  final GenericApiService _apiService;

  @override
  Future<GenericRecord> createRecord(Map<String, dynamic> payload) {
    return _apiService.create(payload);
  }

  @override
  Future<GenericRecord> updateRecord(int id, Map<String, dynamic> payload) {
    return _apiService.update(id, payload);
  }

  @override
  Future<void> deleteRecord(int id) {
    return _apiService.delete(id);
  }
}
