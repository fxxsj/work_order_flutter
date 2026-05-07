import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/checkbox_group_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/color_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/date_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/date_range_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/radio_group_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/tags_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/text_input_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/textarea_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/toggle_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';

// Re-export commonly used types so existing imports don't break
export 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_field.dart'
    show CrudPickedFile;
export 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart'
    show AppDropdownOption;

/// Sealed class hierarchy for CRUD form field configurations.
///
/// Each subclass represents a specific field type and encapsulates
/// all configuration and rendering logic for that field type.
///
/// Example:
/// ```dart
/// // Using the new API
/// CrudFieldConfig.text(label: 'Name').build(context)
/// ```
sealed class CrudFieldConfig {
  const CrudFieldConfig();

  /// Build the widget for this field configuration.
  Widget build(BuildContext context);

  // Factory constructors matching the original API
  static CrudFieldConfig text({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    TextInputType? keyboardType,
    String? initialValue,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    bool isDense = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) =>
      TextFieldConfig(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        keyboardType: keyboardType,
        initialValue: initialValue,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        isDense: isDense,
        readOnly: readOnly,
        onTap: onTap,
      );

  static CrudFieldConfig number({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool decimal = false,
    String? initialValue,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    bool isDense = false,
  }) =>
      NumberFieldConfig(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        decimal: decimal,
        initialValue: initialValue,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        isDense: isDense,
      );

  static CrudFieldConfig email({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
  }) =>
      EmailFieldConfig(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      );

  static CrudFieldConfig phone({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
  }) =>
      PhoneFieldConfig(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      );

  static CrudFieldConfig dropdown({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    String? Function(dynamic)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool isMultiSelect = false,
    int minOptionsForSearch = 7,
    String? searchHintText,
    String emptyText = '暂无可选项',
    String noResultsText = '无匹配结果',
    String selectHintText = '请选择',
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      DropdownFieldConfig(
        label: label,
        fieldKey: fieldKey,
        options: options,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        isMultiSelect: isMultiSelect,
        minOptionsForSearch: minOptionsForSearch,
        searchHintText: searchHintText,
        emptyText: emptyText,
        noResultsText: noResultsText,
        selectHintText: selectHintText,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig date({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool readOnly = true,
    VoidCallback? onTap,
  }) =>
      DateFieldConfig(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        readOnly: readOnly,
        onTap: onTap,
      );

  static CrudFieldConfig dateRange({
    required String label,
    Key? fieldKey,
    required TextEditingController startController,
    required TextEditingController endController,
    String? Function(DateTimeRange?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    DateTime? firstDate,
    DateTime? lastDate,
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      DateRangeFieldConfig(
        label: label,
        fieldKey: fieldKey,
        startController: startController,
        endController: endController,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        firstDate: firstDate,
        lastDate: lastDate,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig textarea({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    int minLines = 2,
    int maxLines = 3,
    Widget? prefixIcon,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    bool isDense = false,
  }) =>
      TextareaFieldConfig(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        minLines: minLines,
        maxLines: maxLines,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        onChanged: onChanged,
        isDense: isDense,
      );

  static CrudFieldConfig toggle({
    required String label,
    Key? fieldKey,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
    String? helperText,
  }) =>
      ToggleFieldConfig(
        label: label,
        fieldKey: fieldKey,
        value: value,
        onChanged: onChanged,
        enabled: enabled,
        helperText: helperText,
      );

  static CrudFieldConfig fileUpload({
    required String label,
    Key? fieldKey,
    CrudPickedFile? value,
    ValueChanged<CrudPickedFile?>? onChanged,
    String? Function(CrudPickedFile?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    required List<String> allowedExtensions,
    String fallbackFilename = 'upload.bin',
  }) =>
      FileUploadFieldConfig(
        label: label,
        fieldKey: fieldKey,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        allowedExtensions: allowedExtensions,
        fallbackFilename: fallbackFilename,
      );

  static CrudFieldConfig multiSelect({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    required Set<dynamic> values,
    ValueChanged<Set<dynamic>>? onChanged,
    String? Function(Set<dynamic>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无可选项',
    String searchHintText = '搜索名称或编码',
    String noResultsText = '无匹配项',
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      MultiSelectFieldConfig(
        label: label,
        fieldKey: fieldKey,
        options: options,
        values: values,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
        searchHintText: searchHintText,
        noResultsText: noResultsText,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig tags({
    required String label,
    Key? fieldKey,
    required List<String> values,
    ValueChanged<List<String>>? onChanged,
    String? Function(List<String>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无标签',
  }) =>
      TagsFieldConfig(
        label: label,
        fieldKey: fieldKey,
        values: values,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
      );

  static CrudFieldConfig checkboxGroup({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    required Set<dynamic> values,
    ValueChanged<Set<dynamic>>? onChanged,
    String? Function(Set<dynamic>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无可选项',
  }) =>
      CheckboxGroupFieldConfig(
        label: label,
        fieldKey: fieldKey,
        options: options,
        values: values,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
      );

  static CrudFieldConfig radioGroup({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    String? Function(dynamic)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
  }) =>
      RadioGroupFieldConfig(
        label: label,
        fieldKey: fieldKey,
        options: options,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
      );

  static CrudFieldConfig color({
    required String label,
    Key? fieldKey,
    required Color? value,
    ValueChanged<Color?>? onChanged,
    String? Function(Color?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    List<Color>? palette,
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      ColorFieldConfig(
        label: label,
        fieldKey: fieldKey,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        palette: palette,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig custom({
    Key? fieldKey,
    required Widget Function(BuildContext context) builder,
  }) =>
      CustomFieldConfig(
        fieldKey: fieldKey,
        builder: builder,
      );
}

// ============================================================================
// Concrete Field Configurations
// ============================================================================

/// Text input field configuration
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

/// Number input field configuration
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

/// Email input field configuration
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

/// Phone input field configuration
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

/// Dropdown field configuration
final class DropdownFieldConfig extends CrudFieldConfig {
  const DropdownFieldConfig({
    required this.label,
    this.fieldKey,
    required this.options,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.isMultiSelect = false,
    this.minOptionsForSearch = 7,
    this.searchHintText,
    this.emptyText = '暂无可选项',
    this.noResultsText = '无匹配结果',
    this.selectHintText = '请选择',
    this.clearText = '清空',
    this.confirmText = '确定',
    this.cancelText = '取消',
  });

  final String label;
  final Key? fieldKey;
  final List<AppDropdownOption<dynamic>> options;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final String? Function(dynamic)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final bool isMultiSelect;
  final int minOptionsForSearch;
  final String? searchHintText;
  final String emptyText;
  final String noResultsText;
  final String selectHintText;
  final String clearText;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final dropdownOptions = options
        .map((opt) => AppDropdownOption<dynamic>(
              value: opt.value,
              label: opt.label,
              enabled: opt.enabled,
            ))
        .toList();
    return AppSelect<dynamic>(
      key: fieldKey,
      options: dropdownOptions,
      value: value,
      decoration: const InputDecoration(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      enabled: enabled,
      isMultiSelect: isMultiSelect,
      minOptionsForSearch: minOptionsForSearch,
      searchConfig: searchHintText != null
          ? AppDropdownSearchConfig(
              hintText: searchHintText,
              enabled: true,
            )
          : const AppDropdownSearchConfig(),
      emptyText: emptyText,
      noResultsText: noResultsText,
      selectHintText: selectHintText,
      clearText: clearText,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }
}

/// Date picker field configuration
final class DateFieldConfig extends CrudFieldConfig {
  const DateFieldConfig({
    required this.label,
    this.fieldKey,
    this.controller,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.readOnly = true,
    this.onTap,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => DateField(
        key: fieldKey,
        label: label,
        controller: controller!,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        readOnly: readOnly,
        onTap: onTap,
      );
}

/// Date range picker field configuration
final class DateRangeFieldConfig extends CrudFieldConfig {
  const DateRangeFieldConfig({
    required this.label,
    this.fieldKey,
    required this.startController,
    required this.endController,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.firstDate,
    this.lastDate,
    this.clearText = '清空',
    this.confirmText = '确定',
    this.cancelText = '取消',
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController startController;
  final TextEditingController endController;
  final String? Function(DateTimeRange?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String clearText;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) => DateRangeField(
        key: fieldKey,
        label: label,
        startController: startController,
        endController: endController,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
        firstDate: firstDate,
        lastDate: lastDate,
        validator: validator,
      );
}

/// Textarea field configuration
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

/// Toggle/Switch field configuration
final class ToggleFieldConfig extends CrudFieldConfig {
  const ToggleFieldConfig({
    required this.label,
    this.fieldKey,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.helperText,
  });

  final String label;
  final Key? fieldKey;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final String? helperText;

  @override
  Widget build(BuildContext context) => ToggleField(
        key: fieldKey,
        label: label,
        value: value,
        onChanged: onChanged,
        validator: null,
        enabled: enabled,
        helperText: helperText,
      );
}

/// File upload field configuration
final class FileUploadFieldConfig extends CrudFieldConfig {
  const FileUploadFieldConfig({
    required this.label,
    this.fieldKey,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    required this.allowedExtensions,
    this.fallbackFilename = 'upload.bin',
  });

  final String label;
  final Key? fieldKey;
  final CrudPickedFile? value;
  final ValueChanged<CrudPickedFile?>? onChanged;
  final String? Function(CrudPickedFile?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final List<String> allowedExtensions;
  final String fallbackFilename;

  @override
  Widget build(BuildContext context) => FileUploadField(
        key: fieldKey,
        label: label,
        value: value,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        allowedExtensions: allowedExtensions,
        fallbackFilename: fallbackFilename,
      );
}

/// Multi-select field configuration
final class MultiSelectFieldConfig extends CrudFieldConfig {
  const MultiSelectFieldConfig({
    required this.label,
    this.fieldKey,
    required this.options,
    required this.values,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.emptyText = '暂无可选项',
    this.searchHintText = '搜索名称或编码',
    this.noResultsText = '无匹配项',
    this.clearText = '清空',
    this.confirmText = '确定',
    this.cancelText = '取消',
  });

  final String label;
  final Key? fieldKey;
  final List<AppDropdownOption<dynamic>> options;
  final Set<dynamic> values;
  final ValueChanged<Set<dynamic>>? onChanged;
  final String? Function(Set<dynamic>?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String emptyText;
  final String searchHintText;
  final String noResultsText;
  final String clearText;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final multiOptions = options
        .map((opt) => AppDropdownOption<dynamic>(
              value: opt.value,
              label: opt.label,
              enabled: opt.enabled,
            ))
        .toList();
    return AppSelect<dynamic>(
      key: fieldKey,
      options: multiOptions,
      value: values,
      decoration: const InputDecoration(),
      onChanged: enabled ? (v) => onChanged?.call(v ?? <dynamic>{}) : null,
      validator: validator != null ? (v) => validator?.call(v ?? <dynamic>{}) : null,
      enabled: enabled,
      isMultiSelect: true,
      emptyText: emptyText,
      noResultsText: noResultsText,
      selectHintText: hintText ?? '请选择',
    );
  }
}

/// Tags field configuration
final class TagsFieldConfig extends CrudFieldConfig {
  const TagsFieldConfig({
    required this.label,
    this.fieldKey,
    required this.values,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.emptyText = '暂无标签',
  });

  final String label;
  final Key? fieldKey;
  final List<String> values;
  final ValueChanged<List<String>>? onChanged;
  final String? Function(List<String>?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String emptyText;

  @override
  Widget build(BuildContext context) => TagsField(
        key: fieldKey,
        label: label,
        values: values,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
      );
}

/// Checkbox group field configuration
final class CheckboxGroupFieldConfig extends CrudFieldConfig {
  const CheckboxGroupFieldConfig({
    required this.label,
    this.fieldKey,
    required this.options,
    required this.values,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.emptyText = '暂无可选项',
  });

  final String label;
  final Key? fieldKey;
  final List<AppDropdownOption<dynamic>> options;
  final Set<dynamic> values;
  final ValueChanged<Set<dynamic>>? onChanged;
  final String? Function(Set<dynamic>?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String emptyText;

  @override
  Widget build(BuildContext context) => CheckboxGroupField<dynamic>(
        key: fieldKey,
        label: label,
        options: options
            .map((opt) => CheckboxGroupFieldOption<dynamic>(
                  value: opt.value,
                  label: opt.label,
                  enabled: opt.enabled,
                ))
            .toList(),
        values: values.cast<dynamic>(),
        onChanged: enabled ? onChanged : null,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
      );
}

/// Radio group field configuration
final class RadioGroupFieldConfig extends CrudFieldConfig {
  const RadioGroupFieldConfig({
    required this.label,
    this.fieldKey,
    required this.options,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
  });

  final String label;
  final Key? fieldKey;
  final List<AppDropdownOption<dynamic>> options;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final String? Function(dynamic)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;

  @override
  Widget build(BuildContext context) => RadioGroupField<dynamic>(
        key: fieldKey,
        label: label,
        options: options
            .map((opt) => RadioGroupFieldOption<dynamic>(
                  value: opt.value,
                  label: opt.label,
                  enabled: opt.enabled,
                ))
            .toList(),
        value: value,
        onChanged: enabled ? onChanged : null,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
      );
}

/// Color picker field configuration
final class ColorFieldConfig extends CrudFieldConfig {
  const ColorFieldConfig({
    required this.label,
    this.fieldKey,
    required this.value,
    ValueChanged<Color?>? onChanged,
    String? Function(Color?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    List<Color>? palette,
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) : _onChanged = onChanged,
        _validator = validator,
        _enabled = enabled,
        _hintText = hintText,
        _helperText = helperText,
        _palette = palette,
        _clearText = clearText,
        _confirmText = confirmText,
        _cancelText = cancelText;

  final String label;
  final Key? fieldKey;
  final Color? value;
  final ValueChanged<Color?>? _onChanged;
  final String? Function(Color?)? _validator;
  final bool _enabled;
  final String? _hintText;
  final String? _helperText;
  final List<Color>? _palette;
  final String _clearText;
  final String _confirmText;
  final String _cancelText;

  @override
  Widget build(BuildContext context) => ColorField(
        key: fieldKey,
        label: label,
        value: value,
        onChanged: _enabled ? _onChanged : null,
        validator: _validator,
        enabled: _enabled,
        hintText: _hintText,
        helperText: _helperText,
        palette: _palette,
        clearText: _clearText,
        confirmText: _confirmText,
        cancelText: _cancelText,
      );
}

/// Custom field configuration that delegates rendering to a builder function
final class CustomFieldConfig extends CrudFieldConfig {
  const CustomFieldConfig({
    this.fieldKey,
    required this.builder,
  });

  final Key? fieldKey;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

// ============================================================================
// Legacy API - Backward Compatibility
// ============================================================================

/// Legacy type enum for backward compatibility
@Deprecated('Use CrudFieldConfig subclasses instead')
enum CrudFieldType {
  text,
  number,
  email,
  phone,
  dropdown,
  date,
  dateRange,
  textarea,
  toggle,
  fileUpload,
  multiSelect,
  tags,
  checkboxGroup,
  radioGroup,
  color,
  custom,
}

/// Reusable field factory used by [CrudEditPage] sections.
///
/// This class is deprecated. Use [CrudFieldConfig] with its static factory
/// constructors instead.
///
/// Example:
/// ```dart
/// // Old API (deprecated but still works)
/// CrudFormField.text(label: 'Name').build(context)
///
/// // New API (preferred)
/// CrudFieldConfig.text(label: 'Name').build(context)
/// ```
@Deprecated('Use CrudFieldConfig instead. This class will be removed in a future release.')
class CrudFormField {
  const CrudFormField._();

  // Factory constructors that delegate to CrudFieldConfig
  static CrudFieldConfig text({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    TextInputType? keyboardType,
    String? initialValue,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    bool isDense = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) =>
      CrudFieldConfig.text(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        keyboardType: keyboardType,
        initialValue: initialValue,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        isDense: isDense,
        readOnly: readOnly,
        onTap: onTap,
      );

  static CrudFieldConfig number({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool decimal = false,
    String? initialValue,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    bool isDense = false,
  }) =>
      CrudFieldConfig.number(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        decimal: decimal,
        initialValue: initialValue,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        isDense: isDense,
      );

  static CrudFieldConfig email({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
  }) =>
      CrudFieldConfig.email(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      );

  static CrudFieldConfig phone({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
  }) =>
      CrudFieldConfig.phone(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      );

  static CrudFieldConfig dropdown({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    String? Function(dynamic)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool isMultiSelect = false,
    int minOptionsForSearch = 7,
    String? searchHintText,
    String emptyText = '暂无可选项',
    String noResultsText = '无匹配结果',
    String selectHintText = '请选择',
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      CrudFieldConfig.dropdown(
        label: label,
        fieldKey: fieldKey,
        options: options,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        isMultiSelect: isMultiSelect,
        minOptionsForSearch: minOptionsForSearch,
        searchHintText: searchHintText,
        emptyText: emptyText,
        noResultsText: noResultsText,
        selectHintText: selectHintText,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig date({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool readOnly = true,
    VoidCallback? onTap,
  }) =>
      CrudFieldConfig.date(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        readOnly: readOnly,
        onTap: onTap,
      );

  static CrudFieldConfig dateRange({
    required String label,
    Key? fieldKey,
    required TextEditingController startController,
    required TextEditingController endController,
    String? Function(DateTimeRange?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    DateTime? firstDate,
    DateTime? lastDate,
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      CrudFieldConfig.dateRange(
        label: label,
        fieldKey: fieldKey,
        startController: startController,
        endController: endController,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        firstDate: firstDate,
        lastDate: lastDate,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig textarea({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    int minLines = 2,
    int maxLines = 3,
    Widget? prefixIcon,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    bool isDense = false,
  }) =>
      CrudFieldConfig.textarea(
        label: label,
        fieldKey: fieldKey,
        controller: controller,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        minLines: minLines,
        maxLines: maxLines,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        onChanged: onChanged,
        isDense: isDense,
      );

  static CrudFieldConfig toggle({
    required String label,
    Key? fieldKey,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
    String? helperText,
  }) =>
      CrudFieldConfig.toggle(
        label: label,
        fieldKey: fieldKey,
        value: value,
        onChanged: onChanged,
        enabled: enabled,
        helperText: helperText,
      );

  static CrudFieldConfig fileUpload({
    required String label,
    Key? fieldKey,
    CrudPickedFile? value,
    ValueChanged<CrudPickedFile?>? onChanged,
    String? Function(CrudPickedFile?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    required List<String> allowedExtensions,
    String fallbackFilename = 'upload.bin',
  }) =>
      CrudFieldConfig.fileUpload(
        label: label,
        fieldKey: fieldKey,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        allowedExtensions: allowedExtensions,
        fallbackFilename: fallbackFilename,
      );

  static CrudFieldConfig multiSelect({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    required Set<dynamic> values,
    ValueChanged<Set<dynamic>>? onChanged,
    String? Function(Set<dynamic>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无可选项',
    String searchHintText = '搜索名称或编码',
    String noResultsText = '无匹配项',
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      CrudFieldConfig.multiSelect(
        label: label,
        fieldKey: fieldKey,
        options: options,
        values: values,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
        searchHintText: searchHintText,
        noResultsText: noResultsText,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig tags({
    required String label,
    Key? fieldKey,
    required List<String> values,
    ValueChanged<List<String>>? onChanged,
    String? Function(List<String>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无标签',
  }) =>
      CrudFieldConfig.tags(
        label: label,
        fieldKey: fieldKey,
        values: values,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
      );

  static CrudFieldConfig checkboxGroup({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    required Set<dynamic> values,
    ValueChanged<Set<dynamic>>? onChanged,
    String? Function(Set<dynamic>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无可选项',
  }) =>
      CrudFieldConfig.checkboxGroup(
        label: label,
        fieldKey: fieldKey,
        options: options,
        values: values,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        emptyText: emptyText,
      );

  static CrudFieldConfig radioGroup({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    String? Function(dynamic)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
  }) =>
      CrudFieldConfig.radioGroup(
        label: label,
        fieldKey: fieldKey,
        options: options,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
      );

  static CrudFieldConfig color({
    required String label,
    Key? fieldKey,
    required Color? value,
    ValueChanged<Color?>? onChanged,
    String? Function(Color?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    List<Color>? palette,
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) =>
      CrudFieldConfig.color(
        label: label,
        fieldKey: fieldKey,
        value: value,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        hintText: hintText,
        helperText: helperText,
        palette: palette,
        clearText: clearText,
        confirmText: confirmText,
        cancelText: cancelText,
      );

  static CrudFieldConfig custom({
    Key? fieldKey,
    required Widget Function(BuildContext context) builder,
  }) =>
      CrudFieldConfig.custom(
        fieldKey: fieldKey,
        builder: builder,
      );
}
