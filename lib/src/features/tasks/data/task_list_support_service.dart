import 'dart:typed_data';

import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';
import 'package:work_order_app/src/features/tasks/presentation/task_department_option.dart';

class TaskListFilterOptions {
  const TaskListFilterOptions({
    required this.departments,
    required this.processes,
  });

  final List<TaskDepartmentOption> departments;
  final List<Process> processes;
}

class TaskExportResult {
  const TaskExportResult({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}

class TaskListSupportService {
  TaskListSupportService(this._client);

  final ApiClient _client;

  Future<TaskListFilterOptions> loadFilterOptions() async {
    final departmentFuture = DepartmentApiService(
      _client,
    ).fetchDepartments(page: 1, pageSize: 50);
    final processFuture = ProcessApiService(
      _client,
    ).fetchProcesses(page: 1, pageSize: 50);

    final departmentPage = await departmentFuture;
    final processPage = await processFuture;

    return TaskListFilterOptions(
      departments: departmentPage.items
          .map(
            (item) => TaskDepartmentOption(
              id: item.id,
              name: item.name,
              processIds: item.processIds,
            ),
          )
          .toList(),
      processes: processPage.items.map((item) => item.toEntity()).toList(),
    );
  }

  Future<TaskExportResult> export(Map<String, dynamic> params) async {
    final response = await TaskApiService(_client).export(params: params);
    final data = response.data;
    final bytes = data is Uint8List
        ? data
        : data is List<int>
        ? Uint8List.fromList(data)
        : null;
    if (bytes == null) {
      throw const FormatException('返回格式不支持');
    }
    return TaskExportResult(
      bytes: bytes,
      filename: _resolveExportFilename(response, fallback: '任务列表'),
    );
  }

  Future<List<Map<String, dynamic>>> loadOperators(int departmentId) {
    return TaskApiService(_client).fetchDepartmentOperators(departmentId);
  }

  Future<List<TaskDepartmentOption>> loadProcessDepartments(
    int processId,
  ) async {
    final departments = await TaskApiService(
      _client,
    ).fetchProcessDepartments(processId);
    return departments
        .map((item) {
          final processIds = _parseProcessIds(
            item,
            fallbackProcessId: processId,
          );
          return TaskDepartmentOption(
            id: toInt(item['id']) ?? 0,
            name: item['name']?.toString() ?? '',
            processIds: processIds,
          );
        })
        .where((item) => item.id > 0 && item.name.isNotEmpty)
        .toList();
  }

  Future<void> updateQuantity(int taskId, Map<String, dynamic> payload) {
    return TaskApiService(_client).updateQuantity(taskId, payload);
  }

  Future<void> completeTask(int taskId, Map<String, dynamic> payload) {
    return TaskApiService(_client).complete(taskId, payload);
  }

  Future<void> assignTask(
    int taskId, {
    required int operatorId,
    required String notes,
  }) {
    return TaskApiService(
      _client,
    ).assignToOperator(taskId, operatorId: operatorId, notes: notes);
  }

  String _resolveExportFilename(dynamic response, {required String fallback}) {
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '')
        .split('.')
        .first;
    try {
      final headers = response.headers;
      final contentDisposition =
          headers.value('content-disposition') ??
          headers.value('Content-Disposition');
      if (contentDisposition != null) {
        final match = RegExp(
          'filename=\"?([^\";]+)\"?',
        ).firstMatch(contentDisposition);
        if (match != null) {
          return match.group(1) ?? '${fallback}_$timestamp.xlsx';
        }
      }
    } catch (_) {
      // ignore header parsing errors
    }
    return '${fallback}_$timestamp.xlsx';
  }

  List<int> _parseProcessIds(
    Map<String, dynamic> item, {
    required int fallbackProcessId,
  }) {
    final ids = <int>{};
    final raw = item['process_ids'] ?? item['processes'];
    if (raw is List) {
      for (final value in raw) {
        final id = value is Map ? toInt(value['id']) : toInt(value);
        if (id != null && id > 0) ids.add(id);
      }
    }
    ids.add(fallbackProcessId);
    return ids.toList();
  }
}
