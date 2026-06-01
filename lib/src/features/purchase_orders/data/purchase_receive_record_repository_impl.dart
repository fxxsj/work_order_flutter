import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/purchase_orders/data/purchase_receive_record_api_service.dart';
import 'package:work_order_app/src/features/purchase_orders/domain/purchase_receive_record_repository.dart';

class PurchaseReceiveRecordRepositoryImpl
    implements PurchaseReceiveRecordRepository {
  PurchaseReceiveRecordRepositoryImpl(this._apiService);

  final PurchaseReceiveRecordApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getReceiveRecords({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchReceiveRecords(
      page: page,
      pageSize: pageSize,
      params: params,
    );
  }

  @override
  Future<Map<String, dynamic>> confirmInspection(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.confirmInspection(id, payload);
  }

  @override
  Future<Map<String, dynamic>> stockIn(int id) {
    return _apiService.stockIn(id);
  }

  @override
  Future<Map<String, dynamic>> processReturn(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.processReturn(id, payload);
  }

  @override
  Future<PageData<Map<String, dynamic>>> getPendingList({
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchPendingList(params: params);
  }

  @override
  Future<PageData<Map<String, dynamic>>> getPendingStockIn({
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchPendingStockIn(params: params);
  }

  @override
  Future<PageData<Map<String, dynamic>>> getPendingReturn({
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchPendingReturn(params: params);
  }
}
