import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class TagsField extends FormField<List<String>> {
  TagsField({
    super.key,
    required String label,
    required List<String> values,
    ValueChanged<List<String>>? onChanged,
    String? Function(List<String>?)? validator,
    bool enabled = true,
    String? hintText,
    String? helperText,
    String emptyText = '暂无标签',
  }) : _label = label,
       _onChanged = onChanged,
       _enabled = enabled,
       _hintText = hintText,
       _helperText = helperText,
       _emptyText = emptyText,
       super(
         initialValue: List<String>.from(values),
         validator: validator,
         builder: (state) => _TagsFieldBody(state: state, values: values),
       );

  final String _label;
  final ValueChanged<List<String>>? _onChanged;
  final bool _enabled;
  final String? _hintText;
  final String? _helperText;
  final String _emptyText;
}

class _TagsFieldBody extends StatefulWidget {
  const _TagsFieldBody({required this.state, required this.values});

  final FormFieldState<List<String>> state;
  final List<String> values;

  @override
  State<_TagsFieldBody> createState() => _TagsFieldBodyState();
}

class _TagsFieldBodyState extends State<_TagsFieldBody> {
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

  TagsField get _field => widget.state.widget as TagsField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = widget.state.value ?? widget.values;

    return InputDecorator(
      decoration:
          InputDecoration(
                labelText: _field._label,
                helperText: _field._helperText,
                errorText: widget.state.errorText,
              )
              .applyDefaults(theme.inputDecorationTheme)
              .copyWith(enabled: _field._enabled),
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
                      onDeleted: _field._enabled ? () => _removeTag(tag) : null,
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              _field._emptyText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          SizedBox(height: SpacingTokens.md),
          if (_field._enabled)
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: _field._hintText ?? '输入后按回车、逗号或换行添加',
                suffixIcon: IconButton(
                  onPressed: _commitInput,
                  icon: const Icon(Icons.add),
                  tooltip: '添加',
                ),
              ),
              onChanged: _handleInputChanged,
              onSubmitted: (_) => _commitInput(),
            )
          else if (tags.isEmpty && _field._hintText != null)
            Text(
              _field._hintText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
        ],
      ),
    );
  }

  void _handleInputChanged(String raw) {
    if (!raw.contains(_separatorPattern)) return;
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
    if (current.isEmpty) return;
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
      if (!current.contains(tag)) {
        current.add(tag);
        changed = true;
      }
    }
    if (!changed) return;
    widget.state.didChange(current);
    _field._onChanged?.call(current);
  }

  void _removeTag(String tag) {
    final current = List<String>.from(widget.state.value ?? widget.values)
      ..remove(tag);
    widget.state.didChange(current);
    _field._onChanged?.call(current);
  }
}
