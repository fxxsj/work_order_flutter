import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';

class TaskViewModel extends PaginatedViewModel<Task> {
  TaskViewModel(this._repository);

  final TaskRepository _repository;
  String? _statusFilter;
  String? _priorityFilter;
  int? _departmentFilterId;
  int? _processFilterId;

  List<Task> get tasks => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadTasks({bool resetPage = false}) => loadItems(resetPage: resetPage);

  String? get statusFilter => _statusFilter;
  String? get priorityFilter => _priorityFilter;
  int? get departmentFilterId => _departmentFilterId;
  int? get processFilterId => _processFilterId;

  void setStatusFilter(String? value) {
    _statusFilter = value?.trim().isEmpty == true ? null : value;
  }

  void setPriorityFilter(String? value) {
    _priorityFilter = value?.trim().isEmpty == true ? null : value;
  }

  void setDepartmentFilterId(int? value) {
    _departmentFilterId = value;
  }

  void setProcessFilterId(int? value) {
    _processFilterId = value;
  }

  @override
  Future<PageData<Task>> fetchPage({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final result = await _repository.getTasks(
      page: page,
      pageSize: pageSize,
      search: search,
      status: _statusFilter,
      priority: _priorityFilter,
      departmentId: _departmentFilterId,
      processId: _processFilterId,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
