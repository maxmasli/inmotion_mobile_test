import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';

// One step == 75cm or 0.75m

class PlayerEntity extends ChangeNotifier {
  // TODO create UUID
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

  int get distance => _measures.last.distance?.toInt() ?? 0;

  int get steps => _measures.last.steps ?? 0;

  int get pulse => _measures.lastOrNull?.hr ?? 0;

  //TODO переделать координаты
  List<(int x, int y, int speed)> get coordinates => [(1, 2, 3)];

  List<int> get hrMeasures => _measures.map((m) => m.hr ?? 0).toList();

  int get speed => _measures.lastOrNull?.speed?.toInt() ?? 0;

  // List<(int x, int y, int speed)> get coordinates =>
  //     _gpsMeasures.map((m) => (m.x, m.y, m.speed)).toList();

  void addMeasure(MeasureEntity payload, [TagMeta? meta]) {
    _measures.add(payload);
    _sensor.notify(meta);
  }

  void notifySensor([TagMeta? meta]) {
    _sensor.notify(meta);
  }

  void setMeasures(List<MeasureEntity> measures) {
    _measures.clear();
    _measures.addAll(measures);
  }
}

enum PlayerError { hrError, stationError, gpsError, otherError }

enum RunningType { onFoot, jogging, run, acceleration }
