import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/unified_dropdown.dart';
import 'package:work_order_app/src/core/utils/file_upload_picker.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

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

class CrudFieldOption<T> {
  const CrudFieldOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

class CrudPickedFile {
  const CrudPickedFile({
    required this.filename,
    required this.file,
  });

  final String filename;
  final MultipartFile file;
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
    required List<CrudFieldOption<dynamic>> options,
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
    required List<CrudFieldOption<dynamic>> options,
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
    required List<CrudFieldOption<dynamic>> options,
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
    required List<CrudFieldOption<dynamic>> options,
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
  final List<CrudFieldOption<dynamic>> options;
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
            .map((opt) => DropdownOption<dynamic>(
                  value: opt.value,
                  label: opt.label,
                  enabled: opt.enabled,
                ))
            .toList();
        return UnifiedDropdown<dynamic>(
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
              ? DropdownSearchConfig(
                  hintText: searchHintText,
                  enabled: true,
                )
              : const DropdownSearchConfig(),
          emptyText: emptyText ?? '暂无可选项',
          noResultsText: noResultsText ?? '无匹配结果',
          selectHintText: selectHintText,
          clearText: clearText ?? '清空',
          confirmText: confirmText ?? '确定',
          cancelText: cancelText ?? '取消',
        );
      case CrudFieldType.dateRange:
        return _CrudDateRangeFormField(
          fieldKey: fieldKey,
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
        return _CrudFileUploadFormField(
          fieldKey: fieldKey,
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
            .map((opt) => DropdownOption<dynamic>(
                  value: opt.value,
                  label: opt.label,
                  enabled: opt.enabled,
                ))
            .toList();
        return UnifiedDropdown<dynamic>(
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
        return _CrudTagsFormField(
          fieldKey: fieldKey,
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
        return _CrudCheckboxGroupFormField(
          fieldKey: fieldKey,
          label: label,
          options: options,
          selectedValues:
              (value as Set<dynamic>? ?? <dynamic>{}).cast<dynamic>(),
          onChanged: enabled ? onChanged : null,
          validator: validator as String? Function(Set<dynamic>?)?,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
          emptyText: emptyText ?? '暂无可选项',
        );
      case CrudFieldType.radioGroup:
        return _CrudRadioGroupFormField(
          fieldKey: fieldKey,
          label: label,
          options: options,
          value: value,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          enabled: enabled,
          hintText: hintText,
          helperText: helperText,
        );
      case CrudFieldType.color:
        return _CrudColorFormField(
          fieldKey: fieldKey,
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
          ),
        );
      case CrudFieldType.custom:
        return const SizedBox.shrink();
    }
  }
}

class _CrudDateRangeFormField extends FormField<DateTimeRange?> {
  _CrudDateRangeFormField({
    Key? fieldKey,
    required this.label,
    required this.startController,
    required this.endController,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.clearText,
    required this.confirmText,
    required this.cancelText,
    this.firstDate,
    this.lastDate,
    String? Function(DateTimeRange?)? validator,
  }) : super(
          key: fieldKey,
          initialValue: _dateRangeFromControllers(
            startController,
            endController,
          ),
          validator: validator,
          builder: (state) => _CrudDateRangeFieldBody(
            state: state,
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
          ),
        );

  final String label;
  final TextEditingController startController;
  final TextEditingController endController;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String clearText;
  final String confirmText;
  final String cancelText;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  FormFieldState<DateTimeRange?> createState() =>
      _CrudDateRangeFormFieldState();
}

class _CrudDateRangeFormFieldState extends FormFieldState<DateTimeRange?> {
  @override
  _CrudDateRangeFormField get widget => super.widget as _CrudDateRangeFormField;

  @override
  void didUpdateWidget(covariant _CrudDateRangeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextValue = _dateRangeFromControllers(
      widget.startController,
      widget.endController,
    );
    final current = value;
    final changed =
        current?.start != nextValue?.start || current?.end != nextValue?.end;
    if (changed) {
      setValue(nextValue);
    }
  }
}

class _CrudDateRangeFieldBody extends StatelessWidget {
  const _CrudDateRangeFieldBody({
    required this.state,
    required this.label,
    required this.startController,
    required this.endController,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.clearText,
    required this.confirmText,
    required this.cancelText,
    required this.firstDate,
    required this.lastDate,
  });

