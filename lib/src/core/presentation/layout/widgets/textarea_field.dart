import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// Textarea field for [CrudFieldConfig.textarea].
class TextareaField extends StatefulWidget {
  const TextareaField({
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.minLines = 2,
    this.maxLines = 3,
    this.isDense = false,
    this.onChanged,
    required this.label,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int minLines;
  final int maxLines;
  final bool isDense;
  final ValueChanged<String>? onChanged;

  @override
  State<TextareaField> createState() => _TextareaFieldState();
}

class _TextareaFieldState extends State<TextareaField> {
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _ownsController = widget.controller == null;
  }

  @override
  void didUpdateWidget(TextareaField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _handleControllerChange(oldWidget.controller);
    }
  }

  void _handleControllerChange(TextEditingController? oldController) {
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
    return TextFormField(
      controller: _controller,
      validator: widget.validator,
      enabled: widget.enabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        isDense: widget.isDense,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
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
            color: Theme.of(context).colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
    );
  }
}
