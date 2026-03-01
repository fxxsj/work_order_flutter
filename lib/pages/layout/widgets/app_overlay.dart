import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_order_app/controllers/app_scaffold_controller.dart';

class AppOverlay extends StatelessWidget {
  const AppOverlay({super.key, required this.controller});

  final AppScaffoldController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _OverlayCard(
          icon: const CircularProgressIndicator(strokeWidth: 2),
          label: '加载中...',
        );
      }
      if (controller.errorMessage.value.isNotEmpty) {
        return _OverlayCard(
          icon: const Icon(Icons.error_outline, color: Colors.redAccent),
          label: controller.errorMessage.value,
        );
      }
      if (controller.emptyMessage.value.isNotEmpty) {
        return _OverlayCard(
          icon: const Icon(Icons.inbox_outlined, color: Colors.blueGrey),
          label: controller.emptyMessage.value,
        );
      }
      return const SizedBox.shrink();
    });
  }
}

class _OverlayCard extends StatelessWidget {
  const _OverlayCard({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.04),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 20, height: 20, child: Center(child: icon)),
                const SizedBox(width: 12),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
