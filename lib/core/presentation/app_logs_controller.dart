import 'package:flutter/material.dart';

class AppLogsController extends ChangeNotifier {

  final _logs = <String>[];

  List<String> get logs => _logs;

  void log(String message, [String tag = 'log']) {
    _logs.add('[$tag] $message');
    notifyListeners();
  }
}