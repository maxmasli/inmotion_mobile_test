import 'dart:typed_data';
import 'package:ieee754/ieee754.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:vector_math/vector_math_64.dart';

import 'tag_data.dart';

enum Fields {
  hr        (0x01, 1),
  time      (0x02, 8),
  location  (0x04, 8),
  speed     (0x08, 2),
  distance  (0x10, 2),
  steps     (0x20, 2),
  activity  (0x40, 1),
  imu       (0x80, 1);

  const Fields(this.flag, this.size);
  final int flag;
  final int size;
}

class InmotionTagDataDecoder {

  static final int metaDataLength = 5;

  // В данный декодер помещаем те пакеты, которые приходят от Advertise сообщений по BLE
  // И, видимо в будущем сообщения которые будут приходить через LPS
  (TagMeta, MeasureEntity) decodeFrame(List<int> frameData) {

    final buf = Uint8Buffer()..addAll(frameData);

    final blob = buf.buffer.asByteData(0, metaDataLength);

    final meta = TagMeta(
        blob.getUint8(0),
        blob.getUint8(1),
        blob.getUint8(2),
        blob.getUint8(3),
        blob.getUint8(4)
    );

    return (meta, decodePayload(buf, metaDataLength));
  }


  // В данный декодер напрявляются данные payload. Они содержатся в части Advertise сообщения
  // Или выходят при потоковом декодировнии данных со флэш накопителя
  MeasureEntity decodePayload(Uint8Buffer payload, [int position = 0]) {

    int flags = payload[position++];

    final result = MeasureEntity();

    if (_checkFlag(flags, Fields.hr)) {
      final blob = payload.buffer.asByteData(position, Fields.hr.size);
      position += Fields.hr.size;

      result.hr = blob.getUint8(0);
    }

    if (_checkFlag(flags, Fields.time)) {
      final blob = payload.buffer.asByteData(position, Fields.time.size);
      position += Fields.time.size;

      int hour = blob.getUint8(0);
      int minute = blob.getUint8(1);
      int milliseconds = blob.getUint16(2, Endian.little);
      int seconds = milliseconds ~/ 1000;
      milliseconds = milliseconds % 1000;

      int day = blob.getUint8(4);
      int month = blob.getUint8(5);
      int year = 2000 + blob.getUint8(6);

      result.time = DateTime.utc(year, month, day, hour, minute, seconds, milliseconds);
    }

    if (_checkFlag(flags, Fields.location)) {
      final blob = payload.buffer.asByteData(position, Fields.location.size);
      position += Fields.location.size;

      final latitude  = blob.getInt32(0, Endian.little);
      final longitude = blob.getInt32(4, Endian.little);

      const int fraction = 10000000;

      result.latitude  = latitude  ~/ fraction + (latitude  % fraction) / fraction;
      result.longitude = longitude ~/ fraction + (longitude % fraction) / fraction;
    }

    if (_checkFlag(flags, Fields.speed)) {
      final blob = payload.buffer.asByteData(position, Fields.speed.size);
      position += Fields.speed.size;

      result.speed = blob.getUint16(0, Endian.little) / 1000;
    }

    if (_checkFlag(flags, Fields.distance)) {
      final blob = payload.buffer.asByteData(position, Fields.distance.size);
      position += Fields.distance.size;

      result.distance = blob.getUint16(0, Endian.little).toDouble();
    }

    if (_checkFlag(flags, Fields.steps)) {
      final blob = payload.buffer.asByteData(position, Fields.steps.size);
      position += Fields.steps.size;

      result.steps = blob.getUint16(0, Endian.little);
    }

    if (_checkFlag(flags, Fields.activity)) {
      final blob = payload.buffer.asByteData(position, Fields.activity.size);
      position += Fields.activity.size;

      result.activity = blob.getUint8(0);
    }

    if (_checkFlag(flags, Fields.imu)) {
      final blob = payload.buffer.asByteData(position, Fields.imu.size);
      position += Fields.imu.size;

      int imuFlag = blob.getUint8(0);

      int count = imuFlag & 0x1F;

      result.imu = [];

      final lst = payload.buffer.asUint8List();

      for (int i = 0; i < count; i++) {

        IMU imu = IMU();

        if (imuFlag & 0x80 != 0) {
          // Нужно обязательно создавать sublist, иначе конвертер не работает

          imu.q = Vector4(
              FloatParts.fromFloat16Bytes(lst.sublist(position + 0, position + 2), Endian.little).toDouble(),
              FloatParts.fromFloat16Bytes(lst.sublist(position + 2, position + 4), Endian.little).toDouble(),
              FloatParts.fromFloat16Bytes(lst.sublist(position + 4, position + 6), Endian.little).toDouble(),
              FloatParts.fromFloat16Bytes(lst.sublist(position + 6, position + 8), Endian.little).toDouble()
          );

          position += 8;
        }

        if (imuFlag & 0x40 != 0) {
          imu.g = Vector3(
              FloatParts.fromFloat16Bytes(lst.sublist(position + 0, position + 2), Endian.little).toDouble(),
              FloatParts.fromFloat16Bytes(lst.sublist(position + 2, position + 4), Endian.little).toDouble(),
              FloatParts.fromFloat16Bytes(lst.sublist(position + 4, position + 6), Endian.little).toDouble()
          );

          position += 6;
        }

        if (imuFlag & 0x20 != 0) {
          imu.m = Vector3(
              FloatParts.fromFloat16Bytes(lst.sublist(position + 0, position + 2), Endian.little).toDouble(),
              FloatParts.fromFloat16Bytes(lst.sublist(position + 2, position + 4), Endian.little).toDouble(),
              FloatParts.fromFloat16Bytes(lst.sublist(position + 4, position + 6), Endian.little).toDouble()
          );

          position += 6;
        }

        imu.a = Vector3(
            FloatParts.fromFloat16Bytes(lst.sublist(position + 0, position + 2), Endian.little).toDouble(),
            FloatParts.fromFloat16Bytes(lst.sublist(position + 2, position + 4), Endian.little).toDouble(),
            FloatParts.fromFloat16Bytes(lst.sublist(position + 4, position + 6), Endian.little).toDouble()
        );

        position += 6;

        result.imu!.add(imu);
      }
    }

    if (payload.length != position) {
      throw FormatException("Readed bytes ($position) not equal presented length (${payload.length})");
    }

    return result;
  }

  static bool _checkFlag(int value, Fields field) => value & field.flag != 0;
}