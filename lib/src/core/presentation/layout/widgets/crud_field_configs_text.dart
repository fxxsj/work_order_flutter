part of 'crud_form_field.dart';

final class TextFieldConfig extends CrudFieldConfig {
  const TextFieldConfig({
    required this.label,
    this.fieldKey,
    this.controller,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.keyboardType,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.isDense = false,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isDense;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => TextInputField(
        key: fieldKey,
        label: label,
        type: TextInputFieldType.text,
        controller: controller,
        initialValue: initialValue,
        validator: validator,
        enabled: enabled,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        readOnly: readOnly,
        onTap: onTap,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: isDense,
      );
}

final class NumberFieldConfig extends CrudFieldConfig {
  const NumberFieldConfig({
    required this.label,
    this.fieldKey,
    this.controller,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.decimal = false,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.isDense = false,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final bool decimal;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isDense;

  @override
  Widget build(BuildContext context) => TextInputField(
        key: fieldKey,
        label: label,
        type: TextInputFieldType.number,
        controller: controller,
        initialValue: initialValue,
        validator: validator,
        enabled: enabled,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: isDense,
      );
}

final class EmailFieldConfig extends CrudFieldConfig {
  const EmailFieldConfig({
    required this.label,
    this.fieldKey,
    this.controller,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => TextInputField(
        key: fieldKey,
        label: label,
        type: TextInputFieldType.email,
        controller: controller,
        initialValue: null,
        validator: validator,
        enabled: enabled,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: false,
      );
}

final class PhoneFieldConfig extends CrudFieldConfig {
  const PhoneFieldConfig({
    required this.label,
    this.fieldKey,
    this.controller,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => TextInputField(
        key: fieldKey,
        label: label,
        type: TextInputFieldType.phone,
        controller: controller,
        initialValue: null,
        validator: validator,
        enabled: enabled,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: false,
      );
}

final class TextareaFieldConfig extends CrudFieldConfig {
  const TextareaFieldConfig({
    required this.label,
    this.fieldKey,
    this.controller,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.minLines = 2,
    this.maxLines = 3,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.isDense = false,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final int minLines;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool isDense;

  @override
  Widget build(BuildContext context) => TextareaField(
        key: fieldKey,
        label: label,
        controller: controller,
        initialValue: null,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        maxLines: maxLines,
        isDense: isDense,
        onChanged: onChanged,
      );
}
