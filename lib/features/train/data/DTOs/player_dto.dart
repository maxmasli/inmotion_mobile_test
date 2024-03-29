import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/measure_dto.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';

part 'player_dto.g.dart';

@HiveType(typeId: 2)
class PlayerDTO {
  @HiveField(1)
  final String name;

  @HiveField(2)
  final int number;

  @HiveField(3)
  final List<MeasureDTO> measures;

  @HiveField(4)
  final String? deviceId;

  @HiveField(5)
  final int? deviceNumber;

  @HiveField(6)
  final String uuid;

  PlayerDTO({
    required this.name,
    required this.number,
    required this.measures,
    this.deviceId,
    this.deviceNumber,
    required this.uuid,
  });

  PlayerEntity toEntity() {
    return PlayerEntity(
      name: name,
      number: number,
      uuid: uuid,
      sensor: deviceId != null && deviceNumber != null
          ? SensorEntity(
              device: BluetoothDevice.fromId(deviceId!),
              number: deviceNumber!,
            )
          : null,
    )..setMeasures(measures.map((m) => m.toEntity()));
  }

  factory PlayerDTO.fromEntity(PlayerEntity entity) {
    return PlayerDTO(
      uuid: entity.uuid!,
      name: entity.name,
      number: entity.number,
      measures: entity.measures.map((m) => MeasureDTO.fromEntity(m)).toList(),
      deviceId: entity.sensor?.device.remoteId.str,
      deviceNumber: entity.sensor?.number,
    );
  }
}
