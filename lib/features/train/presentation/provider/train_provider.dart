import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/demo_resources.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/gps_sensor_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/hr_sensor_repository.dart';

class TrainModel extends ChangeNotifier {
  var _systemStatus = SystemStatus.ready;
  var _trainStage = TrainStage.prepare;

  // Repositories
  final l = getIt<AppLogsController>();
  final _hrSensorRepository = getIt<HrSensorRepository>();
  final _gpsSensorRepository = getIt<GpsSensorRepository>();

  // BLE
  StreamSubscription<BluetoothAdapterState>? bleStatusStream;
  BluetoothAdapterState? _bluetoothState;

  bool get isBLEOn => _bluetoothState == BluetoothAdapterState.on;

  // Model
  final List<PlayerEntity> _players = demoPlayersList;

  List<PlayerEntity> get players => _players;

  SystemStatus get systemStatus => _systemStatus;

  TrainStage get trainStage => _trainStage;

  void init() {
    bleStatusStream = FlutterBluePlus.adapterState.listen(
      (BluetoothAdapterState state) {
        _bluetoothState = state;
        notifyListeners();
      },
    );
    // for (final player in _players) {
    //   final hrSensor = _hrSensorRepository.createSensor();
    //   final gpsSensor = _gpsSensorRepository.createSensor();
    //
    //   hrSensor.onMeasureReceive = (meas) {
    //     l.log(
    //       "HrMeasure received on ${player.name}, hr: ${meas.hr}",
    //       'HrSensor',
    //     );
    //   };
    //
    //   gpsSensor.onMeasureReceive = (meas) {
    //     l.log(
    //       "GpsMeasure received on ${player.name}, x: ${meas.x}, y: ${meas.y}",
    //       'GpsSensor',
    //     );
    //   };
    //
    //   player.hrSensor = hrSensor;
    //   player.gpsSensor = gpsSensor;
    //   l.log('HrSensor connected to player ${player.name}', 'MainModel');
    //   l.log('GpsSensor connected to player ${player.name}', 'MainModel');
    // }
  }

  void startRecording() {
    _systemStatus = SystemStatus.rec;
    notifyListeners();
    l.log("Start recording", "MainModel");
  }

  void stopRecording() {
    _systemStatus = SystemStatus.ready;
    notifyListeners();
    l.log("Stop recording", "MainModel");
  }

  void pauseRecording() {
    _systemStatus = SystemStatus.ready;
    notifyListeners();
    l.log("Pause recording", "MainModel");
  }

  @override
  void dispose() {
    bleStatusStream?.cancel();
    super.dispose();
  }
}

enum SystemStatus { off, ready, rec, error }

enum TrainStage { prepare, running, end }
