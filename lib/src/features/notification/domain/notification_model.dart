enum NotificationLevel {
  info,
  warning,
  urgent,
}

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.notificationType,
    required this.priority,
    this.isRead = false,
    this.level = NotificationLevel.info,
    this.readAt,
    this.workOrderId,
    this.taskId,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final NotificationLevel level;
  final String notificationType;
  final String priority;
  final DateTime? readAt;
  final int? workOrderId;
  final int? taskId;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final priority = json['priority']?.toString() ?? 'normal';
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      notificationType: json['notification_type']?.toString() ?? 'system',
      priority: priority,
      isRead: json['is_read'] == true,
      readAt: DateTime.tryParse(json['read_at']?.toString() ?? ''),
      workOrderId: _toInt(json['work_order_id']),
      taskId: _toInt(json['task_id']),
      level: _levelForPriority(priority),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    bool? isRead,
    NotificationLevel? level,
    String? notificationType,
    String? priority,
    DateTime? readAt,
    int? workOrderId,
    int? taskId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      level: level ?? this.level,
      notificationType: notificationType ?? this.notificationType,
      priority: priority ?? this.priority,
      readAt: readAt ?? this.readAt,
      workOrderId: workOrderId ?? this.workOrderId,
      taskId: taskId ?? this.taskId,
    );
  }
}

NotificationLevel _levelForPriority(String priority) {
  switch (priority) {
    case 'urgent':
      return NotificationLevel.urgent;
    case 'high':
      return NotificationLevel.warning;
    case 'normal':
    case 'low':
    default:
      return NotificationLevel.info;
  }
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}
