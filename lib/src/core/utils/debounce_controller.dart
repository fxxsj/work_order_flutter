import 'dart:async';
import 'dart:ui';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class DebounceController {
  Timer? _timer;
  final Duration duration;

  DebounceController({Duration? duration})
    : duration = duration ?? AnimationTokens.slower;

  void run(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(this.duration, callback);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}
