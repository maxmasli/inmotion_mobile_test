import 'package:flutter/material.dart';
import 'dart:developer' as d;

class AppLogsController extends ChangeNotifier {

  final _logs = <String>[];

  List<String> get logs => _logs;

  void log(String message, [String tag = 'log']) {
    _logs.add('[$tag] $message');
    d.log(message, name: tag);
    notifyListeners();
  }

  void deleteLogs() {
    _logs.clear();
    notifyListeners();
  }
}