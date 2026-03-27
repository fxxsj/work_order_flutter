import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'notification_socket.dart';

NotificationSocket createSocket(String url) => _WebNotificationSocket(url);

class _WebNotificationSocket implements NotificationSocket {
  _WebNotificationSocket(this._url);

  final String _url;
  web.WebSocket? _socket;
  StreamSubscription<web.MessageEvent>? _messageSub;
  StreamSubscription<web.Event>? _errorSub;
  StreamSubscription<web.CloseEvent>? _closeSub;

  @override
  Future<void> connect({
    required NotificationSocketMessage onMessage,
    NotificationSocketError? onError,
    void Function()? onDone,
  }) async {
    final socket = web.WebSocket(_url);
    _socket = socket;
    _messageSub = socket.onMessage.listen((event) {
      onMessage(_readMessage(event));
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

  String _readMessage(web.MessageEvent event) {
    final data = event.data;
    if (data == null) {
      return '';
    }
    if (data.typeofEquals('string')) {
      return (data as JSString).toDart;
    }
    return data.toString();
  }
}
