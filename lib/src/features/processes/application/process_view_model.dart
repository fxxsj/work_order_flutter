import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/processes/domain/process_repository.dart';

class ProcessViewModel extends PaginatedViewModel<Process> {
  ProcessViewModel(this._repository);

  final ProcessRepository _repository;

  List<Process> get processes => items;

  Future<void> initialize() async {
    await loadProcesses(resetPage: true);
  }

  Future<void> loadProcesses({bool resetPage = false}) => loadItems(resetPage: resetPage);

  @override
  Future<PageData<Process>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getProcesses(page: page, pageSize: pageSize, search: search);
  }

  Future<void> createProcess(Process process) async {
    await _repository.createProcess(process);
    await loadItems(resetPage: true);
  }

  Future<void> updateProcess(Process process) async {
    await _repository.updateProcess(process);
    await loadItems();
  }

  Future<void> deleteProcess(int id) async {
    await deleteAndReload(() => _repository.deleteProcess(id));
  }
}
