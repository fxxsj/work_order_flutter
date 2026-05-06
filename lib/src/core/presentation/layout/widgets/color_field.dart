import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/base_dialog.dart';

class ColorField extends FormField<Color?> {
  ColorField({
    super.key,
    required String label,
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
  })  : _label = label,
        _value = value,
        _onChanged = onChanged,
        _enabled = enabled,
        _hintText = hintText,
        _helperText = helperText,
        _palette = palette,
        _clearText = clearText,
        _confirmText = confirmText,
        _cancelText = cancelText,
        super(
          initialValue: value,
          validator: validator,
          builder: (state) => _ColorFieldBody(state: state),
        );

  final String _label;
  final Color? _value;
  final ValueChanged<Color?>? _onChanged;
  final bool _enabled;
  final String? _hintText;
  final String? _helperText;
  final List<Color>? _palette;
  final String _clearText;
  final String _confirmText;
  final String _cancelText;
}

class _ColorFieldBody extends StatelessWidget {
  const _ColorFieldBody({required this.state});

  final FormFieldState<Color?> state;

  ColorField get _field => state.widget as ColorField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = state.value ?? _field._value;

    return InkWell(
      onTap: _field._enabled ? () => _openPicker(context, currentValue) : null,
      borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: _field._label,
          hintText: _field._hintText,
          helperText: _field._helperText,
          errorText: state.errorText,
          suffixIcon: const Icon(Icons.color_lens_outlined),
        ).applyDefaults(theme.inputDecorationTheme).copyWith(enabled: _field._enabled),
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
                    ? (_field._hintText ?? '请选择颜色')
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
          title: _field._label,
          maxWidth: LayoutTokens.dialogWidthSm,
          scrollable: false,
          content: SizedBox(
            width: 320,
            child: BlockPicker(
              pickerColor: temp,
              availableColors: _field._palette ?? _defaultColorPalette,
              onColorChanged: (color) => temp = color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(_field._cancelText),
            ),
            TextButton(
              onPressed: () {
                state.didChange(null);
                _field._onChanged?.call(null);
                Navigator.of(dialogContext).pop();
              },
              child: Text(_field._clearText),
            ),
            FilledButton(
              onPressed: () {
                state.didChange(temp);
                _field._onChanged?.call(temp);
                Navigator.of(dialogContext).pop();
              },
              child: Text(_field._confirmText),
            ),
          ],
        );
      },
    );
  }
}

const List<Color> _defaultColorPalette = [
  Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo,
  Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green,
  Colors.lightGreen, Colors.lime, Colors.yellow, Colors.amber, Colors.orange,
  Colors.deepOrange, Colors.brown, Colors.grey, Colors.blueGrey,
];
