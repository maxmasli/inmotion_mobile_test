import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

abstract interface class SensorPlayersRepository {
  Future<void> savePlayer(PlayerEntity playerEntity);
  Future<void> updatePlayer(PlayerEntity playerEntity);
  Future<List<PlayerEntity>> getPlayers();
  Future<void> deletePlayer(PlayerEntity player);
}