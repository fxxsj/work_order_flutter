import 'package:flutter/material.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText ?? '取消',
    confirmText: confirmText ?? '确定',
    errorFormatText: errorFormatText ?? '请输入正确的日期格式',
    errorInvalidText: errorInvalidText ?? '日期不在可选范围内',
    fieldHintText: fieldHintText ?? '年/月/日',
    fieldLabelText: fieldLabelText ?? '输入日期',
    builder: _buildPickerTheme,
  );
}

Future<DateTimeRange?> showAppDateRangePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? saveText,
  String? errorFormatText,
  String? errorInvalidText,
  String? errorInvalidRangeText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? fieldStartLabelText,
  String? fieldEndLabelText,
}) {
  return showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDateRange: initialDateRange,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    helpText: helpText,
    cancelText: cancelText ?? '取消',
    confirmText: confirmText ?? '确定',
    saveText: saveText ?? confirmText ?? '确定',
    errorFormatText: errorFormatText ?? '请输入正确的日期格式',
    errorInvalidText: errorInvalidText ?? '日期不在可选范围内',
    errorInvalidRangeText: errorInvalidRangeText ?? '结束日期不能早于开始日期',
    fieldStartHintText: fieldStartHintText ?? '开始日期',
    fieldEndHintText: fieldEndHintText ?? '结束日期',
    fieldStartLabelText: fieldStartLabelText ?? '开始日期',
    fieldEndLabelText: fieldEndLabelText ?? '结束日期',
    builder: _buildPickerTheme,
  );
}

Widget _buildPickerTheme(BuildContext context, Widget? child) {
  final theme = Theme.of(context);
  final compactHeader = theme.textTheme.headlineSmall?.copyWith(
    fontFamily: 'Roboto',
    fontSize: 20,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
  final compactMediumHeader = theme.textTheme.headlineMedium?.copyWith(
    fontFamily: 'Roboto',
    fontSize: 20,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
  return Theme(
    data: theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        headlineSmall: compactHeader,
        headlineMedium: compactMediumHeader,
      ),
    ),
    child: child ?? const SizedBox.shrink(),
  );
}
