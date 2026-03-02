import 'dart:async';

import 'package:get/get.dart';
import 'package:work_order_app/api/notification_api.dart';
import 'package:work_order_app/common/app_events.dart';
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
  StreamSubscription<AppEvent>? _authSubscription;
  int _page = 1;
  final int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    if (Utils.isLogin()) {
      startPolling();
    }
    _authSubscription = AppEvents.stream.listen(_handleEvent);
  }

  @override
  void onClose() {
    _poller?.cancel();
    _authSubscription?.cancel();
    super.onClose();
  }

  void _handleEvent(AppEvent event) {
    if (event is AuthChangedEvent) {
      if (event.loggedIn) {
        startPolling();
      } else {
        stopPolling();
      }
    }
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
    try {
      final page = await NotificationApi.fetchNotifications(page: _page, pageSize: _pageSize);
      notifications.assignAll(page.items);
      totalCount.value = page.totalCount ?? page.items.length;
      hasMore.value = page.hasMore;
      await _refreshUnreadCount();
      await _refreshRecent();
    } catch (_) {
      // ignore polling errors
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) {
      return;
    }
    if (!Utils.isLogin()) {
      return;
    }
    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final page = await NotificationApi.fetchNotifications(page: nextPage, pageSize: _pageSize);
      notifications.addAll(page.items);
      _page = nextPage;
      hasMore.value = page.hasMore;
      totalCount.value = page.totalCount ?? totalCount.value;
    } catch (_) {
      // ignore paging errors
    } finally {
      isLoadingMore.value = false;
    }
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
    try {
      await _refreshUnreadCount();
      await _refreshRecent();
    } catch (_) {
      // ignore polling errors
    }
  }

  Future<void> _refreshUnreadCount() async {
    try {
      unreadCount.value = await NotificationApi.fetchUnreadCount();
    } catch (_) {
      // ignore
    }
  }

  Future<void> _refreshRecent() async {
    try {
      final page = await NotificationApi.fetchNotifications(page: 1, pageSize: 5);
      recentList.assignAll(page.items);
    } catch (_) {
      // ignore
    }
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
