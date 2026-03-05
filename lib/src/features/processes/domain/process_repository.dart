import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';

abstract class ProcessRepository {
  Future<PageData<Process>> getProcesses({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<void> createProcess(Process process);

  Future<void> updateProcess(Process process);

  Future<void> deleteProcess(int id);
}
