part of 'crud_form_field.dart';

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
    this.picker,
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
  final FileUploadPicker? picker;

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
        picker: picker,
      );
}

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
  })  : _onChanged = onChanged,
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
