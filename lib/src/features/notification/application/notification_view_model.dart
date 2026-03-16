import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:work_order_app/src/core/common/app_config.dart';
import 'package:work_order_app/src/core/common/http_client.dart';
import 'package:work_order_app/src/features/notification/data/notification_api.dart';
import 'package:work_order_app/src/features/notification/data/notification_socket.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/notification/domain/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel(this._authController, this._api);

  final AuthController _authController;
  final NotificationApi _api;
  int _unreadCount = 0;
  List<NotificationModel> _recentList = [];
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _totalCount = 0;
  bool _showUnreadOnly = false;

  Timer? _poller;
  Timer? _reconnectTimer;
  int _page = 1;
  final int _pageSize = 20;
  bool _disposed = false;
  NotificationSocket? _socket;
  bool _connectingSocket = false;

  int get unreadCount => _unreadCount;
  List<NotificationModel> get recentList => _recentList;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  int get totalCount => _totalCount;
  bool get showUnreadOnly => _showUnreadOnly;

  void initialize() {
    _authController.addListener(_handleAuthChange);
    startPolling();
  }

  @override
  void dispose() {
    _disposed = true;
    _poller?.cancel();
    _reconnectTimer?.cancel();
    _disposeSocket();
    _authController.removeListener(_handleAuthChange);
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  void _handleAuthChange() {
    if (_authController.isLoggedIn) {
      startPolling();
    } else {
      stopPolling();
    }
  }

  void startPolling() {
    if (_poller != null) {
      return;
    }
    _ensureSessionAndStart();
  }

  Future<void> _ensureSessionAndStart() async {
    final ready = await _authController.ensureValidSession();
    if (!ready) {
      stopPolling();
      return;
    }
    refreshAll();
    _poller = Timer.periodic(const Duration(minutes: 1), (_) => _poll());
    _connectSocket();
  }

  void stopPolling() {
    _poller?.cancel();
    _poller = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _disposeSocket();
  }

  Future<void> _connectSocket() async {
    if (_connectingSocket || _socket != null || !_authController.isLoggedIn) {
      return;
    }
    final token = HttpClient.accessToken;
    if (token == null || token.isEmpty) {
      return;
    }
    final wsUrl = _buildSocketUrl(token);
    if (wsUrl == null) {
      return;
    }
    _connectingSocket = true;
    try {
      final socket = createNotificationSocket(wsUrl);
      _socket = socket;
      await socket.connect(
        onMessage: _handleSocketMessage,
        onError: (_) => _handleSocketError(),
        onDone: _handleSocketDone,
      );
    } catch (_) {
      _disposeSocket();
      _scheduleReconnect();
    } finally {
      _connectingSocket = false;
    }
  }

  void _handleSocketMessage(String message) {
    if (message.trim().isEmpty) return;
    try {
      final payload = jsonDecode(message);
      if (payload is Map && payload['type'] == 'notification') {
        _refreshUnreadCount();
        _refreshRecent();
      }
    } catch (_) {
      // ignore malformed payloads
    }
  }

  void _handleSocketError() {
    _disposeSocket();
    _scheduleReconnect();
  }

  void _handleSocketDone() {
    _disposeSocket();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (!_authController.isLoggedIn || _disposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 10), () {
      _connectSocket();
    });
  }

  void _disposeSocket() {
    final socket = _socket;
    _socket = null;
    socket?.close();
  }

  String? _buildSocketUrl(String token) {
    final base = AppConfig.apiBaseUrl;
    if (base.isEmpty) return null;
    try {
      final apiUri = Uri.parse(base);
      final scheme = apiUri.scheme == 'https' ? 'wss' : 'ws';
      return Uri(
        scheme: scheme,
        host: apiUri.host,
        port: apiUri.hasPort ? apiUri.port : null,
        path: 'ws/notifications/',
        queryParameters: {'token': token},
      ).toString();
    } catch (_) {
      return null;
    }
  }

  Future<void> refreshAll() async {
    if (!_authController.isLoggedIn) {
      return;
    }
    _isLoading = true;
    _safeNotify();
    _page = 1;
    try {
      final page = await _api.fetchNotifications(page: _page, pageSize: _pageSize);
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
    if (!_authController.isLoggedIn) {
      return;
    }
    _isLoadingMore = true;
    _safeNotify();
    try {
      final nextPage = _page + 1;
      final page = await _api.fetchNotifications(page: nextPage, pageSize: _pageSize);
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
    await _api.markAllRead();
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
    final updated = await _api.markRead(id);
    if (updated == null) {
      return;
    }
    _updateLists(updated);
    _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
    _safeNotify();
  }

  Future<void> _poll() async {
    if (!_authController.isLoggedIn) {
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
      _unreadCount = await _api.fetchUnreadCount();
      _safeNotify();
    } catch (_) {
      // ignore
    }
  }

  Future<void> _refreshRecent() async {
    try {
      final page = await _api.fetchNotifications(page: 1, pageSize: 5);
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
