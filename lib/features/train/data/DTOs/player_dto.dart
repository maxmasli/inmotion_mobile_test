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

  PlayerDTO({
    required this.name,
    required this.number,
    required this.measures,
  });

  PlayerEntity toEntity() {
    return PlayerEntity(name: name, number: number)
      ..setMeasures(measures.map((m) => m.toEntity()));
  }

  factory PlayerDTO.fromEntity(PlayerEntity entity) {
    return PlayerDTO(
      name: entity.name,
      number: entity.number,
      measures: entity.measures.map((m) => MeasureDTO.fromEntity(m)).toList(),
    );
  }
}
