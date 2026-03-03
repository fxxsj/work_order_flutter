import 'package:flutter/material.dart';

typedef ContentBodyBuilder = Widget Function(BuildContext context, ContentAreaStyle style);

class ContentAreaStyle {
  const ContentAreaStyle({
    required this.primary,
    required this.surface,
    required this.accent,
    required this.subtleText,
    required this.borderColor,
  });

  final Color primary;
  final Color surface;
  final Color accent;
  final Color subtleText;
  final Color borderColor;
}
