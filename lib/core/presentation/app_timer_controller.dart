import 'dart:async';

import 'package:flutter/material.dart';

class AppTimerController extends ChangeNotifier {
  var _state = TimerState.stopped;
  var _time = 0;
  Timer? _timer;
  Function(int)? _onTick;

  TimerState get state => _state;

  String get formattedTime => _time.hhmmss();

  int get timeInSeconds => _time;

  set onTick(Function(int) f) => _onTick = f;

  void startTimer() {
    assert(state != TimerState.running, "Timer is running already");
    _time = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _time += 1;
      toggleTick();
      notifyListeners();
    });
    _state = TimerState.running;

    toggleTick(); // 0
    notifyListeners();
  }

  void stopTimer() {
    assert(state != TimerState.stopped, "Timer is stopped already");
    _timer?.cancel();
    _timer = null;
    _state = TimerState.stopped;
    notifyListeners();
  }

  void toggleTick() {
    if (_onTick != null) {
      _onTick!(_time);
    }
  }

  void clear() {
    _time = 0;
    notifyListeners();
  }
}

enum TimerState { stopped, running }

extension _Format on int {
  String hhmmss() {
    final seconds = this;
    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;

    final hoursStr = hours.toString().padLeft(1, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }
}