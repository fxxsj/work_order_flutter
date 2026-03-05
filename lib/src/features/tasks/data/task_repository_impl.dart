import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/data/task_dto.dart';
import 'package:work_order_app/src/features/tasks/domain/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._apiService);

  final TaskApiService _apiService;

  @override
  Future<TaskPageDto> getTasks({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchTasks(page: page, pageSize: pageSize, search: search);
  }
}