  final FormFieldState<DateTimeRange?> state;
  final String label;
  final TextEditingController startController;
  final TextEditingController endController;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String clearText;
  final String confirmText;
  final String cancelText;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = state.value;
    final hasValue = currentValue != null;
    final text = hasValue
        ? '${_formatDateYmd(currentValue.start)} ~ ${_formatDateYmd(currentValue.end)}'
        : (hintText ?? '请选择日期范围');

    return InkWell(
      onTap: enabled ? () => _pickDateRange(context, currentValue) : null,
      borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          errorText: state.errorText,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasValue && enabled)
                IconButton(
                  tooltip: clearText,
                  onPressed: () {
                    startController.clear();
                    endController.clear();
                    state.didChange(null);
                  },
                  icon: const Icon(Icons.clear, size: 18),
                ),
              const Icon(Icons.date_range_outlined),
              SizedBox(width: LayoutTokens.gapMd),
            ],
          ),
        ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: enabled),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: hasValue ? null : theme.hintColor,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    DateTimeRange? currentValue,
  ) async {
    final now = DateTime.now();
    final resolvedFirstDate = firstDate ?? DateTime(now.year - 5);
    final resolvedLastDate = lastDate ?? DateTime(now.year + 5, 12, 31);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: resolvedFirstDate,
      lastDate: resolvedLastDate,
      initialDateRange: currentValue,
      helpText: label,
      confirmText: confirmText,
      cancelText: cancelText,
    );
    if (picked == null) {
      return;
    }
    startController.text = _formatDateYmd(picked.start);
    endController.text = _formatDateYmd(picked.end);
    state.didChange(
      DateTimeRange(
        start:
            DateTime(picked.start.year, picked.start.month, picked.start.day),
        end: DateTime(picked.end.year, picked.end.month, picked.end.day),
      ),
    );
  }
}

DateTimeRange? _dateRangeFromControllers(
  TextEditingController startController,
  TextEditingController endController,
) {
  final start = DateTime.tryParse(startController.text.trim());
  final end = DateTime.tryParse(endController.text.trim());
  if (start == null || end == null) {
    return null;
  }
  return DateTimeRange(
    start: DateTime(start.year, start.month, start.day),
    end: DateTime(end.year, end.month, end.day),
  );
}

String _formatDateYmd(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

class _CrudFileUploadFormField extends FormField<CrudPickedFile?> {
  _CrudFileUploadFormField({
    Key? fieldKey,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.allowedExtensions,
    required this.fallbackFilename,
    String? Function(CrudPickedFile?)? validator,
  }) : super(
          key: fieldKey,
          initialValue: value,
          validator: validator,
          builder: (state) => _CrudFileUploadFieldBody(
            state: state,
            label: label,
            value: value,
            onChanged: onChanged,
            enabled: enabled,
            hintText: hintText,
            helperText: helperText,
            allowedExtensions: allowedExtensions,
            fallbackFilename: fallbackFilename,
          ),
        );

  final String label;
  final CrudPickedFile? value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final List<String> allowedExtensions;
  final String fallbackFilename;

  @override
  FormFieldState<CrudPickedFile?> createState() =>
      _CrudFileUploadFormFieldState();
}

class _CrudFileUploadFormFieldState extends FormFieldState<CrudPickedFile?> {
  @override
  _CrudFileUploadFormField get widget =>
      super.widget as _CrudFileUploadFormField;

  @override
  void didUpdateWidget(covariant _CrudFileUploadFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value?.filename != value?.filename) {
      setValue(widget.value);
    }
  }
}

class _CrudFileUploadFieldBody extends StatelessWidget {
  const _CrudFileUploadFieldBody({
    required this.state,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.allowedExtensions,
    required this.fallbackFilename,
  });

