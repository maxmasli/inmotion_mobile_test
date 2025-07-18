import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:crclib/catalog.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:vector_math/vector_math.dart';

import 'inmotion_tag_data.dart';

enum Fields {
  hr        (0x01, 1),
  time      (0x02, 8),
  location  (0x04, 20),
  speed     (0x08, 2),
  distance  (0x10, 2),
  steps     (0x20, 2),
  activity  (0x40, 1),
  imu       (0x80, 6);

  const Fields(this.flag, this.size);
  final int flag;
  final int size;
}


class InmotionTagPayload {

  static const int _metaLength = 5;
  static const int _headerMaxSize = 512;

  Uint8List rawPayload;

  final dataLoadComplete = Completer<void>();
  final _data = <InmotionTagData>[];

  String hwId;
  String uuid;

  InmotionTagPayload({
    required this.hwId,
    required this.uuid,
    required this.rawPayload,
  });


  factory InmotionTagPayload.fromRaw(Uint8List rawPayload, {bool loadData = false}) {

    if (!isCrcOk(rawPayload)) {
      throw 'Binary payload is corrupted';
    }

    final headerDivider = rawPayload.indexOf(0x00);
    if ( (headerDivider < 0) || (headerDivider > _headerMaxSize) ) {
      throw 'Binary payload bad header';
    }

    final header = utf8.decode(Uint8List.view(rawPayload.buffer, 0, headerDivider));

    print(header);
    final jsonHeader = jsonDecode(header);

    final instance = InmotionTagPayload(
      hwId: jsonHeader['hw_id'],
      uuid: jsonHeader['uuid'],
      rawPayload: rawPayload,
    );

    instance._load();

    return instance;
  }

  List<InmotionTagData> get data => _data;
  

  void _load() {
    int offset = rawPayload.indexOf(0x00) + 1;

    while(offset + 1 < rawPayload.length - 4) {
      if (rawPayload[offset] != 0x58) {
        print('Error on offset $offset');
      }

      int len = rawPayload[offset + 1];
      int chunkSise = len + 2;

      final sublist = rawPayload.sublist(offset + 2, offset + 2 + len);
      final decoded = decode(sublist);
      _data.add(decoded);

      offset = offset + chunkSise;
    }

    dataLoadComplete.complete();
  }


  static bool isCrcOk(Uint8List rawPayload) {
    // ignore: unrelated_type_equality_checks
    return Crc32().convert(rawPayload) == 0x2144df1c;
  }


  // В данный декодер помещаем те пакеты, которые приходят от Advertise сообщений по BLE
  // И, видимо в будущем сообщения которые будут приходить через LPS
  static (InmotionTagMeta, InmotionTagData) decodeFrame(List<int> frameData) {

    final buf = Uint8Buffer()..addAll(frameData);

    final blob = buf.buffer.asByteData(0, _metaLength);

    final meta = InmotionTagMeta(
      blob.getUint8(0),
      blob.getUint8(1),
      blob.getUint8(2),
      blob.getUint8(3),
      blob.getUint8(4)
    );

    return (meta, decode(buf.buffer.asUint8List(), _metaLength));
  }


  // В данный декодер напрявляются данные payload. Они содержатся в части Advertise сообщения
  // Или выходят при потоковом декодировнии данных со флэш накопителя
  static InmotionTagData decode(Uint8List payload, [int offset = 0]) {
    
    final buffer = payload.buffer;

    int flags = payload[offset++]; 

    DateTime? time;
    int? hr;

    double? lat, lon, alt;

    double? speed;
    int? distance;
    
    int? steps;
    int? activity;

    IMU? imu;


    if (_checkFlag(flags, Fields.hr)) {
      final blob = buffer.asByteData(offset, Fields.hr.size);
      offset += Fields.hr.size;

      hr = blob.getUint8(0);
    }

    if (_checkFlag(flags, Fields.time)) {
      final blob = buffer.asByteData(offset, Fields.time.size);
      offset += Fields.time.size;

      int hour = blob.getUint8(0);
      int minute = blob.getUint8(1);
      int milliseconds = blob.getUint16(2, Endian.little);
      int seconds = milliseconds ~/ 1000;
      milliseconds = milliseconds % 1000;

      int day = blob.getUint8(4);
      int month = blob.getUint8(5);
      int year = 2000 + blob.getUint8(6);

      time = DateTime.utc(year, month, day, hour, minute, seconds, milliseconds);
    }

    if (_checkFlag(flags, Fields.location)) {
      final blob = buffer.asByteData(offset, Fields.location.size);
      offset += Fields.location.size;

      lat = blob.getInt64(0, Endian.little) / 1.0E9;
      lon = blob.getInt64(8, Endian.little) / 1.0E9;
      alt = blob.getInt32(16, Endian.little) / 1.0E3;
    }

    if (_checkFlag(flags, Fields.speed)) {
      final blob = buffer.asByteData(offset, Fields.speed.size);
      offset += Fields.speed.size;

      speed = blob.getUint16(0, Endian.little) / 1.0E3;
    }

    if (_checkFlag(flags, Fields.distance)) {
      final blob = buffer.asByteData(offset, Fields.distance.size);
      offset += Fields.distance.size;

      distance = blob.getUint16(0, Endian.little);
    }

    if (_checkFlag(flags, Fields.steps)) {
      final blob = buffer.asByteData(offset, Fields.steps.size);
      offset += Fields.steps.size;

      steps = blob.getUint16(0, Endian.little);
    }

    if (_checkFlag(flags, Fields.activity)) {
      final blob = buffer.asByteData(offset, Fields.activity.size);
      offset += Fields.activity.size;

      activity = blob.getUint8(0);
    }

    if (_checkFlag(flags, Fields.imu)) {
      final blob = buffer.asByteData(offset);

        Vector3? a;
        Vector4? q;
        Vector3? g;
        Vector3? m;

        a = Vector3(
          blob.getInt16(0, Endian.little).toDouble() / 100,
          blob.getInt16(2, Endian.little).toDouble() / 100,
          blob.getInt16(4, Endian.little).toDouble() / 100
        );

        if (blob.lengthInBytes >= 14) {
          q = Vector4(
            blob.getInt16(0, Endian.little).toDouble() / 0x7FFF,
            blob.getInt16(2, Endian.little).toDouble() / 0x7FFF,
            blob.getInt16(4, Endian.little).toDouble() / 0x7FFF,
            blob.getInt16(6, Endian.little).toDouble() / 0x7FFF
          );
        }

        if (blob.lengthInBytes >= 20) {
          g = Vector3(
            blob.getInt16(0, Endian.little).toDouble() / 100,
            blob.getInt16(2, Endian.little).toDouble() / 100,
            blob.getInt16(4, Endian.little).toDouble() / 100
          );
        }

        if (blob.lengthInBytes >= 26) {
          m = Vector3(
            blob.getInt16(0, Endian.little).toDouble() / 100,
            blob.getInt16(2, Endian.little).toDouble() / 100,
            blob.getInt16(4, Endian.little).toDouble() / 100
          );
        }

        imu = IMU(a: a, q: q, g: g, m: m);
    }

    // if (payload.length != position) {
    //   throw FormatException("Readed bytes ($position) not equal presented length (${payload.length})");
    // }

    return InmotionTagData(
      time: time,
      hr: hr,
      lat: lat,
      lon: lon,
      alt: alt,
      speed: speed,
      distance: distance,
      steps: steps,
      activity: activity,
      imu: imu
    );
  }

