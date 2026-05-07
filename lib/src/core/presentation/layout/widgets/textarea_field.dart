import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Textarea field for [CrudFieldConfig.textarea].
class TextareaField extends StatelessWidget {
  const TextareaField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.minLines = 2,
    this.maxLines = 3,
    this.isDense = false,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int minLines;
  final int maxLines;
  final bool isDense;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      validator: validator,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: isDense,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
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
            color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
