import 'package:flutter/material.dart';
import 'package:work_order_app/router/app_router.dart';

class ToastUtil {
  static void show({required String message, bool isError = false}) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isError ? colorScheme.error : colorScheme.primary;
    final foregroundColor = isError ? colorScheme.onError : colorScheme.onPrimary;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w600),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(String message) {
    show(message: message, isError: false);
  }

  static void showError(String message) {
    show(message: message, isError: true);
  }
}