  final FormFieldState<CrudPickedFile?> state;
  final String label;
  final CrudPickedFile? value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final List<String> allowedExtensions;
  final String fallbackFilename;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = state.value;
    final hasValue = currentValue != null;
    final supportedTypes = allowedExtensions.join(', ').toUpperCase();

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText ??
            (supportedTypes.isEmpty ? null : '支持格式: $supportedTypes'),
        errorText: state.errorText,
      ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: enabled),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasValue ? currentValue.filename : (hintText ?? '请选择文件'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: hasValue ? null : theme.hintColor,
            ),
          ),
          SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: enabled ? () => _pickFile(context) : null,
                icon: const Icon(Icons.attach_file_outlined),
                label: Text(hasValue ? '重新选择' : '选择文件'),
              ),
              if (hasValue)
                TextButton.icon(
                  onPressed: enabled ? _clearFile : null,
                  icon: const Icon(Icons.clear),
                  label: const Text('清空'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final multipartFile = await pickMultipartFile(
        allowedExtensions: allowedExtensions,
        fallbackFilename: fallbackFilename,
      );
      if (multipartFile == null) {
        return;
      }
      final picked = CrudPickedFile(
        filename: multipartFile.filename ?? fallbackFilename,
        file: multipartFile,
      );
      state.didChange(picked);
      onChanged?.call(picked);
    } on FileUploadPickException catch (err) {
      ToastUtil.showError(err.message);
    } catch (_) {
      ToastUtil.showError('读取文件失败');
    }
  }

  void _clearFile() {
    state.didChange(null);
    onChanged?.call(null);
  }
}

class _CrudTagsFormField extends FormField<List<String>> {
  _CrudTagsFormField({
    Key? fieldKey,
    required this.label,
    required this.values,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.emptyText,
    String? Function(List<String>?)? validator,
  }) : super(
          key: fieldKey,
          initialValue: List<String>.from(values),
          validator: validator,
          builder: (state) => _CrudTagsFieldBody(
            state: state,
            label: label,
            values: values,
            onChanged: onChanged,
            enabled: enabled,
            hintText: hintText,
            helperText: helperText,
            emptyText: emptyText,
          ),
        );

  final String label;
  final List<String> values;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String emptyText;

  @override
  FormFieldState<List<String>> createState() => _CrudTagsFormFieldState();
}

class _CrudTagsFormFieldState extends FormFieldState<List<String>> {
  @override
  _CrudTagsFormField get widget => super.widget as _CrudTagsFormField;

  @override
  void didUpdateWidget(covariant _CrudTagsFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.values, value ?? const <String>[])) {
      setValue(List<String>.from(widget.values));
    }
  }
}

class _CrudTagsFieldBody extends StatefulWidget {
  const _CrudTagsFieldBody({
    required this.state,
    required this.label,
    required this.values,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.emptyText,
  });

  final FormFieldState<List<String>> state;
  final String label;
  final List<String> values;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String emptyText;

  @override
  State<_CrudTagsFieldBody> createState() => _CrudTagsFieldBodyState();
}

class _CrudTagsFieldBodyState extends State<_CrudTagsFieldBody> {
  static final RegExp _separatorPattern = RegExp(r'[、,，\n]+');

  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = widget.state.value ?? widget.values;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        errorText: widget.state.errorText,
      ).applyDefaults(theme.inputDecorationTheme).copyWith(
            enabled: widget.enabled,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => InputChip(
                      label: Text(tag),
                      onDeleted: widget.enabled ? () => _removeTag(tag) : null,
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              widget.emptyText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          SizedBox(height: LayoutTokens.gapMd),
          if (widget.enabled)
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: widget.hintText ?? '输入后按回车、逗号或换行添加',
                suffixIcon: IconButton(
                  onPressed: _commitInput,
                  icon: const Icon(Icons.add),
                  tooltip: '添加',
                ),
              ),
              onChanged: _handleInputChanged,
              onSubmitted: (_) => _commitInput(),
            )
          else if (tags.isEmpty && widget.hintText != null)
            Text(
              widget.hintText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
        ],
      ),
    );
  }

  void _handleInputChanged(String raw) {
    if (!raw.contains(_separatorPattern)) {
      return;
    }
    final segments = raw.split(_separatorPattern);
    final endsWithSeparator = RegExp(r'[、,，\n]\s*$').hasMatch(raw);
    final pending = endsWithSeparator || segments.isEmpty
        ? ''
        : segments.removeLast().trim();
    _addTags(
      segments.map((item) => item.trim()).where((item) => item.isNotEmpty),
    );
    _inputController.value = TextEditingValue(
      text: pending,
      selection: TextSelection.collapsed(offset: pending.length),
    );
  }

  void _commitInput() {
    final current = _inputController.text.trim();
    if (current.isEmpty) {
      return;
    }
    _addTags(
      current
          .split(_separatorPattern)
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    );
    _inputController.clear();
  }

  void _addTags(Iterable<String> nextTags) {
    final current = List<String>.from(widget.state.value ?? widget.values);
    var changed = false;
    for (final tag in nextTags) {
      if (current.contains(tag)) {
        continue;
      }
      current.add(tag);
      changed = true;
    }
    if (!changed) {
      return;
    }
    widget.state.didChange(current);
    widget.onChanged?.call(current);
  }

  void _removeTag(String tag) {
    final current = List<String>.from(widget.state.value ?? widget.values)
      ..remove(tag);
    widget.state.didChange(current);
    widget.onChanged?.call(current);
  }
}

