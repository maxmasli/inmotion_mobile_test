import 'package:hive_flutter/adapters.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';

part 'measure_dto.g.dart';

@HiveType(typeId: 3)
class MeasureDTO {
  @HiveField(1)
  DateTime? time;

  @HiveField(2)
  int? hr;

  @HiveField(3)
  double? latitude;

  @HiveField(4)
  double? longitude;

  @HiveField(5)
  double? speed;

  @HiveField(6)
  double? distance;

  @HiveField(7)
  int? steps;

  @HiveField(8)
  int? activity;

  MeasureDTO({
    this.time,
    this.hr,
    this.latitude,
    this.longitude,
    this.speed,
    this.distance,
    this.steps,
    this.activity,
  });

  MeasureEntity toEntity() {
    return MeasureEntity(
      activity: activity,
      distance: distance,
      hr: hr,
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      steps: steps,
      time: time,
    );
  }

  factory MeasureDTO.fromEntity(MeasureEntity entity) {
    return MeasureDTO(
      time: entity.time,
      steps: entity.steps,
      speed: entity.speed,
      longitude: entity.longitude,
      latitude: entity.latitude,
      hr: entity.hr,
      distance: entity.distance,
      activity: entity.activity,
    );
  }
}