import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {

  var systemStatus = SystemStatus.ready;

  void init() {

  }

  void startRecording() {
    systemStatus = SystemStatus.rec;
  }

  void stopRecording() {
    systemStatus = SystemStatus.ready;
  }

}

enum SystemStatus {
  off, ready, rec, error
}