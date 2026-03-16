import 'notification_socket_stub.dart'
    if (dart.library.html) 'notification_socket_web.dart'
    if (dart.library.io) 'notification_socket_io.dart';

typedef NotificationSocketMessage = void Function(String message);
typedef NotificationSocketError = void Function(Object error);

abstract class NotificationSocket {
  Future<void> connect({
    required NotificationSocketMessage onMessage,
    NotificationSocketError? onError,
    void Function()? onDone,
  });

  Future<void> close();
}

NotificationSocket createNotificationSocket(String url) => createSocket(url);