class _CrudCheckboxGroupFormField extends FormField<Set<dynamic>> {
  _CrudCheckboxGroupFormField({
    Key? fieldKey,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.emptyText,
    String? Function(Set<dynamic>?)? validator,
  }) : super(
          key: fieldKey,
          initialValue: Set<dynamic>.from(selectedValues),
          validator: validator,
          builder: (state) => _CrudCheckboxGroupFieldBody(
            state: state,
            label: label,
            options: options,
            selectedValues: selectedValues,
            onChanged: onChanged,
            enabled: enabled,
            hintText: hintText,
            helperText: helperText,
            emptyText: emptyText,
          ),
        );

  final String label;
  final List<CrudFieldOption<dynamic>> options;
  final Set<dynamic> selectedValues;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String emptyText;

  @override
  FormFieldState<Set<dynamic>> createState() =>
      _CrudCheckboxGroupFormFieldState();
}

class _CrudCheckboxGroupFormFieldState extends FormFieldState<Set<dynamic>> {
  @override
  _CrudCheckboxGroupFormField get widget =>
      super.widget as _CrudCheckboxGroupFormField;

  @override
  void didUpdateWidget(covariant _CrudCheckboxGroupFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(widget.selectedValues, value ?? <dynamic>{})) {
      setValue(Set<dynamic>.from(widget.selectedValues));
    }
  }
}

class _CrudCheckboxGroupFieldBody extends StatelessWidget {
  const _CrudCheckboxGroupFieldBody({
    required this.state,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.emptyText,
  });

