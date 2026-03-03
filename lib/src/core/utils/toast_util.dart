import 'dart:async';

import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/router/app_router.dart';

class ToastUtil {
  static final ValueNotifier<List<_ToastItem>> _items = ValueNotifier<List<_ToastItem>>([]);
  static OverlayEntry? _entry;
  static int _nextId = 0;

  static void show({required String message, bool isError = false}) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    _ensureEntry(context);

    final id = _nextId++;
    final item = _ToastItem(id: id, message: message, isError: isError, closing: false);
    _items.value = [..._items.value, item];

    Timer(const Duration(seconds: 3), () {
      _dismiss(id);
    });
  }

  static void showSuccess(String message) {
    show(message: message, isError: false);
  }

  static void showError(String message) {
    show(message: message, isError: true);
  }

  static void _ensureEntry(BuildContext context) {
    if (_entry != null) {
      return;
    }
    final overlayState = Navigator.of(context, rootNavigator: true).overlay;
    if (overlayState == null) {
      return;
    }
    _entry = OverlayEntry(
      builder: (_) => _ToastHost(items: _items),
    );
    overlayState.insert(_entry!);
  }

  static void _dismiss(int id) {
    final current = _items.value;
    final index = current.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }
    if (current[index].closing) {
      return;
    }
    final updated = [...current];
    updated[index] = updated[index].copyWith(closing: true);
    _items.value = updated;

    Timer(const Duration(milliseconds: 220), () {
      _remove(id);
    });
  }

  static void _remove(int id) {
    final current = _items.value;
    final next = current.where((item) => item.id != id).toList();
    if (next.length == current.length) {
      return;
    }
    _items.value = next;
    if (next.isEmpty) {
      _entry?.remove();
      _entry = null;
    }
  }
}

class _ToastItem {
  const _ToastItem({
    required this.id,
    required this.message,
    required this.isError,
    required this.closing,
  });

  final int id;
  final String message;
  final bool isError;
  final bool closing;

  _ToastItem copyWith({bool? closing}) {
    return _ToastItem(
      id: id,
      message: message,
      isError: isError,
      closing: closing ?? this.closing,
    );
  }
}

class _ToastHost extends StatelessWidget {
  const _ToastHost({required this.items});

  final ValueNotifier<List<_ToastItem>> items;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 24),
              child: ValueListenableBuilder<List<_ToastItem>>(
                valueListenable: items,
                builder: (context, list, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: list.map((item) {
                      return _ToastCard(
                        key: ValueKey(item.id),
                        item: item,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({super.key, required this.item});

  final _ToastItem item;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ToastCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.closing && _visible) {
      setState(() {
        _visible = false;
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = widget.item.isError ? scheme.error : scheme.primary;
    final foreground = widget.item.isError ? scheme.onError : scheme.onPrimary;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: _visible ? Offset.zero : const Offset(0.2, 0),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _visible ? 1 : 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.item.isError ? Icons.error_outline : Icons.check_circle_outline,
                color: foreground,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, _) {
                          return LinearProgressIndicator(
                            value: 1 - _progressController.value,
                            minHeight: 3,
                            backgroundColor: foreground.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(foreground),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
