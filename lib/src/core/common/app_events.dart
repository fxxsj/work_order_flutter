import 'dart:async';

abstract class AppEvent {
  const AppEvent();
}

class AuthExpiredEvent extends AppEvent {
  final String? message;
  const AuthExpiredEvent([this.message]);
}

class AppEvents {
  AppEvents._();

  static final StreamController<AppEvent> _controller = StreamController<AppEvent>.broadcast();

  static Stream<AppEvent> get stream => _controller.stream;

  static void emit(AppEvent event) {
    _controller.add(event);
  }
}
