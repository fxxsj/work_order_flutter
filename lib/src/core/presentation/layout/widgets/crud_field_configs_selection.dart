part of 'crud_form_field.dart';

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
        .map(
          (opt) => AppDropdownOption<dynamic>(
            value: opt.value,
            label: opt.label,
            enabled: opt.enabled,
          ),
        )
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
          ? AppDropdownSearchConfig(hintText: searchHintText, enabled: true)
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
        .map(
          (opt) => AppDropdownOption<dynamic>(
            value: opt.value,
            label: opt.label,
            enabled: opt.enabled,
          ),
        )
        .toList();
    return AppSelect<dynamic>(
      key: fieldKey,
      options: multiOptions,
      value: values,
      decoration: const InputDecoration(),
      onChanged: enabled ? (v) => onChanged?.call(v ?? <dynamic>{}) : null,
      validator: validator != null
          ? (v) => validator?.call(v ?? <dynamic>{})
          : null,
      enabled: enabled,
      isMultiSelect: true,
      emptyText: emptyText,
      noResultsText: noResultsText,
      selectHintText: hintText ?? '请选择',
    );
  }
}

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
        .map(
          (opt) => CheckboxGroupFieldOption<dynamic>(
            value: opt.value,
            label: opt.label,
            enabled: opt.enabled,
          ),
        )
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
        .map(
          (opt) => RadioGroupFieldOption<dynamic>(
            value: opt.value,
            label: opt.label,
            enabled: opt.enabled,
          ),
        )
        .toList(),
    value: value,
    onChanged: enabled ? onChanged : null,
    validator: validator,
    enabled: enabled,
    hintText: hintText,
    helperText: helperText,
  );
}

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
