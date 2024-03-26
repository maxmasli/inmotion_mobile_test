import 'package:hive_flutter/adapters.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';

part 'train_dto.g.dart';

@HiveType(typeId: 1)
class TrainDTO {
  @HiveField(1)
  final String uuid;

  @HiveField(2)
  final String playersKey;

  @HiveField(3)
  final String trainName;

  @HiveField(4)
  final DateTime startTime;

  @HiveField(5)
  final DateTime endTime;

  TrainDTO({
    required this.uuid,
    required this.playersKey,
    required this.trainName,
    required this.startTime,
    required this.endTime,
  });

  TrainEntity toEntity() {
    return TrainEntity(
      startTime: startTime,
      endTime: endTime,
      uuid: uuid,
    );
  }

  factory TrainDTO.fromEntity(TrainEntity entity) {
    return TrainDTO(
      uuid: entity.uuid!,
      playersKey: entity.playersKey!,
      trainName: entity.trainName,
      startTime: entity.startTime,
      endTime: entity.endTime!,
    );
  }
}
