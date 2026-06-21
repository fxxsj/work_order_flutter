import 'package:work_order_app/src/features/tasks/domain/task.dart';

class OperatorSummary {
  const OperatorSummary({
    this.myTotal = 0,
    this.myPending = 0,
    this.myInProgress = 0,
    this.myCompleted = 0,
    this.claimableCount = 0,
  });

  final int myTotal;
  final int myPending;
  final int myInProgress;
  final int myCompleted;
  final int claimableCount;

  factory OperatorSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OperatorSummary();
    return OperatorSummary(
      myTotal: (json['my_total'] ?? 0) as int,
      myPending: (json['my_pending'] ?? 0) as int,
      myInProgress: (json['my_in_progress'] ?? 0) as int,
      myCompleted: (json['my_completed'] ?? 0) as int,
      claimableCount: (json['claimable_count'] ?? 0) as int,
    );
  }
}

class PaginationMeta {
  const PaginationMeta({
    this.myTotal = 0,
    this.myCount = 0,
    this.myHasMore = false,
    this.claimableTotal = 0,
    this.claimableCount = 0,
    this.claimableHasMore = false,
  });

  final int myTotal;
  final int myCount;
  final bool myHasMore;
  final int claimableTotal;
  final int claimableCount;
  final bool claimableHasMore;

  factory PaginationMeta.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PaginationMeta();
    return PaginationMeta(
      myTotal: (json['my_total'] ?? 0) as int,
      myCount: (json['my_count'] ?? 0) as int,
      myHasMore: (json['my_has_more'] ?? false) as bool,
      claimableTotal: (json['claimable_total'] ?? 0) as int,
      claimableCount: (json['claimable_count'] ?? 0) as int,
      claimableHasMore: (json['claimable_has_more'] ?? false) as bool,
    );
  }
}

class TaskOperatorCenterResult {
  const TaskOperatorCenterResult({
    required this.myTasks,
    required this.claimableTasks,
    required this.myTasksRaw,
    required this.claimableTasksRaw,
    required this.summary,
    required this.meta,
  });

  final List<Task> myTasks;
  final List<Task> claimableTasks;
  final List<Map<String, dynamic>> myTasksRaw;
  final List<Map<String, dynamic>> claimableTasksRaw;
  final OperatorSummary summary;
  final PaginationMeta meta;
}
