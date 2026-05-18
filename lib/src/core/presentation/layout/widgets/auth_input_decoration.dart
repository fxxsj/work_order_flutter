import 'package:flutter/material.dart';
import '../../layout/layout_tokens.dart';

/// Auth pages InputDecoration factory
/// Consolidates 8 duplicate OutlineInputBorder patterns
class AuthInputDecoration {
  AuthInputDecoration._();

  static InputDecoration authTextField({
    required BuildContext context,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerLowest,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        borderSide: BorderSide(color: colors.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        borderSide: BorderSide(color: colors.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        borderSide: BorderSide(color: colors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
        borderSide: BorderSide(color: colors.error, width: 2),
      ),
    );
  }
}
