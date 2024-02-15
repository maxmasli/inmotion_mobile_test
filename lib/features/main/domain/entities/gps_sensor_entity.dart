import 'dart:async';
import 'dart:math';

import 'package:inmotion_mobile_test/core/utils/cords_generator.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/gps_measure_entity.dart';

class GpsSensorEntity {
  // For demo cords generation
  final cordsGenerator = CordsGenerator();

  Timer? _timer;
  final _controller = StreamController<GpsMeasureEntity>.broadcast();

  Stream<GpsMeasureEntity> get stream => _controller.stream;

  Function(GpsMeasureEntity)? onMeasureReceive;

  void init() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 800),
      (timer) {
        final meas = _createRandomMeasure();
        _controller.add(meas);

        if (onMeasureReceive != null) {
          onMeasureReceive!(meas);
        }
      },
    );
  }

  void dispose() async {
    _timer?.cancel();
    await _controller.close();
  }

  GpsMeasureEntity _createRandomMeasure() {
    final c = cordsGenerator.getNextCords();
    return GpsMeasureEntity(
      x: c.$1,
      y: c.$2,
      speed: c.$3,
      distance: Random().nextInt(5),
      date: DateTime.now(),
    );
  }
}
