extension NullableDateTimeExtensions on DateTime? {
  String get toYMD => _formatDate(this, includeTime: false);

  String get toYMDHM => _formatDate(this, includeTime: true);
}

String _formatDate(
  DateTime? value, {
  required bool includeTime,
  String emptyValue = '-',
}) {
  if (value == null) {
    return emptyValue;
  }
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final ymd = '$year-$month-$day';
  if (!includeTime) {
    return ymd;
  }
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$ymd $hour:$minute';
}
