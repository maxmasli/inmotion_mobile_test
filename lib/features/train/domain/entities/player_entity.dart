import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:uuid/uuid.dart';

// One step == 75cm or 0.75m

class PlayerEntity extends ChangeNotifier {
  String? uuid;
  String name;
  int number;

  RunningType _runningType;

  SensorEntity? _sensor;

  MeasureEntity? lastMeasure;

  final List<MeasureEntity> _measures = [];

  PlayerEntity({
    required this.name,
    required this.number,
    this.uuid,
    SensorEntity? sensor,
  })  : _runningType = RunningType.onFoot,
        _sensor = sensor {
    uuid ??= const Uuid().v4();
    _sensor?.addListener(() {
      notifyListeners();
    });
  }

  PlayerEntity.fromDevice({
    required BluetoothDevice device,
  }) : this(
          name: "Name",
          number: 01,
          sensor: SensorEntity(device: device, number: 1),
        );

  bool get hasSensor => _sensor != null;

  RunningType get runningType => _runningType;

  SensorEntity? get sensor => _sensor;

  int get distance => _measures.lastOrNull?.distance?.toInt() ?? 0;

  int get steps => _measures.lastOrNull?.steps ?? 0;

  int get pulse => _measures.lastOrNull?.hr ?? 60;

  Iterable<(double x, double y, int speed)> get coordinates sync* {
    for (final m in _measures) {
      if (m.latitude != null && m.longitude != null && m.speed != null) {
        yield (m.latitude!, m.longitude!, m.speed!.toInt());
      }
    }
  }

  List<int> get hrMeasures => _measures.map((m) => m.hr ?? 0).toList();

  List<MeasureEntity> get measures => _measures;

  /* Скорость в м/с */
  double get speedMps => _measures.lastOrNull?.speed ?? 0;

  /* Скорость в км/ч */
  double get speedKph => speedMps * 3600 / 1000;

  double get avgSpeedKph => _measures
      .where((m) => m.speed != null)
      .map((m) => m.speed! * 3600 / 1000)
      .average;

  double get maxSpeedKph => _measures
      .map((m) => m.speed! * 3600 / 1000)
      .maxOrNull ?? 0;

  void addMeasure(MeasureEntity payload, [TagMeta? meta]) {
    // TODO сравнивать по inc
    // if (lastMeasure == null || lastMeasure!.time != payload.time) {
    //   _measures.add(payload);
    //   _sensor?.notify(meta);
    //   lastMeasure = payload;
    //   notifyListeners();
    // }

    _measures.add(payload);
    _sensor?.notify(meta);
    notifyListeners();
    log("measure received: length: ${_measures.length}", name: "PlayerEntity");
  }

  void notifySensor(MeasureEntity payload, [TagMeta? meta]) {
    // TODO сравнивать по inc
    // if (lastMeasure == null || lastMeasure!.time != payload.time) {
    //   _sensor?.notify(meta);
    //   lastMeasure = payload;
    //   notifyListeners();
    // }

    _sensor?.notify(meta);
    notifyListeners();
  }

  void setMeasures(Iterable<MeasureEntity> measures) {
    _measures.clear();
    _measures.addAll(measures);
  }

  void clearMeasures() {
    _measures.clear();
  }
}

enum PlayerError { hrError, stationError, gpsError, otherError }

enum RunningType { onFoot, jogging, run, acceleration }
