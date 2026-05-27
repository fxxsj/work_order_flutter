import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/processes/domain/process_repository.dart';

class ProcessViewModel extends PaginatedViewModel<Process> {
  ProcessViewModel(this._repository);

  final ProcessRepository _repository;

  bool? _isActive;
  String? _taskGenerationRule;
  String? _ordering;

  List<Process> get processes => items;

  bool? get isActive => _isActive;

  String? get taskGenerationRule => _taskGenerationRule;

  String? get ordering => _ordering;

  Future<void> initialize() async {
    await loadProcesses(resetPage: true);
  }

  Future<void> loadProcesses({bool resetPage = false}) =>
      loadItems(resetPage: resetPage);

  void setIsActive(bool? value) {
    _isActive = value;
    loadItems(resetPage: true);
  }

  void setTaskGenerationRule(String? value) {
    _taskGenerationRule = value;
    loadItems(resetPage: true);
  }

  void setOrdering(String? value) {
    _ordering = value;
    loadItems(resetPage: true);
  }

  @override
  Future<PageData<Process>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getProcesses(
      page: page,
      pageSize: pageSize,
      search: search,
      isActive: _isActive,
      taskGenerationRule: _taskGenerationRule,
      ordering: _ordering,
    );
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
