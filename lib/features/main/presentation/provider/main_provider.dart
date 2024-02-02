import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/di.dart';

class MainModel extends ChangeNotifier {

  var systemStatus = SystemStatus.ready;
  final l = getIt<AppLogsController>();

  void init() {

  }

  void startRecording() {
    systemStatus = SystemStatus.rec;
    l.log("Start recording", "MODEL");
  }

  void stopRecording() {
    systemStatus = SystemStatus.ready;
    l.log("Stop recording", "MODEL");
  }

}

enum SystemStatus {
  off, ready, rec, error
}