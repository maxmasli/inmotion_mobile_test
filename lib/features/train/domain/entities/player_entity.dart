import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
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

  final List<MeasureEntity> _measures = [];

  PlayerEntity({
    required this.name,
    required this.number,
    this.uuid,
    SensorEntity? sensor,
    VoidCallback? onSensorStatusUpdate,
  })  : _runningType = RunningType.onFoot,
        _sensor = sensor {
    if (onSensorStatusUpdate != null && _sensor != null) {
      _sensor!.addListener(() {
        onSensorStatusUpdate();
      });
    }

    uuid ??= const Uuid().v4();
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

  bool get hasSensor => _sensor != null;

  RunningType get runningType => _runningType;

  SensorEntity? get sensor => _sensor;

  int get distance => _measures.lastOrNull?.distance?.toInt() ?? 0;

  int get steps => _measures.lastOrNull?.steps ?? 0;

  int get pulse => _measures.lastOrNull?.hr ?? 0;

  List<(double x, double y, int speed)> get coordinates => _measures
      .map((m) => (m.latitude ?? 0, m.longitude ?? 0, m.speed?.toInt() ?? 0))
      .toList();

  List<int> get hrMeasures => _measures.map((m) => m.hr ?? 0).toList();

  List<MeasureEntity> get measures => _measures;

  /* Скорость в м/с */
  double get speedMps => _measures.lastOrNull?.speed ?? 0;

  /* Скорость в км/ч */
  double get speedKph => speedMps * 3600 / 1000;

  void setOnSensorStatusUpdate(VoidCallback callback) {
    if (_sensor != null) {
      _sensor!.addListener(callback);
    }
  }

  void addMeasure(MeasureEntity payload, [TagMeta? meta]) {
    _measures.add(payload);
    _sensor?.notify(meta);
    notifyListeners();
  }

  void notifySensor([TagMeta? meta]) {
    _sensor?.notify(meta);
    notifyListeners();
  }

  void setMeasures(Iterable<MeasureEntity> measures) {
    _measures.clear();
    _measures.addAll(measures);
  }
}

enum PlayerError { hrError, stationError, gpsError, otherError }

enum RunningType { onFoot, jogging, run, acceleration }
