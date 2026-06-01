import 'package:flutter/material.dart';

class CheckboxGroupFieldOption<T> {
  const CheckboxGroupFieldOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

class CheckboxGroupField<T> extends FormField<Set<T>> {
  CheckboxGroupField({
    super.key,
    required String label,
    required List<CheckboxGroupFieldOption<T>> options,
    required Set<T> values,
    ValueChanged<Set<T>>? onChanged,
    String? Function(Set<T>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无可选项',
  }) : _label = label,
       _options = options,
       _onChanged = onChanged,
       _enabled = enabled,
       _hintText = hintText,
       _helperText = helperText,
       _emptyText = emptyText,
       super(
         initialValue: Set<T>.from(values),
         validator: validator,
         builder: (state) =>
             _CheckboxGroupFieldBody<T>(state: state, values: values),
       );

  final String _label;
  final List<CheckboxGroupFieldOption<T>> _options;
  final ValueChanged<Set<T>>? _onChanged;
  final bool _enabled;
  final String? _hintText;
  final String? _helperText;
  final String _emptyText;
}

class _CheckboxGroupFieldBody<T> extends StatelessWidget {
  const _CheckboxGroupFieldBody({required this.state, required this.values});

  final FormFieldState<Set<T>> state;
  final Set<T> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widget = state.widget as CheckboxGroupField<T>;
    final currentValues = state.value ?? Set<T>.from(values);

    return InputDecorator(
      decoration:
          InputDecoration(
                labelText: widget._label,
                helperText: widget._helperText ?? widget._hintText,
                errorText: state.errorText,
              )
              .applyDefaults(theme.inputDecorationTheme)
              .copyWith(enabled: widget._enabled),
      child: widget._options.isEmpty
          ? Text(
              widget._emptyText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: widget._options
                  .map(
                    (option) => CheckboxListTile(
                      value: currentValues.contains(option.value),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(option.label),
                      onChanged: widget._enabled && option.enabled
                          ? (checked) {
                              final nextValues = Set<T>.from(currentValues);
                              if (checked == true) {
                                nextValues.add(option.value);
                              } else {
                                nextValues.remove(option.value);
                              }
                              state.didChange(nextValues);
                              widget._onChanged?.call(nextValues);
                            }
                          : null,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
