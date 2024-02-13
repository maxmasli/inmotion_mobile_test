import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/gps_measure_entity.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/gps_sensor_entity.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/hr_measure_entity.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/hr_sensor_entity.dart';

// One step == 75cm or 0.75m
const step = 0.75;

class PlayerEntity extends ChangeNotifier {
  final String name;
  final int number;

  final _hrMeasures = <HrMeasureEntity>[];
  final _gpsMeasures = <GpsMeasureEntity>[];

  RunningType runningType;
  GpsSensorEntity? _gpsSensor;
  HrSensorEntity? _hrSensor;

  PlayerEntity({
    required this.name,
    required this.number,
    this.runningType = RunningType.onFoot,
  });

  int get distance => _gpsMeasures.map((m) => m.distance).sum;

  int get steps => (distance * step).round();

  int get pulse => _hrMeasures.lastOrNull?.hr ?? 0;

  List<(int x, int y, int speed)> get coordinates =>
      _gpsMeasures.map((m) => (m.x, m.y, m.speed)).toList();

  int get speed => _gpsMeasures.lastOrNull?.speed ?? 0;

  set hrSensor(HrSensorEntity sensor) {
    _hrSensor = sensor;
    sensor.stream.listen((meas) {
      _hrMeasures.add(meas);
      notifyListeners();
    });
  }

  set gpsSensor(GpsSensorEntity sensor) {
    _gpsSensor = sensor;
    sensor.stream.listen((meas) {
      _gpsMeasures.add(meas);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gpsSensor?.dispose();
    _hrSensor?.dispose();
  }
}

enum PlayerError { hrError, stationError, gpsError, otherError }

enum RunningType { onFoot, jogging, run, acceleration }
