import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';

enum CrudFieldType {
  text,
  number,
  email,
  phone,
  dropdown,
  date,
  textarea,
  toggle,
  custom,
}

class CrudFieldOption<T> {
  const CrudFieldOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class CrudFormField {
  CrudFormField._({
    required this.label,
    required this.type,
    this.fieldKey,
    this.controller,
    this.validator,
    this.options = const [],
    this.value,
    this.onChanged,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.builder,
  });

  CrudFormField.text({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) : this._(
          label: label,
          type: CrudFieldType.text,
          fieldKey: fieldKey,
          controller: controller,
          validator:
              validator == null ? null : (value) => validator(value as String?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
        );

  CrudFormField.number({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool decimal = false,
  }) : this._(
          label: label,
          type: CrudFieldType.number,
          fieldKey: fieldKey,
          controller: controller,
          validator:
              validator == null ? null : (value) => validator(value as String?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        );

  CrudFormField.email({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
  }) : this._(
          label: label,
          type: CrudFieldType.email,
          fieldKey: fieldKey,
          controller: controller,
          validator:
              validator == null ? null : (value) => validator(value as String?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          keyboardType: TextInputType.emailAddress,
        );

  CrudFormField.phone({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
  }) : this._(
          label: label,
          type: CrudFieldType.phone,
          fieldKey: fieldKey,
          controller: controller,
          validator:
              validator == null ? null : (value) => validator(value as String?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          keyboardType: TextInputType.phone,
        );

  CrudFormField.dropdown({
    required String label,
    Key? fieldKey,
    required List<CrudFieldOption<dynamic>> options,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    String? Function(dynamic)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
  }) : this._(
          label: label,
          type: CrudFieldType.dropdown,
          fieldKey: fieldKey,
          options: options,
          value: value,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
        );

  CrudFormField.textarea({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    int minLines = 2,
    int maxLines = 3,
  }) : this._(
          label: label,
          type: CrudFieldType.textarea,
          fieldKey: fieldKey,
          controller: controller,
          validator:
              validator == null ? null : (value) => validator(value as String?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          minLines: minLines,
          maxLines: maxLines,
        );

  CrudFormField.toggle({
    required String label,
    Key? fieldKey,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
    String? helperText,
  }) : this._(
          label: label,
          type: CrudFieldType.toggle,
          fieldKey: fieldKey,
          value: value,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as bool),
          enabled: enabled,
          helperText: helperText,
        );

  CrudFormField.custom({
    Key? fieldKey,
    required Widget Function(BuildContext context) builder,
  }) : this._(
          label: '',
          type: CrudFieldType.custom,
          fieldKey: fieldKey,
          builder: builder,
        );

  final String label;
  final CrudFieldType type;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? Function(dynamic)? validator;
  final List<CrudFieldOption<dynamic>> options;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final int? minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget Function(BuildContext context)? builder;

  Widget build(BuildContext context) {
    if (builder != null) {
      return builder!(context);
    }

    switch (type) {
      case CrudFieldType.dropdown:
        return SearchableDropdownFormField<dynamic>(
          key: fieldKey,
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            helperText: helperText,
          ),
          items: options
              .map(
                (option) => DropdownMenuItem<dynamic>(
                  value: option.value,
                  child: Text(option.label),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
        );
      case CrudFieldType.toggle:
        return InputDecorator(
          key: fieldKey,
          decoration: InputDecoration(
            labelText: label,
            helperText: helperText,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Switch(
              value: value as bool? ?? false,
              onChanged:
                  enabled ? (nextValue) => onChanged?.call(nextValue) : null,
            ),
          ),
        );
      case CrudFieldType.textarea:
        return TextFormField(
          key: fieldKey,
          controller: controller,
          validator: validator as String? Function(String?)?,
          enabled: enabled,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            helperText: helperText,
          ),
        );
      case CrudFieldType.text:
      case CrudFieldType.number:
      case CrudFieldType.email:
      case CrudFieldType.phone:
      case CrudFieldType.date:
        return TextFormField(
          key: fieldKey,
          controller: controller,
          validator: validator as String? Function(String?)?,
          enabled: enabled,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            helperText: helperText,
          ),
        );
      case CrudFieldType.custom:
        return const SizedBox.shrink();
    }
  }
}
