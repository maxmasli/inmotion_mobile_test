import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data_decoder.dart';
import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:typed_data/typed_buffers.dart';

class AppBLEConnection {
  // guid для конкретного поиска сервисов и хараетеристик
  final _serviceGuid = Guid("243a0000-1234-2374-5673-a8a1593ef645");
  final _charGuid = Guid("243a0003-1234-2374-5673-a8a1593ef645");

  final _decoder = InmotionTagDataDecoder();

  StreamSubscription<BluetoothAdapterState>? _bleStatusStream;

  StreamSubscription<List<ScanResult>>? _scanResultStream;

  StreamController<List<int>>? _savedDataStreamController;

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

  /// Метод возвращает список [ScanResult] - адвертаиз пакеты уже с нужными сервисами [_serviceGuid]
  /// То есть конкретные нужные метки
  void startScanning(
      Function(List<(BluetoothDevice, TagMeta, MeasureEntity)> scanResults)
          onReceivedScanResults) async {
    _scanResultStream = FlutterBluePlus.onScanResults.listen(
      (results) {
        onReceivedScanResults(
          results.map(
            (r) {
              final serviceGuid = r.advertisementData.serviceUuids[0];
              final frame = r.advertisementData.serviceData[serviceGuid]!;
              final (meta, payload) = _decoder.decodeFrame(frame);
              return (r.device, meta, payload);
            },
          ).toList(),
        );
      },
      onError: (e) => log(e),
    );
    await FlutterBluePlus.startScan(
      withServiceData: [ServiceDataFilter(_serviceGuid)],
    );
  }

  void downloadDataFromPlayers(
    List<PlayerEntity> players,
    Function(PlayerEntity, List<MeasureEntity>) onPlayerDataDownload, [
    Function(double)? onPercentUpdated,
  ]) async {
    var totalLength = 0;
    var downloaded = 0;
    if (onPercentUpdated != null) onPercentUpdated(0);

    for (final player in players) {
      final device = player.sensor.device;
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
      final device = player.sensor.device;
      //already connected
      //await device.connect();
      final service = (await device.discoverServices())
          .firstWhere((service) => service.serviceUuid == _serviceGuid);
      final payloadChar = service.characteristics
          .firstWhere((char) => char.characteristicUuid == _charGuid);

      payloadChar.setNotifyValue(true);

      final measureList = <MeasureEntity>[];
      StreamSubscription<List<int>>? charSubscription;
      _savedDataStreamController = StreamController();

      const CborDecoder().bind(_savedDataStreamController!.stream).listen(
        (value) {
          Uint8Buffer object = value.toObject() as Uint8Buffer;
          final dataPayload = _decoder.decodePayload(object);
          measureList.add(dataPayload);
          downloaded += 1;
          if (onPercentUpdated != null) {
            onPercentUpdated(downloaded / totalLength * 100);
          }
        },
        onDone: () async {
          await payloadChar.setNotifyValue(false);
          charSubscription?.cancel();
          await device.disconnect();

          onPlayerDataDownload(player, measureList);
        },
      );

      charSubscription = payloadChar.onValueReceived.listen(
        (payload) async {
          if (payload.isEmpty) {
            _savedDataStreamController?.close();
            return;
          }
          _savedDataStreamController?.sink.add(payload);
        },
      );
    }
  }

  void dispose() async {
    await _bleStatusStream?.cancel();
    await _scanResultStream?.cancel();
    await _savedDataStreamController?.close();
  }
}
