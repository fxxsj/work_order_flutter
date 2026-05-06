import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

enum TextInputFieldType { text, number, email, phone }

/// Unified text input field for [CrudFormField.text], [CrudFormField.number],
/// [CrudFormField.email], and [CrudFormField.phone].
class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    required this.label,
    required this.type,
    this.controller,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.obscureText = false,
    this.isDense = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String label;
  final TextInputFieldType type;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool isDense;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  TextInputType get _keyboardType {
    switch (type) {
      case TextInputFieldType.number:
        return TextInputType.number;
      case TextInputFieldType.email:
        return TextInputType.emailAddress;
      case TextInputFieldType.phone:
        return TextInputType.phone;
      case TextInputFieldType.text:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      validator: validator,
      enabled: enabled,
      keyboardType: _keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      onTap: onTap,
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
