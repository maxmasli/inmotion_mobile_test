import 'dart:async';
import 'dart:math';

import 'package:inmotion_mobile_test/features/main/domain/entities/hr_measure_entity.dart';

class HrSensorEntity {
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
    return HrMeasureEntity(
      hr: Random().nextInt(100),
      date: DateTime.now(),
    );
  }
}
