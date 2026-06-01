import 'package:work_order_app/src/core/data/page_data.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_process_api_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_process_repository.dart';

class WorkOrderProcessRepositoryImpl implements WorkOrderProcessRepository {
  WorkOrderProcessRepositoryImpl(this._apiService);

  final WorkOrderProcessApiService _apiService;

  @override
  Future<PageData<Map<String, dynamic>>> getProcesses({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  }) {
    return _apiService.fetchProcesses(
      page: page,
      pageSize: pageSize,
      params: params,
    );
  }

  @override
  Future<Map<String, dynamic>> getProcess(int id) {
    return _apiService.fetchProcess(id);
  }

  @override
  Future<Map<String, dynamic>> createProcess(Map<String, dynamic> payload) {
    return _apiService.createProcess(payload);
  }

  @override
  Future<Map<String, dynamic>> updateProcess(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.updateProcess(id, payload);
  }

  @override
  Future<void> deleteProcess(int id) {
    return _apiService.deleteProcess(id);
  }

  @override
  Future<Map<String, dynamic>> start(int id, {Map<String, dynamic>? payload}) {
    return _apiService.start(id, payload: payload);
  }

  @override
  Future<Map<String, dynamic>> complete(int id, Map<String, dynamic> payload) {
    return _apiService.complete(id, payload);
  }

  @override
  Future<Map<String, dynamic>> addLog(int id, String content) {
    return _apiService.addLog(id, content);
  }

  @override
  Future<Map<String, dynamic>> reassignTasks(
    int id,
    Map<String, dynamic> payload,
  ) {
    return _apiService.reassignTasks(id, payload);
  }
}
