import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data_decoder.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/demo_resources.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/gps_sensor_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/hr_sensor_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainModel extends ChangeNotifier {
  final decoder = InmotionTagDataDecoder();

  // Status
  var _systemStatus = SystemStatus.off;
  var _trainStage = TrainStage.prepare;

  // Repositories

  // Permissions
  var _hasAllPermissions = true;

  bool get hasAllPermissions => _hasAllPermissions;

  // BLE
  StreamSubscription<BluetoothAdapterState>? _bleStatusStream;
  StreamSubscription<List<ScanResult>>? _scanResultStream;
  BluetoothAdapterState? _bluetoothState;

  //TODO список игроков будет вместо девайсов
  final List<BluetoothDevice> _foundedDevices = [];

  bool get isBLEOn => _bluetoothState == BluetoothAdapterState.on;

  List<BluetoothDevice> get foundedDevices => _foundedDevices;

  // Model
  // TODO переделать/убрать
  final List<PlayerEntity> _players2 = demoPlayersList;

  // TODO переделать/убрать
  List<PlayerEntity> get players2 => _players2;

  List<PlayerEntity> get players => _players;

  final _players = <PlayerEntity>[];

  final _selectedPlayers = <PlayerEntity>[];

  SystemStatus get systemStatus => _systemStatus;

  TrainStage get trainStage => _trainStage;

  void _startScanning() async {
    await _checkPermissions();
    if (!_hasAllPermissions || !isBLEOn) return;

    // Для идентификации датчиков
    final guid = Guid("243a0000-1234-2374-5673-a8a1593ef645");

    // Метод работает всегда для прослушки имерений из adv пакетов
    _scanResultStream = FlutterBluePlus.onScanResults.listen(
      (results) {
        _foundedDevices.clear();
        for (final scanResult in results) {
          if (scanResult.advertisementData.serviceUuids.contains(guid)) {
            /// Девайс нашелся, но не добавлен
            if (!_players
                .map((p) => p.sensor?.device)
                .contains(scanResult.device)) {
              _foundedDevices.add(scanResult.device);
            } else if (_systemStatus == SystemStatus.rec) {
              /// Девайс добавлен, обновляем данные player если идет запись
              final player = _players
                  .where((p) => p.sensor?.device == scanResult.device)
                  .first;
              final serviceGuid = scanResult.advertisementData.serviceUuids[0];
              final frame =
                  scanResult.advertisementData.serviceData[serviceGuid];
              final (meta, payload) = decoder.decodeFrame(frame!);
              player.addMeasure(payload);
            }
            notifyListeners();
          }
        }
      },
      onError: (e) => log(e),
    );
    await FlutterBluePlus.startScan();
  }

  void init() {
    _startScanning();
    _bleStatusStream = FlutterBluePlus.adapterState.listen(
      (BluetoothAdapterState state) {
        _bluetoothState = state;
        notifyListeners();
        if (state == BluetoothAdapterState.on) {
          _startScanning();
        }
      },
    );
  }

  void saveDevice(BluetoothDevice device) {
    final player = PlayerEntity.fromDevice(device);
    _foundedDevices.remove(device);
    _players.add(player);
    notifyListeners();
  }

  void startRecording() {
    _systemStatus = SystemStatus.rec;
    notifyListeners();
  }

  void stopRecording() {
    _systemStatus = SystemStatus.off;
    notifyListeners();
  }

  // TODO убрать паузу
  void pauseRecording() {
    _systemStatus = SystemStatus.rec;
    notifyListeners();
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
    notifyListeners();
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
