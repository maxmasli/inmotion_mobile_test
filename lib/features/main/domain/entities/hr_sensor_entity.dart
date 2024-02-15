import 'dart:async';
import 'dart:math';

import 'package:inmotion_mobile_test/features/main/domain/entities/hr_measure_entity.dart';

class HrSensorEntity {
  // For generate random pulse
  var lastHr = 130;
  final minHr = 64;
  final maxHr = 186;

  Timer? _timer;
  final _controller = StreamController<HrMeasureEntity>.broadcast();

  Stream<HrMeasureEntity> get stream => _controller.stream;

  Function(HrMeasureEntity)? onMeasureReceive;

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

  HrMeasureEntity _createRandomMeasure() {
    int newHr = lastHr - 3 +  Random().nextInt(7);
    if (newHr < minHr) newHr = minHr;
    if (newHr > maxHr) newHr = maxHr;
    lastHr = newHr;
    return HrMeasureEntity(
      hr: newHr,
      date: DateTime.now(),
    );
  }
}
