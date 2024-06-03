import 'dart:math';

import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

class DemoPlayerEntity extends PlayerEntity {
  final _random = Random();

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
    final payload = MeasureEntity(
      time: DateTime.now(),
      hr: _random.nextInt(100) + 60,
      latitude: _random.nextDouble() / 5000 + 54.979763,
      longitude: _random.nextDouble() / 5000 + 82.890123,
      speed: _random.nextInt(7) + 7,
      steps: _random.nextInt(1000),
      distance: _random.nextInt(2000).toDouble(),
    );

    final meta = TagMeta(1, 10, 100, 1024, 0xFF);

    measures.add(payload);
    sensor?.notify(meta);
    notifyListeners();
  }
}
