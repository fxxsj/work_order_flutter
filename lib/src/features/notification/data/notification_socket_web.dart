import 'dart:async';
import 'dart:html';

import 'notification_socket.dart';

NotificationSocket createSocket(String url) => _WebNotificationSocket(url);

class _WebNotificationSocket implements NotificationSocket {
  _WebNotificationSocket(this._url);

  final String _url;
  WebSocket? _socket;
  StreamSubscription<MessageEvent>? _messageSub;
  StreamSubscription<Event>? _errorSub;
  StreamSubscription<CloseEvent>? _closeSub;

  @override
  Future<void> connect({
    required NotificationSocketMessage onMessage,
    NotificationSocketError? onError,
    void Function()? onDone,
  }) async {
    final socket = WebSocket(_url);
    _socket = socket;
    _messageSub = socket.onMessage.listen((event) {
      onMessage(event.data?.toString() ?? '');
    });
    _errorSub = socket.onError.listen((event) {
      onError?.call(event);
    });
    _closeSub = socket.onClose.listen((_) {
      onDone?.call();
    });
  }

  @override
  Future<void> close() async {
    await _messageSub?.cancel();
    await _errorSub?.cancel();
    await _closeSub?.cancel();
    _socket?.close();
    _messageSub = null;
    _errorSub = null;
    _closeSub = null;
    _socket = null;
  }
}
