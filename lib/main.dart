import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inmotion_mobile_test/app.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/measure_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_list_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/train_dto.dart';
import 'package:wakelock/wakelock.dart';
import 'package:inmotion_mobile_test/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MeasureDTOAdapter());
  Hive.registerAdapter(PlayerDTOAdapter());
  Hive.registerAdapter(PlayerListDTOAdapter());
  Hive.registerAdapter(TrainDTOAdapter());

  await Wakelock.enable();
  di.setup();
  runApp(App());
}
