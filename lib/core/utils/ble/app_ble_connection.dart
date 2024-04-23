import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data_decoder.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:typed_data/typed_buffers.dart';

class AppBLEConnection {
  // guid для конкретного поиска сервисов и хараетеристик
  final _serviceGuid = Guid("243a0000-1234-2374-5673-a8a1593ef645");
  final _charGuid = Guid("243a0003-1234-2374-5673-a8a1593ef645");

  final _decoder = InmotionTagDataDecoder();

  StreamSubscription<BluetoothAdapterState>? _bleStatusStream;

  StreamSubscription<List<ScanResult>>? _scanResultStream;

  /// Вызывается при начале работы для отслеживания статуса
  void listenBLEStatus(
    Function(BluetoothAdapterState state) onStatusUpdated,
  ) {
    _bleStatusStream = FlutterBluePlus.adapterState.listen(
      (BluetoothAdapterState state) {
        onStatusUpdated(state);
      },
    );
  }

  //TODO rename
  void writeToDevices(Iterable<BluetoothDevice> devices, Guid guid, List<int> data) async {
    for (final device in devices) {
      await device.connect();
      await device.connect();
      final service = (await device.discoverServices())
          .firstWhere((service) => service.serviceUuid == _serviceGuid);
      final char = service.characteristics
          .firstWhere((char) => char.characteristicUuid == guid);
      await char.write(data);
      await device.disconnect();
    }
  }

  void devicesStartRecording(Iterable<BluetoothDevice> devices) {
    writeToDevices(devices, _charGuid, [0x01]);
  }

  // void devicesStopRecording(Iterable<BluetoothDevice> devices) {
  //   writeToDevices(devices, _charGuid, [0x00]);
  // }

  /// Метод возвращает список [ScanResult] - адвертаиз пакеты уже с нужными сервисами [_serviceGuid]
  /// То есть конкретные нужные метки
  Future<void> startScanning(
    Future<void> Function(List<(BluetoothDevice, TagMeta, MeasureEntity)>)
        onReceivedScanResults,
  ) async {
    _scanResultStream = FlutterBluePlus.onScanResults.listen(
      (results) async {
        final mapped = results.map(
              (r) {
            final frame = r.advertisementData.serviceData[_serviceGuid]!;
            final (meta, payload) = _decoder.decodeFrame(frame);
            return (r.device, meta, payload);
          },
        ).toList();

        await onReceivedScanResults(mapped);
      },
      onError: (e) => log(e),
    );
    await FlutterBluePlus.startScan(
      withServiceData: [ServiceDataFilter(_serviceGuid)],
    );
  }

  Future<void> downloadDataFromPlayers(
    List<PlayerEntity> players, {
    required Function(PlayerEntity, List<MeasureEntity>) onPlayerDataDownload,
    Function(double)? onPercentUpdated,
    required Future<void> Function() onStop,
  }) async {
    var totalLength = 0;
    var downloaded = 0;
    final devices = players.length;
    var finishedDevices = 0;
    if (onPercentUpdated != null) onPercentUpdated(0);

    for (final player in players) {
      assert(player.hasSensor, 'Sensor is null');
      final device = player.sensor!.device;
      await device.connect();
      final service = (await device.discoverServices())
          .firstWhere((service) => service.serviceUuid == _serviceGuid);
      final payloadChar = service.characteristics
          .firstWhere((char) => char.characteristicUuid == _charGuid);

      List<int> value = await payloadChar.read();
      final byteData = ByteData.sublistView(Uint8List.fromList(value));
      final length = byteData.getInt32(0, Endian.little);
      totalLength += length;
    }

    for (final player in players) {
      final device = player.sensor!.device;
      //already connected
      //await device.connect();
      final service = (await device.discoverServices())
          .firstWhere((service) => service.serviceUuid == _serviceGuid);
      final payloadChar = service.characteristics
          .firstWhere((char) => char.characteristicUuid == _charGuid);
      await payloadChar.write([0x00]);

      final measureList = <MeasureEntity>[];
      StreamSubscription<List<int>>? charSubscription;
      final savedDataStreamController = StreamController<List<int>>();

      const CborDecoder().bind(savedDataStreamController.stream).listen(
        (value) async {
            Uint8Buffer object = value.toObject() as Uint8Buffer;
            final dataPayload = _decoder.decodePayload(object);
            measureList.add(dataPayload);
        },
        onDone: () async {
          await payloadChar.setNotifyValue(false);
          await charSubscription?.cancel();
          device.disconnect(queue: false);
          onPlayerDataDownload(player, measureList);

          finishedDevices++;
          if (finishedDevices == devices) {
            await onStop();
          }
        },
      );

      charSubscription = payloadChar.onValueReceived.listen(
        (payload) async {
          if (payload.isEmpty) {
            savedDataStreamController.close();
            return;
          }
          savedDataStreamController.sink.add(payload);
          downloaded += payload.length;
          final percent = downloaded / totalLength * 100;
          if (onPercentUpdated != null) {
            onPercentUpdated(percent);
          }
        },
      );
      await payloadChar.setNotifyValue(true);
    }
  }

  Future<void> dispose() async {
    await _bleStatusStream?.cancel();
    await _scanResultStream?.cancel();
  }
}
