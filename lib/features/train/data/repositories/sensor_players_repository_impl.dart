import 'package:inmotion_mobile_test/features/train/data/DTOs/player_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/local_data_sources/sensor_players_data_source.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/sensor_players_repository.dart';

class SensorPlayersRepositoryImpl implements SensorPlayersRepository {
  final SensorPlayerDataSource sensorPlayerDataSource;

  const SensorPlayersRepositoryImpl({
    required this.sensorPlayerDataSource,
  });

  @override
  Future<List<PlayerEntity>> getPlayers() async {
    return (await sensorPlayerDataSource.getPlayers())
        .map((p) => p.toEntity())
        .toList();
  }

  @override
  Future<void> savePlayer(PlayerEntity playerEntity) async {
    return await sensorPlayerDataSource
        .savePlayer(PlayerDTO.fromEntity(playerEntity));
  }

  @override
  Future<void> updatePlayer(PlayerEntity playerEntity) async {
    return await sensorPlayerDataSource
        .updatePlayer(PlayerDTO.fromEntity(playerEntity));
  }
}
