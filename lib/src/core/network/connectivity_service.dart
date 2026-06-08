import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// 全局网络连接状态服务
///
/// 封装 [Connectivity] 为单例 Stream，供 UI 层监听。
/// 监听结果：
/// - `ConnectivityResult.wifi` / `mobile` / `ethernet` / `vpn` / `other` → 在线
/// - `ConnectivityResult.none` → 离线
/// - `ConnectivityResult.bluetooth` → 视为离线（无法访问互联网）
class ConnectivityService {
  ConnectivityService._internal() {
    _init();
  }

  /// 测试专用构造函数，不绑定真实 Connectivity 插件。
  @visibleForTesting
  ConnectivityService.test({bool initialOnline = true}) : _isOnline = initialOnline;

  static final ConnectivityService _instance = ConnectivityService._internal();

  /// 获取单例实例
  static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  bool _isOnline = true;

  /// 当前是否在线（同步读取最新状态）
  bool get isOnline => _isOnline;

  /// 离线状态反向快捷访问
  bool get isOffline => !_isOnline;

  /// 网络状态变化流：true=在线, false=离线
  Stream<bool> get onStatusChange => _controller.stream;

  void _init() {
    // 主动获取一次当前状态
    _connectivity.checkConnectivity().then(_handleResult);

    // 监听后续变化
    _connectivity.onConnectivityChanged.listen(
      _handleResult,
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint('ConnectivityService error: $error');
        }
        // 出错时保守认为离线
        _updateStatus(false);
      },
    );
  }

  void _handleResult(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    final online = _isConnected(result);
    _updateStatus(online);
  }

  static bool _isConnected(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
      case ConnectivityResult.satellite:
        return true;
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
        return false;
    }
  }

  void _updateStatus(bool online) {
    if (_isOnline == online) return;
    _isOnline = online;
    _controller.add(online);
  }

  /// 模拟网络状态变化（仅用于测试）。
  @visibleForTesting
  void simulateStatusChange(bool online) => _updateStatus(online);

  /// 释放资源（通常不需要手动调用，单例生命周期与 App 一致）
  void dispose() {
    _controller.close();
  }
}
