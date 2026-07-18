import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/models/api_response.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/tasks/data/task_supervisor_support_service.dart';

void main() {
  test('board loading requests one bounded page', () async {
    final client = _RecordingApiClient();
    final service = TaskSupervisorSupportService(client);

    final board = await service.loadDepartmentBoardTasks(7);

    expect(client.paths, ['/workorder-tasks/']);
    expect(client.queryParameters.single, {
      'page': 1,
      'page_size': TaskSupervisorSupportService.taskPageSize,
      'assigned_department': 7,
      'ordering': '-created_at',
    });
    expect(board.tasks, isEmpty);
    expect(board.taskTotal, 125);
    expect(board.taskPage, 1);
    expect(board.taskPageSize, TaskSupervisorSupportService.taskPageSize);
  });
}

class _RecordingApiClient extends ApiClient {
  final List<String> paths = [];
  final List<Map<String, dynamic>?> queryParameters = [];

  @override
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    paths.add(path);
    this.queryParameters.add(queryParameters);
    return ApiResponse(
      success: true,
      data: {'count': 125, 'results': <Map<String, dynamic>>[]},
    );
  }
}
