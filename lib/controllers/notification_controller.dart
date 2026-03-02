import 'dart:async';

import 'package:get/get.dart';
import 'package:work_order_app/api/notification_api.dart';
import 'package:work_order_app/models/notification_model.dart';
import 'package:work_order_app/utils/utils.dart';

class NotificationController extends GetxController {
  final RxInt unreadCount = 0.obs;
  final RxList<NotificationModel> recentList = <NotificationModel>[].obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = false.obs;
  final RxInt totalCount = 0.obs;
  final RxBool showUnreadOnly = false.obs;

  Timer? _poller;
  int _page = 1;
  final int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    if (Utils.isLogin()) {
      startPolling();
    }
  }

  @override
  void onClose() {
    _poller?.cancel();
    super.onClose();
  }

  void startPolling() {
    if (_poller != null) {
      return;
    }
    refreshAll();
    _poller = Timer.periodic(const Duration(minutes: 1), (_) => _poll());
  }

  void stopPolling() {
    _poller?.cancel();
    _poller = null;
  }

  Future<void> refreshAll() async {
    if (!Utils.isLogin()) {
      return;
    }
    isLoading.value = true;
    _page = 1;
    final page = await NotificationApi.fetchNotifications(page: _page, pageSize: _pageSize);
    notifications.assignAll(page.items);
    totalCount.value = page.totalCount ?? page.items.length;
    hasMore.value = page.hasMore;
    await _refreshUnreadCount();
    await _refreshRecent();
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) {
      return;
    }
    if (!Utils.isLogin()) {
      return;
    }
    isLoadingMore.value = true;
    final nextPage = _page + 1;
    final page = await NotificationApi.fetchNotifications(page: nextPage, pageSize: _pageSize);
    notifications.addAll(page.items);
    _page = nextPage;
    hasMore.value = page.hasMore;
    totalCount.value = page.totalCount ?? totalCount.value;
    isLoadingMore.value = false;
  }

  Future<void> markAllRead() async {
    await NotificationApi.markAllRead();
    notifications.value = notifications
        .map((item) => item.isRead ? item : item.copyWith(isRead: true))
        .toList();
    recentList.value = recentList
        .map((item) => item.isRead ? item : item.copyWith(isRead: true))
        .toList();
    unreadCount.value = 0;
  }

  Future<void> markRead(String id) async {
    final updated = await NotificationApi.markRead(id);
    if (updated == null) {
      return;
    }
    _updateLists(updated);
    unreadCount.value = unreadCount.value > 0 ? unreadCount.value - 1 : 0;
  }

  Future<void> _poll() async {
    if (!Utils.isLogin()) {
      return;
    }
    await _refreshUnreadCount();
    await _refreshRecent();
  }

  Future<void> _refreshUnreadCount() async {
    unreadCount.value = await NotificationApi.fetchUnreadCount();
  }

  Future<void> _refreshRecent() async {
    final page = await NotificationApi.fetchNotifications(page: 1, pageSize: 5);
    recentList.assignAll(page.items);
  }

  void _updateLists(NotificationModel updated) {
    final recentIndex = recentList.indexWhere((item) => item.id == updated.id);
    if (recentIndex != -1) {
      recentList[recentIndex] = updated;
    }
    final listIndex = notifications.indexWhere((item) => item.id == updated.id);
    if (listIndex != -1) {
      notifications[listIndex] = updated;
    }
  }

  void setShowUnreadOnly(bool value) {
    showUnreadOnly.value = value;
  }
}
