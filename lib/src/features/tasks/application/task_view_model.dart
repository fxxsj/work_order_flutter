import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/tasks/domain/task.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';

class TaskViewModel extends PaginatedViewModel<Task> {
  TaskViewModel(this._repository);

  final TaskRepository _repository;

  List<Task> get tasks => items;

  Future<void> initialize() => loadItems(resetPage: true);

  Future<void> loadTasks({bool resetPage = false}) => loadItems(resetPage: resetPage);

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
    );
    return PageData(
      items: result.items.map((dto) => dto.toEntity()).toList(),
      total: result.total,
      page: result.page,
      pageSize: result.pageSize,
    );
  }
}
