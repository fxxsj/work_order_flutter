import 'package:work_order_app/src/features/tasks/domain/task.dart';

class TaskUiHelper {
  const TaskUiHelper._();

  static String title(Task task) {
    final content = task.workContent?.trim() ?? '';
    if (content.isNotEmpty) return content;
    final process = task.processName?.trim() ?? '';
    if (process.isNotEmpty) return process;
    return '任务 #${task.id}';
  }

  static String sourceSummary(Task task) {
    final customer = task.customerName?.trim() ?? '';
    final workOrder = task.workOrderNumber?.trim() ?? '';
    if (customer.isNotEmpty && workOrder.isNotEmpty) {
      return '$customer · $workOrder';
    }
    if (customer.isNotEmpty) return customer;
    if (workOrder.isNotEmpty) return workOrder;
    return '-';
  }

  static String quantitySummary(Task task) {
    final total = task.productionQuantity;
    final completed = task.quantityCompleted;
    if (total == null && completed == null) return '-';
    final totalText = total == null ? '-' : _formatNumber(total);
    final completedText = completed == null ? '-' : _formatNumber(completed);
    return '$completedText / $totalText';
  }

  static String progressText(Task task) {
    final total = task.productionQuantity ?? 0;
    final completed = task.quantityCompleted ?? 0;
    if (total <= 0) return '-';
    final percentage =
        (completed / total * 100).clamp(0, 100).toStringAsFixed(0);
    return '$percentage%';
  }

  static String followUpText(Task task) {
    final status = task.status ?? '';
    final hasOperator = (task.assignedOperatorName ?? '').trim().isNotEmpty;
    switch (status) {
      case 'pending':
        return hasOperator ? '待开工生产' : '待分派/开工';
      case 'in_progress':
        return '跟进生产进度';
      case 'completed':
        return '推进质检/入库';
      case 'cancelled':
        return '任务已取消';
      default:
        return '-';
    }
  }

  static String? deadlineRiskText(Task task, {DateTime? now}) {
    final deliveryDate = task.deliveryDate;
    final status = task.status ?? '';
    if (deliveryDate == null ||
        status == 'completed' ||
        status == 'cancelled') {
      return null;
    }
    final today = _dateOnly(now ?? DateTime.now());
    final target = _dateOnly(deliveryDate.toLocal());
    final days = target.difference(today).inDays;
    if (days < 0) return '已逾期';
    if (days == 0) return '今天到期';
    if (days <= 2) return '$days天内到期';
    return null;
  }

  static bool isOverdue(Task task, {DateTime? now}) {
    return deadlineRiskText(task, now: now) == '已逾期';
  }

  static bool isDueSoon(Task task, {DateTime? now}) {
    final text = deadlineRiskText(task, now: now);
    return text != null && text != '已逾期';
  }

  static bool needsAssignment(Task task) {
    final status = task.status ?? '';
    return task.assignedOperatorId == null &&
        status != 'completed' &&
        status != 'cancelled';
  }

  static bool isCompletedWaitingHandoff(Task task) {
    return (task.status ?? '') == 'completed';
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static String _formatNumber(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }
}
