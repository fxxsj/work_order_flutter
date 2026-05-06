/// Formats a [DateTime] as a human-readable relative time string in Chinese.
String formatRelativeTime(DateTime createdAt) {
  final diff = DateTime.now().difference(createdAt);
  if (diff.inMinutes < 1) {
    return '刚刚';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}分钟前';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours}小时前';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays}天前';
  }
  final hour = createdAt.hour.toString().padLeft(2, '0');
  final minute = createdAt.minute.toString().padLeft(2, '0');
  return '${createdAt.month}月${createdAt.day}日 $hour:$minute';
}
