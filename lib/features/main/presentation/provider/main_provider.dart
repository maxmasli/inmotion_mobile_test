import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/di.dart';

class MainModel extends ChangeNotifier {
  var _systemStatus = SystemStatus.ready;

  final l = getIt<AppLogsController>();

  SystemStatus get systemStatus => _systemStatus;

  void init() {}

  void startRecording() {
    _systemStatus = SystemStatus.rec;
    notifyListeners();
    l.log("Start recording", "MODEL");
  }

  void stopRecording() {
    _systemStatus = SystemStatus.ready;
    notifyListeners();
    l.log("Stop recording", "MODEL");
  }

  void pauseRecording() {
    _systemStatus = SystemStatus.ready;
    notifyListeners();
    l.log("Pause recording", "MODEL");
  }
}

enum SystemStatus { off, ready, rec, error }
