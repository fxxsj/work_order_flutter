import 'package:flutter/material.dart';

class RadioGroupFieldOption<T> {
  const RadioGroupFieldOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

class RadioGroupField<T> extends FormField<T> {
  RadioGroupField({
    super.key,
    required String label,
    required List<RadioGroupFieldOption<T>> options,
    required T value,
    ValueChanged<T>? onChanged,
    String? Function(T?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
  }) : _label = label,
       _onChanged = onChanged,
       _enabled = enabled,
       _hintText = hintText,
       _helperText = helperText,
       super(
         initialValue: value,
         validator: validator,
         builder: (state) =>
             _RadioGroupFieldBody<T>(state: state, options: options),
       );

  final String _label;
  final ValueChanged<T>? _onChanged;
  final bool _enabled;
  final String? _hintText;
  final String? _helperText;
}

class _RadioGroupFieldBody<T> extends StatelessWidget {
  const _RadioGroupFieldBody({required this.state, required this.options});

  final FormFieldState<T> state;
  final List<RadioGroupFieldOption<T>> options;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widget = state.widget as RadioGroupField<T>;
    final currentValue = state.value;

    return InputDecorator(
      decoration:
          InputDecoration(
                labelText: widget._label,
                helperText: widget._helperText ?? widget._hintText,
                errorText: state.errorText,
              )
              .applyDefaults(theme.inputDecorationTheme)
              .copyWith(enabled: widget._enabled),
      child: RadioGroup<T>(
        groupValue: currentValue,
        onChanged: (nextValue) {
          if (nextValue != null && widget._enabled) {
            state.didChange(nextValue);
            widget._onChanged?.call(nextValue);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return RadioListTile<T>(
              value: option.value,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(option.label),
              enabled: widget._enabled && option.enabled,
            );
          }).toList(),
        ),
      ),
    );
  }
}
