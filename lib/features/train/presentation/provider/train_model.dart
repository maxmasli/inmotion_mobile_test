import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data_decoder.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/demo_resources.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainModel extends ChangeNotifier {
  final decoder = InmotionTagDataDecoder();

  // Status
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

  bool _isTrainStart = false;

  final _players = <PlayerEntity>[];

  final _selectedPlayers = <PlayerEntity>[];

  List<PlayerEntity> get players => _players;

  List<PlayerEntity> get selectedPlayers => _selectedPlayers;

  SystemStatus get systemStatus {
    /// Если в _selectedPlayers есть неподключенные, то SystemStatus.error
    if (_selectedPlayers
        .where((p) => p.sensor.status != SensorStatus.connected)
        .isNotEmpty) return SystemStatus.error;

    /// Если выбранных игроков нет и тренировка не идет то SystemStatus.off
    if (selectedPlayers.isEmpty && !_isTrainStart) return SystemStatus.off;

    if (selectedPlayers.isNotEmpty && !_isTrainStart) return SystemStatus.ready;

    if (_isTrainStart) return SystemStatus.rec;

    throw Exception("Unexcepted behavior of systemStatus");
  }

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
            //log(scanResult.device.advName);
            /// Девайс нашелся, но не добавлен
            if (!_players
                .map((p) => p.sensor.device)
                .contains(scanResult.device)) {
              _foundedDevices.add(scanResult.device);
              notifyListeners();
              return;
            }
            final player = _players
                .where((p) => p.sensor.device == scanResult.device)
                .first;

            final serviceGuid = scanResult.advertisementData.serviceUuids[0];
            final frame = scanResult.advertisementData.serviceData[serviceGuid];
            final (meta, payload) = decoder.decodeFrame(frame!);

            if (!_isTrainStart) {
              /// Если не идет запись
              player.notifySensor(meta);
            } else {
              /// Если идет запись
              player.addMeasure(payload, meta);
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

  void toggleSelectedPlayers(PlayerEntity player) {
    if (_selectedPlayers.contains(player)) {
      log("remove player from selected players");
      _selectedPlayers.remove(player);
    } else {
      log("add player to selected players");
      _selectedPlayers.add(player);
    }
    notifyListeners();
  }

  void saveDevice(BluetoothDevice device) {
    final player = PlayerEntity.fromDevice(
        device: device,
        onSensorStatusUpdate: () {
          /// Если статус датчика изменился, олключился или подключился, надо
          /// вызвать notifyListeners для пересчета полей модели
          notifyListeners();
        });

    _foundedDevices.remove(device);
    _players.add(player);
    _selectedPlayers.add(player);
    notifyListeners();
  }

  void startRecording() {
    _isTrainStart = true;
    assert(_trainStage == TrainStage.prepare,
        "TrainStage is not prepare. Can not start train");
    _trainStage = TrainStage.running;
    notifyListeners();
  }

  void stopRecording() {
    _isTrainStart = false;
    assert(_trainStage == TrainStage.running,
        "TrainStage is not running. Can not start train");
    _trainStage = TrainStage.end;
    notifyListeners();
  }

  Future<void> _checkPermissions() async {
    _hasAllPermissions = true;
    if (!(await Permission.bluetoothScan.request().isGranted)) {
      log("bluetoothScan no!!!");
      _hasAllPermissions = false;
      notifyListeners();
      return;
    }
    if (!(await Permission.bluetoothConnect.request().isGranted)) {
      _hasAllPermissions = false;
      notifyListeners();
      log("bluetoothConnect no!!!");
      return;
    }
    if (!(await Permission.location.request().isGranted)) {
      _hasAllPermissions = false;
      notifyListeners();
      log("location no!!!");
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

enum SystemStatus { off, ready, rec, error }

/// Для правильного показа этапа
enum TrainStage { prepare, running, end }
