import 'dart:async';

import 'package:get/get.dart';
import 'package:work_order_app/models/notification_model.dart';

class NotificationController extends GetxController {
  final RxInt unreadCount = 0.obs;
  final RxList<NotificationModel> recentList = <NotificationModel>[].obs;

  Timer? _poller;
  int _seed = 0;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
    _poller = Timer.periodic(const Duration(minutes: 1), (_) => _refreshMockData());
  }

  @override
  void onClose() {
    _poller?.cancel();
    super.onClose();
  }

  void markAllRead() {
    if (recentList.isEmpty) {
      unreadCount.value = 0;
      return;
    }
    recentList.value = recentList
        .map((item) => item.isRead ? item : item.copyWith(isRead: true))
        .toList();
    unreadCount.value = 0;
  }

  void markRead(String id) {
    final index = recentList.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }
    final item = recentList[index];
    if (item.isRead) {
      return;
    }
    recentList[index] = item.copyWith(isRead: true);
    _syncUnreadCount();
  }

  void _loadMockData() {
    final now = DateTime.now();
    recentList.assignAll([
      NotificationModel(
        id: 'seed-1',
        title: '新的审批待处理',
        body: '采购申请单 PO-2026-031 已提交，请尽快审核。',
        createdAt: now.subtract(const Duration(minutes: 12)),
        level: NotificationLevel.warning,
      ),
      NotificationModel(
        id: 'seed-2',
        title: '设备维保提醒',
        body: '印刷线 A3 的例行维护将在今日 17:30 开始。',
        createdAt: now.subtract(const Duration(hours: 1, minutes: 5)),
      ),
      NotificationModel(
        id: 'seed-3',
        title: '库存预警',
        body: '牛皮纸库存低于安全线，请安排补货。',
        createdAt: now.subtract(const Duration(hours: 3)),
        level: NotificationLevel.urgent,
      ),
    ]);
    _syncUnreadCount();
  }

  void _refreshMockData() {
    _seed += 1;
    final now = DateTime.now();
    final newItem = NotificationModel(
      id: 'poll-$_seed',
      title: '新的工单更新',
      body: '工单 WO-2026-${100 + _seed} 已进入待验收状态。',
      createdAt: now,
    );
    recentList.insert(0, newItem);
    if (recentList.length > 5) {
      recentList.removeLast();
    }
    _syncUnreadCount();
  }

  void _syncUnreadCount() {
    unreadCount.value = recentList.where((item) => !item.isRead).length;
  }
}
