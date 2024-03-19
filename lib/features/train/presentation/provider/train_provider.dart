import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/demo_resources.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/gps_sensor_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/hr_sensor_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainModel extends ChangeNotifier {
  // Status
  var _systemStatus = SystemStatus.off;
  var _trainStage = TrainStage.prepare;

  // Repositories
  final l = getIt<AppLogsController>();
  final _hrSensorRepository = getIt<HrSensorRepository>();
  final _gpsSensorRepository = getIt<GpsSensorRepository>();

  // Permissions
  var _hasAllPermissions = true;

  bool get hasAllPermissions => _hasAllPermissions;

  // BLE
  StreamSubscription<BluetoothAdapterState>? _bleStatusStream;
  StreamSubscription<List<ScanResult>>? _scanResultStream;
  BluetoothAdapterState? _bluetoothState;
  final List<BluetoothDevice> _devices = [];

  bool get isBLEOn => _bluetoothState == BluetoothAdapterState.on;

  List<BluetoothDevice> get devices => _devices;

  // Model
  final List<PlayerEntity> _players = demoPlayersList;

  List<PlayerEntity> get players => _players;

  SystemStatus get systemStatus => _systemStatus;

  TrainStage get trainStage => _trainStage;

  void _startScanning() async {
    await _checkPermissions();
    if (!_hasAllPermissions) return;

    // TODO надо будет както различать датчики
    const guid = "243a0000-1234-2374-5673-a8a1593ef645";
    _scanResultStream = FlutterBluePlus.onScanResults.listen(
      (results) {
        _devices.clear();
        print("--------------------");
        for (final scanResult in results) {
          if (scanResult.advertisementData.serviceUuids.contains(Guid(guid))) {
            print(scanResult.advertisementData.advName);
            // TODO вызывать метод createPlayerFromDevice
            // TODO каждый найденый девайс преобразовывается в типа игрока с сенсором
            _devices.add(scanResult.device);
            notifyListeners();
          }
        }
      },
      onError: (e) => print(e),
    );

    await FlutterBluePlus.startScan();
  }

  void init() {
    _bleStatusStream = FlutterBluePlus.adapterState.listen(
      (BluetoothAdapterState state) {
        _bluetoothState = state;
        notifyListeners();
        if (state == BluetoothAdapterState.on) {
          _startScanning();
        }
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

  // TODO сделать метод
  void createPlayerFromDevice() {

  }

  void startRecording() {
    _systemStatus = SystemStatus.rec;
    notifyListeners();
    l.log("Start recording", "MainModel");
  }

  void stopRecording() {
    _systemStatus = SystemStatus.off;
    notifyListeners();
    l.log("Stop recording", "MainModel");
  }

  void pauseRecording() {
    _systemStatus = SystemStatus.rec;
    notifyListeners();
    l.log("Pause recording", "MainModel");
  }

  Future<void> _checkPermissions() async {
    _hasAllPermissions = true;
    if (!(await Permission.bluetoothScan.request().isGranted)) {
      print("bluetoothScan no!!!");
      _hasAllPermissions = false;
      notifyListeners();
      return;
    }
    if (!(await Permission.bluetoothConnect.request().isGranted)) {
      _hasAllPermissions = false;
      notifyListeners();
      print("bluetoothConnect no!!!");
      return;
    }
    if (!(await Permission.location.request().isGranted)) {
      _hasAllPermissions = false;
      notifyListeners();
      print("location no!!!");
      return;
    }
  }

  @override
  void dispose() {
    _bleStatusStream?.cancel();
    _scanResultStream?.cancel();
    super.dispose();
  }
}

enum SystemStatus { off, rec, error }

enum TrainStage { prepare, running, end }
