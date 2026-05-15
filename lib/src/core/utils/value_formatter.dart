/// 共享值格式化工具类
///
/// 整合 [GenericValueFormatter] 和 [CrudValueFormatter] 的公共逻辑，
/// 避免在多个文件中重复定义格式化方法。
class AppValueFormatter {
  const AppValueFormatter._();

  static const String empty = '-';

  // ── 通用文本 ────────────────────────────────────────────

  /// 格式化动态值，null 或空字符串返回 [empty]。
  static String text(dynamic value) {
    if (value == null) return empty;
    final asString = value.toString().trim();
    return asString.isEmpty ? empty : asString;
  }

  /// 格式化字符串值，null 或空白返回 [fallback]。
  static String textOr(String? value, {String fallback = empty}) {
    final resolved = value?.trim() ?? '';
    return resolved.isEmpty ? fallback : resolved;
  }

  // ── 布尔 ────────────────────────────────────────────────

  static String boolText(bool? value) {
    if (value == null) return empty;
    return value ? '是' : '否';
  }

  // ── 数字 ────────────────────────────────────────────────

  static String number(num? value, {String fallback = empty}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static String amount(
    num? value, {
    int fractionDigits = 2,
    String fallback = empty,
  }) {
    if (value == null) return fallback;
    return value.toStringAsFixed(fractionDigits);
  }

  // ── 日期 / 日期时间 ─────────────────────────────────────

  /// 格式化日期，接受 DateTime 或可解析的字符串。
  static String date(dynamic value, {String fallback = empty}) {
    if (value == null) return fallback;
    if (value is DateTime) return _formatDate(value);
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed == null ? text(value) : _formatDate(parsed);
    }
    return text(value);
  }

  /// 格式化日期时间，仅接受 DateTime?。
  static String dateTime(DateTime? value, {String fallback = empty}) {
    if (value == null) return fallback;
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  static String _formatDate(DateTime value) {
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
