import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/hr_measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';

// One step == 75cm or 0.75m
const step = 0.75;

class PlayerEntity extends ChangeNotifier {
  final String name;
  final int number;

  RunningType _runningType;
  SensorEntity _sensor;

  final List<MeasureEntity> _measures = [];

  PlayerEntity({
    required this.name,
    required this.number,
    required SensorEntity sensor,
    VoidCallback? onSensorStatusUpdate,
  })  : _runningType = RunningType.onFoot,
        _sensor = sensor {
    if (onSensorStatusUpdate != null) {
      log("add listener");
      _sensor.addListener(() {
        onSensorStatusUpdate();
      });
    }
  }

  PlayerEntity.fromDevice({
    required BluetoothDevice device,
    VoidCallback? onSensorStatusUpdate,
  }) : this(
          name: "Name",
          number: 01,
          sensor: SensorEntity(device: device, number: 1),
          onSensorStatusUpdate: onSensorStatusUpdate,
        );

  RunningType get runningType => _runningType;

  SensorEntity get sensor => _sensor;

  //TODO переделать как в расчетах

  int get distance => 10;

  int get steps => (distance * step).round();

  int get pulse => 10;

  List<(int x, int y, int speed)> get coordinates => [(1, 2, 3)];

  List<HrMeasureEntity> get hrMeasures => [];

  int get speed => 0;

  // TODO расчеты

  // int get distance => _gpsMeasures.map((m) => m.distance).sum;
  //
  // int get steps => (distance * step).round();
  //
  // int get pulse => _hrMeasures.lastOrNull?.hr ?? 0;
  //
  // List<(int x, int y, int speed)> get coordinates =>
  //     _gpsMeasures.map((m) => (m.x, m.y, m.speed)).toList();
  //
  // List<HrMeasureEntity> get hrMeasures => _hrMeasures;
  //
  // int get speed => _gpsMeasures.lastOrNull?.speed ?? 0;

  void addMeasure(MeasureEntity payload, [TagMeta? meta]) {
    _measures.add(payload);
    _sensor.notify(meta);
  }

  void notifySensor([TagMeta? meta]) {
    _sensor.notify(meta);
  }
}

enum PlayerError { hrError, stationError, gpsError, otherError }

enum RunningType { onFoot, jogging, run, acceleration }
