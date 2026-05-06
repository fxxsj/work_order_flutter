import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/checkbox_group_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/color_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/date_range_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/file_upload_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/radio_group_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/tags_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';

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

class AppDropdownOption<T> {
  const AppDropdownOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// Reusable field factory used by [CrudEditPage] sections.
class CrudFormField {
  CrudFormField._({
    required this.label,
    required this.type,
    this.fieldKey,
    this.controller,
    this.startController,
    this.endController,
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
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.isDense = false,
    this.readOnly = false,
    this.onTap,
    this.emptyText,
    this.searchHintText,
    this.noResultsText,
    this.clearText,
    this.confirmText,
    this.cancelText,
    this.palette,
    this.allowedExtensions,
    this.fallbackFilename,
    this.firstDate,
    this.lastDate,
    this.builder,
    // 新增 UnifiedDropdown 配置参数
    this.minOptionsForSearch = 7,
    this.isMultiSelect = false,
    this.selectHintText = '请选择',
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
          initialValue: initialValue,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as String),
          onFieldSubmitted: onFieldSubmitted,
          isDense: isDense,
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
    String? initialValue,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    bool isDense = false,
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
          initialValue: initialValue,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          textInputAction: textInputAction,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as String),
          onFieldSubmitted: onFieldSubmitted,
          isDense: isDense,
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
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
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
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          textInputAction: textInputAction,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as String),
          onFieldSubmitted: onFieldSubmitted,
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
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
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
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          textInputAction: textInputAction,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as String),
          onFieldSubmitted: onFieldSubmitted,
          keyboardType: TextInputType.phone,
        );

  CrudFormField.dropdown({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    String? Function(dynamic)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    // 新增：UnifiedDropdown 配置参数
    bool isMultiSelect = false,
    int minOptionsForSearch = 7,
    String? searchHintText,
    String emptyText = '暂无可选项',
    String noResultsText = '无匹配结果',
    String selectHintText = '请选择',
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
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
          emptyText: emptyText,
          searchHintText: searchHintText,
          noResultsText: noResultsText,
          clearText: clearText,
          confirmText: confirmText,
          cancelText: cancelText,
          minOptionsForSearch: minOptionsForSearch,
          isMultiSelect: isMultiSelect,
          selectHintText: selectHintText,
        );

  CrudFormField.date({
    required String label,
    Key? fieldKey,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    bool readOnly = true,
    VoidCallback? onTap,
  }) : this._(
          label: label,
          type: CrudFieldType.date,
          fieldKey: fieldKey,
          controller: controller,
          validator:
              validator == null ? null : (value) => validator(value as String?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          keyboardType: TextInputType.datetime,
          readOnly: readOnly,
          onTap: onTap,
        );

  CrudFormField.dateRange({
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
  }) : this._(
          label: label,
          type: CrudFieldType.dateRange,
          fieldKey: fieldKey,
          startController: startController,
          endController: endController,
          validator: validator == null
              ? null
              : (value) => validator(value as DateTimeRange?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          clearText: clearText,
          confirmText: confirmText,
          cancelText: cancelText,
          firstDate: firstDate,
          lastDate: lastDate,
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
    Widget? prefixIcon,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    bool isDense = false,
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
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as String),
          isDense: isDense,
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

  CrudFormField.fileUpload({
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
  }) : this._(
          label: label,
          type: CrudFieldType.fileUpload,
          fieldKey: fieldKey,
          value: value,
          onChanged: onChanged == null
              ? null
              : (value) => onChanged(value as CrudPickedFile?),
          validator: validator == null
              ? null
              : (value) => validator(value as CrudPickedFile?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          allowedExtensions: allowedExtensions,
          fallbackFilename: fallbackFilename,
        );

  CrudFormField.multiSelect({
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
  }) : this._(
          label: label,
          type: CrudFieldType.multiSelect,
          fieldKey: fieldKey,
          options: options,
          value: Set<dynamic>.from(values),
          onChanged: onChanged == null
              ? null
              : (value) => onChanged(Set<dynamic>.from(value as Set<dynamic>)),
          validator: validator == null
              ? null
              : (value) => validator(value as Set<dynamic>?),
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

  CrudFormField.tags({
    required String label,
    Key? fieldKey,
    required List<String> values,
    ValueChanged<List<String>>? onChanged,
    String? Function(List<String>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无标签',
  }) : this._(
          label: label,
          type: CrudFieldType.tags,
          fieldKey: fieldKey,
          value: List<String>.from(values),
          onChanged: onChanged == null
              ? null
              : (value) => onChanged(List<String>.from(value as List<String>)),
          validator: validator == null
              ? null
              : (value) => validator(value as List<String>?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          emptyText: emptyText,
        );

  CrudFormField.checkboxGroup({
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
  }) : this._(
          label: label,
          type: CrudFieldType.checkboxGroup,
          fieldKey: fieldKey,
          options: options,
          value: Set<dynamic>.from(values),
          onChanged: onChanged == null
              ? null
              : (value) => onChanged(Set<dynamic>.from(value as Set<dynamic>)),
          validator: validator == null
              ? null
              : (value) => validator(value as Set<dynamic>?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          emptyText: emptyText,
        );

  CrudFormField.radioGroup({
    required String label,
    Key? fieldKey,
    required List<AppDropdownOption<dynamic>> options,
    dynamic value,
    ValueChanged<dynamic>? onChanged,
    String? Function(dynamic)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
  }) : this._(
          label: label,
          type: CrudFieldType.radioGroup,
          fieldKey: fieldKey,
          options: options,
          value: value,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
        );

  CrudFormField.color({
    required String label,
    Key? fieldKey,
    required Color? value,
    ValueChanged<Color>? onChanged,
    String? Function(Color?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    List<Color>? palette,
    String clearText = '清空',
    String confirmText = '确定',
    String cancelText = '取消',
  }) : this._(
          label: label,
          type: CrudFieldType.color,
          fieldKey: fieldKey,
          value: value,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as Color),
          validator:
              validator == null ? null : (value) => validator(value as Color?),
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          palette: palette,
          clearText: clearText,
          confirmText: confirmText,
          cancelText: cancelText,
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
  final TextEditingController? startController;
  final TextEditingController? endController;
  final String? Function(dynamic)? validator;
  final List<AppDropdownOption<dynamic>> options;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final int? minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isDense;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? emptyText;
  final String? searchHintText;
  final String? noResultsText;
  final String? clearText;
  final String? confirmText;
  final String? cancelText;
  final List<Color>? palette;
  final List<String>? allowedExtensions;
  final String? fallbackFilename;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Widget Function(BuildContext context)? builder;
  // 新增 UnifiedDropdown 配置字段
  final int minOptionsForSearch;
  final bool isMultiSelect;
  final String selectHintText;

  Widget build(BuildContext context) {
    if (builder != null) {
      return builder!(context);
    }

    switch (type) {
      case CrudFieldType.dropdown:
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
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            helperText: helperText,
          ),
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
          emptyText: emptyText ?? '暂无可选项',
          noResultsText: noResultsText ?? '无匹配结果',
          selectHintText: selectHintText,
          clearText: clearText ?? '清空',
          confirmText: confirmText ?? '确定',
          cancelText: cancelText ?? '取消',
        );
      case CrudFieldType.dateRange:
        return DateRangeField(
          key: fieldKey,
          label: label,
          startController: startController!,
          endController: endController!,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          clearText: clearText ?? '清空',
          confirmText: confirmText ?? '确定',
          cancelText: cancelText ?? '取消',
          firstDate: firstDate,
          lastDate: lastDate,
          validator: validator as String? Function(DateTimeRange?)?,
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
      case CrudFieldType.fileUpload:
        return FileUploadField(
          key: fieldKey,
          label: label,
          value: value as CrudPickedFile?,
          onChanged: enabled ? onChanged : null,
          validator: validator as String? Function(CrudPickedFile?)?,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          allowedExtensions: allowedExtensions ?? const [],
          fallbackFilename: fallbackFilename ?? 'upload.bin',
        );
      case CrudFieldType.multiSelect:
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
          value: (value is Set<dynamic> ? value : null) ?? const {},
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            helperText: helperText,
          ),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          enabled: enabled,
          isMultiSelect: true,
          emptyText: emptyText ?? '暂无可选项',
          noResultsText: noResultsText ?? '无匹配项',
          selectHintText: hintText ?? '请选择',
        );
      case CrudFieldType.tags:
        return TagsField(
          key: fieldKey,
          label: label,
          values: (value as List<String>? ?? const <String>[]),
          onChanged: enabled ? onChanged : null,
          validator: validator as String? Function(List<String>?)?,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          emptyText: emptyText ?? '暂无标签',
        );
      case CrudFieldType.checkboxGroup:
        return CheckboxGroupField<dynamic>(
          key: fieldKey,
          label: label,
          options: options
              .map((opt) => CheckboxGroupFieldOption<dynamic>(
                    value: opt.value,
                    label: opt.label,
                    enabled: opt.enabled,
                  ))
              .toList(),
          values: (value as Set<dynamic>? ?? <dynamic>{}).cast<dynamic>(),
          onChanged: enabled ? onChanged : null,
          validator: validator as String? Function(Set<dynamic>?)?,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          emptyText: emptyText ?? '暂无可选项',
        );
      case CrudFieldType.radioGroup:
        return RadioGroupField<dynamic>(
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
      case CrudFieldType.color:
        return ColorField(
          key: fieldKey,
          label: label,
          value: value as Color?,
          onChanged: enabled ? onChanged : null,
          validator: validator as String? Function(Color?)?,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          palette: palette,
          clearText: clearText ?? '清空',
          confirmText: confirmText ?? '确定',
          cancelText: cancelText ?? '取消',
        );
      case CrudFieldType.textarea:
        return TextFormField(
          key: fieldKey,
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          validator: validator as String? Function(String?)?,
          enabled: enabled,
          minLines: minLines,
          maxLines: maxLines,
          onChanged: onChanged as ValueChanged<String>?,
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
      case CrudFieldType.text:
      case CrudFieldType.number:
      case CrudFieldType.email:
      case CrudFieldType.phone:
      case CrudFieldType.date:
        return TextFormField(
          key: fieldKey,
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          validator: validator as String? Function(String?)?,
          enabled: enabled,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onChanged: onChanged as ValueChanged<String>?,
          onFieldSubmitted: onFieldSubmitted,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
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
      case CrudFieldType.custom:
        return const SizedBox.shrink();
    }
  }
}


