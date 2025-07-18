import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart' as fbp;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inmotion_mobile_test/app.dart';
import 'package:inmotion_mobile_test/di.dart' as di;
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/duration_adapter.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/measure_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_list_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/split_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/train_dto.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  di.setup();
  runTalkerZonedGuarded(
    getIt<Talker>(),
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      fbp.FlutterBluePlus.setLogLevel(fbp.LogLevel.none);

      await Hive.initFlutter();
      Hive.registerAdapter(MeasureDTOAdapter());
      Hive.registerAdapter(PlayerDTOAdapter());
      Hive.registerAdapter(PlayerListDTOAdapter());
      Hive.registerAdapter(TrainDTOAdapter());
      Hive.registerAdapter(SplitDTOAdapter());
      Hive.registerAdapter(DurationAdapter());

      await WakelockPlus.enable();
      runApp(App());
    },
    (error, st) {},
  );
}
