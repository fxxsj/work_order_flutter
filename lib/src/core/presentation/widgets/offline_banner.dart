import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/connectivity_service.dart';
import 'package:work_order_app/src/core/presentation/layout/color_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/text_tokens.dart';

/// 顶部离线状态提示横幅
///
/// 当网络断开时从顶部滑入显示，网络恢复后自动收起。
/// 颜色使用 [ColorTokens] 语义色，不使用硬编码。
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  bool _isOffline = false;
  StreamSubscription<bool>? _subscription;
  ConnectivityService? _service;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = context.read<ConnectivityService>();
    if (_service == service) return;
    _subscription?.cancel();
    _service = service;

    _isOffline = service.isOffline;
    if (_isOffline) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }

    _subscription = service.onStatusChange.listen((online) {
      if (!mounted) return;
      final offline = !online;
      if (_isOffline == offline) return;
      setState(() {
        _isOffline = offline;
      });
      if (offline) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: _offsetAnimation,
          child: _buildBanner(),
        ),
        Expanded(child: widget.child ?? const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      color: ColorTokens.surface3,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 16,
              color: ColorTokens.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '网络异常，请检查网络连接',
              style: TextTokens.labelMedium(context).copyWith(
                color: ColorTokens.inkMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
