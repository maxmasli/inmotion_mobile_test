import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/core/utils/ble/app_ble_connection.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/create_excel_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/delete_trains_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/get_players_sensor_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/get_trains_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/save_player_sencor_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/save_train_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/update_train_usecase.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/sensor_entity.dart';

class TrainModel extends ChangeNotifier {
  // Status
  var _trainStage = TrainStage.prepare;

  TrainStage get trainStage => _trainStage;

  SystemStatus get systemStatus {
    /// Если тренировка начата
    if (_isTrainStart) return SystemStatus.rec;

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

    throw Exception("Unexpected behavior of systemStatus");
  }

  // Use cases
  final _saveTrainUseCase = getIt<SaveTrainUseCase>();

  final _getTrainsUseCase = getIt<GetTrainsUseCase>();

  final _savePlayerSensorUseCase = getIt<SavePlayerSensorUseCase>();

  final _getPlayersSensorUseCase = getIt<GetPlayersSensorUseCase>();

  final _updateTrainUseCase = getIt<UpdateTrainUseCase>();

  final _deleteTrainsUseCase = getIt<DeleteTrainsUseCase>();

  final _createExcelUseCase = getIt<CreateExcelUseCase>();

  // Permissions
  var _hasAllPermissions = true;

  bool get hasAllPermissions => _hasAllPermissions;

  // BLE
  final _appBLEConnection = AppBLEConnection();

  BluetoothAdapterState? _bluetoothState;

  var _foundedDevices = <BluetoothDevice>[];

  List<BluetoothDevice> get foundedDevices => _foundedDevices;

  bool get isBLEOn => _bluetoothState == BluetoothAdapterState.on;

  // Model
  double _loadingPercent = 0;

  bool _isTrainStart = false;

  var _players = <PlayerEntity>[];

  final _selectedPlayers = <PlayerEntity>[];

  var _trains = <TrainEntity>[];

  TrainEntity? _train;

  double get loadingPercent => _loadingPercent;

  List<PlayerEntity> get players => _players;

  List<PlayerEntity> get selectedPlayers => _selectedPlayers;

  TrainEntity? get train => _train;

  List<TrainEntity> get trains => _trains;

  Future<void> _startScanning() async {
    await _checkPermissions();
    if (!_hasAllPermissions || !isBLEOn) return;

    await _appBLEConnection.startScanning(
      (scanResults) async {
        _foundedDevices = [];
        for (final scanResult in scanResults) {
          final device = scanResult.$1;
          final meta = scanResult.$2;
          final payload = scanResult.$3;

          /// Если девайс еще не добавлен
          if (!_players.map((p) => p.sensor!.device).contains(device)) {
            _foundedDevices.add(device);
            notifyListeners();
            continue;
          }

          /// Девайс уже добавлен, достаем данные
          final player = _players.where((p) {
            assert(p.hasSensor, 'Sensor is null');
            return p.sensor!.device == device;
          }).first;

          //if (player == null) return;
          if (!_isTrainStart) {
            /// Если не идет запись
            player.notifySensor(payload, meta);
          } else {
            /// Если идет запись
            player.addMeasure(payload, meta);
          }
          notifyListeners();
        }
      },
    );
  }

  Future<void> _downloadDataFromDevices() async {
    log("Downloading data");
    await _appBLEConnection.downloadDataFromPlayers(
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
        for (final player in players) {
          player.clearMeasures();
        }
      },
    );
  }

  void init() async {
    /// Загрузка сохраненных игроков с датчиками
    _players = await _getPlayersSensorUseCase();
    for (final player in _players) {
      // устанавливаем слушатели на оновление статуса
      // player.setOnSensorStatusUpdate(() {
      //   notifyListeners();
      // });
      player.addListener(() {
        notifyListeners();
      });
    }
    notifyListeners();

    _appBLEConnection.listenBLEStatus((state) async {
      _bluetoothState = state;
      notifyListeners();
      if (state == BluetoothAdapterState.on) {
        await _startScanning();
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

  Future<void> saveDevice(BluetoothDevice device) async {
    final player = PlayerEntity.fromDevice(
      device: device,
    )..addListener(
        () {
          notifyListeners();
        },
      );

    _foundedDevices.remove(device);
    _players.add(player);
    _selectedPlayers.add(player);
    notifyListeners();
    await _savePlayerSensorUseCase(PlayersParams(player));
  }

  Future<void> updateCurrentTrainName(String name) async {
    assert(train != null, 'Current train is null');
    train!.trainName = name;
    await _updateTrainUseCase(TrainParams(train!));
  }

  Future<void> updateTrainName(TrainEntity train, String name) async {
    train.trainName = name;
    await _updateTrainUseCase(TrainParams(train));
  }

  Future<void> updateTrains() async {
    final updatesTrains = await _getTrainsUseCase();
    _trains = updatesTrains;
    _trains.sort((a, b) => a.startTime.compareTo(b.startTime));
    notifyListeners();
  }

  Future<void> deleteTrains(List<TrainEntity> trains) async {
    await _deleteTrainsUseCase(TrainsListParams(trains));
    await updateTrains();
    notifyListeners();
  }

  Future<void> updateSensorPlayer(PlayerEntity player, String name,
      String number, String deviceNumber) async {
    player.name = name;
    player.number = int.parse(number);
    player.sensor!.number = int.parse(deviceNumber);
    await _savePlayerSensorUseCase(PlayersParams(player));
    player.notifyListeners();
  }

  Future<String> createExcel(TrainEntity train) async {
    return await _createExcelUseCase(TrainParams(train));
  }

  void startRecording() {
    _isTrainStart = true;
    assert(_trainStage == TrainStage.prepare,
        "TrainStage is not prepare. Can not start train");
    _trainStage = TrainStage.running;
    _train = TrainEntity(
      startTime: DateTime.now(),
    );
    _appBLEConnection.devicesStartRecording(
        _selectedPlayers.map((e) => e.sensor?.device).nonNulls);
    notifyListeners();
  }

  void stopRecording() async {
    _isTrainStart = false;
    assert(_trainStage == TrainStage.running,
        "TrainStage is not running. Can not stop train");
    assert(_train != null, 'TrainEntity == null');
    _trainStage = TrainStage.end;
    _train!.endTime = DateTime.now();
    await _downloadDataFromDevices();
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
  void dispose() async {
    super.dispose();
    await _appBLEConnection.dispose();
  }
}

enum SystemStatus { off, ready, rec, error }

/// Для правильного показа этапа
enum TrainStage { prepare, running, end }
