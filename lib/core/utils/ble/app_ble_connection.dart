import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_payload.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:path_provider/path_provider.dart';

class AppBLEConnection {
  // guid для конкретного поиска сервисов и хараетеристик
  final _serviceGuid = Guid("243a0000-1234-2374-5673-a8a1593ef645");
  final _cmdGuid = Guid("243a0002-1234-2374-5673-a8a1593ef645");
  final _payloadGuid = Guid("243a0003-1234-2374-5673-a8a1593ef645");

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
    try {
      for (final device in devices) {
        await device.connect();
        final service = (await device.discoverServices())
            .firstWhere((service) => service.serviceUuid == _serviceGuid);
        final char = service.characteristics
            .firstWhere((char) => char.characteristicUuid == guid);
        await char.write(data);
        await device.disconnect();
      }
    } catch (ex) {

    }
  }

  void devicesStartRecording(Iterable<BluetoothDevice> devices) {
    log(devices.toString());
    writeToDevices(devices, _cmdGuid, [0x01]);
  }

  // void devicesStopRecording(Iterable<BluetoothDevice> devices) {
  //   writeToDevices(devices, _charGuid, [0x00]);
  // }

  /// Метод возвращает список [ScanResult] - адвертаиз пакеты уже с нужными сервисами [_serviceGuid]
  /// То есть конкретные нужные метки
  Future<void> startScanning(
    Future<void> Function(List<(BluetoothDevice, InmotionTagMeta, MeasureEntity)>)
        onReceivedScanResults,
  ) async {
    _scanResultStream = FlutterBluePlus.scanResults.listen(
      (results) async {
        final mapped = results.map(
              (r) {
            final frame = r.advertisementData.serviceData[_serviceGuid]!;
            final (meta, payload) = InmotionTagPayload.decodeFrame(frame);
            final measureEntity = MeasureEntity(
              time: payload.time,
              hr: payload.hr,
              latitude: payload.lat,
              longitude: payload.lon,
              speed: payload.speed,
              distance: payload.distance?.toDouble(),
            );
            return (r.device, meta, measureEntity);
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
    var totalDownloaded = 0;

    onPercentUpdated?.call(0);

    for (final player in players) {
      assert(player.hasSensor, 'Sensor is null');

      final device = player.sensor!.device;
      await device.connect();

      final service = (await device.discoverServices())
          .firstWhere((service) => service.serviceUuid == _serviceGuid);
      final cmdChar = service.characteristics
          .firstWhere((char) => char.characteristicUuid == _cmdGuid);
      final payloadChar = service.characteristics
          .firstWhere((char) => char.characteristicUuid == _payloadGuid);
      
      await cmdChar.write([0x00]);

      List<int> value = await payloadChar.read();
      final byteData = ByteData.sublistView(Uint8List.fromList(value));
      final expectedPayloadLength = byteData.getInt32(0, Endian.little);
      totalLength += expectedPayloadLength;

      BytesBuilder payload = BytesBuilder();

      Future<void> finishDownload() async {
        if (expectedPayloadLength == payload.length) {
          final decodedPayload = InmotionTagPayload.fromRaw(payload.toBytes());

          final measureList = <MeasureEntity>[];

          for (final tagData in decodedPayload.data) {
            measureList.add(
                MeasureEntity(
                  time: tagData.time,
                  hr: tagData.hr,
                  latitude: tagData.lat,
                  longitude: tagData.lon,
                  speed: tagData.speed,
                  distance: tagData.distance?.toDouble(),
                )
            );
          }

          onPlayerDataDownload(player, measureList);

          try {
            final uuid = decodedPayload.uuid;
            final bytes = payload.toBytes();

            final dir = await getApplicationDocumentsDirectory();
            final filePath = '${dir.path}/$uuid.bin';
            final file = File(filePath);

            await file.writeAsBytes(bytes);
            log('Файл сохранён: $filePath');
          } catch (e) {
            log('Ошибка при сохранении файла: $e');
          }

        } else {
          log('Sizes not equal');
        }
      }

      late final StreamSubscription<List<int>> charSubscription;
      charSubscription = payloadChar.onValueReceived.listen(
        (data) async {
          if (data.isEmpty) {
            log("Expected[$expectedPayloadLength], donwload[${payload.length}]");
            await payloadChar.setNotifyValue(false);
            await charSubscription.cancel();
            device.disconnect(queue: false);
            await finishDownload();
          } else {
            payload.add(data);

            totalDownloaded += data.length;
            final percent = totalDownloaded / totalLength * 100;
            onPercentUpdated?.call(percent);
          }
        },
        onDone: () async {
          await finishDownload();
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
