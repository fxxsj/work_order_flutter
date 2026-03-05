import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_dto.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/processes/domain/process_repository.dart';

class ProcessRepositoryImpl implements ProcessRepository {
  ProcessRepositoryImpl(this._api);

  final ProcessApiService _api;

  @override
  Future<PageData<Process>> getProcesses({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final response = await _api.fetchProcesses(
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
  Future<void> createProcess(Process process) async {
    await _api.createProcess(ProcessDto.fromEntity(process));
  }

  @override
  Future<void> updateProcess(Process process) async {
    await _api.updateProcess(ProcessDto.fromEntity(process));
  }

  @override
  Future<void> deleteProcess(int id) async {
    await _api.deleteProcess(id);
  }
}
