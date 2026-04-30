 

import 'dart:async';


import '../utils/devlog.dart';

class CountdownTimerService {
  final int initialSeconds;
  late int seconds;
  Stream<int>? _stream;
  StreamController<int>? _controller;
  Timer? _timer;

  CountdownTimerService({required this.initialSeconds}) {
    seconds = initialSeconds;
    devlog("countdowntimer initialized.!");
    _controller = StreamController<int>.broadcast(
      onListen: startCountdown,
      onCancel: () {
        _timer?.cancel(); // Cancel timer if no listeners
      },
    );
  }

  Stream<int> get remainingTime {
    return _controller!.stream;
  }

  void startCountdown() {
    devlog("countdowntimer started.!");
    seconds = initialSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        _controller?.add(seconds);
        // devlog("countdown seconds : $seconds");
      } else {
        _timer?.cancel();
        _controller?.close();
      }
    });
  }

  void reset() {
    devlog("countdowntimer reseted.!");
    _timer?.cancel();
    _controller?.close();
    _controller = StreamController<int>.broadcast(
      onListen: startCountdown,
      onCancel: () {
        _timer?.cancel();
      },
    );
    startCountdown();
  }

  void dispose() {
    devlog("countdowntimer disposed.!");
    _timer?.cancel();
    _controller?.close();
  }
}
