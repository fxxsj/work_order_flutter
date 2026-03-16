import 'notification_socket.dart';

NotificationSocket createSocket(String url) => _UnsupportedNotificationSocket();

class _UnsupportedNotificationSocket implements NotificationSocket {
  @override
  Future<void> close() async {}

  @override
  Future<void> connect({
    required NotificationSocketMessage onMessage,
    NotificationSocketError? onError,
    void Function()? onDone,
  }) async {
    onError?.call(StateError('Notification socket not supported'));
  }
}
