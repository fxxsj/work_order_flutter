import 'package:flutter/material.dart';

class DateRangeFilterField extends StatelessWidget {
  const DateRangeFilterField({
    super.key,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
    this.hintText = '请选择日期范围',
    this.helperText,
    this.firstDate,
    this.lastDate,
    this.clearTooltip = '清空',
  });

  final String label;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange?> onChanged;
  final String hintText;
  final String? helperText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String clearTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasRange = startDate != null && endDate != null;
    final displayText = hasRange
        ? '${_formatDate(startDate!)} ~ ${_formatDate(endDate!)}'
        : hintText;

    return InkWell(
      onTap: () => _pickRange(context),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasRange)
                IconButton(
                  tooltip: clearTooltip,
                  onPressed: () => onChanged(null),
                  icon: const Icon(Icons.close, size: 16),
                ),
              const Icon(Icons.date_range_outlined, size: 18),
              const SizedBox(width: 12),
            ],
          ),
        ).applyDefaults(theme.inputDecorationTheme),
        child: Text(
          displayText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: hasRange ? null : theme.hintColor,
          ),
        ),
      ),
    );
  }

  Future<void> _pickRange(BuildContext context) async {
    final now = DateTime.now();
    final resolvedFirstDate = firstDate ?? DateTime(2020);
    final resolvedLastDate = lastDate ?? now.add(const Duration(days: 365));
    final initialRange = startDate != null && endDate != null
        ? DateTimeRange(start: startDate!, end: endDate!)
        : null;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: resolvedFirstDate,
      lastDate: resolvedLastDate,
      initialDateRange: initialRange,
      helpText: label,
    );
    if (picked == null) {
      return;
    }
    onChanged(
      DateTimeRange(
        start:
            DateTime(picked.start.year, picked.start.month, picked.start.day),
        end: DateTime(picked.end.year, picked.end.month, picked.end.day),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
