import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/core/utils/ble/app_ble_connection.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/get_players_sensor_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/get_trains_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/save_player_sencor_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/save_train_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/update_train_usecase.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainModel extends ChangeNotifier {
  // Status
  var _trainStage = TrainStage.prepare;

  TrainStage get trainStage => _trainStage;

  SystemStatus get systemStatus {
    /// Если сейчас экран окончания тренировки, то SystemStatus.off
    if (_trainStage == TrainStage.end) return SystemStatus.off;

    /// Если в _selectedPlayers есть неподключенные, то SystemStatus.error
    /// При любых обстоятельствах, тренировка это или нет, если есть неподключенные датчики то ошибка
    if (_selectedPlayers
        .where((p) => p.sensor!.status != SensorStatus.connected)
        .isNotEmpty) return SystemStatus.error;

    /// Если выбранных игроков нет и тренировка не идет то SystemStatus.off
    if (selectedPlayers.isEmpty && !_isTrainStart) return SystemStatus.off;

    /// Если есть выбранные игроки, то тренировка не начата
    if (selectedPlayers.isNotEmpty && !_isTrainStart) return SystemStatus.ready;

    /// Если тренировка начата
    if (_isTrainStart) return SystemStatus.rec;

    throw Exception("Unexcepted behavior of systemStatus");
  }

  // Use cases
  final _saveTrainUseCase = getIt<SaveTrainUseCase>();

  final _getTrainsUseCase = getIt<GetTrainsUseCase>();

  final _savePlayerSensorUseCase = getIt<SavePlayerSensorUseCase>();

  final _getPlayersSensorUseCase = getIt<GetPlayersSensorUseCase>();

  final _updateTrainUseCase = getIt<UpdateTrainUseCase>();

  // Permissions
  var _hasAllPermissions = true;

  bool get hasAllPermissions => _hasAllPermissions;

  // BLE
  final _appBLEConnection = AppBLEConnection();

  BluetoothAdapterState? _bluetoothState;

  final List<BluetoothDevice> _foundedDevices = [];

  List<BluetoothDevice> get foundedDevices => _foundedDevices;

  bool get isBLEOn => _bluetoothState == BluetoothAdapterState.on;

  // Model
  double _loadingPercent = 0;

  bool _isTrainStart = false;

  // TODO сделать лист final, но с ним не обновляется список
  var _players = <PlayerEntity>[];

  final _selectedPlayers = <PlayerEntity>[];

  // TODO сделать лист final, но с ним не обновляется список
  var _trains = <TrainEntity>[];

  TrainEntity? _train;

  double get loadingPercent => _loadingPercent;

  List<PlayerEntity> get players => _players;

  List<PlayerEntity> get selectedPlayers => _selectedPlayers;

  TrainEntity? get train => _train;

  List<TrainEntity> get trains => _trains;

  void _startScanning() async {
    await _checkPermissions();
    if (!_hasAllPermissions || !isBLEOn) return;

    _appBLEConnection.startScanning(
      (scanResults) {
        _foundedDevices.clear();
        for (final scanResult in scanResults) {
          final device = scanResult.$1;
          final meta = scanResult.$2;
          final payload = scanResult.$3;

          /// Если девайс еще не добавлен
          if (!_players.map((p) => p.sensor!.device).contains(device)) {
            _foundedDevices.add(device);
            notifyListeners();
            return;
          }

          /// Девайс уже добавлен, достаем данные
          final player = _players.where((p) {
            assert(p.hasSensor, 'Sensor is null');
            return p.sensor!.device == device;
          }).first;

          if (!_isTrainStart) {
            /// Если не идет запись
            player.notifySensor(meta);
          } else {
            /// Если идет запись
            player.addMeasure(payload, meta);
          }
          notifyListeners();
        }
      },
    );
  }

  void _downloadDataFromDevices() async {
    log("Downloading data");
    _appBLEConnection.downloadDataFromPlayers(
      selectedPlayers,
      onPlayerDataDownload: (player, measures) {
        player.setMeasures(measures);
        train!.addPlayer(player);
      },
      onPercentUpdated: (percent) {
        _loadingPercent = percent;
        notifyListeners();
      },
      onStop: () async {
        await _saveTrainUseCase(TrainParams(train!));
      }
    );
  }

  void init() async {
    /// Загрузка сохраненных игроков с датчиками
    final savedSensorPlayers = await _getPlayersSensorUseCase();
    _players = savedSensorPlayers;
    print("Saved players: ${_players}");
    notifyListeners();

    _appBLEConnection.listenBLEStatus((state) {
      _bluetoothState = state;
      notifyListeners();
      if (state == BluetoothAdapterState.on) {
        _startScanning();
      }
    });
    await updateTrains();
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

  void saveDevice(BluetoothDevice device) async {
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
    await _savePlayerSensorUseCase(PlayersParams(player));
  }

  void updateCurrentTrainName(String name) async {
    assert(train != null, 'Current train is null');
    train!.trainName = name;
    await _updateTrainUseCase(TrainParams(train!));
  }

  Future<void> updateTrains() async {
    final updatesTrains = await _getTrainsUseCase();
    _trains = updatesTrains;
    _trains.sort((a, b) => a.startTime.compareTo(b.startTime));
    notifyListeners();
  }

  void startRecording() {
    _isTrainStart = true;
    assert(_trainStage == TrainStage.prepare,
        "TrainStage is not prepare. Can not start train");
    _trainStage = TrainStage.running;
    _train = TrainEntity(
      startTime: DateTime.now(),
    );
    //_appBLEConnection.writeToDevices(_selectedPlayers);
    notifyListeners();
  }

  void stopRecording() {
    _isTrainStart = false;
    assert(_trainStage == TrainStage.running,
        "TrainStage is not running. Can not stop train");
    assert(_train != null, 'TrainEntity == null');
    _trainStage = TrainStage.end;
    _train!.endTime = DateTime.now();
    _downloadDataFromDevices();
    notifyListeners();
  }

  void prepareRecording() async {
    assert(_trainStage == TrainStage.end,
        "TrainStage is not stop. Can not prepare train");
    _trainStage = TrainStage.prepare;
    notifyListeners();
    await updateTrains();
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
    _appBLEConnection.dispose();
    super.dispose();
  }
}

enum SystemStatus { off, ready, rec, error }

/// Для правильного показа этапа
enum TrainStage { prepare, running, end }
