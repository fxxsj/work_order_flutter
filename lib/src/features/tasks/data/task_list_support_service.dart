import 'dart:typed_data';

import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/departments/data/department_api_service.dart';
import 'package:work_order_app/src/features/departments/data/department_dto.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/data/process_dto.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/tasks/data/task_api_service.dart';

class TaskListFilterOptions {
  const TaskListFilterOptions({
    required this.departments,
    required this.processes,
  });

  final List<Department> departments;
  final List<Process> processes;
}

class TaskExportResult {
  const TaskExportResult({
    required this.bytes,
    required this.filename,
  });

  final Uint8List bytes;
  final String filename;
}

class TaskListSupportService {
  TaskListSupportService(this._client);

  final ApiClient _client;

  Future<TaskListFilterOptions> loadFilterOptions() async {
    final results = await Future.wait([
      DepartmentApiService(_client).fetchDepartments(page: 1, pageSize: 200),
      ProcessApiService(_client).fetchProcesses(page: 1, pageSize: 200),
    ]);
    final departmentPage = results[0] as DepartmentPageDto;
    final processPage = results[1] as ProcessPageDto;
    return TaskListFilterOptions(
      departments: departmentPage.items
          .map<Department>((item) => item.toEntity())
          .toList(),
      processes:
          processPage.items.map<Process>((item) => item.toEntity()).toList(),
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
    return TaskApiService(_client).assign(taskId, {
      'operator_id': operatorId,
      'notes': notes,
    });
  }

  String _resolveExportFilename(
    dynamic response, {
    required String fallback,
  }) {
    final timestamp =
        DateTime.now().toIso8601String().replaceAll(':', '').split('.').first;
    try {
      final headers = response.headers;
      final contentDisposition = headers.value('content-disposition') ??
          headers.value('Content-Disposition');
      if (contentDisposition != null) {
        final match =
            RegExp('filename=\"?([^\";]+)\"?').firstMatch(contentDisposition);
        if (match != null) {
          return match.group(1) ?? '${fallback}_$timestamp.xlsx';
        }
      }
    } catch (_) {
      // ignore header parsing errors
    }
    return '${fallback}_$timestamp.xlsx';
  }
}
