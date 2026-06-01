import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

enum TextInputFieldType { text, number, email, phone }

/// Unified text input field for [CrudFieldConfig.text], [CrudFieldConfig.number],
/// [CrudFieldConfig.email], and [CrudFieldConfig.phone].
class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    required this.label,
    required this.type,
    this.controller,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.obscureText = false,
    this.isDense = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String label;
  final TextInputFieldType type;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool isDense;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late TextEditingController _controller;
  bool _ownsController = false;

  TextInputType get _keyboardType {
    switch (widget.type) {
      case TextInputFieldType.number:
        return TextInputType.number;
      case TextInputFieldType.email:
        return TextInputType.emailAddress;
      case TextInputFieldType.phone:
        return TextInputType.phone;
      case TextInputFieldType.text:
        return TextInputType.text;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }
  }

  @override
  void didUpdateWidget(TextInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _handleControllerChange();
    }
  }

  void _handleControllerChange() {
    TextEditingController? oldOwned;
    if (_ownsController) {
      oldOwned = _controller;
    }
    _ownsController = widget.controller == null;
    if (_ownsController) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      _controller = widget.controller!;
    }
    // Defer disposal to avoid TextFormField.State listener removal conflicts
    if (oldOwned != null) {
      final toDispose = oldOwned;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          toDispose.dispose();
        } catch (_) {
          // Already disposed
        }
      });
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      final toDispose = _controller;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          toDispose.dispose();
        } catch (_) {
          // Already disposed
        }
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _controller,
      validator: widget.validator,
      enabled: widget.enabled,
      keyboardType: _keyboardType,
      obscureText: widget.obscureText,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        isDense: widget.isDense,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
          borderSide: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
      ),
    );
  }
}
