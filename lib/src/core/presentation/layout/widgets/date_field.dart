import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Date field for [CrudFormField.date].
class DateField extends FormField<String> {
  DateField({
    super.key,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool readOnly = true,
    VoidCallback? onTap,
  }) : super(
          initialValue: controller.text,
          validator: validator,
          builder: (state) {
            return Builder(
              builder: (ctx) {
                return TextFormField(
                  controller: controller,
                  validator: validator,
                  enabled: enabled,
                  readOnly: readOnly,
                  onTap: onTap,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hintText,
                    helperText: helperText,
                    filled: true,
                    fillColor: Theme.of(ctx).colorScheme.surfaceContainerLowest,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(LayoutTokens.radiusSm),
                      borderSide: BorderSide(
                        color: ColorTokens.border,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(LayoutTokens.radiusSm),
                      borderSide: BorderSide(
                        color: Theme.of(ctx).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(LayoutTokens.radiusSm),
                      borderSide: BorderSide(
                        color: ColorTokens.danger,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(LayoutTokens.radiusSm),
                      borderSide: BorderSide(
                        color: ColorTokens.danger,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
}
