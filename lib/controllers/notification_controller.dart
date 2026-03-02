import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:work_order_app/api/notification_api.dart';
import 'package:work_order_app/common/app_events.dart';
import 'package:work_order_app/models/notification_model.dart';
import 'package:work_order_app/utils/utils.dart';

class NotificationController extends ChangeNotifier {
  int _unreadCount = 0;
  List<NotificationModel> _recentList = [];
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _totalCount = 0;
  bool _showUnreadOnly = false;

  Timer? _poller;
  StreamSubscription<AppEvent>? _authSubscription;
  int _page = 1;
  final int _pageSize = 20;
  bool _disposed = false;

  int get unreadCount => _unreadCount;
  List<NotificationModel> get recentList => _recentList;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  int get totalCount => _totalCount;
  bool get showUnreadOnly => _showUnreadOnly;

  void initialize() {
    if (Utils.isLogin()) {
      startPolling();
    }
    _authSubscription = AppEvents.stream.listen(_handleEvent);
  }

  @override
  void dispose() {
    _disposed = true;
    _poller?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
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
    _isLoading = true;
    _safeNotify();
    _page = 1;
    try {
      final page = await NotificationApi.fetchNotifications(page: _page, pageSize: _pageSize);
      _notifications = page.items.toList();
      _totalCount = page.totalCount ?? page.items.length;
      _hasMore = page.hasMore;
      await _refreshUnreadCount();
      await _refreshRecent();
    } catch (_) {
      // ignore polling errors
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }
    if (!Utils.isLogin()) {
      return;
    }
    _isLoadingMore = true;
    _safeNotify();
    try {
      final nextPage = _page + 1;
      final page = await NotificationApi.fetchNotifications(page: nextPage, pageSize: _pageSize);
      _notifications = [..._notifications, ...page.items];
      _page = nextPage;
      _hasMore = page.hasMore;
      _totalCount = page.totalCount ?? _totalCount;
    } catch (_) {
      // ignore paging errors
    } finally {
      _isLoadingMore = false;
      _safeNotify();
    }
  }

  Future<void> markAllRead() async {
    await NotificationApi.markAllRead();
    _notifications = _notifications
        .map((item) => item.isRead ? item : item.copyWith(isRead: true))
        .toList();
    _recentList = _recentList
        .map((item) => item.isRead ? item : item.copyWith(isRead: true))
        .toList();
    _unreadCount = 0;
    _safeNotify();
  }

  Future<void> markRead(String id) async {
    final updated = await NotificationApi.markRead(id);
    if (updated == null) {
      return;
    }
    _updateLists(updated);
    _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
    _safeNotify();
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
      _unreadCount = await NotificationApi.fetchUnreadCount();
      _safeNotify();
    } catch (_) {
      // ignore
    }
  }

  Future<void> _refreshRecent() async {
    try {
      final page = await NotificationApi.fetchNotifications(page: 1, pageSize: 5);
      _recentList = page.items.toList();
      _safeNotify();
    } catch (_) {
      // ignore
    }
  }

  void _updateLists(NotificationModel updated) {
    final recentIndex = _recentList.indexWhere((item) => item.id == updated.id);
    if (recentIndex != -1) {
      _recentList = List.from(_recentList)..[recentIndex] = updated;
    }
    final listIndex = _notifications.indexWhere((item) => item.id == updated.id);
    if (listIndex != -1) {
      _notifications = List.from(_notifications)..[listIndex] = updated;
    }
  }

  void setShowUnreadOnly(bool value) {
    _showUnreadOnly = value;
    _safeNotify();
  }
}
