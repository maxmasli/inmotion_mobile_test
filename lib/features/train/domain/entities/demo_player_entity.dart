import 'dart:math';

import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data.dart';
import 'package:inmotion_mobile_test/core/utils/settings.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

class DemoPlayerEntity extends PlayerEntity {
  final _random = Random();

  double lastLong = 82.890123;
  double lastLat = 54.979763;
  int lastHr = 80;
  int lastSteps = 0;
  int lastDistance = 0;
  int time = 0;
  int lastSpeed = 0;

  DemoPlayerEntity({
    required super.name,
    required super.number,
    required super.sensor,
  });

  @override
  void notifySensor(MeasureEntity p, [InmotionTagMeta? m]) {
    time = 0;
    final meta = InmotionTagMeta(1, 10, 100, 1024, 0xFF);
    sensor?.notify(meta);
    notifyListeners();
  }

  @override
  void addMeasure(p, [InmotionTagMeta? m]) {
    lastLat += _random.nextDouble() / 7000;
    lastLong += _random.nextDouble() / 7000;
    lastHr += _random.nextInt(7) - 3;
    lastSteps += _random.nextInt(7);
    lastDistance += _random.nextInt(5);
    lastSpeed += _random.nextInt(6) - 3;
    time++;

    if (time < 30) {
      if (lastHr < 60) lastHr = 60;
      if (lastHr > Settings.lightLoad) lastHr = Settings.lightLoad;
    } else if (time < 60) {
      if (lastHr < Settings.lightLoad) lastHr = Settings.lightLoad;
      if (lastHr > Settings.anaerobicMode) lastHr = Settings.anaerobicMode;
    } else {
      if (lastHr < Settings.anaerobicMode) lastHr = Settings.anaerobicMode;
      if (lastHr > Settings.maximumIntensity + 10) lastHr = Settings.maximumIntensity + 10;
    }

    if (lastSpeed < 0) lastSpeed = 0;
    if (lastSpeed > 10) lastSpeed = 10;


    final payload = MeasureEntity(
      time: DateTime.now(),
      hr: lastHr,
      latitude: lastLat,
      longitude: lastLong,
      speed: lastSpeed.toDouble(),
      steps: lastSteps,
      distance: lastDistance.toDouble(),
    );

    final meta = InmotionTagMeta(1, 10, 100, 1024, 0xFF);

    measures.add(payload);
    sensor?.notify(meta);
    notifyListeners();
  }
}
