import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;

  Duration get elapsedTime => _elapsedTime;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime += const Duration(seconds: 1);
      notifyListeners(); // Notify listeners to update the UI
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(_elapsedTime.inMinutes.remainder(60));
    final seconds = twoDigits(_elapsedTime.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
