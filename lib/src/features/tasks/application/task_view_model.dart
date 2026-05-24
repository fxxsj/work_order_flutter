import 'dart:async';

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
  String? _todoFilter;
  Map<String, dynamic> _summary = const {};
  int _summaryRequestToken = 0;

  List<Task> get tasks => items;
  Map<String, dynamic> get summary => _summary;

  Future<void> initialize() => loadTasks(resetPage: true);

  Future<void> loadTasks({bool resetPage = false}) async {
    await loadItems(resetPage: resetPage);
    unawaited(_loadSummary());
  }

  String? get statusFilter => _statusFilter;
  String? get priorityFilter => _priorityFilter;
  int? get departmentFilterId => _departmentFilterId;
  int? get processFilterId => _processFilterId;
  String? get todoFilter => _todoFilter;

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

  void setTodoFilter(String? value) {
    _todoFilter = value?.trim().isEmpty == true ? null : value;
  }

  Future<void> applyRoutePrefill({
    String? search,
    String? status,
    String? priority,
    int? departmentId,
    int? processId,
    String? todo,
  }) async {
    setSearchText(search?.trim() ?? '');
    _statusFilter = status?.trim().isEmpty == true ? null : status?.trim();
    _priorityFilter =
        priority?.trim().isEmpty == true ? null : priority?.trim();
    _departmentFilterId =
        departmentId != null && departmentId > 0 ? departmentId : null;
    _processFilterId = processId != null && processId > 0 ? processId : null;
    _todoFilter = todo?.trim().isEmpty == true ? null : todo?.trim();
    await loadTasks(resetPage: true);
  }

  Future<void> _loadSummary() async {
    final token = ++_summaryRequestToken;
    try {
      final summary = await _repository.getSummary(
        search: searchText,
        status: _statusFilter,
        priority: _priorityFilter,
        departmentId: _departmentFilterId,
        processId: _processFilterId,
        todo: _todoFilter,
      );
      if (token != _summaryRequestToken) return;
      _summary = summary;
      safeNotify();
    } catch (_) {
      if (token != _summaryRequestToken) return;
      // Keep the list usable even if summary loading fails.
    }
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
      todo: _todoFilter,
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
