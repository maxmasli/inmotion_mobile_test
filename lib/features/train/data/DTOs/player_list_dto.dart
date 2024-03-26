import 'package:hive_flutter/adapters.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_dto.dart';

part 'player_list_dto.g.dart';

@HiveType(typeId: 4)
class PlayerListDTO {
  @HiveField(1)
  final List<PlayerDTO> list;

  const PlayerListDTO({
    required this.list,
  });
}