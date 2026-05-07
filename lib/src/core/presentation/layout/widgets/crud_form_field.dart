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

part 'crud_field_configs_text.dart';
part 'crud_field_configs_selection.dart';
part 'crud_field_configs_picker.dart';
part 'crud_field_configs_misc.dart';

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
