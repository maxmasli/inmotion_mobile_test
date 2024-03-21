import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/app.dart';
import 'package:wakelock/wakelock.dart';
import 'package:inmotion_mobile_test/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.setup();
  await Wakelock.enable();
  runApp(App());
}
