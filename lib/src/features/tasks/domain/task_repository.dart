import 'package:work_order_app/src/features/tasks/data/task_dto.dart';

abstract class TaskRepository {
  Future<TaskPageDto> getTasks({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
