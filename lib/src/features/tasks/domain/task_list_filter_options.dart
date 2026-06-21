import 'dart:typed_data';

import 'package:work_order_app/src/features/processes/domain/process.dart';
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
