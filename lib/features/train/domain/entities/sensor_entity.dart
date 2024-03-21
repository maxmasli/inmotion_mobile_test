import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';

class SensorEntity extends ChangeNotifier {
  // Timeout
  Timer? _timeoutTimer;
  int _timeoutCounter = 0;

  //
  final BluetoothDevice device;
  final int number;
  bool _isHrOk = false;
  SensorStatus _status = SensorStatus.disconnected;

  SensorStatus get status => _status;

  bool get isHrOk => _isHrOk;

  SensorEntity({
    required this.device,
    required this.number,
  }) {
    _startTimeoutTimer();
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeoutCounter += 1;
      _updateStatus();
    });
  }

  /// Метод который вызывается как только пришло измерение, чтобы понять
  /// что данные приходят и с девайсом все хорошо
  void notify([TagMeta? meta]) {
    _timeoutCounter = 0;
    _updateMetaStatus(meta);
    _updateStatus();
  }

  void _updateMetaStatus(TagMeta? meta) {
    if (meta != null && meta.hrOk != _isHrOk) {
      _isHrOk = meta.hrOk;
      notifyListeners();
    }
  }

  void _updateStatus() {
    if (_timeoutCounter >= 10 && _status != SensorStatus.disconnected) {
      _status = SensorStatus.disconnected;
      log("Sensor status disconnected");
      notifyListeners();
    } else if (_timeoutCounter >= 5 &&
        _timeoutCounter < 10 &&
        _status != SensorStatus.timeout) {
      _status = SensorStatus.timeout;
      log("Sensor status timeout");
      notifyListeners();
    } else if (_timeoutCounter < 5 &&
        _status != SensorStatus.connected) {
      _status = SensorStatus.connected;
      log("Sensor status connected");
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }
}

enum SensorStatus {
  /// Девайс подключен
  connected,

  /// Девайс не отвечает в течении 30 сек.
  timeout,

  /// Девайс не отвечает в течении минуты и больше
  disconnected,
}
