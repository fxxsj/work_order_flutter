import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/utils/file_upload_picker.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

class FileUploadField extends FormField<CrudPickedFile?> {
  FileUploadField({
    super.key,
    required String label,
    required CrudPickedFile? value,
    ValueChanged<CrudPickedFile?>? onChanged,
    String? Function(CrudPickedFile?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    required List<String> allowedExtensions,
    String fallbackFilename = 'upload.bin',
  })  : _label = label,
        _value = value,
        _onChanged = onChanged,
        _enabled = enabled,
        _hintText = hintText,
        _helperText = helperText,
        _allowedExtensions = allowedExtensions,
        _fallbackFilename = fallbackFilename,
        super(
          initialValue: value,
          validator: validator,
          builder: (state) => _FileUploadFieldBody(state: state),
        );

  final String _label;
  final CrudPickedFile? _value;
  final ValueChanged<CrudPickedFile?>? _onChanged;
  final bool _enabled;
  final String? _hintText;
  final String? _helperText;
  final List<String> _allowedExtensions;
  final String _fallbackFilename;
}

class _FileUploadFieldBody extends StatelessWidget {
  const _FileUploadFieldBody({required this.state});

  final FormFieldState<CrudPickedFile?> state;

  FileUploadField get _field => state.widget as FileUploadField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = state.value ?? _field._value;
    final hasValue = currentValue != null;
    final supportedTypes = _field._allowedExtensions.join(', ').toUpperCase();

    return InputDecorator(
      decoration: InputDecoration(
        labelText: _field._label,
        helperText: _field._helperText ??
            (supportedTypes.isEmpty ? null : '支持格式: $supportedTypes'),
        errorText: state.errorText,
      ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: _field._enabled),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasValue ? currentValue.filename : (_field._hintText ?? '请选择文件'),
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
                onPressed: _field._enabled ? () => _pickFile(context) : null,
                icon: const Icon(Icons.attach_file_outlined),
                label: Text(hasValue ? '重新选择' : '选择文件'),
              ),
              if (hasValue)
                TextButton.icon(
                  onPressed: _field._enabled ? _clearFile : null,
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
        allowedExtensions: _field._allowedExtensions,
        fallbackFilename: _field._fallbackFilename,
      );
      if (multipartFile == null) return;
      final picked = CrudPickedFile(
        filename: multipartFile.filename ?? _field._fallbackFilename,
        file: multipartFile,
      );
      state.didChange(picked);
      _field._onChanged?.call(picked);
    } on FileUploadPickException catch (err) {
      ToastUtil.showError(err.message);
    } catch (_) {
      ToastUtil.showError('读取文件失败');
    }
  }

  void _clearFile() {
    state.didChange(null);
    _field._onChanged?.call(null);
  }
}
