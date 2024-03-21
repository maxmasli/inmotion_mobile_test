import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data_decoder.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/demo_resources.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:typed_data/typed_buffers.dart';

class TrainModel extends ChangeNotifier {
  final decoder = InmotionTagDataDecoder();

  // Status
  var _trainStage = TrainStage.prepare;

  TrainStage get trainStage => _trainStage;

  SystemStatus get systemStatus {
    /// Если сейчас экран окончания тренировки, то SystemStatus.off
    if (_trainStage == TrainStage.end) return SystemStatus.off;

    /// Если в _selectedPlayers есть неподключенные, то SystemStatus.error
    /// При любых обстоятельствах, тренировка это или нет, если есть неподключенные датчики то ошибка
    if (_selectedPlayers
        .where((p) => p.sensor.status != SensorStatus.connected)
        .isNotEmpty) return SystemStatus.error;

    /// Если выбранных игроков нет и тренировка не идет то SystemStatus.off
    if (selectedPlayers.isEmpty && !_isTrainStart) return SystemStatus.off;

    /// Если есть выбранные игроки, то тренировка не начата
    if (selectedPlayers.isNotEmpty && !_isTrainStart) return SystemStatus.ready;

    /// Если тренировка начата
    if (_isTrainStart) return SystemStatus.rec;

    throw Exception("Unexcepted behavior of systemStatus");
  }

  // Repositories

  // Permissions
  var _hasAllPermissions = true;

  bool get hasAllPermissions => _hasAllPermissions;

  // BLE
  StreamSubscription<BluetoothAdapterState>? _bleStatusStream;
  StreamSubscription<List<ScanResult>>? _scanResultStream;
  BluetoothAdapterState? _bluetoothState;

  final List<BluetoothDevice> _foundedDevices = [];

  List<BluetoothDevice> get foundedDevices => _foundedDevices;

  bool get isBLEOn => _bluetoothState == BluetoothAdapterState.on;

  // Model
  double _loadingPercent = 0;

  bool _isTrainStart = false;

  final _players = <PlayerEntity>[];

  final _selectedPlayers = <PlayerEntity>[];

  double get loadingPercent => _loadingPercent;

  List<PlayerEntity> get players => _players;

  List<PlayerEntity> get selectedPlayers => _selectedPlayers;

  void _startScanning() async {
    await _checkPermissions();
    if (!_hasAllPermissions || !isBLEOn) return;

    /// Для идентификации датчиков
    /// Все датчики будут иметь этот Guid
    final serviceGuid = Guid("243a0000-1234-2374-5673-a8a1593ef645");

    /// Поток работает всегда для прослушки имерений из adv пакетов
    _scanResultStream = FlutterBluePlus.onScanResults.listen(
      (results) {
        _foundedDevices.clear();
        for (final scanResult in results) {
          if (scanResult.advertisementData.serviceUuids.contains(serviceGuid)) {
            /// Девайс нашелся, но не добавлен
            if (!_players
                .map((p) => p.sensor.device)
                .contains(scanResult.device)) {
              _foundedDevices.add(scanResult.device);
              notifyListeners();
              return;
            }

            /// Девайс уже добавлен, достаем данные
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
        "TrainStage is not running. Can not stop train");
    _trainStage = TrainStage.end;
    _downloadDataFromDevices();
    notifyListeners();
  }

  void prepareRecording() {
    assert(_trainStage == TrainStage.end,
        "TrainStage is not stop. Can not prepare train");
    _trainStage = TrainStage.prepare;
    _startScanning();
    notifyListeners();
  }

  void _downloadDataFromDevices() async {
    log("start downloading");
    _loadingPercent = 0;
    notifyListeners();
    // read char to get payload count
    // char with uuid 243a0000-1234-2374-5673-a8a1593ef645
    final serviceGuid = Guid("243a0000-1234-2374-5673-a8a1593ef645");
    final charGuid = Guid("243a0003-1234-2374-5673-a8a1593ef645");

    var totalLength = 0;
    var downloaded = 0;

    for (final player in selectedPlayers) {
      final device = player.sensor.device;
      await device.connect();
      final service = (await device.discoverServices())
          .firstWhere((service) => service.serviceUuid == serviceGuid);
      final payloadChar = service.characteristics
          .firstWhere((char) => char.characteristicUuid == charGuid);

      List<int> value = await payloadChar.read();
      final byteData = ByteData.sublistView(Uint8List.fromList(value));
      final length = byteData.getInt32(0, Endian.little);
      totalLength += length;
    }

    log("total length: ${totalLength}");

    for (final player in selectedPlayers) {
      final device = player.sensor.device;
      //already connected
      //await device.connect();
      final service = (await device.discoverServices())
          .firstWhere((service) => service.serviceUuid == serviceGuid);
      final payloadChar = service.characteristics
          .firstWhere((char) => char.characteristicUuid == charGuid);

      payloadChar.setNotifyValue(true);

      final measureList = <MeasureEntity>[];
      StreamSubscription<List<int>>? charSubscription;
      final StreamController<List<int>> savedDataStreamController =
          StreamController();

      CborDecoder().bind(savedDataStreamController.stream).listen(
        (value) {
          Uint8Buffer object = value.toObject() as Uint8Buffer;
          final dataPayload = decoder.decodePayload(object);
          measureList.add(dataPayload);
          downloaded += 1;
          _loadingPercent = downloaded / totalLength * 100;
          notifyListeners();
        },
        onDone: () async {
          await payloadChar.setNotifyValue(false);
          charSubscription?.cancel();
          await device.disconnect();
          // for (final data in measureList) {
          //   log(data.toString());
          // }
        },
      );

      charSubscription = payloadChar.onValueReceived.listen(
        (payload) async {
          if (payload.isEmpty) {
            savedDataStreamController.close();
            return;
          }
          savedDataStreamController.sink.add(payload);
        },
        onDone: () {
          print("charSubscription DONE!");
        },
      );
    }
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
