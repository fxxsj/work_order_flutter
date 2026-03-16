import 'dart:async';
import 'dart:io';

import 'notification_socket.dart';

NotificationSocket createSocket(String url) => _IoNotificationSocket(url);

class _IoNotificationSocket implements NotificationSocket {
  _IoNotificationSocket(this._url);

  final String _url;
  WebSocket? _socket;
  StreamSubscription<dynamic>? _subscription;

  @override
  Future<void> connect({
    required NotificationSocketMessage onMessage,
    NotificationSocketError? onError,
    void Function()? onDone,
  }) async {
    _socket = await WebSocket.connect(_url);
    _subscription = _socket!.listen(
      (event) {
        if (event == null) return;
        onMessage(event.toString());
      },
      onError: onError,
      onDone: onDone,
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _socket?.close();
    _subscription = null;
    _socket = null;
  }
}
