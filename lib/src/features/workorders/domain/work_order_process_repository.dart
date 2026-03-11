import 'package:work_order_app/src/core/data/page_data.dart';

abstract class WorkOrderProcessRepository {
  Future<PageData<Map<String, dynamic>>> getProcesses({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>> getProcess(int id);

  Future<Map<String, dynamic>> createProcess(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> updateProcess(int id, Map<String, dynamic> payload);

  Future<void> deleteProcess(int id);

  Future<Map<String, dynamic>> start(int id, {Map<String, dynamic>? payload});

  Future<Map<String, dynamic>> complete(int id, Map<String, dynamic> payload);

  Future<Map<String, dynamic>> addLog(int id, String content);

  Future<Map<String, dynamic>> reassignTasks(int id, Map<String, dynamic> payload);
}
