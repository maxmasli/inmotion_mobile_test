import 'package:hive_flutter/hive_flutter.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/split_entity.dart';

part 'split_dto.g.dart';

@HiveType(typeId: 5)
class SplitDTO {
  @HiveField(1)
  final String uuid;

  @HiveField(2)
  final Duration? startFragment;

  @HiveField(3)
  final Duration? endFragment;

  @HiveField(4)
  final String name;

  const SplitDTO({
    required this.uuid,
    required this.startFragment,
    required this.endFragment,
    required this.name,
  });

  factory SplitDTO.fromEntity(SplitEntity entity) {
    return SplitDTO(
      uuid: entity.uuid,
      startFragment: entity.startFragment,
      endFragment: entity.endFragment,
      name: entity.name,
    );
  }

  SplitEntity toEntity() {
    return SplitEntity(
      uuid: uuid,
      startFragment: startFragment,
      endFragment: endFragment,
      name: name,
    );
  }
}
