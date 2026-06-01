import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_date_picker.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class DateRangeField extends FormField<DateTimeRange?> {
  DateRangeField({
    super.key,
    required String label,
    required this.startController,
    required this.endController,
    String? Function(DateTimeRange?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
    DateTime? firstDate,
    DateTime? lastDate,
  }) : _label = label,
       _enabled = enabled,
       _hintText = hintText,
       _helperText = helperText,
       _clearText = clearText,
       _confirmText = confirmText,
       _cancelText = cancelText,
       _firstDate = firstDate,
       _lastDate = lastDate,
       super(
         initialValue: _dateRangeFromControllers(
           startController,
           endController,
         ),
         validator: validator,
         builder: (state) => _DateRangeFieldBody(
           state: state,
           startController: startController,
           endController: endController,
         ),
       );

  final String _label;
  final bool _enabled;
  final String? _hintText;
  final String? _helperText;
  final String _clearText;
  final String _confirmText;
  final String _cancelText;
  final DateTime? _firstDate;
  final DateTime? _lastDate;
  final TextEditingController startController;
  final TextEditingController endController;

  @override
  FormFieldState<DateTimeRange?> createState() => _DateRangeFieldState();
}

class _DateRangeFieldState extends FormFieldState<DateTimeRange?> {
  @override
  DateRangeField get widget => super.widget as DateRangeField;

  @override
  void didUpdateWidget(covariant DateRangeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextValue = _dateRangeFromControllers(
      widget.startController,
      widget.endController,
    );
    final current = value;
    final changed =
        current?.start != nextValue?.start || current?.end != nextValue?.end;
    if (changed) setValue(nextValue);
  }
}

class _DateRangeFieldBody extends StatelessWidget {
  const _DateRangeFieldBody({
    required this.state,
    required this.startController,
    required this.endController,
  });

  final FormFieldState<DateTimeRange?> state;
  final TextEditingController startController;
  final TextEditingController endController;

  DateRangeField get _field => state.widget as DateRangeField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = state.value;
    final hasValue = currentValue != null;
    final text = hasValue
        ? '${_formatDateYmd(currentValue.start)} ~ ${_formatDateYmd(currentValue.end)}'
        : (_field._hintText ?? '请选择日期范围');

    return InkWell(
      onTap: _field._enabled
          ? () => _pickDateRange(context, currentValue)
          : null,
      borderRadius: BorderRadius.circular(RadiusTokens.sm),
      child: InputDecorator(
        decoration:
            InputDecoration(
                  labelText: _field._label,
                  helperText: _field._helperText,
                  errorText: state.errorText,
                  prefixIcon: const Icon(Icons.date_range_outlined, size: 18),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasValue && _field._enabled)
                        IconButton(
                          tooltip: _field._clearText,
                          onPressed: () {
                            startController.clear();
                            endController.clear();
                            state.didChange(null);
                          },
                          icon: const Icon(Icons.clear, size: 18),
                        ),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                      SizedBox(width: SpacingTokens.md),
                    ],
                  ),
                )
                .applyDefaults(theme.inputDecorationTheme)
                .copyWith(enabled: _field._enabled),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: hasValue ? null : theme.hintColor,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    DateTimeRange? currentValue,
  ) async {
    final now = DateTime.now();
    final resolvedFirstDate = _field._firstDate ?? DateTime(now.year - 5);
    final resolvedLastDate = _field._lastDate ?? DateTime(now.year + 5, 12, 31);
    final picked = await showAppDateRangePicker(
      context: context,
      firstDate: resolvedFirstDate,
      lastDate: resolvedLastDate,
      initialDateRange: currentValue,
      helpText: _field._label,
      confirmText: _field._confirmText,
      cancelText: _field._cancelText,
      saveText: _field._confirmText,
    );
    if (picked == null) return;
    startController.text = _formatDateYmd(picked.start);
    endController.text = _formatDateYmd(picked.end);
    state.didChange(
      DateTimeRange(
        start: DateTime(
          picked.start.year,
          picked.start.month,
          picked.start.day,
        ),
        end: DateTime(picked.end.year, picked.end.month, picked.end.day),
      ),
    );
  }
}

DateTimeRange? _dateRangeFromControllers(
  TextEditingController startController,
  TextEditingController endController,
) {
  final start = DateTime.tryParse(startController.text.trim());
  final end = DateTime.tryParse(endController.text.trim());
  if (start == null || end == null) return null;
  return DateTimeRange(
    start: DateTime(start.year, start.month, start.day),
    end: DateTime(end.year, end.month, end.day),
  );
}

String _formatDateYmd(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
