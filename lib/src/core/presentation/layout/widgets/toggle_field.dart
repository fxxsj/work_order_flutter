import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Toggle/switch field for [CrudFieldConfig.toggle].
class ToggleField extends FormField<bool> {
  ToggleField({
    super.key,
    required String label,
    required bool value,
    ValueChanged<bool>? onChanged,
    String? Function(bool?)? validator,
    bool enabled = true,
    String? helperText,
  }) : super(
          initialValue: value,
          validator: validator,
          onSaved: (v) => onChanged?.call(v ?? false),
          builder: (state) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                helperText: helperText,
                errorText: state.errorText,
                filled: true,
                fillColor: Theme.of(state.context).colorScheme.surfaceContainerLowest,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                  borderSide: BorderSide(
                    color: ColorTokens.border,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                  borderSide: BorderSide(
                    color: Theme.of(state.context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                  borderSide: BorderSide(
                    color: ColorTokens.danger,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
                  borderSide: BorderSide(
                    color: ColorTokens.danger,
                    width: 2,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Switch(
                  value: state.value ?? false,
                  onChanged: enabled
                      ? (nextValue) {
                          state.didChange(nextValue);
                          onChanged?.call(nextValue);
                        }
                      : null,
                ),
              ),
            );
          },
        );
}