  final FormFieldState<Set<dynamic>> state;
  final String label;
  final List<CrudFieldOption<dynamic>> options;
  final Set<dynamic> selectedValues;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValues = state.value ?? Set<dynamic>.from(selectedValues);

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText ?? hintText,
        errorText: state.errorText,
      ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: enabled),
      child: options.isEmpty
          ? Text(
              emptyText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: options
                  .map(
                    (option) => CheckboxListTile(
                      value: currentValues.contains(option.value),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(option.label),
                      onChanged: enabled && option.enabled
                          ? (checked) {
                              final nextValues = Set<dynamic>.from(
                                currentValues,
                              );
                              if (checked == true) {
                                nextValues.add(option.value);
                              } else {
                                nextValues.remove(option.value);
                              }
                              state.didChange(nextValues);
                              onChanged?.call(nextValues);
                            }
                          : null,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _CrudRadioGroupFormField extends FormField<dynamic> {
  _CrudRadioGroupFormField({
    Key? fieldKey,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    String? Function(dynamic)? validator,
  }) : super(
          key: fieldKey,
          initialValue: value,
          validator: validator,
          builder: (state) => _CrudRadioGroupFieldBody(
            state: state,
            label: label,
            options: options,
            value: value,
            onChanged: onChanged,
            enabled: enabled,
            hintText: hintText,
            helperText: helperText,
          ),
        );

  final String label;
  final List<CrudFieldOption<dynamic>> options;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;

  @override
  FormFieldState<dynamic> createState() => _CrudRadioGroupFormFieldState();
}

class _CrudRadioGroupFormFieldState extends FormFieldState<dynamic> {
  @override
  _CrudRadioGroupFormField get widget =>
      super.widget as _CrudRadioGroupFormField;

  @override
  void didUpdateWidget(covariant _CrudRadioGroupFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != value) {
      setValue(widget.value);
    }
  }
}

class _CrudRadioGroupFieldBody extends StatelessWidget {
  const _CrudRadioGroupFieldBody({
    required this.state,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
  });

  final FormFieldState<dynamic> state;
  final String label;
  final List<CrudFieldOption<dynamic>> options;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = state.value;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText ?? hintText,
        errorText: state.errorText,
      ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: enabled),
      child: RadioGroup<dynamic>(
        groupValue: currentValue,
        onChanged: (nextValue) {
          if (!enabled) {
            return;
          }
          state.didChange(nextValue);
          onChanged?.call(nextValue);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (option) => RadioListTile<dynamic>(
                  value: option.value,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  enabled: enabled && option.enabled,
                  title: Text(option.label),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _CrudColorFormField extends FormField<Color?> {
  _CrudColorFormField({
    Key? fieldKey,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.palette,
    required this.clearText,
    required this.confirmText,
    required this.cancelText,
    String? Function(Color?)? validator,
  }) : super(
          key: fieldKey,
          initialValue: value,
          validator: validator,
          builder: (state) => _CrudColorFieldBody(
            state: state,
            label: label,
            value: value,
            onChanged: onChanged,
            enabled: enabled,
            hintText: hintText,
            helperText: helperText,
            palette: palette,
            clearText: clearText,
            confirmText: confirmText,
            cancelText: cancelText,
          ),
        );

  final String label;
  final Color? value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final List<Color>? palette;
  final String clearText;
  final String confirmText;
  final String cancelText;

  @override
  FormFieldState<Color?> createState() => _CrudColorFormFieldState();
}

class _CrudColorFormFieldState extends FormFieldState<Color?> {
  @override
  _CrudColorFormField get widget => super.widget as _CrudColorFormField;

  @override
  void didUpdateWidget(covariant _CrudColorFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != value) {
      setValue(widget.value);
    }
  }
}

class _CrudColorFieldBody extends StatelessWidget {
  const _CrudColorFieldBody({
    required this.state,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.hintText,
    required this.helperText,
    required this.palette,
    required this.clearText,
    required this.confirmText,
    required this.cancelText,
  });

  final FormFieldState<Color?> state;
  final String label;
  final Color? value;
  final ValueChanged<dynamic>? onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final List<Color>? palette;
  final String clearText;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = state.value ?? value;

    return InkWell(
      onTap: enabled ? () => _openPicker(context, currentValue) : null,
      borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          helperText: helperText,
          errorText: state.errorText,
          suffixIcon: const Icon(Icons.color_lens_outlined),
        ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: enabled),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: currentValue ?? Colors.transparent,
                borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
                border: Border.all(color: theme.dividerColor),
              ),
            ),
            SizedBox(width: LayoutTokens.gapMd),
            Expanded(
              child: Text(
                currentValue == null
                    ? (hintText ?? '请选择颜色')
                    : '#${currentValue.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: currentValue == null ? theme.hintColor : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context, Color? currentValue) async {
    var temp = currentValue ?? Colors.blue;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BaseDialog(
          title: label,
          maxWidth: LayoutTokens.dialogWidthSm,
          scrollable: false,
          content: SizedBox(
            width: 320,
            child: BlockPicker(
              pickerColor: temp,
              availableColors: palette ?? _defaultColorPalette,
              onColorChanged: (color) {
                temp = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () {
                state.didChange(null);
                onChanged?.call(null);
                Navigator.of(dialogContext).pop();
              },
              child: Text(clearText),
            ),
            FilledButton(
              onPressed: () {
                state.didChange(temp);
                onChanged?.call(temp);
                Navigator.of(dialogContext).pop();
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}

const List<Color> _defaultColorPalette = ColorTokens.tagColors;
