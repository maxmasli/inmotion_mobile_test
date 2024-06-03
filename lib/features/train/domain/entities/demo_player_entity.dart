import 'dart:math';

import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

class DemoPlayerEntity extends PlayerEntity {
  final _random = Random();

  double lastLong = 82.890123;
  double lastLat = 54.979763;
  int lastHr = 80;

  DemoPlayerEntity({
    required super.name,
    required super.number,
    required super.sensor,
  });

  @override
  void notifySensor(MeasureEntity p, [TagMeta? m]) {
    final meta = TagMeta(1, 10, 100, 1024, 1);
    sensor?.notify(meta);
    notifyListeners();
  }

  @override
  void addMeasure(p, [TagMeta? m]) {
    lastLat += _random.nextDouble() / 7000;
    lastLong += _random.nextDouble() / 7000;
    lastHr += _random.nextInt(6) - 3;

    if (lastHr < 60) lastHr = 60;
    if (lastHr > 180) lastHr = 180;

    final payload = MeasureEntity(
      time: DateTime.now(),
      hr: lastHr,
      latitude: lastLat,
      longitude: lastLong,
      speed: _random.nextInt(5).toDouble(),
      steps: _random.nextInt(1000),
      distance: _random.nextInt(2000).toDouble(),
    );

    final meta = TagMeta(1, 10, 100, 1024, 0xFF);

    measures.add(payload);
    sensor?.notify(meta);
    notifyListeners();
  }
}
