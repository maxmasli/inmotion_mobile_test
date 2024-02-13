import 'dart:async';

import 'package:inmotion_mobile_test/features/main/domain/entities/gps_measure_entity.dart';

class GpsSensorEntity {
  Timer? _timer;
  final _controller = StreamController<GpsMeasureEntity>.broadcast();

  Stream<GpsMeasureEntity> get stream => _controller.stream;

  Function(GpsMeasureEntity)? onMeasureReceive;

  void init() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 3000),
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
    return GpsMeasureEntity(
      x: 50,
      y: 30,
      speed: 3,
      distance: 2,
      date: DateTime.now(),
    );
  }
}