  static Uint8Buffer encode(InmotionTagData payload) {

    final (size, flag) = calculateExpectedSize(payload);
    Uint8Buffer buf = Uint8Buffer(size);

    assert(size != 0);

    final data = buf.buffer.asByteData();
    int offset = 0;

    print("Expected size of payload: ${buf.length}");

    data.setUint8(offset, flag);
    offset += 1;

    if (payload.hr != null) {
      data.setUint8(offset, payload.hr!);
      offset += Fields.hr.size;
    }

    if (payload.time != null) {
      data.setUint8(offset + 0, payload.time!.hour);
      data.setUint8(offset + 1, payload.time!.minute);
      data.setUint16(offset + 2, 60 * payload.time!.second + payload.time!.millisecond, Endian.little);

      data.setUint8(offset + 4, payload.time!.day);
      data.setUint8(offset + 5, payload.time!.month);
      data.setUint8(offset + 6, 2000 - payload.time!.year);

      offset += Fields.time.size;
    }

    if (payload.lat != null) {
      data.setInt32(offset + 0, (payload.lat! * 1.0E9).toInt(), Endian.little);
      data.setInt32(offset + 4, (payload.lon! * 1.0E9).toInt(), Endian.little);

      offset += Fields.location.size;
    }

    if (payload.speed != null) {
      data.setUint16(offset, (payload.speed! * 1.0E3).toInt());
      
      offset += Fields.speed.size;
    }

    if (payload.distance != null) {
      data.setUint16(offset, (payload.distance!).toInt());

      offset += Fields.distance.size;
    }

    if (payload.steps != null) {
      data.setUint16(offset, (payload.steps!).toInt());

      offset += Fields.steps.size;
    }

    if (payload.activity != null) {
      data.setUint8(offset, payload.activity!);

      offset += Fields.activity.size;
    }

    return buf;
  }

  static (int, int) calculateExpectedSize(InmotionTagData payload) {
    int size = 1; // flag_size
    int flag = 0;

    if (payload.hr != null)   {
      size += Fields.hr.size;
      flag |= Fields.hr.flag;
    }

    if (payload.time != null) {
      size += Fields.time.size;
      flag |= Fields.time.flag;
    }
    
    if (payload.lat != null) {
      size += Fields.location.size;
      flag |= Fields.location.flag;
    } 

    if (payload.speed != null)  {
      size += Fields.speed.size;
      flag |= Fields.speed.flag;
    }

    if (payload.distance != null) {
      size += Fields.distance.size;
      flag |= Fields.distance.flag;
    }

    if (payload.steps != null) {
      size += Fields.steps.size;
      flag |= Fields.steps.flag;
    }

    if (payload.activity != null) {
      size += Fields.activity.size;
      flag |= Fields.activity.flag;
    }

    final imu = payload.imu;
    if (imu != null) {
      int recordSize = 
        (imu.q != null ? 8 : 0) +
        (imu.a != null ? 6 : 0) +
        (imu.g != null ? 6 : 0) +
        (imu.m != null ? 6 : 0);

      size += recordSize; 
    }


    return (size, flag);
  }

  static bool _checkFlag(int value, Fields field) => value & field.flag != 0;
}


